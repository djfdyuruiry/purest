local ipcFilelock = require "ipc.filelock"

local log = require "PuRest.Logging.FileLogger"
local LogLevelMap = require "PuRest.Logging.LogLevelMap"
local getTempPath = require "PuRest.Util.System.getTempPath"

local read = "r"
local write = "w"

local lockFileContent = ".lock"
local lockFileBasePath = getTempPath()

-- 'callingThreadIsMutexOwner' parameter should be false for child threads 
-- so that they error appropriately when master thread has destroyed mutex
local function NamedMutex(name, callingThreadIsMutexOwner)
    local generateLockFileIfMissing = callingThreadIsMutexOwner
    local lockFilePath = string.format("%s/%s", lockFileBasePath, name)
    local destroyed = false
    
    local getLockFileHandle

    local function generateLockFile()
        local lockFile, err = io.open(lockFilePath, write)

        if not lockFile or err then
            error(string.format("Error generating lock file: %s", err or "unknown error"))
        end

        lockFile:write(lockFileContent)
        lockFile:close()

        log(string.format("Generated lock file %s for named mutex: %s", lockFilePath, name), LogLevelMap.DEBUG)
    end

    local function shouldGenerateLockFile(err)
        return err and 
            generateLockFileIfMissing and 
            err == string.format("%s: No such file or directory", lockFilePath)
    end

    getLockFileHandle = function()
        local fileHandle, err = io.open(lockFilePath, read)

        if shouldGenerateLockFile(err) then
            generateLockFile()

            fileHandle = getLockFileHandle()
        elseif not fileHandle or err then
            destroyed = true

            error(string.format(
                "Mutex does not exist or has been destroyed, detected by lock file '%s' handle error: %s", 
                lockFilePath, 
                err))
        end

        log(string.format("Got handle for lock file %s for named mutex: %s", lockFilePath, name), LogLevelMap.DEBUG)

        return fileHandle
    end

    local function checkIsNotDestroyed()
        if destroyed then
            error(string.format("Attempted illegal operation on destroyed mutex '%s'", name))
        end
    end

    local function obtainLock()
        log(string.format("Obtaining lock on file %s for named mutex: %s", lockFilePath, name), LogLevelMap.DEBUG)
        return ipcFilelock.lock(getLockFileHandle(), write)
    end

    local function releaseLock()
        log(string.format("Releasing lock on file %s for named mutex: %s", lockFilePath, name), LogLevelMap.DEBUG)
        return ipcFilelock.unlock(getLockFileHandle())
    end

    local function destroy()
        if not callingThreadIsMutexOwner then
            error(string.format(
                "unable to destroy named mutex '%s' because the current thread is not the mutex owner", name))
        end

        obtainLock()
        
        local status, err = os.remove(lockFilePath)

        destroyed = status
        
        if destroyed then
            log(string.format("Destroyed lock file %s for named mutex: %s", lockFilePath, name), LogLevelMap.DEBUG)
        end

        return status, err
    end
    
    local function getName()
        return name
    end

    local function checkedCall(method)
        return function(...)
            checkIsNotDestroyed()
            return method(...)
        end
    end

    return 
    {
        obtainLock = checkedCall(obtainLock),
        releaseLock = checkedCall(releaseLock),
        destroy = checkedCall(destroy),
        getName = getName
    }
end

return NamedMutex
