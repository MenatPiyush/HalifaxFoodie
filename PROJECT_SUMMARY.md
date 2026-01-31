# Project Summary - Halifax Foodie

## 📊 Project Overview

**Halifax Foodie** is a cloud-native restaurant discovery and review platform built with serverless architecture on AWS and GCP. The platform leverages AI/ML for personalized recommendations and natural language processing for insights extraction.

## 🎯 Key Features

| Feature | Technology | Description |
|---------|-----------|-------------|
| User Authentication | AWS Lambda + DynamoDB | Secure registration and login system |
| Restaurant Reviews | React + DynamoDB | User-generated ratings and comments |
| Word Cloud Analytics | AWS Comprehend + Python | NLP-powered entity extraction and visualization |
| ML Recommendations | Python + Cosine Similarity | Recipe categorization and similarity matching |
| Chatbot Assistant | AWS Lex | Order tracking and navigation help |
| Real-time Chat | Google Cloud Pub/Sub | Customer-restaurant messaging |

## 🏗️ Architecture Summary

### Frontend
- **Framework**: React 17
- **Hosting**: AWS S3 + CloudFront (optional)
- **UI Libraries**: Material-UI, Bulma

### Backend
- **Compute**: AWS Lambda (serverless)
- **API**: AWS API Gateway (REST)
- **Database**: DynamoDB (4 tables)
- **Storage**: S3 (3 buckets)
- **AI/ML**: AWS Comprehend, AWS Lex
- **Messaging**: Google Cloud Pub/Sub

### Infrastructure
- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **Monitoring**: CloudWatch
- **Logging**: CloudWatch Logs

## 📁 Repository Structure

```
HalifaxFoodie/
├── README.md                    # Main project documentation
├── QUICKSTART.md                # Quick setup guide
├── DEPLOYMENT.md                # Detailed deployment guide
├── ARCHITECTURE.md              # System architecture
├── CONTRIBUTING.md              # Contribution guidelines
├── CHANGELOG.md                 # Version history
├── LICENSE                      # MIT License
├── .gitignore                   # Git ignore rules
├── deploy.sh                    # Automated deployment script
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml           # GitHub Actions pipeline
│
├── frontend/                    # React application
│   ├── README.md               # Frontend documentation
│   ├── package.json            # Dependencies
│   ├── public/                 # Static assets
│   └── src/                    # Source code
│       ├── component/          # React components
│       └── App.js              # Main app component
│
├── backend/                     # Lambda functions
│   ├── README.md               # Backend documentation
│   ├── Authentication/         # User management (Node.js)
│   ├── DataProcessing/         # Word cloud (Python)
│   ├── MachineLearning/        # Similarity (Python)
│   ├── Virtual Assistance/     # Lex fulfillment (Python)
│   └── Online Chat/            # Messaging (Node.js)
│       ├── getmessages/
│       └── publishmsg/
│
└── terraform/                   # Infrastructure as Code
    ├── README.md               # Terraform documentation
    ├── main.tf                 # Provider configuration
    ├── variables.tf            # Input variables
    ├── outputs.tf              # Output values
    ├── iam.tf                  # IAM roles and policies
    ├── lambda.tf               # Lambda functions
    ├── dynamodb.tf             # DynamoDB tables
    ├── s3.tf                   # S3 buckets
    ├── api-gateway.tf          # API Gateway
    ├── cloudwatch.tf           # Monitoring
    └── terraform.tfvars.example # Configuration template
```

## 🚀 Quick Start

1. **Clone repository**:
   ```bash
   git clone <repo-url>
   cd HalifaxFoodie
   ```

2. **Configure AWS**:
   ```bash
   aws configure
   ```

3. **Deploy**:
   ```bash
   ./deploy.sh
   ```

See [QUICKSTART.md](QUICKSTART.md) for detailed instructions.

## 📚 Documentation Index

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Main project overview and features |
| [QUICKSTART.md](QUICKSTART.md) | Get started in 5 minutes |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Comprehensive deployment guide |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System design and architecture |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute to the project |
| [CHANGELOG.md](CHANGELOG.md) | Version history and changes |
| [backend/README.md](backend/README.md) | Backend services documentation |
| [frontend/README.md](frontend/README.md) | Frontend development guide |
| [terraform/README.md](terraform/README.md) | Infrastructure documentation |

## 🔧 Technology Stack

### Languages
- JavaScript (ES6+)
- Python 3.9
- HCL (Terraform)

### Frontend
- React 17.0.2
- Material-UI 4.12
- Bulma CSS
- Axios
- React Router DOM

### Backend
- Node.js 18.x
- Express.js
- Python 3.9
- Boto3 (AWS SDK)

### Cloud Services (AWS)
- Lambda
- API Gateway
- DynamoDB
- S3
- CloudWatch
- Comprehend
- Lex
- CloudFront (optional)

### Cloud Services (GCP)
- Cloud Pub/Sub
- Cloud Functions (optional)

### DevOps
- Terraform 1.0+
- GitHub Actions
- AWS CLI
- Docker (future)

## 📊 Resource Inventory

### AWS Lambda Functions (4)
- `halifaxfoodie-auth` - Authentication
- `halifaxfoodie-dataprocessing` - Word Cloud
- `halifaxfoodie-ml` - Machine Learning
- `halifaxfoodie-virtualassistance` - Chatbot

### DynamoDB Tables (4)
- `user` - User accounts
- `Ratings` - Restaurant reviews
- `recipes` - Recipe categorization
- `orders` - Order tracking

### S3 Buckets (3)
- Frontend hosting bucket
- Application storage bucket
- Recipe files bucket

### API Gateway
- REST API with CORS
- Multiple endpoints (auth, wordcloud, etc.)

## 💰 Estimated Costs

**Monthly cost for moderate usage**:
- Lambda: $10-20
- DynamoDB: $5-15
- S3: $2-5
- API Gateway: $3-5
- CloudWatch: $2-3
- **Total**: ~$25-50/month

## 🔐 Security Features

- IAM roles with least privilege
- DynamoDB encryption at rest
- S3 bucket policies
- API Gateway CORS
- CloudWatch logging
- Environment variable encryption

## 📈 Scalability

- **Lambda**: Auto-scales to thousands of concurrent executions
- **DynamoDB**: On-demand capacity scaling
- **S3**: Unlimited storage
- **API Gateway**: Handles millions of requests
- **CloudFront**: Global CDN for low latency

## 🧪 Testing

- Frontend: Jest + React Testing Library
- Backend: Unit tests for Lambda functions
- Infrastructure: Terraform validation
- CI/CD: Automated testing in GitHub Actions

## 🔄 CI/CD Pipeline

1. **Push to branch** → GitHub Actions triggered
2. **Run tests** → Frontend and backend tests
3. **Security scan** → Trivy vulnerability scanning
4. **Terraform validate** → Infrastructure validation
5. **Deploy** → Automated deployment to AWS
6. **Notify** → Deployment status notification

## 📝 Development Workflow

1. Fork repository
2. Create feature branch
3. Make changes
4. Write tests
5. Commit with conventional commits
6. Push to fork
7. Create pull request
8. Code review
9. Merge to main
10. Automatic deployment


## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

## 🎯 Future Enhancements

- [ ] Implement authentication with JWT
- [ ] Add payment integration
- [ ] Advanced analytics dashboard