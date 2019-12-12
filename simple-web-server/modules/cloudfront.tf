resource "aws_cloudfront_distribution" "main" {
  comment = "simple-web-server by Terraform"

  enabled         = true

  is_ipv6_enabled = true
  http_version    = "http2"
  price_class = "PriceClass_All"
  retain_on_delete = false

  origin {
    origin_id   = "elb"
    domain_name = aws_elb.elb.dns_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.2", "TLSv1.1"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["PATCH", "PUT", "HEAD", "OPTIONS", "DELETE", "GET", "POST"]
    cached_methods  = ["HEAD", "GET"]
    compress        = true

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["CloudFront-Forwarded-Proto", "Host", "Origin", "Accept"]
      query_string = true
    }

    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "elb"
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }

}
