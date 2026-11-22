resource "aws_budgets_budget" "monthly" {
  name         = "${local.service}-monthly"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit   = "USD"

  # 同じアカウントのほかのプロジェクトの費用を除き、service タグが付いた費用だけ数える
  # (service はコスト配分タグとして有効化済みである必要がある)
  cost_filter {
    name   = "TagKeyValue"
    values = [format("user:service$%s", local.service)]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_notification_emails
  }
}
