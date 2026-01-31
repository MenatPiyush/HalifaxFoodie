# Backend Services Documentation

This directory contains all serverless backend services for the Halifax Foodie platform.

## 📁 Directory Structure

```
backend/
├── Authentication/              # User management service
├── DataProcessing/              # Word cloud and NLP processing
├── MachineLearning/             # Recipe similarity engine
├── Online Chat/                 # Real-time messaging
│   ├── getmessages/
│   └── publishmsg/
└── Virtual Assistance/          # Chatbot fulfillment
```

## 🔧 Services

### 1. Authentication Service

**Technology**: Node.js, Express, AWS Lambda, DynamoDB

**Location**: `Authentication/`

**Purpose**: Handles user registration and authentication

**Endpoints**:
- `POST /register` - Register new user
- `POST /login` - Authenticate user

**Environment Variables**:
```bash
AWS_REGION=us-east-1
DYNAMODB_TABLE=user
```

**Dependencies**:
```json
{
  "aws-sdk": "^2.952.0",
  "cors": "^2.8.5",
  "express": "^4.17.1",
  "serverless-http": "^2.7.0"
}
```

**DynamoDB Schema**:
- Table: `user`
- Primary Key: `email` (String)
- Attributes: `name`, `password`, `type`

**Deployment**:
```bash
cd Authentication
npm install
zip -r function.zip .
aws lambda update-function-code --function-name halifaxfoodie-auth --zip-file fileb://function.zip
```

---

### 2. Data Processing Service

**Technology**: Python 3.9, AWS Lambda, DynamoDB, Comprehend, S3

**Location**: `DataProcessing/`

**Purpose**: Generates word clouds from restaurant reviews using NLP

**Features**:
- Scans all reviews from DynamoDB
- Uses AWS Comprehend for entity extraction
- Generates word cloud visualization
- Uploads image to S3 bucket

**Environment Variables**:
```bash
AWS_REGION=us-east-1
DYNAMODB_TABLE=Ratings
S3_BUCKET=halifaxfoodie
```

**Python Dependencies**:
```
boto3>=1.20.0
matplotlib>=3.5.0
wordcloud>=1.8.1
```

**Required IAM Permissions**:
- `dynamodb:Scan` on Ratings table
- `comprehend:DetectEntities`
- `s3:PutObject` on halifaxfoodie bucket

**Deployment**:
```bash
cd DataProcessing
pip install -r requirements.txt -t .
zip -r function.zip .
aws lambda update-function-code --function-name halifaxfoodie-wordcloud --zip-file fileb://function.zip
```

---

### 3. Machine Learning Service

**Technology**: Python 3.9, AWS Lambda, S3, DynamoDB

**Location**: `MachineLearning/`

**Purpose**: Recipe similarity analysis using cosine similarity

**Features**:
- Triggered by S3 upload events
- Compares new recipes with existing ones
- Uses textdistance library for similarity calculation
- Auto-categorizes recipes

**Environment Variables**:
```bash
AWS_REGION=us-east-1
RECIPE_BUCKET=csci5410-group-project-recipe-bucket
DYNAMODB_TABLE=recipes
```

**Python Dependencies**:
```
boto3>=1.20.0
textdistance>=4.2.0
```

**Trigger Configuration**:
- Event Type: S3 Object Created
- Bucket: `csci5410-group-project-recipe-bucket`
- Prefix: (all objects)

**Required IAM Permissions**:
- `s3:GetObject` on recipe bucket
- `s3:ListBucket` on recipe bucket
- `dynamodb:GetItem` on recipes table
- `dynamodb:PutItem` on recipes table

**Deployment**:
```bash
cd MachineLearning
pip install -r requirements.txt -t .
zip -r function.zip .
aws lambda update-function-code --function-name halifaxfoodie-ml --zip-file fileb://function.zip
```

---

### 4. Virtual Assistance Service

**Technology**: Python 3.9, AWS Lambda, AWS Lex, DynamoDB

**Location**: `Virtual Assistance/`

**Purpose**: Chatbot fulfillment logic for AWS Lex

**Intents Supported**:
1. **NavigationHelp**: Guides users through the app
   - Queries: orderfood, orderstatus, makepayment, contactstaff
   
2. **OrderStatus**: Retrieves order status from DynamoDB
   - Input: Order number
   - Output: Current order status

**Environment Variables**:
```bash
AWS_REGION=us-east-1
ORDERS_TABLE=orders
```

**DynamoDB Schema**:
- Table: `orders`
- Primary Key: `orderid` (Number)
- Attributes: `status`, `userId`, `restaurantId`, `items`, `timestamp`

**Required IAM Permissions**:
- `dynamodb:GetItem` on orders table

**Lex Bot Configuration**:
- Bot Name: HalifaxFoodieBot
- Intents: NavigationHelp, OrderStatus
- Fulfillment: AWS Lambda

**Deployment**:
```bash
cd "Virtual Assistance"
zip -r function.zip lambda_function.py
aws lambda update-function-code --function-name halifaxfoodie-lex --zip-file fileb://function.zip
```

---

### 5. Online Chat Service

**Technology**: Node.js, Express, Google Cloud Pub/Sub

**Location**: `Online Chat/`

**Purpose**: Real-time messaging between users and restaurants

#### 5a. Get Messages Function

**Location**: `Online Chat/getmessages/`

**Endpoint**: `GET /messages/:subscription`

**Features**:
- Pulls messages from GCP Pub/Sub subscription
- 30-second timeout for long-polling
- Acknowledges messages after retrieval

**Dependencies**:
```json
{
  "@google-cloud/pubsub": "^2.18.0",
  "express": "^4.17.1",
  "cors": "^2.8.5"
}
```

**Environment Variables**:
```bash
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
GCP_PROJECT_ID=your-project-id
```

**Deployment**:
```bash
cd "Online Chat/getmessages"
npm install
zip -r function.zip .
# Deploy to Google Cloud Functions or run as service
```

#### 5b. Publish Messages Function

**Location**: `Online Chat/publishmsg/`

**Endpoint**: `POST /messages/:topic`

**Features**:
- Publishes messages to GCP Pub/Sub topic
- Supports message attributes
- Async message delivery

**Dependencies**:
```json
{
  "@google-cloud/pubsub": "^2.18.0",
  "express": "^4.17.1",
  "cors": "^2.8.5"
}
```

**Deployment**:
```bash
cd "Online Chat/publishmsg"
npm install
zip -r function.zip .
# Deploy to Google Cloud Functions
```

---

## 🚀 Deployment Guide

### Prerequisites
- AWS CLI configured with appropriate credentials
- Python 3.9+ and pip
- Node.js 14+ and npm
- Google Cloud SDK (for chat services)
- Terraform (for automated deployment)

### Automated Deployment (Recommended)

Use Terraform to deploy all services:

```bash
cd ../terraform
terraform init
terraform plan
terraform apply
```

### Manual Deployment

Each service can be deployed individually using the commands in their respective sections above.

### Environment Setup

1. **AWS Credentials**:
```bash
aws configure
```

2. **Google Cloud Credentials**:
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

3. **Create DynamoDB Tables**:
```bash
# Using Terraform (recommended)
terraform apply -target=aws_dynamodb_table.user

# Or manually
aws dynamodb create-table \
  --table-name user \
  --attribute-definitions AttributeName=email,AttributeType=S \
  --key-schema AttributeName=email,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

## 🧪 Testing

### Local Testing

**Authentication Service**:
```bash
cd Authentication
npm install
npm test  # Add test scripts
```

**Python Services**:
```bash
cd DataProcessing
pip install -r requirements.txt
python -m pytest tests/  # Add tests
```

### API Testing

Use the provided Postman collection or curl:

```bash
# Register User
curl -X POST https://your-api-gateway.amazonaws.com/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com","password":"pass123","type":"customer"}'

# Login
curl -X POST https://your-api-gateway.amazonaws.com/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"pass123"}'
```

---

## 📊 Monitoring

### CloudWatch Logs

View logs for each Lambda:
```bash
aws logs tail /aws/lambda/halifaxfoodie-auth --follow
```

### CloudWatch Metrics

Monitor:
- Invocation count
- Duration
- Error rate
- Throttles

### Alarms

Set up CloudWatch alarms for:
- Lambda errors > threshold
- API Gateway 5xx errors
- DynamoDB throttling

---

## 🔒 Security Best Practices

1. **Use IAM roles** with least privilege
2. **Encrypt environment variables** in Lambda
3. **Enable API Gateway authentication**
4. **Use VPC** for sensitive Lambda functions
5. **Implement rate limiting** on API Gateway
6. **Validate all inputs** in Lambda functions
7. **Use AWS Secrets Manager** for credentials
8. **Enable CloudTrail** for audit logging

---

## 🐛 Troubleshooting

### Common Issues

**Lambda timeout errors**:
- Increase timeout in Lambda configuration
- Optimize DynamoDB queries
- Check for cold starts

**DynamoDB throttling**:
- Switch to on-demand billing mode
- Implement exponential backoff
- Use batch operations

**S3 permissions errors**:
- Verify IAM role has correct permissions
- Check bucket policy
- Ensure correct region configuration

**GCP Pub/Sub connection issues**:
- Verify service account credentials
- Check Pub/Sub API is enabled
- Validate topic and subscription names

---

## 📚 Additional Resources

- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/)
- [DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)
- [AWS Lex Documentation](https://docs.aws.amazon.com/lex/)
- [Google Cloud Pub/Sub Documentation](https://cloud.google.com/pubsub/docs)

---

## 📧 Support

For issues or questions about backend services:
- Check the logs in CloudWatch
- Review the architecture documentation
- Create an issue in the GitHub repository
