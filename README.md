# 📱 WhatsApp Bulk Message Sender

A comprehensive full-stack web application for sending and managing bulk WhatsApp messages using the WhatsApp Business API. Built with React, Node.js, Express, and MongoDB.

## ✨ Features

### 🔐 Authentication & Security
- JWT-based authentication with refresh tokens
- Role-based access control (Admin, Operator)
- Secure password hashing and validation
- Audit logging for all user actions

### 📊 Dashboard & Analytics
- Real-time KPI dashboard
- Interactive charts for message trends
- Campaign progress tracking
- Delivery rate monitoring
- Quick stats and recent activities

### 👥 Contact Management
- Full CRUD operations for contacts
- CSV/Excel bulk import functionality
- Contact tagging and segmentation
- Opt-in/opt-out management
- Phone number normalization (E.164 format)
- Deduplication and validation

### 📝 Template Management
- Create and edit WhatsApp message templates
- Live preview with WhatsApp-style UI
- Variable management and substitution
- Template versioning and rollback
- WhatsApp approval workflow
- Test message sending

### 📢 Campaign Engine
- Campaign creation wizard
- Template or custom message support
- Recipient targeting and segmentation
- Scheduling and rate limiting
- Real-time progress tracking
- Pause/resume/cancel controls
- Test run functionality

### 🌐 Webhook Integration
- Delivery status tracking
- Read receipt handling
- Inbound message processing
- Multi-provider support (360dialog, Twilio, Gupshup)
- Webhook signature verification
- Error handling and retry logic

### 📈 Reporting & Exports
- Detailed campaign analytics
- CSV and PDF report generation
- Interactive visualizations
- Cost analysis and ROI tracking
- Historical data trends
- Custom date range filtering

### ⚙️ Settings & Configuration
- WhatsApp API provider configuration
- Rate limiting settings
- Notification preferences
- User management (Admin)
- System monitoring

## 🚀 Tech Stack

### Frontend
- **React 18** - Modern UI library
- **React Router** - Client-side routing
- **React Query** - Data fetching and caching
- **Tailwind CSS** - Utility-first styling
- **Recharts** - Data visualization
- **React Hook Form** - Form management
- **Socket.IO Client** - Real-time updates
- **Lucide React** - Icon library

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM for MongoDB
- **JWT** - Authentication
- **Socket.IO** - Real-time communication
- **Node-cron** - Task scheduling
- **Multer** - File upload handling

### External Services
- **WhatsApp Business API** (360dialog, Twilio, Gupshup)
- **Email notifications** (SMTP)
- **File storage** (Local/Cloud)

## 📦 Installation

### Prerequisites
- Node.js (v16 or higher)
- MongoDB (v4.4 or higher)
- WhatsApp Business API account

### Database Setup

Before setting up the application, you need to have MongoDB running. Refer to [DATABASE_SETUP.md](DATABASE_SETUP.md) for detailed instructions on installing and configuring MongoDB.

### Backend Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd whatsapp-bulk-sender
```

2. Install server dependencies:
```bash
cd server
npm install
```

3. Create environment file:
```bash
cp env.example .env
```

4. Configure environment variables in `.env`:
```env
# Server Configuration
PORT=5000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/whatsapp-bulk-sender

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-here
JWT_REFRESH_SECRET=your-super-secret-refresh-key-here
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# WhatsApp API Configuration
WHATSAPP_API_URL=https://api.360dialog.com/v1
WHATSAPP_API_KEY=your-whatsapp-api-key
WHATSAPP_WEBHOOK_SECRET=your-webhook-secret

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS
CORS_ORIGIN=http://localhost:3000
```

5. Initialize the database:
```bash
npm run db:init
```

6. Start the server:
```bash
npm run dev
```

### Frontend Setup

1. Install client dependencies:
```bash
cd client
npm install
```

2. Create environment file:
```bash
cp .env.example .env
```

3. Configure environment variables in `.env`:
```env
REACT_APP_API_URL=http://localhost:5000/api
REACT_APP_SOCKET_URL=http://localhost:5000
```

4. Start the client:
```bash
npm start
```

### Full Stack Development

From the root directory, run:
```bash
npm run install-all  # Install all dependencies
npm run dev          # Start both frontend and backend
```

## 🐛 Troubleshooting

If you encounter issues, especially "Request failed with status code 500" errors, refer to [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

For "Failed to fetch campaigns" and "Failed to fetch templates" errors, refer to [CAMPAIGNS_TEMPLATES_TROUBLESHOOTING.md](CAMPAIGNS_TEMPLATES_TROUBLESHOOTING.md).

Common issues and solutions:

1. **Database Connection Issues**: Ensure MongoDB is running
2. **Environment Variables**: Check that all required variables are set
3. **Port Conflicts**: Change the PORT in server/.env if needed
4. **Missing Dependencies**: Run `npm run install-all` to reinstall

## 🔧 Configuration

### WhatsApp API Providers

#### 360dialog
```env
WHATSAPP_PROVIDER=360dialog
WHATSAPP_API_URL=https://api.360dialog.com/v1
WHATSAPP_API_KEY=your-api-key
```

#### Twilio
```env
WHATSAPP_PROVIDER=twilio
TWILIO_ACCOUNT_SID=your-account-sid
TWILIO_AUTH_TOKEN=your-auth-token
TWILIO_WHATSAPP_NUMBER=your-whatsapp-number
```

#### Gupshup
```env
WHATSAPP_PROVIDER=gupshup
GUPSHUP_API_KEY=your-api-key
GUPSHUP_SOURCE_NUMBER=your-source-number
```

#### Meta (WhatsApp Business API)
```env
WHATSAPP_PROVIDER=meta
META_ACCESS_TOKEN=your-access-token
META_PHONE_NUMBER_ID=your-phone-number-id
META_APP_ID=your-app-id
META_APP_SECRET=your-app-secret
```

### Rate Limiting
Configure message sending rates:
```env
RATE_LIMIT_WINDOW_MS=900000      # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100      # Max requests per window
```

## 📱 Usage

### 1. Authentication
- Register a new account or use demo credentials
- Admin: `admin@example.com` / `password123`
- Operator: `operator@example.com` / `password123`

### 2. Contact Management
- Import contacts via CSV/Excel files
- Organize contacts with tags
- Manage opt-in/opt-out status
- Segment contacts for targeted campaigns

### 3. Template Creation
- Create WhatsApp-compliant message templates
- Use variables for personalization
- Preview templates with sample data
- Submit for WhatsApp approval

### 4. Campaign Creation
- Select template or create custom message
- Choose target audience
- Configure scheduling and rate limits
- Monitor real-time progress

### 5. Analytics & Reporting
- View campaign performance metrics
- Export detailed reports
- Track delivery and engagement rates
- Monitor costs and ROI

## 🔒 Security Features

- JWT-based authentication with refresh tokens
- Role-based access control
- API rate limiting
- Input validation and sanitization
- Webhook signature verification
- Audit logging for compliance
- Secure file upload handling

## 🚀 Deployment

### Environment Setup
1. Set up MongoDB Atlas or self-hosted MongoDB
2. Configure WhatsApp Business API credentials
3. Set up SMTP for email notifications
4. Configure environment variables for production

### Docker Deployment
```bash
docker-compose up -d
```

### Manual Deployment
1. Build the frontend:
```bash
cd client
npm run build
```

2. Deploy backend to your server
3. Configure reverse proxy (Nginx)
4. Set up SSL certificates
5. Configure domain and DNS

## 📊 API Documentation

### Authentication Endpoints
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/logout` - User logout

### Contact Endpoints
- `GET /api/contacts` - List contacts
- `POST /api/contacts` - Create contact
- `POST /api/contacts/bulk-import` - Import contacts
- `GET /api/contacts/stats/summary` - Contact statistics

### Template Endpoints
- `GET /api/templates` - List templates
- `POST /api/templates` - Create template
- `POST /api/templates/:id/render` - Preview template
- `POST /api/templates/:id/submit-for-approval` - Submit for approval

### Campaign Endpoints
- `GET /api/campaigns` - List campaigns
- `POST /api/campaigns` - Create campaign
- `POST /api/campaigns/:id/start` - Start campaign
- `POST /api/campaigns/:id/pause` - Pause campaign

### Webhook Endpoints
- `POST /api/webhooks/whatsapp` - WhatsApp webhooks
- `POST /api/webhooks/twilio` - Twilio webhooks
- `POST /api/webhooks/gupshup` - Gupshup webhooks
- `POST /api/webhooks/meta` - Meta webhooks

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue on GitHub
- Check the documentation
- Contact the development team

## 🔮 Roadmap

- [ ] Advanced analytics dashboard
- [ ] A/B testing for campaigns
- [ ] Multi-language support
- [ ] Mobile app
- [ ] Advanced automation workflows
- [ ] Integration with CRM systems
- [ ] Advanced reporting features
- [ ] Performance optimizations

---

Built with ❤️ for efficient WhatsApp bulk messaging