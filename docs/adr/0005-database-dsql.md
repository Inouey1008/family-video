# ADR-0005: DB に Aurora DSQL を使い、AWS Backup で毎日バックアップする

- Status: Accepted
- Date: 2026-11-15

## Context

動画のメタデータを SQL で扱い、固定費をほぼ 0 円にしたい。動画の控えは取らないので (PRD の Decisions のとおり)、メタデータのバックアップ方法を決める必要がある。

## Decision

- DB は Aurora DSQL にする。無料枠 (毎月 100,000 DPU と 1 GB) に期限はない。SQL は基本的な CRUD に限り、アクセスは `internal/db` に集める。
- AWS Backup で毎日バックアップし、7 日分を保持する (月 10 円ほど)。RPO は最大 24 時間。
- 復元は新しいクラスターを作り、アプリの接続先を差し替える。DSQL クラスターの削除保護をオンにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| DynamoDB | SQL が使える点で DSQL を選んだ |
| 毎週 + 4 世代 | RPO が 7 日になる |
| 自作のエクスポート | ほぼ 0 円だが、スクリプトを保守する必要がある |
| バックアップしない | メタデータを失うリスクが残る |

## Consequences

- DSQL には組み込みの PITR がなく、`pg_dump` の公式対応もない。AWS Backup (Aurora DSQL のオプトインが必要) に頼る。
- DSQL は新しく仕様が変わりやすい。SQL を絞り、アクセスを 1 か所に集めて影響を小さくする。

## References

- [Aurora DSQL 料金](https://aws.amazon.com/rds/aurora/dsql/pricing/)
