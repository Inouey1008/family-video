# ADR-0017: 監視は CloudWatch の標準機能だけで構成する

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Operations は、エラーを記録し、異常があれば開発者に通知すること。固定費はほぼ 0 円にし、外部依存を増やさず、エラーの内容を外部に送らない。

## Decision

- ログは `log/slog` の JSON 形式で CloudWatch Logs に出し、ERROR の件数をメトリクスフィルターでアラームにする。
- 通知は SNS から Amazon Q Developer in chat applications 経由で Slack に送る。予備はメール。Slack から AWS は操作させない。
- 分散トレーシングは入れない。Lambda が 1 つだけなので、ログのリクエスト ID でたどれば足りる。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| X-Ray SDK / OpenTelemetry | X-Ray SDK は 2026-02-25 からメンテナンスモードで、OpenTelemetry への移行が推奨されている。OpenTelemetry は依存が増える |
| Sentry など | SDK の依存が増え、エラーの内容が外部に送られる |
| Lambda + Slack の Webhook | Amazon Q Developer in chat applications ならコード不要で、追加料金もない |

## Consequences

- アラームやダッシュボードは無料枠に収める。エラーの調査が大変になったら、Sentry の無料プランを検討する。
- ログの項目・アラームの条件は [設計書](../specs/observability.md) を参照。

## References

- [X-Ray SDK とデーモンのサポートの時期](https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-daemon-timeline.html)
- [Amazon CloudWatch 料金 (無料枠)](https://aws.amazon.com/cloudwatch/pricing/)
