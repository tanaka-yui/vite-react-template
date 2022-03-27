#--------------------------------------------------------------
# CodeBuild Role
#--------------------------------------------------------------
resource "aws_iam_role" "codebuild_role" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name               = "${var.name}-codebuild-role"
  assume_role_policy = file("${path.module}/json/codebuild-assume-policy.json")
}

resource "aws_iam_role_policy" "codebuild_policy" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  role = aws_iam_role.codebuild_role[0].name
  policy = templatefile("${path.module}/json/codebuild-policy.json", {
    name        = var.name
    account_id  = var.account_id
    region      = var.region
    bucket_name = aws_s3_bucket.s3_bucket_codebuild_artifact[0].bucket
  })

  depends_on = [aws_iam_role.codebuild_role[0]]
}

#--------------------------------------------------------------
# CodePipeline Role
#--------------------------------------------------------------
resource "aws_iam_role" "codepipeline_role" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name               = "${var.name}-codepipeline-role"
  assume_role_policy = file("${path.module}/json/codepipeline-assume-policy.json")
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name   = "${var.name}-codepipeline-policy"
  role   = aws_iam_role.codepipeline_role[0].id
  policy = file("${path.module}/json/codepipeline-policy.json")

  depends_on = [aws_iam_role.codepipeline_role[0]]
}

#--------------------------------------------------------------
# CloudWatch Event Role
#--------------------------------------------------------------
resource "aws_iam_role" "cloudwatch_events" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name               = "${var.name}-codepipeline-cloudwatch-events"
  assume_role_policy = file("${path.module}/json/cloudwatch-events-assume-policy.json")
}

resource "aws_iam_role_policy" "cloudwatch_events" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name   = "${var.name}-codepipeline-cloudwatch-events"
  role   = aws_iam_role.cloudwatch_events[0].id
  policy = file("${path.module}/json/cloudwatch-events-policy.json")

  depends_on = [aws_iam_role.cloudwatch_events[0]]
}
