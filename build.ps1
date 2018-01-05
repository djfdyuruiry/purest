$templateDir = "$PSScriptRoot/build/template"
$luaSrcDir = "$PSScriptRoot/src"
$luaLibDir = "$PSScriptRoot/lib/lua"

$releaseDir = "$PSScriptRoot/build/release"
$releaseWebDir = "$PSScriptRoot/build/release/web"
$releaseLuaDir = "$PSScriptRoot/build/release/lua"

$webAppsPath = "$PSScriptRoot/../PuRest-web-apps"

if (Test-Path $releaseDir)
{
    Remove-Item $releaseDir -Recurse -Force -Verbose
}

# make release directory
New-Item $releaseDir -ItemType Directory -Force -Verbose

# copy release template and lua code
Copy-Item "$templateDir/*" $releaseDir -Recurse -Container -Force -Verbose
Copy-Item "$luaSrcDir/*" "$releaseLuaDir/PuRest" -Recurse -Container -Force -Verbose

# copy lua libs
Copy-Item "$luaLibDir/*" $releaseLuaDir -Recurse -Container -Force -Verbose

# copy favico
Copy-Item "$PSScriptRoot/resources/favicon.ico" $releaseWebDir -Force -Verbose

# copy server config
Copy-Item "$luaSrcDir/Config/DefaultConfig.lua" "$releaseDir/cfg/cfg.lua" -Force -Verbose

# clean build placeholders from release
Get-ChildItem -Path $releaseDir -File -Include "build.txt" -Recurse | Remove-Item -Force -Verbose

# copy in web apps repo if present
if (Test-Path $webAppsPath)
{
    Copy-Item "$webAppsPath/*" $releaseWebDir -Recurse -Container -Force -Verbose
}
