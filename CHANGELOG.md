# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial GitHub-ready documentation
- Comprehensive README with architecture overview
- Architecture diagrams with Mermaid
- Terraform infrastructure as code
- Backend and Frontend specific READMEs
- Contributing guidelines
- MIT License
- .gitignore file

## [1.0.0] - 2026-01-30

### Added
- User authentication system (registration and login)
- Restaurant review and rating system
- Word cloud visualization with AWS Comprehend
- Machine learning recipe similarity engine
- AWS Lex chatbot for virtual assistance
- Real-time chat using Google Cloud Pub/Sub
- Data insights and visualization dashboard
- React frontend with Material-UI and Bulma
- AWS Lambda backend services
- DynamoDB data storage
- S3 bucket storage for files and images

### Features
- **Authentication Service**: User management with DynamoDB
- **Data Processing**: NLP-powered word cloud generation
- **Machine Learning**: Cosine similarity for recipe recommendations
- **Virtual Assistant**: Order status and navigation help via chatbot
- **Online Chat**: Real-time messaging between users and restaurants

### Infrastructure
- AWS Lambda functions for serverless compute
- API Gateway for REST endpoints
- DynamoDB tables for data persistence
- S3 buckets for storage and hosting
- CloudWatch for logging and monitoring
- Terraform for infrastructure management

---

## How to Update

When making changes:

1. Add changes under `[Unreleased]` section
2. Categorize changes:
   - `Added` for new features
   - `Changed` for changes in existing functionality
   - `Deprecated` for soon-to-be removed features
   - `Removed` for now removed features
   - `Fixed` for any bug fixes
   - `Security` for vulnerability fixes

Example:
```markdown
## [Unreleased]

### Added
- New payment gateway integration

### Fixed
- Fixed authentication timeout issue
```
