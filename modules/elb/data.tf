data "aws_acm_certificate" "xotocross-certificate" {
  domain   = "${var.xotocross-domain-name}.com"
  statuses = ["ISSUED"]
}