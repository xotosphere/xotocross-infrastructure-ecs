data "external" "certificate" {
  program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\" and .Status == \"ISSUED\") | .CertificateArn // \"\"' | xargs -I {} echo -n '{\"arn\": \"{}\"}'"]
  # program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '{arn: (.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\") | .CertificateArn // \"\")}'"]
}

