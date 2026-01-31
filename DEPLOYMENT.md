# Deployment Guide

Comprehensive guide for deploying Halifax Foodie to AWS.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Pre-Deployment Checklist](#pre-deployment-checklist)
- [Automated Deployment](#automated-deployment)
- [Manual Deployment](#manual-deployment)
- [Post-Deployment](#post-deployment)
- [Troubleshooting](#troubleshooting)
- [Rollback Procedure](#rollback-procedure)

## Prerequisites

### Required Tools

| Tool | Version | Installation |
|------|---------|--------------|
| AWS CLI | 2.x+ | [Install Guide](https://aws.amazon.com/cli/) |
| Terraform | 1.0+ | [Install Guide](https://www.terraform.io/downloads) |
| Node.js | 14+ | [Install Guide](https://nodejs.org/) |
| Python | 3.9+ | [Install Guide](https://www.python.org/) |
| Git | Any | [Install Guide](https://git-scm.com/) |

### AWS Account Setup

1. **Create IAM User** with the following permissions:
   - AWSLambdaFullAccess
   - AmazonDynamoDBFullAccess
   - AmazonS3FullAccess
   - AmazonAPIGatewayAdministrator
   - IAMFullAccess
   - CloudWatchLogsFullAccess

2. **Configure AWS CLI**:
```bash
aws configure
AWS Access Key ID: YOUR_ACCESS_KEY
AWS Secret Access Key: YOUR_SECRET_KEY
Default region name: us-east-1
Default output format: json
```

3. **Verify Configuration**:
```bash
aws sts get-caller-identity
```

## Pre-Deployment Checklist

- [ ] AWS account set up with proper IAM permissions
- [ ] AWS CLI configured with credentials
- [ ] All prerequisite tools installed
- [ ] Repository cloned locally
- [ ] `terraform.tfvars` file created and configured
- [ ] Lambda function dependencies reviewed
- [ ] Frontend environment variables configured

## Automated Deployment

### Using the Deployment Script (Recommended)

The easiest way to deploy is using the provided deployment script:

```bash
# Make script executable (if not already)
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

The script will:
1. ✅ Check all prerequisites
2. ✅ Package Lambda functions
3. ✅ Deploy infrastructure with Terraform
4. ✅ Build and deploy frontend
5. ✅ Display all URLs and endpoints

**Expected Duration**: 5-10 minutes

### Using GitHub Actions

For CI/CD deployment:

1. **Set up GitHub Secrets**:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `CLOUDFRONT_DISTRIBUTION_ID` (optional)

2. **Push to main branch**:
```bash
git add .
git commit -m "Deploy to production"
git push origin main
```

3. **Monitor deployment**:
   - Go to Actions tab in GitHub
   - Watch the CI/CD pipeline run

## Manual Deployment

### Step 1: Prepare Lambda Packages

```bash
# Create packages directory
mkdir -p terraform/lambda-packages

# Package Authentication Service
cd backend/Authentication
npm install --production
zip -r ../../terraform/lambda-packages/authentication.zip .
cd ../..

# Package Data Processing Service
cd backend/DataProcessing
pip install -r requirements.txt -t .
zip -r ../../terraform/lambda-packages/dataprocessing.zip .
cd ../..

# Package Machine Learning Service
cd backend/MachineLearning
pip install textdistance boto3 -t .
zip -r ../../terraform/lambda-packages/machinelearning.zip .
cd ../..

# Package Virtual Assistance Service
cd "backend/Virtual Assistance"
zip -r ../../terraform/lambda-packages/virtualassistance.zip .
cd ../..
```

### Step 2: Configure Terraform

```bash
cd terraform

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars
nano terraform.tfvars
```

**Required Configuration**:
```hcl
project_name = "halifaxfoodie"
aws_region   = "us-east-1"
environment  = "production"
```

### Step 3: Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Apply configuration
terraform apply
```

Review the plan and type `yes` to confirm.

### Step 4: Deploy Frontend

```bash
cd ../frontend

# Install dependencies
npm install

# Build production bundle
npm run build

# Get S3 bucket name
cd ../terraform
BUCKET_NAME=$(terraform output -raw frontend_bucket_name)

# Deploy to S3
cd ..
aws s3 sync frontend/build/ s3://$BUCKET_NAME --delete
```

### Step 5: Verify Deployment

```bash
cd terraform

# Get all outputs
terraform output

# Test API Gateway
API_URL=$(terraform output -raw api_gateway_url)
curl $API_URL/health || echo "No health endpoint configured"
```

## Post-Deployment

### 1. Test the Application

```bash
# Get frontend URL
cd terraform
FRONTEND_URL=$(terraform output -raw frontend_website_url)
echo "Frontend: http://$FRONTEND_URL"

# Open in browser
open "http://$FRONTEND_URL"  # macOS
# or
xdg-open "http://$FRONTEND_URL"  # Linux
```

### 2. Configure Frontend Environment

Update frontend to use deployed API:

```bash
# Create .env.production in frontend/
cat > frontend/.env.production << EOF
REACT_APP_API_GATEWAY_URL=$(cd terraform && terraform output -raw api_gateway_url)
REACT_APP_AWS_REGION=us-east-1
REACT_APP_S3_BUCKET=$(cd terraform && terraform output -raw storage_bucket_name)
EOF

# Rebuild and redeploy
cd frontend
npm run build
aws s3 sync build/ s3://$(cd ../terraform && terraform output -raw frontend_bucket_name) --delete
```

### 3. Set Up Monitoring

```bash
# View Lambda logs
aws logs tail /aws/lambda/halifaxfoodie-auth --follow

# View API Gateway logs
aws logs tail /aws/apigateway/halifaxfoodie --follow
```

### 4. Configure CloudFront (Optional)

For better performance:

```bash
# Enable CloudFront in terraform.tfvars
echo 'enable_cloudfront = true' >> terraform/terraform.tfvars

# Apply changes
cd terraform
terraform apply
```

### 5. Set Up Custom Domain (Optional)

1. Purchase domain in Route53
2. Create SSL certificate in ACM
3. Update `terraform.tfvars`:
```hcl
domain_name = "halifaxfoodie.com"
```
4. Apply changes:
```bash
terraform apply
```

## Troubleshooting

### Common Issues

#### 1. Lambda Deployment Failed

**Error**: `Error creating Lambda function: InvalidParameterValueException`

**Solution**:
```bash
# Check zip file size
ls -lh terraform/lambda-packages/*.zip

# Ensure files are not too large (< 50MB uncompressed)
# Remove unnecessary files from package
```

#### 2. Terraform State Lock

**Error**: `Error locking state: resource temporarily unavailable`

**Solution**:
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID
```

#### 3. S3 Bucket Already Exists

**Error**: `BucketAlreadyExists`

**Solution**:
```bash
# Change bucket name in terraform.tfvars
# Or import existing bucket
terraform import aws_s3_bucket.frontend existing-bucket-name
```

#### 4. IAM Permission Errors

**Error**: `AccessDenied`

**Solution**:
- Verify IAM user has required permissions
- Check AWS credentials are correct
- Ensure credentials are not expired

#### 5. API Gateway CORS Errors

**Error**: `No 'Access-Control-Allow-Origin' header`

**Solution**:
- Verify CORS configuration in `api-gateway.tf`
- Check Lambda responses include CORS headers
- Test with browser console open

### Debug Mode

Enable detailed logging:

```bash
# Terraform debug
export TF_LOG=DEBUG
terraform apply

# AWS CLI debug
aws s3 ls --debug
```

## Rollback Procedure

### Quick Rollback

```bash
cd terraform

# Destroy all resources
terraform destroy
```

### Selective Rollback

```bash
# Rollback specific Lambda
terraform destroy -target=aws_lambda_function.auth

# Rollback frontend only
aws s3 rm s3://bucket-name --recursive
```

### Restore from Backup

```bash
# DynamoDB point-in-time recovery
aws dynamodb restore-table-to-point-in-time \
  --source-table-name user \
  --target-table-name user-restored \
  --restore-date-time 2026-01-30T10:00:00Z
```

## Cost Optimization

### Monitor Costs

```bash
# Get cost estimate
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

### Optimization Tips

1. **Use Reserved Capacity**: For predictable workloads
2. **Enable S3 Lifecycle Policies**: Archive old data
3. **Set Lambda Memory Appropriately**: Don't over-provision
4. **Use DynamoDB On-Demand**: For variable workloads
5. **Enable CloudWatch Log Retention**: Delete old logs

## Security Hardening

### Post-Deployment Security

1. **Enable MFA Delete on S3 buckets**
2. **Rotate AWS access keys regularly**
3. **Enable AWS CloudTrail for audit logging**
4. **Set up AWS GuardDuty for threat detection**
5. **Implement AWS WAF on API Gateway**
6. **Enable S3 bucket encryption**
7. **Use AWS Secrets Manager for sensitive data**

### Security Checklist

- [ ] MFA enabled on AWS account
- [ ] CloudTrail logging enabled
- [ ] S3 buckets encrypted
- [ ] Lambda environment variables encrypted
- [ ] API Gateway authentication enabled
- [ ] Security groups properly configured
- [ ] IAM roles follow least privilege principle

## Maintenance

### Regular Updates

```bash
# Update Lambda dependencies monthly
cd backend/Authentication
npm update
npm audit fix

# Update Terraform providers
cd terraform
terraform init -upgrade
```

### Backup Strategy

1. **DynamoDB**: Point-in-time recovery enabled
2. **S3**: Versioning enabled
3. **Terraform State**: Stored in S3 with versioning
4. **Code**: Git repository with tags

## Additional Resources

- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [API Gateway Documentation](https://docs.aws.amazon.com/apigateway/)
- [DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)

---

**Need Help?** Open an issue on GitHub or contact the development team.
