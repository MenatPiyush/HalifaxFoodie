#!/bin/bash

# Halifax Foodie Deployment Script
# This script packages and deploys the Halifax Foodie application

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
AWS_REGION="${AWS_REGION:-us-east-1}"
ENVIRONMENT="${ENVIRONMENT:-production}"
PROJECT_NAME="halifaxfoodie"

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Halifax Foodie Deployment Script${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Check prerequisites
check_prerequisites() {
    echo -e "${YELLOW}Checking prerequisites...${NC}"
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}Error: AWS CLI is not installed${NC}"
        exit 1
    fi
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        echo -e "${RED}Error: Terraform is not installed${NC}"
        exit 1
    fi
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Error: Node.js is not installed${NC}"
        exit 1
    fi
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Error: Python 3 is not installed${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ All prerequisites met${NC}"
    echo ""
}

# Package Lambda functions
package_lambda_functions() {
    echo -e "${YELLOW}Packaging Lambda functions...${NC}"
    
    # Create lambda-packages directory
    mkdir -p terraform/lambda-packages
    
    # Package Authentication Service
    echo "  Packaging Authentication service..."
    cd backend/Authentication
    npm install --production --silent
    zip -rq ../../terraform/lambda-packages/authentication.zip . -x "*.git*" "node_modules/.cache/*"
    cd ../..
    
    # Package Data Processing Service
    echo "  Packaging Data Processing service..."
    cd backend/DataProcessing
    pip install -r requirements.txt -t . --quiet 2>/dev/null || true
    zip -rq ../../terraform/lambda-packages/dataprocessing.zip . -x "*.git*" "*__pycache__*"
    cd ../..
    
    # Package Machine Learning Service
    echo "  Packaging Machine Learning service..."
    cd backend/MachineLearning
    pip install textdistance boto3 -t . --quiet 2>/dev/null || true
    zip -rq ../../terraform/lambda-packages/machinelearning.zip . -x "*.git*" "*__pycache__*"
    cd ../..
    
    # Package Virtual Assistance Service
    echo "  Packaging Virtual Assistance service..."
    cd "backend/Virtual Assistance"
    zip -rq ../../terraform/lambda-packages/virtualassistance.zip . -x "*.git*" "*__pycache__*"
    cd ../..
    
    echo -e "${GREEN}✓ Lambda functions packaged${NC}"
    echo ""
}

# Deploy infrastructure with Terraform
deploy_infrastructure() {
    echo -e "${YELLOW}Deploying infrastructure with Terraform...${NC}"
    
    cd terraform
    
    # Check if tfvars file exists
    if [ ! -f "terraform.tfvars" ]; then
        echo -e "${RED}Error: terraform.tfvars not found${NC}"
        echo "Please create terraform.tfvars from terraform.tfvars.example"
        exit 1
    fi
    
    # Initialize Terraform
    echo "  Initializing Terraform..."
    terraform init -upgrade
    
    # Validate configuration
    echo "  Validating configuration..."
    terraform validate
    
    # Plan deployment
    echo "  Planning deployment..."
    terraform plan -out=tfplan
    
    # Ask for confirmation
    echo ""
    read -p "Do you want to apply these changes? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo -e "${YELLOW}Deployment cancelled${NC}"
        exit 0
    fi
    
    # Apply changes
    echo "  Applying changes..."
    terraform apply tfplan
    
    # Get outputs
    echo ""
    echo -e "${GREEN}Infrastructure deployed successfully!${NC}"
    echo ""
    echo "Outputs:"
    terraform output
    
    cd ..
    echo ""
}

# Build and deploy frontend
deploy_frontend() {
    echo -e "${YELLOW}Building and deploying frontend...${NC}"
    
    cd frontend
    
    # Install dependencies
    echo "  Installing dependencies..."
    npm install --silent
    
    # Build production bundle
    echo "  Building production bundle..."
    npm run build
    
    # Get S3 bucket name from Terraform
    cd ../terraform
    BUCKET_NAME=$(terraform output -raw frontend_bucket_name)
    cd ..
    
    if [ -z "$BUCKET_NAME" ]; then
        echo -e "${RED}Error: Could not get S3 bucket name from Terraform${NC}"
        exit 1
    fi
    
    # Deploy to S3
    echo "  Uploading to S3 bucket: $BUCKET_NAME..."
    aws s3 sync frontend/build/ s3://$BUCKET_NAME --delete --region $AWS_REGION
    
    echo -e "${GREEN}✓ Frontend deployed${NC}"
    echo ""
}

# Display deployment information
display_info() {
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}Deployment Complete!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    
    cd terraform
    
    echo "Frontend URL:"
    terraform output frontend_website_url
    echo ""
    
    echo "API Gateway URL:"
    terraform output api_gateway_url
    echo ""
    
    echo "CloudFront URL (if enabled):"
    terraform output cloudfront_domain_name || echo "Not enabled"
    echo ""
    
    cd ..
}

# Rollback function
rollback() {
    echo -e "${RED}Deployment failed!${NC}"
    echo "Would you like to rollback? (yes/no)"
    read -p "> " rollback_confirm
    
    if [ "$rollback_confirm" = "yes" ]; then
        echo "Rolling back..."
        cd terraform
        terraform destroy -auto-approve
        cd ..
    fi
}

# Main deployment flow
main() {
    # Trap errors
    trap rollback ERR
    
    check_prerequisites
    package_lambda_functions
    deploy_infrastructure
    deploy_frontend
    display_info
    
    echo -e "${GREEN}All done! 🚀${NC}"
}

# Run main function
main
