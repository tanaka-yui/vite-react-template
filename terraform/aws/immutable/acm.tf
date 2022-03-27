resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  provider = aws.virginia
}

resource "aws_acm_certificate" "acm_certificate_northeast" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"
}
