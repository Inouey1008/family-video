# ADR-0022: ログとアラームは CloudWatch の標準機能だけで作る

- Status: Accepted
- Date: 2026-11-15

## Context

- エラーを記録し、異常があれば開発者に通知する (PRD の Operations)
- 固定費はほぼ 0 円にし、外部依存を増やさず、エラーの内容を外部に送らない

## Decision

- ログは `log/slog` の JSON 形式で CloudWatch Logs に出し、ERROR の件数をメトリクスフィルターでアラームにする。
- 分散トレーシングは入れない。Lambda が 1 つだけなので、ログのリクエスト ID でたどれば足りる。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| X-Ray SDK / OpenTelemetry | X-Ray SDK は 2026-02-25 からメンテナンスモードで、OpenTelemetry への移行が推奨されている。OpenTelemetry は依存が増える |
| Sentry など | SDK の依存が増え、エラーの内容が外部に送られる |

## Consequences

- アラームやダッシュボードは無料枠に収める。エラーの調査が大変になったら、Sentry の無料プランを検討する。
- 通知の方法は [ADR-0023](0023-notification.md)、ログの項目・アラームの条件は [設計書](../specs/observability.md) を参照。

## References

- [X-Ray SDK とデーモンのサポートの時期](https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-daemon-timeline.html)
- [Amazon CloudWatch 料金 (無料枠)](https://aws.amazon.com/cloudwatch/pricing/)
