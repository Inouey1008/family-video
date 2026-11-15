# ADR-0002: クラウドは AWS (東京) にする

- Status: Accepted
- Date: 2026-11-15

## Context

- サーバーレスで作る ([ADR-0001](0001-serverless.md))
- 日本国内からのアクセスだけを許可する (PRD の Security)
- 動画・DB・認証・配信を 1 つのクラウドの中で扱い、IAM で権限を絞りたい

## Decision

- AWS の東京リージョンを使う。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare Workers | Go が Wasm 経由になる |
| Firebase | DB を SQL で扱うと Cloud SQL (SQL Connect) になり、インスタンスの固定費 (月 9 ドル台から) がかかる |
| Supabase | 無料プランは 1 週間使わないと止まる。有料プランは月額の固定費がかかる |

## Consequences

- 処理・DB・認証・動画の保存先は、AWS のサービスから選ぶ。

## References

- [Supabase の無料プランの一時停止](https://supabase.com/docs/guides/platform/free-project-pausing)
- [Firebase SQL Connect 料金](https://firebase.google.com/docs/sql-connect/pricing)
