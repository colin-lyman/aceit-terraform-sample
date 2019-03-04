provider "aws" {
  region  = "eu-west-1"
  profile = "aws_profile_name"
}

/* The below is used to use ACM with CloudFront */
provider "aws" {
  alias   = "useast1"
  region  = "us-east-1"
  profile = "aws_profile_name"
}
