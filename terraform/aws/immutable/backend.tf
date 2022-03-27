terraform {
  backend "s3" {
    bucket  = "sample-terraform"
    key     = "immutable/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
