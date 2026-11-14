# ADR-0009: 監視は CloudWatch の標準機能だけで構成する

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Operations: エラーは記録し、異常があれば開発者に通知する。
- PRD の Cost: 固定費はほぼ 0 円にする。
- PRD の Maintenance: 外部の部品を最小限にする。
- エラーの内容を外部のサービスに送らない。

## Decision

- ログは Go 標準の `log/slog` で JSON 形式の構造化ログにし、CloudWatch Logs に出す。保持期間は 30 日にする。
- メトリクスは、Lambda・API Gateway・CloudFront・S3・DSQL が自動で出すものを使う。追加の指標とダッシュボードは無料枠に収める。
- エラーは、メトリクスフィルターで ERROR の件数を指標にし、アラームで検知する。調査は Logs Insights の `pattern` で似たエラーをまとめて行う。
- アラームと AWS Budgets の通知は SNS から Amazon Q Developer in chat applications 経由で Slack のプライベートチャンネルへ送る。予備としてメールにも送る。
- Slack から AWS を操作する機能は使わない。権限は CloudWatch の読み取りだけにする。
- 分散トレーシングは入れない。Lambda が 1 つだけなので、ログのリクエスト ID でたどれば足りる。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| X-Ray SDK | 2026-02-25 からメンテナンスモードで、OpenTelemetry への移行が推奨されている |
| OpenTelemetry | 依存が増える |
| Sentry など外部のエラー監視 | SDK の依存が増え、エラーの内容が外部に送られる |
| Lambda + Slack の Incoming Webhook (通知) | Amazon Q Developer in chat applications ならコード不要で、追加料金もない |

## Consequences

- すべて無料枠の範囲に収まる。ただし、アラームは 10 個、カスタムメトリクスは 10 個、ダッシュボードは 3 つまでを守る。
- エラーの調査が大変になったら、Sentry の無料プランを検討する。
- Slack ワークスペースの連携は、最初の 1 回だけコンソールで行う。
- ログの項目・アラームの条件・通知の流れは [設計書](../specs/observability.md) にまとめる。

## References

- [Lambda のログレベルによるフィルタリング](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs-log-level.html)
- [Amazon CloudWatch 料金 (無料枠)](https://aws.amazon.com/cloudwatch/pricing/)
- [CloudWatch Logs Insights の pattern コマンド](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax-Pattern.html)
- [X-Ray SDK とデーモンのサポートの時期](https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-daemon-timeline.html)
- [Amazon Q Developer in chat applications で CloudWatch の通知をテストする](https://docs.aws.amazon.com/chatbot/latest/adminguide/test-notifications-cw.html)
- [AWS::Chatbot::SlackChannelConfiguration](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-chatbot-slackchannelconfiguration.html)
- [チャットアプリケーションでの予算アラートの受信](https://docs.aws.amazon.com/ja_jp/cost-management/latest/userguide/sns-alert-chime.html)
