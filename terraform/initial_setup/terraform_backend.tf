module "terraform_backend" {
  source = "../modules/terraform_backend"

  bucket_name = var.state_bucket_name
  role_arns = {
    ci_readonly = module.terraform_actions_role["ci_readonly"].arn
    dev         = module.terraform_actions_role["dev"].arn
    prod        = module.terraform_actions_role["prod"].arn
  }
}
