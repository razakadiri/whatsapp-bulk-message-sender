@echo off
echo Starting MongoDB...
echo.

REM Check if MongoDB is already running as a service
sc query MongoDB >nul 2>&1
if %errorlevel% == 0 (
    echo MongoDB service found. Starting service...
    net start MongoDB >nul 2>&1
    if %errorlevel% == 0 (
        echo MongoDB service started successfully!
    ) else (
        echo Failed to start MongoDB service. It might already be running.
    )
) else (
    echo MongoDB service not found. Checking for manual installation...
    
    REM Try to find MongoDB installation
    set MONGO_FOUND=0
    
    if exist "C:\Program Files\MongoDB\Server\7.0\bin\mongod.exe" (
        set MONGO_FOUND=1
        echo Starting MongoDB manually...
        start "MongoDB" "C:\Program Files\MongoDB\Server\7.0\bin\mongod.exe" --dbpath="C:\data\db"
        echo MongoDB started in a new window. Please keep it open.
    ) else if exist "C:\Program Files\MongoDB\Server\6.0\bin\mongod.exe" (
        set MONGO_FOUND=1
        echo Starting MongoDB manually...
        start "MongoDB" "C:\Program Files\MongoDB\Server\6.0\bin\mongod.exe" --dbpath="C:\data\db"
        echo MongoDB started in a new window. Please keep it open.
    ) else if exist "C:\Program Files\MongoDB\Server\5.0\bin\mongod.exe" (
        set MONGO_FOUND=1
        echo Starting MongoDB manually...
        start "MongoDB" "C:\Program Files\MongoDB\Server\5.0\bin\mongod.exe" --dbpath="C:\data\db"
        echo MongoDB started in a new window. Please keep it open.
    ) else if exist "C:\Program Files\MongoDB\Server\4.4\bin\mongod.exe" (
        set MONGO_FOUND=1
        echo Starting MongoDB manually...
        start "MongoDB" "C:\Program Files\MongoDB\Server\4.4\bin\mongod.exe" --dbpath="C:\data\db"
        echo MongoDB started in a new window. Please keep it open.
    )
    
    if %MONGO_FOUND% == 0 (
        echo.
        echo ================================================
        echo MONGODB NOT FOUND
        echo ================================================
        echo MongoDB is not installed on your system.
        echo.
        echo Please install MongoDB Community Server:
        echo 1. Visit: https://www.mongodb.com/try/download/community
        echo 2. Download "Windows x64" version
        echo 3. Run the installer and follow the setup wizard
        echo 4. Choose "Complete" setup type
        echo 5. Select "Run service as Network Service user"
        echo 6. Complete the installation
        echo.
        echo After installation, run this script again.
        echo ================================================
        echo.
        pause
        exit /b 1
    )
)

echo.
echo To verify MongoDB is running, try:
echo   mongo --eval "db.version()"
echo.
pause