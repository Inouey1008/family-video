# ADR-0017: API は API Gateway の HTTP API にする

- Status: Accepted
- Date: 2026-11-15

## Context

- CloudFront から Lambda へリクエストを渡す、API の入り口が要る ([ADR-0016](0016-entry.md))
- 固定費はほぼ 0 円にする (PRD の Goals)

## Decision

- API は API Gateway の HTTP API にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| API Gateway の REST API | 料金が HTTP API の 3.5 倍 (100 万リクエストあたり 3.50 ドルと 1.00 ドル)。使用量プランなどの機能は要らない |
| Lambda 関数 URL + OAC | CloudFront だけに絞れるが、POST の本文のハッシュをブラウザの JS で計算して付ける必要がある |

## Consequences

- HTTP API の既定のエンドポイントは公開されたままになる。直接のアクセスへの対策は [ADR-0020](0020-origin-lock.md) を参照。

## References

- [API Gateway 料金](https://aws.amazon.com/api-gateway/pricing/)
