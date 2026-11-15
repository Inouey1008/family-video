# ADR-0006: DB・認証・保存先も AWS でそろえ、東京リージョンに置く

- Status: Accepted
- Date: 2026-11-15

## Context

- 処理は AWS Lambda で動かす ([ADR-0005](0005-lambda.md))
- 日本国内からのアクセスだけを許可する (PRD の Security)
- 秘密情報は持たず、権限は IAM で絞りたい

## Decision

- DB・認証・動画の保存先も AWS のサービスから選ぶ。Lambda からは IAM の認証で接続し、パスワードやアクセスキーを持たない。
- リージョンは東京にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Firebase | DB を SQL で扱うと Cloud SQL (SQL Connect) になり、インスタンスの固定費 (月 9 ドル台から) がかかる。IAM で権限を絞れない |
| Supabase | 無料プランは 1 週間使わないと止まる。有料プランは月額の固定費がかかる。IAM で権限を絞れない |

## Consequences

- DB は [ADR-0013](0013-database-dsql.md)、認証は [ADR-0011](0011-auth-cognito.md)、動画の保存先は [ADR-0015](0015-video-storage.md) を参照。

## References

- [Supabase の無料プランの一時停止](https://supabase.com/docs/guides/platform/free-project-pausing)
- [Firebase SQL Connect 料金](https://firebase.google.com/docs/sql-connect/pricing)
