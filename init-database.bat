@echo off
echo Initializing WhatsApp Bulk Sender Database...
echo.

REM Navigate to server directory
cd /d "%~dp0\server"

REM Check if node is available
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ================================================
    echo NODE.JS NOT FOUND
    echo ================================================
    echo Node.js is not installed or not in PATH.
    echo.
    echo Please install Node.js from https://nodejs.org/
    echo 1. Download the LTS version
    echo 2. Run the installer and follow the setup wizard
    echo 3. Make sure to check "Add to PATH" during installation
    echo.
    echo After installation, run this script again.
    echo ================================================
    echo.
    pause
    exit /b 1
)

REM Check if npm is available
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ================================================
    echo NPM NOT AVAILABLE
    echo ================================================
    echo npm is not available. Please ensure Node.js is properly installed.
    echo.
    echo Try reinstalling Node.js and make sure to check "Add to PATH".
    echo ================================================
    echo.
    pause
    exit /b 1
)

REM Check if server dependencies are installed
if not exist "node_modules" (
    echo Installing server dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo ================================================
        echo DEPENDENCY INSTALLATION FAILED
        echo ================================================
        echo Failed to install dependencies.
        echo.
        echo Possible solutions:
        echo 1. Check your internet connection
        echo 2. Clear npm cache: npm cache clean --force
        echo 3. Run as administrator
        echo ================================================
        echo.
        pause
        exit /b 1
    )
    echo Dependencies installed successfully!
    echo.
)

REM Run database initialization
echo Running database initialization...
npm run db:init

if %errorlevel% equ 0 (
    echo.
    echo ================================================
    echo DATABASE INITIALIZED SUCCESSFULLY!
    echo ================================================
    echo.
    echo Default admin user:
    echo   Email: admin@whatsapp-bulk.com
    echo   Password: admin123
    echo.
    echo Please change the default password after first login.
    echo.
    echo Next steps:
    echo 1. Start the application: npm run dev
    echo 2. Open browser to: http://localhost:3000
    echo 3. Login with the credentials above
    echo ================================================
) else (
    echo.
    echo ================================================
    echo DATABASE INITIALIZATION FAILED
    echo ================================================
    echo Database initialization failed.
    echo.
    echo Please ensure:
    echo 1. MongoDB is installed and running
    echo 2. The MONGODB_URI in server/.env is correct
    echo 3. No firewall is blocking the connection
    echo.
    echo Try running start-mongodb.bat first, then this script.
    echo ================================================
)

pause