# CodeBuild Section for the Package stage
resource "aws_codebuild_project" "build_project" {
  name          = "${var.pipeline_name}-build"
  description   = "The CodeBuild project for ${var.pipeline_name}"
  service_role  = "${aws_iam_role.codebuild_assume_role.arn}"
  build_timeout = "5"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/nodejs:6.3.1"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
