locals {
  region  = "ap-northeast-1"
  service = "family-video"

  # GitHub OIDC の sub は ID を含む形にする
  github_sub_prefix = "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}"

  role_names = {
    ci_readonly = "${local.service}-ci-readonly"
    dev         = "${local.service}-dev"
    prod        = "${local.service}-prod"
  }

  role_arns = {
    for key, name in local.role_names :
    key => "arn:aws:iam::${var.aws_account_id}:role/${name}"
  }

  state_bucket_arn = "arn:aws:s3:::${var.state_bucket_name}"
}
