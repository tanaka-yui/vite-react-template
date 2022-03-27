resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false
}

resource "aws_route53_record" "route53_record_CNAME" {
  name    = ""
  records = [""]
  ttl     = "300"
  type    = "CNAME"
  zone_id = aws_route53_zone.route53_zone.zone_id
}
