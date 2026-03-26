@echo off
echo ========================================
echo    Amni-Code Agent Installer v0.3.0
echo ========================================
echo.
echo Checking for Python...

REM Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    py --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo Python not found. Installing from Microsoft Store...
        echo Please wait while Python installs from Microsoft Store...
        start ms-windows-store://pdp/?productid=9PJPW5LDXLZ5
        echo.
        echo IMPORTANT: After Python installation completes, run this installer again.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    ) else (
        echo Python found via 'py' command.
        py install_gui.py
    )
) else (
    echo Python is already installed.
    python install_gui.py
)

if %errorlevel% equ 0 (
    echo.
    echo Installation completed successfully!
) else (
    echo.
    echo Installation failed!
    pause
    exit /b 1
)