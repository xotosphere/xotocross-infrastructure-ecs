data "external" "certificate" {
  program = ["bash", "-c", "aws acm list-certificates --region eu-west-3 | jq -r '.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\") | .CertificateArn // \"\"'"]
}

# data "aws_acm_certificate" "xotocross-certificate" {
#   domain   = "${var.xotocross-domain-name}.com"
#   statuses = ["ISSUED"]
# }