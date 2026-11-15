# Operations

[設計書](../architecture.md) の詳細。手動で行う作業とテスト。

判断の理由: [ADR-0019](../adr/0019-environments.md) / [ADR-0021](../adr/0021-manual-tasks.md)

## Runbook

開発者が行う操作を `docs/runbook/` にまとめる (未作成)。

- 家族の招待・アカウントの復旧 (パスキーの再登録・開発者自身の復旧)
- メンバーの除外・削除した動画の復元 (`cmd/task`)
- 障害対応
- 署名用の鍵と `X-Origin-Verify` の値の入れ替え、海外旅行のときの地域制限の変更
- S3 と DSQL の誤操作からの復元 ([Data](data.md))
- 元の動画とメタデータの一括取り出し

## Manual Tasks

一回きりの作業 (データの修正・バックフィル・不整合の確認) と、決まった管理の操作は、`app/cmd/task/` にサブコマンドで置く。入口は 1 つで、アプリと同じ `internal/` のコードを使い、DB と S3 の整合を保つ。

- `dev` は手元で `go run ./cmd/task <name>` を実行する
- `prod` は `task.yml` (workflow_dispatch) で、リリースのタグを選んで実行する。入力は作業の名前・環境・ドライランかどうか。OIDC のロールで接続し、Environment の承認を通す。記録は Actions に残る
- 既定はドライラン (変更する件数を出すだけ)。書き換えるのは、入力で指定したときだけ

## Data Inspection

- データを見るだけなら、手元の `psql` から、IAM 認証のトークン (`aws dsql generate-db-connect-auth-token`) で DSQL に接続する
- 確認用に、SELECT だけできる DB のロールを用意する

## Testing

- Go の単体テストと、ローカルの PostgreSQL を使った結合テストを CI で実行する
- リリース前に iPhone で手動確認する (ログイン・複数アップロード・再開・再生・選んだ動画の保存・ホーム画面からの起動)
