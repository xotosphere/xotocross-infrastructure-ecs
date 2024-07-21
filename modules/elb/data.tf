data "external" "certificate" {
  program = ["bash", "-c", "arn=$(aws acm list-certificates --region ${var.region} | jq -r '.CertificateSummaryList[] | select(.DomainName == \"${var.xotocross-domain-name}.com\" and .Status == \"ISSUED\") | .CertificateArn // \"\"'); if [ -z \"$arn\" ]; then echo -n '{\"arn\": \"\"}'; else echo -n '{\"arn\": \"$arn\"}'; fi"]
  # program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '{arn: (.CertificateSummaryList[] | select(.DomainName == \"${var.xotocross-domain-name}.com\") | .CertificateArn // \"\")}'"]
}


