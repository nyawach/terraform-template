resource "aws_cloudfront_distribution" "root_distribution" {

  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.s3_bucket_name}"

  viewer_certificate {
    # acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    cloudfront_default_certificate = true
    ssl_support_method  = "sni-only"
  }

  origin {
    domain_name = "${aws_s3_bucket.root.website_endpoint}"
    origin_id   = "${var.s3_bucket_name}"
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.s3_bucket_name}"
    min_ttl                = 0
    default_ttl            = 360
    max_ttl                = 360

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
