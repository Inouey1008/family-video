# ADR-0023: 通知は Amazon Q Developer 経由で Slack に送る

- Status: Accepted
- Date: 2026-11-15

## Context

- 異常があれば開発者に通知する (PRD の Operations)
- アラームは CloudWatch で作る ([ADR-0022](0022-observability.md))
- 通知のためのコードは持ちたくない

## Decision

- アラームは SNS に送り、Amazon Q Developer in chat applications 経由で Slack のプライベートチャンネルに通知する。予備はメール。
- Slack から AWS は操作させない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Lambda + Slack の Webhook | 通知のコードを保守する必要がある。Amazon Q Developer in chat applications ならコード不要で、追加料金もない |
| メールだけ | 気づくのが遅れやすい |

## Consequences

- 通知の条件と宛先は [設計書](../specs/observability.md) を参照。
