resource "aws_api_gateway_rest_api" "xotocross-api" {
	name        = var.xotocross-service-name
	description = "xotocross api gateway for ${var.xotocross-service-name}"

	tags = {
		Name        = "${var.xotocross-service-name}-api"
		Environment = var.environment
	}
}

resource "aws_api_gateway_resource" "xotocross-resource" {
	rest_api_id = aws_api_gateway_rest_api.xotocross-api.id
	parent_id   = aws_api_gateway_rest_api.xotocross-api.root_resource_id
	path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "xotocross_proxy" {
	rest_api_id   = aws_api_gateway_rest_api.xotocross-api.id
	resource_id   = aws_api_gateway_resource.xotocross-resource.id
	http_method   = "ANY"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "xotocross_integration" {
	rest_api_id             = aws_api_gateway_rest_api.xotocross-api.id
	resource_id             = aws_api_gateway_resource.xotocross-resource.id
	http_method             = aws_api_gateway_method.xotocross_proxy.http_method

	type                    = "HTTP_PROXY"
	integration_http_method = "ANY"
	uri                     = "http://${var.xotocross-alb-name}/{proxy}"
}