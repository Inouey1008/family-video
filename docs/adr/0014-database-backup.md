# ADR-0014: DB は AWS Backup で毎日バックアップする

- Status: Accepted
- Date: 2026-11-15

## Context

動画の控えは取らない (PRD の Decisions のとおり) が、メタデータを失うと動画を一覧できなくなる。DSQL には組み込みの PITR がなく、`pg_dump` の公式対応もない。

## Decision

- AWS Backup で毎日バックアップし、7 日分を保持する (月 10 円ほど)。RPO は最大 24 時間。
- 復元は新しいクラスターを作り、アプリの接続先を差し替える。
- DSQL クラスターの削除保護をオンにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| 毎週 + 4 世代 | RPO が 7 日になる |
| 自作のエクスポート | ほぼ 0 円だが、スクリプトを保守する必要がある |
| バックアップしない | メタデータを失うリスクが残る |

## Consequences

- AWS Backup の設定で、Aurora DSQL のオプトインが必要になる。
- 復元の手順は Runbook にまとめる ([Operations](../specs/operations.md))。
