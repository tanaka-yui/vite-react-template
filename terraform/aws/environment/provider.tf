provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "archive" {
}

provider "template" {
}

provider "local" {
}