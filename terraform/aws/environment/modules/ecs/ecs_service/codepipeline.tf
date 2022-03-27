locals {
  imagedefinitions_filename = "imagedefinitions.json"
}

resource "aws_codepipeline" "codepipeline" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name     = var.name
  role_arn = aws_iam_role.codepipeline_role[0].arn

  artifact_store {
    location = aws_s3_bucket.s3_bucket_codebuild_artifact[0].bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = var.repository.name
        ImageTag       = "latest"
      }
    }

    action {
      name             = "S3Setting"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["S3OutArtifuct"]

      configuration = {
        S3Bucket    = aws_s3_bucket.s3_bucket_codebuild_artifact[0].bucket
        S3ObjectKey = "${local.imagedefinitions_filename}.zip"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["S3OutArtifuct"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster.name
        ServiceName = aws_ecs_service.ecs_service[0].name
      }
    }
  }

  depends_on = [
    aws_iam_role.codepipeline_role[0],
    aws_s3_bucket.s3_bucket_codebuild_artifact[0],
    aws_ecs_service.ecs_service[0]
  ]
}