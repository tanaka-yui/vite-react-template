data "terraform_remote_state" "remote_state_immutable" {
  backend = "s3"

  config = {
    bucket = "sample-terraform"
    key    = "immutable/terraform.tfstate"
    region = "ap-northeast-1"
  }
}