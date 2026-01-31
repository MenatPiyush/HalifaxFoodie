# CloudWatch Log Group: Authentication Lambda
resource "aws_cloudwatch_log_group" "auth" {
  name              = "/aws/lambda/${aws_lambda_function.auth.function_name}"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-auth-logs"
  })
}

# CloudWatch Log Group: Data Processing Lambda
resource "aws_cloudwatch_log_group" "data_processing" {
  name              = "/aws/lambda/${aws_lambda_function.data_processing.function_name}"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-dataprocessing-logs"
  })
}

# CloudWatch Log Group: Machine Learning Lambda
resource "aws_cloudwatch_log_group" "machine_learning" {
  name              = "/aws/lambda/${aws_lambda_function.machine_learning.function_name}"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ml-logs"
  })
}

# CloudWatch Log Group: Virtual Assistance Lambda
resource "aws_cloudwatch_log_group" "virtual_assistance" {
  name              = "/aws/lambda/${aws_lambda_function.virtual_assistance.function_name}"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-virtualassistance-logs"
  })
}

# CloudWatch Log Group: API Gateway
resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/${var.project_name}"
  retention_in_days = 7

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-apigateway-logs"
  })
}

# CloudWatch Alarm: Lambda Errors - Auth
resource "aws_cloudwatch_metric_alarm" "lambda_errors_auth" {
  alarm_name          = "${var.project_name}-auth-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors lambda errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.auth.function_name
  }

  tags = local.common_tags
}

# CloudWatch Alarm: Lambda Errors - Data Processing
resource "aws_cloudwatch_metric_alarm" "lambda_errors_dataprocessing" {
  alarm_name          = "${var.project_name}-dataprocessing-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors lambda errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.data_processing.function_name
  }

  tags = local.common_tags
}

# CloudWatch Alarm: API Gateway 5XX Errors
resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx" {
  alarm_name          = "${var.project_name}-api-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors API Gateway 5XX errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.main.name
    Stage   = aws_api_gateway_stage.main.stage_name
  }

  tags = local.common_tags
}

# CloudWatch Alarm: DynamoDB Read Throttles
resource "aws_cloudwatch_metric_alarm" "dynamodb_read_throttles" {
  alarm_name          = "${var.project_name}-dynamodb-read-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadThrottleEvents"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors DynamoDB read throttles"
  treat_missing_data  = "notBreaching"

  dimensions = {
    TableName = aws_dynamodb_table.user.name
  }

  tags = local.common_tags
}
