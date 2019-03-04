resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for ${var.websiteURL}"
}

locals {
  s3_origin_id = "S3-${var.websiteURL}"
}

resource "aws_cloudfront_distribution" "website" {
  provider = "aws.useast1"
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_regional_domain_name}"
    origin_id   = "${local.s3_origin_id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CF for ${var.websiteURL}"
  default_root_object = "index.html"

  aliases = ["${var.websiteURL}", "www.${var.websiteURL}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 3600
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0

  price_class = "PriceClass_100"

  tags = {
    website     = "${var.websiteURL}"
    Environment = "${var.ENV_NAME}"
  }

  viewer_certificate {
    acm_certificate_arn  = "${aws_acm_certificate.cert.arn}"
    ssl_support_method = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
