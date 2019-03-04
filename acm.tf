resource "aws_acm_certificate" "cert" {
  provider          = "aws.useast1"
  domain_name       = "${var.websiteURL}"
  validation_method = "DNS"

  tags = {
    website     = "${var.websiteURL}"
    Environment = "${var.ENV_NAME}"
  }

  subject_alternative_names = ["www.${var.websiteURL}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider = "aws.useast1"
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
