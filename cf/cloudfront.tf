terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

data "aws_acm_certificate" "cfdomain" {
  domain = "."
}

data "aws_route53_zone" "testkjdomain" {
  name         = "."
  private_zone = false
}

resource "aws_cloudfront_distribution" "main" {
  enabled                        = true
  aliases                        = [
    var.cf_domain
  ]

  default_cache_behavior {
      allowed_methods        = [
          "GET",
          "HEAD",
      ]
      cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # "CachingDisabled"
      cached_methods         = [
          "GET",
          "HEAD",
      ]
      compress               = true
      default_ttl            = 0
      max_ttl                = 0
      min_ttl                = 0
      smooth_streaming       = false
      target_origin_id       = "${var.project_name}-${var.environment}-cf"
      viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = var.lb_domain_name
    origin_id           = "${var.project_name}-${var.environment}-cf"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = [
          "TLSv1.2",
      ]
    }
  }

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.cfdomain.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  depends_on = [var.web_alb]
}

resource "aws_route53_record" "cf" {
  zone_id = data.aws_route53_zone.testkjdomain.zone_id
  name    = var.cf_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
  depends_on = [aws_cloudfront_distribution.main]
}