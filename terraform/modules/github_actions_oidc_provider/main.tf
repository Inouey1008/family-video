terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.71.0"
    }
  }
}

resource "aws_iam_openid_connect_provider" "this" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}
