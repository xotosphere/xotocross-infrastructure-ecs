data "external" "certificate" {
	program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\" and .Status == \"ISSUED\") | .CertificateArn // \"\"' | {\"arn\": .}"]
	
  # program = ["bash", "-c", "aws acm list-certificates --region ${var.region} | jq -r '{arn: (.CertificateSummaryList[] | select(.DomainName == \"xotosphere.com\") | .CertificateArn // \"\")}'"]
}

