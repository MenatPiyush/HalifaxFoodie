variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "halifaxfoodie"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "production"
}

variable "lambda_runtime_nodejs" {
  description = "Node.js runtime for Lambda functions"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_runtime_python" {
  description = "Python runtime for Lambda functions"
  type        = string
  default     = "python3.9"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory" {
  description = "Lambda function memory in MB"
  type        = number
  default     = 256
}

variable "enable_cloudfront" {
  description = "Enable CloudFront CDN for frontend"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Custom domain name for the application"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
