resource "aws_route53_record" "route53_record_app_origin" {
  zone_id = data.terraform_remote_state.remote_state_immutable.outputs.route53_zone_id
  name    = var.backend.origin_domain_name
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = module.alb_backend.alb_dns_name
    zone_id                = module.alb_backend.alb_zone_id
  }
}


resource "aws_route53_record" "route53_record_app" {
  zone_id = data.terraform_remote_state.remote_state_immutable.outputs.route53_zone_id
  name    = var.backend.domain_name
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.cloudfront_distribution_app.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution_app.hosted_zone_id
  }

  depends_on = [
    aws_cloudfront_distribution.cloudfront_distribution_app,
  ]
}
