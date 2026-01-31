# Halifax Foodie - Frontend

React-based web application for the Halifax Foodie platform, providing an intuitive interface for restaurant discovery, reviews, and AI-powered features.

## 🎨 Features

- **Authentication**: Secure login and registration system
- **Home Dashboard**: Restaurant browsing and discovery
- **Word Cloud Visualization**: Visual representation of review sentiments
- **ML Recommendations**: Personalized restaurant suggestions
- **Intelligent Chatbot**: AWS Lex-powered virtual assistant
- **Real-time Chat**: Communication with restaurants
- **Data Insights**: Analytics and visualization dashboard

## 🛠️ Tech Stack

- **Framework**: React 17.0.2
- **UI Components**: 
  - Material-UI (@material-ui/core, @material-ui/icons)
  - Bulma CSS Framework
  - Custom CSS
- **Routing**: React Router DOM v5.2.0
- **State Management**: React Hooks and Local Storage
- **API Integration**: 
  - Axios for HTTP requests
  - AWS SDK for direct AWS service integration
- **Chatbot**: react-lex for AWS Lex integration
- **Build Tool**: Create React App (react-scripts)

## 📁 Project Structure

```
frontend/
├── public/
│   ├── index.html              # HTML template
│   ├── manifest.json           # PWA manifest
│   └── robots.txt              # SEO configuration
│
├── src/
│   ├── component/
│   │   ├── Authentication/
│   │   │   ├── Login.js       # Login page
│   │   │   ├── Registration.js # Registration page
│   │   │   └── Authentication.css
│   │   │
│   │   ├── Chat/
│   │   │   └── chat.js        # Real-time messaging
│   │   │
│   │   ├── Chatbot/
│   │   │   └── chatbot.js     # AWS Lex chatbot
│   │   │
│   │   ├── homepage/
│   │   │   └── homepage.js    # Main dashboard
│   │   │
│   │   ├── MachineLearning/
│   │   │   └── ML.js          # ML recommendations
│   │   │
│   │   ├── Visualization/
│   │   │   └── insights.js    # Data analytics
│   │   │
│   │   └── WordCloud/
│   │       ├── wordcloud.js   # Word cloud trigger
│   │       └── WordCloudImage.js # Display component
│   │
│   ├── App.js                  # Main app component
│   ├── App.css                 # Global styles
│   ├── index.js                # Entry point
│   ├── index.css               # Base styles
│   ├── setupTests.js           # Test configuration
│   ├── reportWebVitals.js      # Performance monitoring
│   └── App.test.js             # App tests
│
├── package.json                # Dependencies
└── README.md                   # This file
```

## 🚀 Getting Started

### Prerequisites

- Node.js 14 or higher
- npm or yarn
- AWS account with configured services
- Google Cloud account (for chat features)

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/your-org/HalifaxFoodie.git
cd HalifaxFoodie/frontend
```

2. **Install dependencies**:
```bash
npm install
```

3. **Configure environment variables**:

Create a `.env` file in the frontend directory:

```env
REACT_APP_API_GATEWAY_URL=https://your-api-gateway.amazonaws.com
REACT_APP_AWS_REGION=us-east-1
REACT_APP_LEX_BOT_NAME=HalifaxFoodieBot
REACT_APP_LEX_BOT_ALIAS=prod
REACT_APP_S3_BUCKET=halifaxfoodie
REACT_APP_WORDCLOUD_IMAGE_URL=https://halifaxfoodie.s3.amazonaws.com/halifaxFoodieCloud.png
REACT_APP_GCP_CHAT_API=https://your-chat-api.com
```

4. **Start the development server**:
```bash
npm start
```

The app will open at [http://localhost:3000](http://localhost:3000)

### Building for Production

```bash
npm run build
```

This creates an optimized production build in the `build/` directory.

### Deployment to AWS S3

```bash
# Build the app
npm run build

# Sync to S3 bucket
aws s3 sync build/ s3://your-bucket-name --delete

# Invalidate CloudFront cache (if using CloudFront)
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

## 🧭 Application Routes

| Route | Component | Auth Required | Description |
|-------|-----------|---------------|-------------|
| `/` | Login | No | User login page |
| `/register` | Registration | No | New user registration |
| `/home` | Homepage | Yes | Main dashboard |
| `/WordCloud` | WordCloud | Yes | Trigger word cloud generation |
| `/WordCloudImage` | WordCloudImage | Yes | Display generated word cloud |
| `/chatbot` | ChatBot | Yes | AI assistant interface |
| `/similarity` | ML | Yes | ML-based recommendations |

**Note**: Protected routes redirect to `/` if user is not authenticated.

## 🔐 Authentication Flow

1. User enters credentials on Login page
2. Frontend sends POST request to `/login` endpoint
3. Backend validates credentials against DynamoDB
4. On success, user data is stored in `localStorage`
5. User is redirected to `/home`
6. Protected routes check for `localStorage.getItem("user")`

**Security Considerations**:
- Passwords should be hashed (implement bcrypt in backend)
- Use JWT tokens instead of localStorage for production
- Implement token refresh mechanism
- Add HTTPS enforcement

## 📦 Key Dependencies

```json
{
  "@material-ui/core": "^4.12.2",
  "@material-ui/icons": "^4.11.2",
  "aws-sdk": "^2.953.0",
  "axios": "^0.21.1",
  "bulma": "^0.9.3",
  "react": "^17.0.2",
  "react-dom": "^17.0.2",
  "react-lex": "^1.2.1",
  "react-router-dom": "^5.2.0",
  "react-scripts": "4.0.3"
}
```

## 🎨 Styling

The project uses a combination of:
- **Bulma**: Lightweight CSS framework for layout
- **Material-UI**: React components with Material Design
- **Custom CSS**: Component-specific styles

### Theme Customization

To customize Material-UI theme, edit your component:

```javascript
import { createMuiTheme, ThemeProvider } from '@material-ui/core/styles';

const theme = createMuiTheme({
  palette: {
    primary: {
      main: '#your-color',
    },
  },
});

// Wrap your app
<ThemeProvider theme={theme}>
  <App />
</ThemeProvider>
```

## 🧪 Testing

### Run Tests

```bash
npm test
```

### Run Tests with Coverage

```bash
npm test -- --coverage
```

### Test Structure

- Unit tests for components
- Integration tests for user flows
- E2E tests with Cypress (to be added)

## 🔧 Available Scripts

- `npm start` - Start development server
- `npm test` - Run test suite
- `npm run build` - Create production build
- `npm run eject` - Eject from Create React App (irreversible)

## 🌐 API Integration

### Example: Calling Backend API

```javascript
import axios from 'axios';

const API_URL = process.env.REACT_APP_API_GATEWAY_URL;

// Login request
const login = async (email, password) => {
  try {
    const response = await axios.post(`${API_URL}/login`, {
      email,
      password
    });
    return response.data;
  } catch (error) {
    console.error('Login failed:', error);
    throw error;
  }
};
```

### AWS SDK Integration

```javascript
import AWS from 'aws-sdk';

AWS.config.update({
  region: process.env.REACT_APP_AWS_REGION,
  credentials: new AWS.CognitoIdentityCredentials({
    IdentityPoolId: 'your-identity-pool-id'
  })
});

const s3 = new AWS.S3();
```

## 🤖 Chatbot Integration

The app uses `react-lex` for AWS Lex integration:

```javascript
import { LexChat } from 'react-lex';

<LexChat
  botName={process.env.REACT_APP_LEX_BOT_NAME}
  IdentityPoolId="your-cognito-identity-pool-id"
  placeholder="Ask me anything..."
  backgroundColor="#FFFFFF"
  height="400px"
/>
```

## 📱 Progressive Web App

The app is configured as a PWA. To enable offline functionality:

1. Edit `src/index.js`:
```javascript
// Change from unregister() to register()
serviceWorker.register();
```

2. Customize `public/manifest.json` for your app

## 🐛 Troubleshooting

### Common Issues

**CORS Errors**:
- Ensure API Gateway has CORS enabled
- Check backend CORS configuration
- Verify request headers

**Authentication Issues**:
- Clear localStorage: `localStorage.clear()`
- Check API endpoint URLs
- Verify backend is running

**AWS SDK Errors**:
- Configure AWS credentials properly
- Check IAM permissions
- Verify region settings

**Build Errors**:
```bash
# Clear cache
rm -rf node_modules
rm package-lock.json
npm install
```

## 🚀 Performance Optimization

1. **Code Splitting**:
```javascript
const HomePage = React.lazy(() => import('./component/homepage/homepage'));
```

2. **Image Optimization**:
- Use WebP format
- Implement lazy loading
- Use CDN for static assets

3. **Bundle Size**:
```bash
npm run build
npm install -g source-map-explorer
source-map-explorer build/static/js/*.js
```

## 📊 Monitoring

### Performance Monitoring

The app uses `reportWebVitals` for performance tracking:

```javascript
reportWebVitals(console.log);
```

### Error Tracking

Consider integrating:
- Sentry for error tracking
- Google Analytics for usage analytics
- LogRocket for session replay

## 🔄 State Management

Currently using:
- React Hooks (useState, useEffect)
- localStorage for persistence
- React Router for navigation state

**Future Enhancement**: Consider Redux or Context API for complex state management.

## 🌍 Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| REACT_APP_API_GATEWAY_URL | Backend API URL | https://api.example.com |
| REACT_APP_AWS_REGION | AWS region | us-east-1 |
| REACT_APP_LEX_BOT_NAME | Lex bot name | HalifaxFoodieBot |
| REACT_APP_S3_BUCKET | S3 bucket name | halifaxfoodie |

## 📚 Additional Resources

- [React Documentation](https://reactjs.org/)
- [Material-UI Documentation](https://material-ui.com/)
- [Bulma Documentation](https://bulma.io/)
- [React Router Documentation](https://reactrouter.com/)
- [AWS SDK for JavaScript](https://docs.aws.amazon.com/sdk-for-javascript/)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Submit a pull request

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed guidelines.

## 📄 License

MIT License - See [LICENSE](../LICENSE) for details

---

**Happy Coding! 🚀**
