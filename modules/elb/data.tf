data "external" "certificate" {
  program = ["bash", "-c", "arn=$(aws acm list-certificates --region ${var.region} | jq -r '.CertificateSummaryList[] | select(.DomainName == \"${var.xotocross-domain-name}.com\" and (.Status == \"ISSUED\" or .Status == \"PENDING_VALIDATION\")) | .CertificateArn // \"\"'); if [ -z \"$arn\" ]; then echo -n '{\"arn\": \"\"}'; else echo -n '{\"arn\": \"$arn\"}'; fi"]
}

