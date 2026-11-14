# ADR-0005: DB に Aurora DSQL を使い、AWS Backup で毎日バックアップする

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Cost: 固定費はほぼ 0 円にする。
- PRD の Maintenance: 保守の手間を小さく保つ。
- 動画のメタデータ (撮影日時・お気に入り・論理削除の状態) を SQL で扱いたい。
- PRD の Decisions: 動画の控えは取らない (#15)。残る課題は、メタデータのバックアップ方法だけ (#21)。

## Decision

- DB は Aurora DSQL にする。無料枠は毎月 100,000 DPU と 1 GB のストレージで、期限はない (2026-11-15 に確認)。
- SQL は基本的な CRUD に限り、データアクセスは `internal/db` に集める。
- バックアップは AWS Backup で毎日取り、7 日分を保持する (#21)。
  - 費用は月 10 円ほど (0.1 GB の想定、$0.12/GB-月、無料枠なし)。
  - RPO (復旧時点の目標) は最大 24 時間。
  - 復元は新しいクラスターを作り、アプリの接続先を差し替える。
  - AWS Backup 側で Aurora DSQL のオプトインが必要になる。
- DSQL クラスターの削除保護をオンにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| DynamoDB | SQL が使える点で DSQL を選んだ |
| 毎週 + 4 世代のバックアップ | RPO が 7 日になる |
| 自作のエクスポート | 費用はほぼ 0 円だが、スクリプトを保守する必要がある |
| バックアップしない | メタデータを失うリスクが残る |

## Consequences

- DSQL には組み込みの PITR (任意の時点への復元) がなく、`pg_dump` の公式対応もない。バックアップは AWS Backup に頼る。
- DSQL は新しく、仕様が変わりやすい。SQL を絞り、アクセスを 1 か所に集めて影響を小さくする。
- DSQL の制限はローカルの PostgreSQL では検出できないので、マイグレーションは dev 環境で確かめる。
- RTO (復旧時間) の数値は決めない。復元手順は手順書に書く。

## References

- [Aurora DSQL 料金](https://aws.amazon.com/rds/aurora/dsql/pricing/)
- [Aurora DSQL のアクセス制御 (AWS Database Blog)](https://aws.amazon.com/blogs/database/securing-amazon-aurora-dsql-access-control-best-practices)
