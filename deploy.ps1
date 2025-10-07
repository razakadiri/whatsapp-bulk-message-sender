# WhatsApp Bulk Message Sender - Windows Deployment Script
# This script deploys the application to a live server on Windows

param(
    [switch]$SkipSSL,
    [switch]$Help
)

if ($Help) {
    Write-Host "WhatsApp Bulk Message Sender - Deployment Script" -ForegroundColor Green
    Write-Host "Usage: .\deploy.ps1 [-SkipSSL]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  -SkipSSL    Skip SSL certificate generation"
    Write-Host "  -Help       Show this help message"
    exit 0
}

Write-Host "🚀 Starting deployment of WhatsApp Bulk Message Sender..." -ForegroundColor Green

# Check if Docker is installed
try {
    docker --version | Out-Null
    Write-Host "✅ Docker is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not installed. Please install Docker Desktop first." -ForegroundColor Red
    exit 1
}

try {
    docker-compose --version | Out-Null
    Write-Host "✅ Docker Compose is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose is not installed. Please install Docker Compose first." -ForegroundColor Red
    exit 1
}

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  .env file not found. Creating from example..." -ForegroundColor Yellow
    Copy-Item "env.production.example" ".env"
    Write-Host "❌ Please edit .env file with your actual configuration before running deployment again." -ForegroundColor Red
    exit 1
}

# Create necessary directories
Write-Host "📁 Creating necessary directories..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "nginx\ssl" | Out-Null
New-Item -ItemType Directory -Force -Path "nginx\logs" | Out-Null
New-Item -ItemType Directory -Force -Path "server\uploads" | Out-Null

# Generate SSL certificates (self-signed for development)
if (-not $SkipSSL) {
    if (-not (Test-Path "nginx\ssl\cert.pem") -or -not (Test-Path "nginx\ssl\key.pem")) {
        Write-Host "🔐 Generating self-signed SSL certificates..." -ForegroundColor Green
        
        # Check if OpenSSL is available
        try {
            openssl version | Out-Null
            $opensslAvailable = $true
        } catch {
            $opensslAvailable = $false
        }
        
        if ($opensslAvailable) {
            openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "nginx\ssl\key.pem" -out "nginx\ssl\cert.pem" -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
            Write-Host "✅ Self-signed certificates generated" -ForegroundColor Green
        } else {
            Write-Host "⚠️  OpenSSL not found. Skipping SSL certificate generation." -ForegroundColor Yellow
            Write-Host "   You can install OpenSSL or use -SkipSSL parameter" -ForegroundColor Yellow
        }
    }
}

# Build and start services
Write-Host "🔨 Building and starting services..." -ForegroundColor Green
docker-compose down --remove-orphans
docker-compose build --no-cache
docker-compose up -d

# Wait for services to be ready
Write-Host "⏳ Waiting for services to start..." -ForegroundColor Green
Start-Sleep -Seconds 30

# Check if services are running
Write-Host "🔍 Checking service health..." -ForegroundColor Green

# Check MongoDB
try {
    docker-compose exec mongodb mongosh --eval "db.runCommand('ping')" 2>$null | Out-Null
    Write-Host "✅ MongoDB is running" -ForegroundColor Green
} catch {
    Write-Host "❌ MongoDB failed to start" -ForegroundColor Red
    docker-compose logs mongodb
    exit 1
}

# Check Backend
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/api/health" -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend API is running" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Backend API failed to start" -ForegroundColor Red
    docker-compose logs backend
    exit 1
}

# Check Frontend
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Frontend is running" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Frontend failed to start" -ForegroundColor Red
    docker-compose logs frontend
    exit 1
}

# Check Nginx
try {
    $response = Invoke-WebRequest -Uri "http://localhost" -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Nginx is running" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Nginx failed to start" -ForegroundColor Red
    docker-compose logs nginx
    exit 1
}

Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Application URLs:" -ForegroundColor Yellow
Write-Host "   Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "   Backend API: http://localhost:5000" -ForegroundColor White
Write-Host "   Nginx (HTTPS): https://localhost" -ForegroundColor White
Write-Host ""
Write-Host "🔐 Default Admin Credentials:" -ForegroundColor Yellow
Write-Host "   Email: admin@whatsapp-bulk.com" -ForegroundColor White
Write-Host "   Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "📊 Useful Commands:" -ForegroundColor Yellow
Write-Host "   View logs: docker-compose logs -f" -ForegroundColor White
Write-Host "   Stop services: docker-compose down" -ForegroundColor White
Write-Host "   Restart services: docker-compose restart" -ForegroundColor White
Write-Host "   Update services: docker-compose pull; docker-compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Remember to:" -ForegroundColor Yellow
Write-Host "   1. Update .env file with your actual WhatsApp API credentials" -ForegroundColor White
Write-Host "   2. Replace self-signed SSL certificates with proper ones for production" -ForegroundColor White
Write-Host "   3. Configure your domain name and update CORS settings" -ForegroundColor White
Write-Host "   4. Set up proper backup strategies for MongoDB data" -ForegroundColor White
