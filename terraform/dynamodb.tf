# DynamoDB Table: User
resource "aws_dynamodb_table" "user" {
  name           = "user"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "email"

  attribute {
    name = "email"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-user-table"
  })
}

# DynamoDB Table: Ratings
resource "aws_dynamodb_table" "ratings" {
  name           = "Ratings"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ratingId"

  attribute {
    name = "ratingId"
    type = "S"
  }

  attribute {
    name = "restaurantId"
    type = "S"
  }

  global_secondary_index {
    name            = "RestaurantIndex"
    hash_key        = "restaurantId"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ratings-table"
  })
}

# DynamoDB Table: Recipes
resource "aws_dynamodb_table" "recipes" {
  name           = "recipes"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "dish_name"

  attribute {
    name = "dish_name"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-recipes-table"
  })
}

# DynamoDB Table: Orders
resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orderid"

  attribute {
    name = "orderid"
    type = "N"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  global_secondary_index {
    name            = "UserIndex"
    hash_key        = "userId"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-orders-table"
  })
}
