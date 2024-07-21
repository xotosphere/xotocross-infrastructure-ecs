data "external" "certificate" {
  # program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '{arn: (.CertificateSummaryList[] | select(.DomainName == \"${var.xotocross-domain-name}.com\" and .Status == \"ISSUED\") | .CertificateArn // \"\")}'"]
  program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '{arn: (.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\") | .CertificateArn // \"\")}'"]
}