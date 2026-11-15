# ADR-0013: DB に Aurora DSQL を使う

- Status: Accepted
- Date: 2026-11-15

## Context

- 使い慣れている RDB (PostgreSQL) の SQL で、動画のメタデータを扱いたい
- 固定費をほぼ 0 円にする
- VPC は使わない ([ADR-0003](0003-lambda.md))

## Decision

- DB は Aurora DSQL にする。PostgreSQL と互換があり、無料枠 (毎月 100,000 DPU と 1 GB) に期限はない。
- IAM 認証で接続する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| DynamoDB | RDB ではなく、SQL で扱えない |
| RDS for PostgreSQL / Aurora Serverless v2 | VPC が要る。RDS はインスタンスの固定費がかかる |
| Supabase / Neon | AWS の外にあり、IAM 認証が使えない。接続のパスワードを秘密情報として管理する必要がある。Supabase の無料プランは 1 週間使わないと止まる |
| Turso / Cloudflare D1 | PostgreSQL ではなく SQLite 系。D1 は Cloudflare Workers から使う前提 |

## Consequences

- DSQL は新しく仕様が変わりやすい。SQL を基本的な CRUD に絞り、アクセスを 1 か所に集めて影響を小さくする。
- バックアップは [ADR-0014](0014-database-backup.md) を参照。

## References

- [Aurora DSQL 料金](https://aws.amazon.com/rds/aurora/dsql/pricing/)
- [Supabase の無料プランの一時停止](https://supabase.com/docs/guides/platform/free-project-pausing)
