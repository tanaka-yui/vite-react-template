terraform {
  backend "s3" {
    bucket               = "sample-terraform"
    key                  = "terraform.tfstate"
    region               = "ap-northeast-1"
    workspace_key_prefix = "environment"
    encrypt              = true
  }
}
