#!/bin/sh
# TODO: redo this in powershell

SRC=/home/user/src/lua
WEB_APPS=/home/user/src/lua/purest-web-apps

export LUA_PATH="$LUA_PATH;$SRC/?/?.lua;$SRC/?/init.lua;$SRC/?.lua;$SRC/init.lua;$SRC/?/src/?.lua;$SRC/init.lua;$SRC/?/src/?/?.lua;$SRC/?/src/init.lua;$WEB_APPS/?/?.lua;$WEB_APPS/?/init.lua;$WEB_APPS/?.lua;$WEB_APPS/init.lua;$WEB_APPS/?/src/?.lua;$WEB_APPS/init.lua;$WEB_APPS/?/src/?/?.lua;$WEB_APPS/?/src/init.lua"

LUA_LIBS=/usr/share/lua/5.1
LUA_LIBS_ALT=/usr/local/share/lua/5.1
LUA_CLIBS=/usr/lib/x86_64-linux-gnu/lua/5.1

export LUA_PATH="$LUA_PATH;$LUA_LIBS/?/?.lua;$LUA_LIBS/?/init.lua;$LUA_LIBS/?.lua;$LUA_LIBS/init.lua;$LUA_LIBS/?/src/?.lua;$LUA_LIBS/init.lua;$LUA_LIBS/?/src/?/?.lua;$LUA_LIBS/?/src/init.lua;"

LUA_LIBS=/usr/local/share/lua/5.1

export LUA_PATH="$LUA_PATH;$LUA_LIBS/?/?.lua;$LUA_LIBS/?/init.lua;$LUA_LIBS/?.lua;$LUA_LIBS/init.lua;$LUA_LIBS/?/src/?.lua;$LUA_LIBS/init.lua;$LUA_LIBS/?/src/?/?.lua;$LUA_LIBS/?/src/init.lua;"
export LUA_CPATH="$LUA_CPATH;$LUA_CLIBS/?/core.so;$LUA_CLIBS/?/?.so;$LUA_CLIBS/?.so"

LUA_CLIBS=/usr/local/lib/lua/5.1

export LUA_CPATH="$LUA_CPATH;$LUA_CLIBS/?/core.so;$LUA_CLIBS/?/?.so;$LUA_CLIBS/?.so"

# PuRest web server env. variables
export PUREST_WEB=$WEB_APPS
export PUREST=$SRC