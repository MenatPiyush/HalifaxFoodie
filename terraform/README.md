# Halifax Foodie - Terraform Infrastructure

This directory contains Terraform configuration files for provisioning and managing the Halifax Foodie cloud infrastructure.

## 📋 Overview

The infrastructure is built on AWS with some components on Google Cloud Platform (GCP). Terraform manages:

- AWS Lambda Functions (5 services)
- API Gateway (REST API)
- DynamoDB Tables (4 tables)
- S3 Buckets (static hosting & storage)
- IAM Roles & Policies
- CloudWatch Logs
- CloudFront Distribution (optional)

## 📁 File Structure

```
terraform/
├── README.md              # This file
├── main.tf                # Main configuration and provider setup
├── variables.tf           # Input variables
├── outputs.tf             # Output values
├── lambda.tf              # Lambda functions and permissions
├── dynamodb.tf            # DynamoDB tables
├── s3.tf                  # S3 buckets and policies
├── api-gateway.tf         # API Gateway configuration
├── iam.tf                 # IAM roles and policies
├── cloudwatch.tf          # CloudWatch logs and alarms
└── terraform.tfvars       # Variable values (create this file)
```

## 🚀 Quick Start

### Prerequisites

1. **Install Terraform**:
```bash
# macOS
brew install terraform

# Verify installation
terraform --version
```

2. **Configure AWS CLI**:
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your default region (e.g., us-east-1)
```

3. **Prepare Lambda Deployment Packages**:
```bash
cd ../backend

# Authentication service
cd Authentication
npm install
zip -r ../../terraform/lambda-packages/authentication.zip .

# Data Processing service
cd ../DataProcessing
pip install -r requirements.txt -t .
zip -r ../../terraform/lambda-packages/dataprocessing.zip .

# Machine Learning service
cd ../MachineLearning
pip install textdistance boto3 -t .
zip -r ../../terraform/lambda-packages/machinelearning.zip .

# Virtual Assistance service
cd "../Virtual Assistance"
zip -r ../../terraform/lambda-packages/virtualassistance.zip .
```

### Deployment Steps

1. **Initialize Terraform**:
```bash
cd terraform
terraform init
```

2. **Create `terraform.tfvars`**:
```hcl
project_name = "halifaxfoodie"
aws_region   = "us-east-1"
environment  = "production"

# Optional: Your domain name
domain_name = "halifaxfoodie.com"
```

3. **Review the Plan**:
```bash
terraform plan
```

4. **Apply Configuration**:
```bash
terraform apply
```

5. **Note the Outputs**:
```bash
terraform output
```

## 🔧 Configuration

### Required Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Project identifier | halifaxfoodie |
| `aws_region` | AWS region | us-east-1 |
| `environment` | Environment name | production |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `lambda_timeout` | Lambda timeout in seconds | 30 |
| `lambda_memory` | Lambda memory in MB | 256 |
| `domain_name` | Custom domain name | null |
| `enable_cloudfront` | Enable CloudFront CDN | false |

## 📦 Resources Created

### Lambda Functions

- **halifaxfoodie-auth**: User authentication
- **halifaxfoodie-dataprocessing**: Word cloud generation
- **halifaxfoodie-ml**: Machine learning similarity
- **halifaxfoodie-virtualassistance**: Chatbot fulfillment

### DynamoDB Tables

- **user**: User accounts
- **Ratings**: Restaurant ratings and reviews
- **recipes**: Recipe categorization
- **orders**: Order tracking

### S3 Buckets

- **halifaxfoodie-frontend**: Static website hosting
- **halifaxfoodie-storage**: Application data storage
- **csci5410-group-project-recipe-bucket**: Recipe files

### API Gateway

- REST API with CORS enabled
- Stage: production
- Endpoints: /register, /login, /wordcloud, etc.

## 🔐 Security

### IAM Policies

- Lambda execution roles with minimal permissions
- S3 bucket policies for secure access
- API Gateway authentication (implement later)

### Secrets Management

Store sensitive data in AWS Secrets Manager (not included in this template):

```bash
aws secretsmanager create-secret \
  --name halifaxfoodie/db-credentials \
  --secret-string '{"username":"admin","password":"your-password"}'
```

## 🧪 Testing Infrastructure

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt

# Test with dry-run
terraform plan

# Target specific resources
terraform plan -target=aws_lambda_function.auth
```

## 📊 Monitoring

### View Resources

```bash
# List all resources
terraform state list

# Show specific resource
terraform state show aws_lambda_function.auth
```

### CloudWatch

Access logs:
```bash
aws logs tail /aws/lambda/halifaxfoodie-auth --follow
```

## 🔄 Updates

### Update Lambda Code

```bash
# Update the zip file
cd ../backend/Authentication
zip -r ../../terraform/lambda-packages/authentication.zip .

# Apply changes
cd ../../terraform
terraform apply -target=aws_lambda_function.auth
```

### Update Infrastructure

```bash
# Pull latest changes
git pull

# Apply updates
terraform plan
terraform apply
```

## 🗑️ Cleanup

### Destroy All Resources

```bash
terraform destroy
```

### Destroy Specific Resources

```bash
terraform destroy -target=aws_lambda_function.auth
```

**Warning**: This will permanently delete resources and data!

## 🐛 Troubleshooting

### Common Issues

**State Lock Errors**:
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID
```

**Provider Errors**:
```bash
# Re-initialize providers
rm -rf .terraform
terraform init
```

**Lambda Deployment Errors**:
- Verify zip file exists in `lambda-packages/`
- Check file size < 50MB (unzipped)
- Ensure dependencies are included

**API Gateway 502 Errors**:
- Check Lambda execution logs
- Verify IAM permissions
- Test Lambda function directly

## 📈 Cost Estimation

Approximate monthly costs (us-east-1):

- Lambda: $5-20 (1M requests)
- DynamoDB: $5-15 (on-demand)
- S3: $1-5 (storage & requests)
- API Gateway: $3.50 (1M requests)
- CloudWatch: $1-3 (logs)

**Total**: ~$15-45/month for light usage

Use AWS Cost Calculator for accurate estimates.

## 🔧 Advanced Configuration

### Enable CloudFront

In `terraform.tfvars`:
```hcl
enable_cloudfront = true
```

### Custom Domain

1. Purchase domain in Route53
2. Create SSL certificate in ACM
3. Update `terraform.tfvars`:
```hcl
domain_name = "halifaxfoodie.com"
```

### Multi-Environment Setup

```bash
# Development
terraform workspace new dev
terraform apply -var-file="dev.tfvars"

# Production
terraform workspace new prod
terraform apply -var-file="prod.tfvars"
```

## 📚 Additional Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Lambda with Terraform](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 🤝 Contributing

1. Make changes in a feature branch
2. Test with `terraform plan`
3. Update documentation
4. Submit pull request

## 📞 Support

For infrastructure issues:
- Check CloudWatch logs
- Review Terraform state
- Create GitHub issue with logs

---

**Note**: Always review `terraform plan` output before applying changes to production!
