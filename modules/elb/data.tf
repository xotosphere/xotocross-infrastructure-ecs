data "external" "certificate" {
  program = ["bash", "-c", "arn=$(aws acm list-certificates --region ${var.region} | jq -r '.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\" and .Status == \"ISSUED\") | .CertificateArn // \"\"'); if [ -z \"$arn\" ]; then echo -n '{\"arn\": \"\"}'; else echo -n '{\"arn\": \"$arn\"}'; fi"]
  # program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '{arn: (.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\") | .CertificateArn // \"\")}'"]
}


