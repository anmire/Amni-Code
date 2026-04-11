@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul
for /f %%e in ('powershell -nop -c "[char]27"') do set "E=%%e"
title Amni-Code
echo.
echo   !E![95m╔═════════════════════════════════════════════╗!E![0m
echo   !E![95m║!E![97;1m            ⚡  A M N I - C O D E            !E![0;95m║!E![0m
echo   !E![95m╚═════════════════════════════════════════════╝!E![0m
echo.
set "H=%USERPROFILE%\.amni"
set "BIN=!H!\amni-app.exe"
if not exist "!H!\.repo" (
    echo   !E![93mNo repo configured. Run run.bat from the Amni-Code repo first.!E![0m
    if exist "!BIN!" ("!BIN!" %*) else (pause)
    exit /b
)
set /p REPO=<"!H!\.repo"
if not exist "!REPO!\.git" (
    echo   !E![93mRepo moved? Running cached binary.!E![0m
    if exist "!BIN!" ("!BIN!" %*) else (echo   !E![91mNo binary found.!E![0m&pause)
    exit /b
)
pushd "!REPO!"
<nul set /p =  !E![96m SYN  !E![95m■!E![90m····  !E![97mChecking upstream        !E![0m
git fetch --quiet 2>nul
for /f %%i in ('git rev-parse HEAD 2^>nul') do set "L=%%i"
for /f %%i in ('git rev-parse @{u} 2^>nul') do set "R=%%i"
echo !E![92m✓!E![0m
set "UPD=0"
if "!L!" NEQ "!R!" (
    <nul set /p =  !E![96m PULL !E![95m■■!E![90m···  !E![97mPulling latest           !E![0m
    git pull --ff-only --quiet 2>nul
    if errorlevel 1 (echo !E![91m✗ merge conflict!E![0m) else (echo !E![92m✓!E![0m&set "UPD=1")
) else (
    echo   !E![96m PULL !E![90m■■···  up to date!E![0m
)
set "NB=!UPD!"
if not exist "target\release\amni.exe" set "NB=1"
if "!NB!"=="1" (
    <nul set /p =  !E![96m MAKE !E![95m■■■!E![90m··  !E![97mBuilding release         !E![0m
    cargo build --release --quiet >nul 2>&1
    if errorlevel 1 (
        echo !E![91m✗!E![0m
        echo.
        echo   !E![91mBuild failed — showing errors:!E![0m
        echo.
        cargo build --release 2>&1
        popd
        if exist "!BIN!" (echo.&echo   !E![93mLaunching cached binary...!E![0m&"!BIN!" %*)
        exit /b
    )
    echo !E![92m✓!E![0m
    <nul set /p =  !E![96m LINK !E![95m■■■■!E![90m·  !E![97mInstalling binary        !E![0m
    copy /Y "target\release\amni.exe" "!BIN!" >nul 2>nul
    echo !E![92m✓!E![0m
) else (
    echo   !E![96m MAKE !E![90m■■■··  cached!E![0m
    echo   !E![96m LINK !E![90m■■■■·  cached!E![0m
)
echo   !E![96m BOOT !E![92;1m■■■■■  Ignition!E![0m
popd
echo.
echo   !E![95m═════════════════════════════════════════════!E![0m
echo.
if exist "!BIN!" ("!BIN!" %*) else (echo   !E![91mBinary not found.!E![0m&pause)
