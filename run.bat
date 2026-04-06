@echo off
title Amni-Code
echo.
echo   Amni-Code - AI Coding Agent
echo   ============================
echo.
git fetch --quiet 2>nul&&git pull --ff-only --quiet 2>nul||echo   Git pull skipped.
where cargo >nul 2>nul||powershell -Command "Invoke-WebRequest -Uri 'https://win.rustup.rs/x86_64' -OutFile '%TEMP%\rustup-init.exe';Start-Process '%TEMP%\rustup-init.exe' -ArgumentList '-y','--default-toolchain','stable' -Wait"
cargo install --path . --force --quiet
echo   Starting Amni-Code...
echo.
amni