## S3 Buckets

# used to redirect to non www bucket
resource "aws_s3_bucket" "s3www" {
  bucket = "www.${var.websiteURL}"
  acl = "private"
  website {
    redirect_all_requests_to = "https://${var.websiteURL}"
  }
  tags = {
    website     = "${var.websiteURL}"
    Environment = "${var.ENV_NAME}"
  }
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.websiteURL}"
  acl = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    website     = "${var.websiteURL}"
    Environment = "${var.ENV_NAME}"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.website.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = "${aws_s3_bucket.website.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_s3_bucket" "build_artifact_bucket" {
  bucket = "${var.pipeline_name}-artifact-bucket"
  acl    = "private"
}
