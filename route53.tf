resource "aws_route53_zone" "primary" {
  name = "${var.websiteURL}"
  tags = {
    website = "${var.websiteURL}"
    Environment = "${var.ENV_NAME}"
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = "${aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "cert_validationwww" {
  zone_id = "${aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "arecord" {
  zone_id = "${aws_route53_zone.primary.id}"
  name    = "${var.websiteURL}"
  type    = "A"
  alias {
    name = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "arecordwww" {
  zone_id = "${aws_route53_zone.primary.id}"
  name    = "www.${var.websiteURL}"
  type    = "A"
  alias {
    name = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}
