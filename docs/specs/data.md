# Data

[設計書](../architecture.md) の詳細。保存する情報・削除・バックアップ。

判断の理由: [ADR-0012](../adr/0012-database-dsql.md) / [ADR-0014](../adr/0014-video-storage.md) / [ADR-0015](../adr/0015-video-deletion.md) / [ADR-0013](../adr/0013-database-backup.md)

## Stored Data

```mermaid
erDiagram
  videos ||--o{ favorites : "お気に入りされる"
  videos {
    uuid id PK
    text uploader_sub "アップロードした家族 (Cognito の sub)"
    text s3_key "S3 のキー"
    bigint size "バイト"
    timestamptz taken_at "撮影日時 (UTC)"
    integer duration "再生時間 (秒)"
    text status "uploading / ready / failed"
    timestamptz deleted_at "削除した日時"
  }
  favorites {
    text member_sub PK "家族 (Cognito の sub)"
    uuid video_id PK, FK
    timestamptz created_at "登録した日時"
  }
```

※ 型は仮。確定はマイグレーションを作るときに行う
※ DSQL には外部キーがないので、関係は論理上のもの。整合はアプリで保つ
※ 家族の情報は Cognito が持つので、家族のテーブルは作らない

- S3: 動画とサムネイル
- 撮影日時は UTC で保存し、日本時間で表示する
- 家族を除外しても、`videos` の行と動画は残す

## Delete and Restore

```mermaid
stateDiagram-v2
  [*] --> ready: アップロード完了
  ready --> deleted: 削除 (deleted_at を記録)
  deleted --> ready: 30 日以内に復元
  deleted --> [*]: 30 日後に完全削除
```

- 削除した動画は一覧に出さない。復元は `cmd/task` で行う ([Operations](operations.md))
- 完全削除は、EventBridge Scheduler が同じ Lambda を日次に呼んで行う。30 日を過ぎた行と、S3 の全バージョン (古いバージョンを含む) を消す
- 完全削除した行は、DSQL のバックアップに最大 7 日残る

## Backup

- S3: バージョニングで、削除や上書きの前の状態を 30 日間保持する。別リージョンへの複製はしない
- DSQL: AWS Backup で毎日取り、7 日分を保持する (RPO は最大 24 時間)。クラスターの削除保護をオンにする
- DSQL の復元は、新しいクラスターを作り、アプリの接続先を差し替える

## Storage Cost

S3 Intelligent-Tiering (東京。2026-11 時点の単価で、採用前に AWS Pricing Calculator で再確認する)。

| 保存量 | 最近見られている | ほぼすべて古い |
|---|---|---|
| 100 GB | 約 $2.5 | 約 $0.5 |
| 500 GB | 約 $12.5 | 約 $2.5 |
| 1 TB | 約 $25.6 | 約 $5.1 |
