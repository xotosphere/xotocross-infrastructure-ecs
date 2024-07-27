
# resource "aws_cognito_user_pool" "xtcross-user-pool" {
#   name = "xtcross-${var.environment}-pool"
  
#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = true
#     require_uppercase = true
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_cognito_user_pool_client" "client" {
#   name = "xtcross-${var.environment}-client"
#   user_pool_id = aws_cognito_user_pool.xtcross-user-pool.id

#   explicit_auth_flows = [
#     "ALLOW_USER_SRP_AUTH",
#     "ALLOW_REFRESH_TOKEN_AUTH"
#   ]

#   allowed_oauth_flows_user_pool_client = true
#   generate_secret                       = true

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# output "user_pool_id" {
#   description = "xtcross id of the user pool"
#   value       = aws_cognito_user_pool.xtcross-user-pool.id
# }

# output "client_id" {
#   description = "xtcross id of the user pool client"
#   value       = aws_cognito_user_pool_client.client.id
# }

# TeSST 2

# variable "user_pool_name" {
#   description = "The name of the user pool"
# }

# variable "client_name" {
#   description = "The name of the client"
# }

# resource "aws_cognito_user_pool" "pool" {
#   name = var.user_pool_name
# }

# resource "aws_cognito_user_pool_client" "client" {
#   name         = var.client_name
#   user_pool_id = aws_cognito_user_pool.pool.id
#   generate_secret = true
# }

# output "user_pool_id" {
#   description = "The ID of the user pool"
#   value       = aws_cognito_user_pool.pool.id
# }

# output "client_id" {
#   description = "The ID of the client"
#   value       = aws_cognito_user_pool_client.client.id
# }

# output "user_pool_client_secret" {
#   value = aws_cognito_user_pool_client.client.client_secret
# }

variable "environment" {description = "The environment in which the resources are created"}
# variable "xtcross-service-name" { description = "xtcross the name of the xtcross service" }

resource "aws_cognito_user_pool" "xtcross-user-pool" {
  name = "xtcross-${var.environment}-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "xtcross-${var.environment}-client"
  user_pool_id = aws_cognito_user_pool.xtcross-user-pool.id

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  generate_secret = false
}

resource "aws_ssm_parameter" "user_pool_id" {
  name  = "/authorizer/cognito_user_pool_id"
  type  = "String"
  value = aws_cognito_user_pool.xtcross-user-pool.id
}

resource "aws_ssm_parameter" "client_id" {
  name  = "/authorizer/cognito_client_id"
  type  = "String"
  value = aws_cognito_user_pool_client.client.id
}