output "route53_zone_id" {
  value = aws_route53_zone.route53_zone.id
}

output "route53_zone_name" {
  value = aws_route53_zone.route53_zone.name
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

output "acm_certificate_arn_northeast" {
  value = aws_acm_certificate.acm_certificate_northeast.arn
}

output "maintenance_key_pair_name" {
  value = aws_key_pair.maintenance_key_pair.key_name
}
