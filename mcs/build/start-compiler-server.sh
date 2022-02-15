#!/bin/sh
# usage: start-compiler-server.sh <working directory> <log path> <pipename>
# ensure that VBCS_RUNTIME and VBCS_LOCATION environment variables are set.

set -eu

if test -s "$VBCS_LOCATION"; then
    CMD="RoslynCommandLineLogFile=$2 $VBCS_RUNTIME --gc-params=nursery-size=64m \"$VBCS_LOCATION\" -pipename:$3 &"
    command -v sh >/dev/null 2>&1 && SH=sh || SH=/bin/sh
    echo "Log location set to $2"
    touch "$2"
    echo "cd $1; $SH -c \"$CMD\""
    cd "$1"
    "$SH" -c "$CMD"
    if test "$?" -eq 0; then
        echo Compiler server started.
    else
        echo Failed to start compiler server.
    fi;
else
    echo No compiler server found at path "$VBCS_LOCATION". Ensure that VBCS_LOCATION is set in config.make or passed as a parameter to make.
    echo Use ENABLE_COMPILER_SERVER=0 to disable the use of the compiler server and continue to build.
    exit 1
fi;
