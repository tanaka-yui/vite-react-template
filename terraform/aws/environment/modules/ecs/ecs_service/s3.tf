resource "aws_s3_bucket" "s3_bucket_codebuild_artifact" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  bucket = "${var.name}-codebuild-artifact"
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_codebuild_artifact_private_block" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  bucket                  = aws_s3_bucket.s3_bucket_codebuild_artifact[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.s3_bucket_codebuild_artifact[0]]
}

data "archive_file" "archive_file_image_definitions" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  type        = "zip"
  output_path = "${path.module}/${var.repository.name}/${local.imagedefinitions_filename}.zip"

  source {
    content = templatefile("${path.module}/json/codebuild-image-definitions.json", {
      name     = var.repository.name
      imageUri = var.repository.repository_url
    })
    filename = local.imagedefinitions_filename
  }
}

resource "aws_s3_bucket_object" "aws_s3_bucket_object_imagedefinitions" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket_codebuild_artifact[0].bucket
  source = data.archive_file.archive_file_image_definitions[0].output_path
  acl    = "private"
  key    = "${local.imagedefinitions_filename}.zip"

  depends_on = [
    aws_codepipeline.codepipeline[0],
    aws_s3_bucket.s3_bucket_codebuild_artifact[0],
    data.archive_file.archive_file_image_definitions[0]
  ]
}