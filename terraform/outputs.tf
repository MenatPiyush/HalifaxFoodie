output "api_gateway_url" {
  description = "API Gateway invoke URL"
  value       = aws_api_gateway_deployment.main.invoke_url
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "frontend_bucket_name" {
  description = "S3 bucket name for frontend hosting"
  value       = aws_s3_bucket.frontend.id
}

output "frontend_website_url" {
  description = "Frontend website URL"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "storage_bucket_name" {
  description = "S3 bucket name for storage"
  value       = aws_s3_bucket.storage.id
}

output "recipe_bucket_name" {
  description = "S3 bucket name for recipes"
  value       = aws_s3_bucket.recipes.id
}

output "dynamodb_table_names" {
  description = "DynamoDB table names"
  value = {
    user    = aws_dynamodb_table.user.name
    ratings = aws_dynamodb_table.ratings.name
    recipes = aws_dynamodb_table.recipes.name
    orders  = aws_dynamodb_table.orders.name
  }
}

output "lambda_function_names" {
  description = "Lambda function names"
  value = {
    authentication      = aws_lambda_function.auth.function_name
    data_processing     = aws_lambda_function.data_processing.function_name
    machine_learning    = aws_lambda_function.machine_learning.function_name
    virtual_assistance  = aws_lambda_function.virtual_assistance.function_name
  }
}

output "lambda_function_arns" {
  description = "Lambda function ARNs"
  value = {
    authentication      = aws_lambda_function.auth.arn
    data_processing     = aws_lambda_function.data_processing.arn
    machine_learning    = aws_lambda_function.machine_learning.arn
    virtual_assistance  = aws_lambda_function.virtual_assistance.arn
  }
}

output "cloudwatch_log_groups" {
  description = "CloudWatch log group names"
  value = {
    authentication      = aws_cloudwatch_log_group.auth.name
    data_processing     = aws_cloudwatch_log_group.data_processing.name
    machine_learning    = aws_cloudwatch_log_group.machine_learning.name
    virtual_assistance  = aws_cloudwatch_log_group.virtual_assistance.name
  }
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (if enabled)"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.frontend[0].id : null
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name (if enabled)"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.frontend[0].domain_name : null
}
