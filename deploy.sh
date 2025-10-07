#!/bin/bash

# WhatsApp Bulk Message Sender - Deployment Script
# This script deploys the application to a live server

set -e

echo "🚀 Starting deployment of WhatsApp Bulk Message Sender..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_warning ".env file not found. Creating from example..."
    cp env.production.example .env
    print_error "Please edit .env file with your actual configuration before running deployment again."
    exit 1
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p nginx/ssl
mkdir -p nginx/logs
mkdir -p server/uploads

# Generate SSL certificates (self-signed for development)
if [ ! -f "nginx/ssl/cert.pem" ] || [ ! -f "nginx/ssl/key.pem" ]; then
    print_status "Generating self-signed SSL certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout nginx/ssl/key.pem \
        -out nginx/ssl/cert.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    print_warning "Self-signed certificates generated. For production, use proper SSL certificates."
fi

# Build and start services
print_status "Building and starting services..."
docker-compose down --remove-orphans
docker-compose build --no-cache
docker-compose up -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Check if services are running
print_status "Checking service health..."

# Check MongoDB
if docker-compose exec mongodb mongosh --eval "db.runCommand('ping')" > /dev/null 2>&1; then
    print_status "✅ MongoDB is running"
else
    print_error "❌ MongoDB failed to start"
    docker-compose logs mongodb
    exit 1
fi

# Check Backend
if curl -f http://localhost:5000/api/health > /dev/null 2>&1; then
    print_status "✅ Backend API is running"
else
    print_error "❌ Backend API failed to start"
    docker-compose logs backend
    exit 1
fi

# Check Frontend
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    print_status "✅ Frontend is running"
else
    print_error "❌ Frontend failed to start"
    docker-compose logs frontend
    exit 1
fi

# Check Nginx
if curl -f http://localhost > /dev/null 2>&1; then
    print_status "✅ Nginx is running"
else
    print_error "❌ Nginx failed to start"
    docker-compose logs nginx
    exit 1
fi

print_status "🎉 Deployment completed successfully!"
echo ""
echo "📱 Application URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:5000"
echo "   Nginx (HTTPS): https://localhost"
echo ""
echo "🔐 Default Admin Credentials:"
echo "   Email: admin@whatsapp-bulk.com"
echo "   Password: admin123"
echo ""
echo "📊 Useful Commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Restart services: docker-compose restart"
echo "   Update services: docker-compose pull && docker-compose up -d"
echo ""
print_warning "Remember to:"
echo "   1. Update .env file with your actual WhatsApp API credentials"
echo "   2. Replace self-signed SSL certificates with proper ones for production"
echo "   3. Configure your domain name and update CORS settings"
echo "   4. Set up proper backup strategies for MongoDB data"
