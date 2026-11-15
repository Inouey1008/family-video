# ADR-0005: DB に Aurora DSQL を使う

- Status: Accepted
- Date: 2026-11-15

## Context

動画のメタデータを SQL で扱い、固定費をほぼ 0 円にしたい。VPC は使わない ([ADR-0001](0001-cloud-aws-lambda.md))。

## Decision

- DB は Aurora DSQL にする。無料枠 (毎月 100,000 DPU と 1 GB) に期限はない。
- IAM 認証で接続する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| DynamoDB | SQL が使える点で DSQL を選んだ |

## Consequences

- DSQL は新しく仕様が変わりやすい。SQL を基本的な CRUD に絞り、アクセスを 1 か所に集めて影響を小さくする。
- バックアップは [ADR-0012](0012-database-backup.md) を参照。

## References

- [Aurora DSQL 料金](https://aws.amazon.com/rds/aurora/dsql/pricing/)
