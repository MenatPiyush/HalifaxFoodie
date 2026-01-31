# Halifax Foodie 🍽️

A comprehensive cloud-based food review and restaurant management platform built with serverless architecture. Halifax Foodie enables users to discover restaurants, share reviews, get personalized recommendations using machine learning, and interact with an intelligent chatbot assistant.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Infrastructure](#infrastructure)
- [Services Overview](#services-overview)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

- **User Authentication**: Secure registration and login system
- **Restaurant Reviews**: Browse and submit restaurant reviews
- **Word Cloud Visualization**: AI-powered entity extraction and visualization from reviews
- **Machine Learning Recommendations**: Cosine similarity-based recipe/restaurant recommendations
- **Intelligent Chatbot**: AWS Lex-powered virtual assistant for navigation and order status
- **Real-time Chat**: Google Cloud Pub/Sub-based messaging system
- **Data Insights**: Analytics and visualization of user feedback

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Frontend (React)                            │
│                      Hosted on AWS S3/CloudFront                    │
└────────────┬──────────────────────────────────────────┬─────────────┘
             │                                           │
             ├───────────────┬──────────────┬───────────┤
             ▼               ▼              ▼           ▼
    ┌────────────────┐ ┌──────────┐ ┌─────────┐ ┌─────────────┐
    │  API Gateway   │ │ AWS Lex  │ │   GCP   │ │   AWS S3    │
    │                │ │ Chatbot  │ │ Pub/Sub │ │   Bucket    │
    └───────┬────────┘ └────┬─────┘ └────┬────┘ └──────┬──────┘
            │               │            │             │
    ┌───────┴────────────────────────────┴─────────────┴──────────┐
    │                    AWS Lambda Functions                      │
    ├──────────────────────────────────────────────────────────────┤
    │ • Authentication        • Data Processing (WordCloud)        │
    │ • Machine Learning      • Virtual Assistance                 │
    │ • Online Chat (Get/Publish Messages)                         │
    └──────────────────┬─────────────────────────────────┬─────────┘
                       │                                 │
            ┌──────────┴────────────┐        ┌──────────┴────────────┐
            │   DynamoDB Tables     │        │  AWS Comprehend       │
            ├───────────────────────┤        │  (NLP Service)        │
            │ • user                │        └───────────────────────┘
            │ • Ratings             │
            │ • recipes             │
            │ • orders              │
            └───────────────────────┘
```

## 🛠️ Technology Stack

### Frontend
- **Framework**: React 17
- **UI Libraries**: Material-UI, Bulma
- **State Management**: React Router DOM
- **API Integration**: Axios, AWS SDK
- **Chatbot**: React-Lex

### Backend
- **Serverless**: AWS Lambda, Google Cloud Functions
- **API**: Express.js with Serverless HTTP
- **Database**: AWS DynamoDB
- **Storage**: AWS S3
- **Messaging**: Google Cloud Pub/Sub
- **AI/ML**: AWS Lex, AWS Comprehend
- **Languages**: Node.js (JavaScript), Python 3.9+

### Infrastructure
- **IaC**: Terraform
- **Cloud Providers**: AWS, Google Cloud Platform
- **CI/CD**: (Ready for GitHub Actions integration)

## 📁 Project Structure

```
HalifaxFoodie/
├── frontend/                          # React frontend application
│   ├── src/
│   │   ├── component/
│   │   │   ├── Authentication/        # Login and Registration
│   │   │   ├── Chat/                  # Real-time chat interface
│   │   │   ├── Chatbot/               # AWS Lex chatbot integration
│   │   │   ├── homepage/              # Main dashboard
│   │   │   ├── MachineLearning/       # ML recommendations UI
│   │   │   ├── Visualization/         # Data insights and analytics
│   │   │   └── WordCloud/             # Word cloud visualization
│   │   └── App.js                     # Main application component
│   └── package.json
│
├── backend/                           # Serverless backend services
│   ├── Authentication/                # User management Lambda
│   ├── DataProcessing/                # Word cloud generation
│   ├── MachineLearning/               # Cosine similarity engine
│   ├── Online Chat/                   # Pub/Sub messaging
│   │   ├── getmessages/
│   │   └── publishmsg/
│   └── Virtual Assistance/            # AWS Lex Lambda fulfillment
│
└── terraform/                         # Infrastructure as Code
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── lambda.tf
    ├── dynamodb.tf
    ├── s3.tf
    └── api-gateway.tf
```

## 🚀 Getting Started

### Prerequisites

- Node.js 14+ and npm
- Python 3.9+
- AWS Account with configured credentials
- Google Cloud Account (for Pub/Sub)
- Terraform 1.0+

### Frontend Setup

```bash
cd frontend
npm install
npm start
```

The application will run on `http://localhost:3000`

### Backend Setup

Each Lambda function can be deployed individually or using Terraform (recommended).

#### Manual Lambda Deployment

```bash
# Authentication Service
cd backend/Authentication
npm install
zip -r function.zip .
aws lambda update-function-code --function-name user-management --zip-file fileb://function.zip

# Data Processing
cd backend/DataProcessing
pip install -r requirements.txt -t .
zip -r function.zip .
aws lambda update-function-code --function-name wordcloud-generator --zip-file fileb://function.zip
```

### Infrastructure Deployment (Recommended)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

See [terraform/README.md](terraform/README.md) for detailed infrastructure documentation.

## 🔧 Infrastructure

The project uses Terraform to manage cloud infrastructure across AWS and GCP:

- **AWS Lambda Functions**: Serverless compute for all backend services
- **API Gateway**: RESTful API endpoints
- **DynamoDB**: NoSQL database for user data, ratings, recipes, and orders
- **S3 Buckets**: Static website hosting and file storage
- **CloudFront**: CDN for frontend distribution
- **AWS Lex**: Conversational AI chatbot
- **AWS Comprehend**: Natural language processing for entity extraction
- **IAM Roles & Policies**: Secure access management
- **Google Cloud Pub/Sub**: Real-time messaging infrastructure

## 📦 Services Overview

### Authentication Service
- User registration and login
- Password validation
- Session management
- DynamoDB user table integration

### Data Processing Service
- Scans restaurant ratings and comments
- Extracts entities using AWS Comprehend
- Generates word cloud visualizations
- Stores images in S3 bucket

### Machine Learning Service
- Cosine similarity algorithm for recipe matching
- Automated recipe categorization
- S3-triggered processing pipeline
- DynamoDB recipe classification

### Virtual Assistance Service
- AWS Lex chatbot integration
- Order status tracking
- Navigation help
- Food ordering guidance

### Online Chat Service
- Google Cloud Pub/Sub messaging
- Real-time message retrieval
- Subscription-based message handling
- Customer-restaurant communication

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
