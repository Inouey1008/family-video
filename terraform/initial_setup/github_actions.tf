module "github_actions_oidc_provider" {
  source = "../modules/github_actions_oidc_provider"
}

locals {
  # 3 つのロール自身への iam:* を Deny する (自分の権限を書き換えられないようにする)
  deny_self_iam_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyIamOnTerraformRoles"
        Effect   = "Deny"
        Action   = "iam:*"
        Resource = concat(values(local.role_arns), [module.github_actions_oidc_provider.arn])
      }
    ]
  })

  # dev / prod: 自分の環境の state だけを読み書きできる
  env_state_policy = {
    for env in ["dev", "prod"] : env => jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "ListOwnStatePrefix"
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = local.state_bucket_arn
          Condition = {
            StringLike = {
              "s3:prefix" = ["${env}/*", "${env}/"]
            }
          }
        },
        {
          Sid      = "ReadWriteOwnState"
          Effect   = "Allow"
          Action   = ["s3:GetObject", "s3:PutObject"]
          Resource = "${local.state_bucket_arn}/${env}/*"
        },
        {
          Sid      = "DeleteOwnLockFile"
          Effect   = "Allow"
          Action   = "s3:DeleteObject"
          Resource = "${local.state_bucket_arn}/${env}/*.tflock"
        }
      ]
    })
  }

  # ci-readonly: データを読む操作を明示的に Deny する
  ci_readonly_deny_data_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid         = "DenyReadObjectsExceptEnvState"
        Effect      = "Deny"
        Action      = "s3:GetObject*"
        NotResource = ["${local.state_bucket_arn}/dev/*", "${local.state_bucket_arn}/prod/*"]
      },
      {
        Sid    = "DenyReadDataOfOtherServices"
        Effect = "Deny"
        Action = [
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:StartQuery",
          "logs:GetQueryResults",
          "cognito-idp:ListUsers",
          "cognito-idp:AdminGetUser",
          "ssm:GetParameter*",
          "secretsmanager:GetSecretValue",
          "dsql:DbConnect*",
          "budgets:ViewBudget",
          "secretsmanager:BatchGetSecretValue",
          "logs:GetLogRecord",
          "logs:StartLiveTail",
          "logs:Unmask",
          "cognito-idp:ListUsersInGroup",
          "cognito-idp:AdminListGroupsForUser",
        ]
        Resource = "*"
      }
    ]
  })

  terraform_roles = {
    ci_readonly = {
      name                = local.role_names["ci_readonly"]
      sub                 = "${local.github_sub_prefix}:pull_request"
      managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      inline_policies = {
        deny-self-iam  = local.deny_self_iam_policy
        deny-read-data = local.ci_readonly_deny_data_policy
      }
    }
    dev = {
      name                = local.role_names["dev"]
      sub                 = "${local.github_sub_prefix}:environment:dev"
      managed_policy_arns = []
      inline_policies = {
        deny-self-iam = local.deny_self_iam_policy
        state         = local.env_state_policy["dev"]
      }
    }
    prod = {
      name                = local.role_names["prod"]
      sub                 = "${local.github_sub_prefix}:environment:prod"
      managed_policy_arns = []
      inline_policies = {
        deny-self-iam = local.deny_self_iam_policy
        state         = local.env_state_policy["prod"]
      }
    }
  }
}

module "terraform_actions_role" {
  source   = "../modules/terraform_actions_role"
  for_each = local.terraform_roles

  name                = each.value.name
  oidc_provider_arn   = module.github_actions_oidc_provider.arn
  sub                 = each.value.sub
  managed_policy_arns = each.value.managed_policy_arns
  inline_policies     = each.value.inline_policies
}
