resource "aws_ecr_repository" "ecr_repository_backend" {
  name                 = local.backend_name
  image_tag_mutability = "MUTABLE"
}

