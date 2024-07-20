data "aws_route53_zone" "xotocross-zone" {
  name = "${var.xotocross-domain-name}.com"
}
