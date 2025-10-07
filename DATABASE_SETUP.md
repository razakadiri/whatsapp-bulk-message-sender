# Database Setup Guide

This project uses MongoDB as its database. Follow this guide to properly set up and configure the database.

## Prerequisites

- MongoDB 4.4 or higher
- Node.js 14 or higher

## Installing MongoDB on Windows

### Option 1: Using MongoDB Community Server (Recommended for local development)

1. Download MongoDB Community Server from [MongoDB Download Center](https://www.mongodb.com/try/download/community)
2. Run the installer and follow the installation wizard
3. Choose "Complete" setup type
4. Select "Run service as Network Service user"
5. Choose the default data directory or specify a custom one
6. Complete the installation

### Option 2: Using Docker (Recommended for production)

If you have Docker installed:

```bash
# Start MongoDB container
docker run -d -p 27017:27017 --name whatsapp-mongodb mongo:6.0
```

## Starting MongoDB Service

### On Windows (if installed as a service)

MongoDB should start automatically. If not, start it manually:

1. Open Services (services.msc)
2. Find "MongoDB Server"
3. Right-click and select "Start"

### On Windows (manual start)

If MongoDB was installed without the service:

```cmd
"C:\Program Files\MongoDB\Server\[version]\bin\mongod.exe" --dbpath="C:\data\db"
```

## Database Configuration

The application uses the following environment variables for database configuration:

- `MONGODB_URI` - MongoDB connection string (default: `mongodb://localhost:27017/whatsapp-bulk-sender`)

## Setting Up the Database

### Option 1: Using Docker (Recommended)

The project includes a Docker Compose configuration that sets up MongoDB automatically:

```bash
# Start all services including MongoDB
docker-compose up -d

# Check if MongoDB is running
docker-compose ps
```

### Option 2: Using Local MongoDB Installation

1. Install MongoDB on your system
2. Start the MongoDB service
3. The application will automatically connect to `mongodb://localhost:27017/whatsapp-bulk-sender`

## Database Initialization

After starting the database, initialize it with required collections and indexes:

```bash
# Navigate to the server directory
cd server

# Run the database initialization script
npm run db:init
```

This will:
- Create all required collections
- Set up proper indexes for performance
- Create a default admin user (admin@whatsapp-bulk.com / admin123)

## Health Check

To verify the database connection and health:

```bash
# Navigate to the server directory
cd server

# Run the database health check
npm run db:health
```

## Database Schema

The application uses the following collections:

### Users
- email (unique)
- password (hashed)
- firstName
- lastName
- role (admin/operator)
- phone
- isActive
- lastLogin
- refreshTokens
- auditLogs
- timestamps

### Contacts
- name
- phone
- email
- tags
- customFields
- timestamps

### Templates
- name
- content
- mediaUrl
- category
- language
- status
- variables
- timestamps

### Campaigns
- name
- template
- contacts
- status
- scheduledAt
- sentCount
- failedCount
- timestamps

### Messages
- campaign
- contact
- status
- sentAt
- deliveredAt
- readAt
- errorMessage
- providerMessageId
- timestamps

### WebhookLogs
- eventType
- payload
- processed
- error
- timestamps

## Backup and Restore

### Backup
```bash
mongodump --uri="mongodb://localhost:27017/whatsapp-bulk-sender" --out=./backups/
```

### Restore
```bash
mongorestore --uri="mongodb://localhost:27017/whatsapp-bulk-sender" ./backups/whatsapp-bulk-sender/
```

## Troubleshooting

### Connection Issues
1. Verify MongoDB is running
2. Check the MONGODB_URI environment variable
3. Ensure firewall settings allow connections on port 27017

### Authentication Issues
1. Check MongoDB user credentials
2. Verify the user has proper permissions on the database

### Performance Issues
1. Ensure proper indexes are created
2. Check MongoDB logs for slow queries
3. Consider enabling MongoDB profiling for detailed analysis