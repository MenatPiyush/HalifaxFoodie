# Create deployment package directory placeholder
# Note: Actual zip files need to be created before applying terraform

# Lambda Function: Authentication
resource "aws_lambda_function" "auth" {
  filename         = "lambda-packages/authentication.zip"
  function_name    = "${var.project_name}-auth"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "usermanagementlambda.handler"
  source_code_hash = fileexists("lambda-packages/authentication.zip") ? filebase64sha256("lambda-packages/authentication.zip") : null
  runtime         = var.lambda_runtime_nodejs
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.user.name
      AWS_REGION_CUSTOM = var.aws_region
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-auth-lambda"
  })
}

# Lambda Function: Data Processing (WordCloud)
resource "aws_lambda_function" "data_processing" {
  filename         = "lambda-packages/dataprocessing.zip"
  function_name    = "${var.project_name}-dataprocessing"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = fileexists("lambda-packages/dataprocessing.zip") ? filebase64sha256("lambda-packages/dataprocessing.zip") : null
  runtime         = var.lambda_runtime_python
  timeout         = 60
  memory_size     = 512

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.ratings.name
      S3_BUCKET      = aws_s3_bucket.storage.id
      MPLCONFIGDIR   = "/tmp"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-dataprocessing-lambda"
  })
}

# Lambda Function: Machine Learning (Cosine Similarity)
resource "aws_lambda_function" "machine_learning" {
  filename         = "lambda-packages/machinelearning.zip"
  function_name    = "${var.project_name}-ml"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "cosineSimilarityLambda.lambda_handler"
  source_code_hash = fileexists("lambda-packages/machinelearning.zip") ? filebase64sha256("lambda-packages/machinelearning.zip") : null
  runtime         = var.lambda_runtime_python
  timeout         = 60
  memory_size     = 512

  environment {
    variables = {
      RECIPE_BUCKET  = aws_s3_bucket.recipes.id
      DYNAMODB_TABLE = aws_dynamodb_table.recipes.name
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ml-lambda"
  })
}

# Lambda Function: Virtual Assistance (Lex Fulfillment)
resource "aws_lambda_function" "virtual_assistance" {
  filename         = "lambda-packages/virtualassistance.zip"
  function_name    = "${var.project_name}-virtualassistance"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = fileexists("lambda-packages/virtualassistance.zip") ? filebase64sha256("lambda-packages/virtualassistance.zip") : null
  runtime         = var.lambda_runtime_python
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory

  environment {
    variables = {
      ORDERS_TABLE = aws_dynamodb_table.orders.name
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-virtualassistance-lambda"
  })
}

# Lambda Permission for API Gateway - Auth
resource "aws_lambda_permission" "api_gateway_auth" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# Lambda Permission for API Gateway - Data Processing
resource "aws_lambda_permission" "api_gateway_dataprocessing" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processing.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# Lambda Permission for S3 to invoke ML Lambda
resource "aws_lambda_permission" "s3_invoke_ml" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.machine_learning.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.recipes.arn
}

# Lambda Permission for Lex to invoke Virtual Assistance
resource "aws_lambda_permission" "lex_invoke_virtualassistance" {
  statement_id  = "AllowLexInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.virtual_assistance.function_name
  principal     = "lexv2.amazonaws.com"
}
