locals {
  custom_origin_id = "custom-${local.backend_name}"
}

resource "aws_cloudfront_distribution" "cloudfront_distribution_app" {
  origin {
    domain_name = var.app.origin_domain_name
    origin_id   = local.custom_origin_id

    custom_header {
      name  = local.x_origin_access_key
      value = var.origin_access_key
    }

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.s3_bucket_front.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3_bucket_front.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity_front.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"
  aliases             = [var.app.domain_name]

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["POST", "HEAD", "PATCH", "DELETE", "PUT", "GET", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = local.custom_origin_id

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    max_ttl     = 0
    default_ttl = 0
  }

  default_cache_behavior {
    allowed_methods        = ["POST", "HEAD", "PATCH", "DELETE", "PUT", "GET", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = aws_s3_bucket.s3_bucket_front.id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.terraform_remote_state.remote_state_immutable.outputs.acm_certificate_arn
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
}
