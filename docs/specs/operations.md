# Operations

[設計書](../architecture.md) の詳細。環境とデプロイ以外の運用の細目。環境・デプロイ・ロールバックは設計書にある。

判断の理由: [ADR-0008](../adr/0008-iac-environments.md)

## Runbook

開発者が行う次の操作を、`docs/runbook/` にまとめる (未作成)。管理の操作は、Runbook に沿ってコンソールか CLI で行う。

- 家族の追加
- メンバーからの除外 (`cmd/task` で行う)
- アカウントの復旧 (パスキーの再登録・開発者自身の復旧)
- 障害対応
- 署名用の鍵と `X-Origin-Verify` の値の入れ替え
- 海外旅行のときの地域制限の変更
- 削除した動画の復元 (`cmd/task` で行う)
- 誤操作からの復元 (S3 のバージョニング・DSQL のバックアップ。[Data](data.md))
- 元の動画とメタデータの一括取り出し

## Manual Tasks

一回きりの作業 (データの修正・バックフィル・不整合の確認) と、決まった管理の操作 (削除した動画の復元・メンバーの除外など) は、Go のコードとして `app/cmd/task/` にサブコマンドで置く。

- 入口は 1 つ。アプリと同じ `internal/` のコードを使い、DB と S3 の整合を保つ
- `dev` は手元で `go run ./cmd/task <name>` を実行する
- `prod` は GitHub Actions の手動実行 (`workflow_dispatch`、`.github/workflows/task.yml`、未作成) で行う
  - 入力は、作業の名前・環境・ドライランかどうか
  - OIDC のロールで接続し、`prod` は GitHub Environment の承認を通す
  - 実行の記録が Actions に残る
- 既定はドライラン (変更する件数を出すだけ)。書き換えるのは、入力で指定したときだけ
- 管理用・マイグレーション用の Lambda は持たない

## Data Inspection

- データを見るだけなら、手元の `psql` から、IAM 認証のトークン (`aws dsql generate-db-connect-auth-token`) で DSQL に接続する
- 確認用に、SELECT だけできる DB のロールを用意する

## Cost Management

- 固定費をほぼ 0 円にするため、配信・DB・認証・Lambda は無料枠に収める
- AWS Budgets で月額のアラートを設定する (予算の 80% で通知)
- 保存料の目安は [Data](data.md) にある
- 既存の動画の移行は、各自がアップロードして行う。一括取り込みの手順は作らず、期限も設けない

## Dependencies

- Dependabot が gomod・terraform・github-actions を月 1 回確認する
- govulncheck を週 1 回実行する
- Go のバージョンは年 1 回上げる。脆弱性の修正版が出たら、その都度上げる

## Testing

- Go の単体テストと、ローカルの PostgreSQL を使った結合テストを、CI で実行する
- リリース前に、iPhone で手動確認する。項目はログイン・複数アップロード・再開・再生・ホーム画面からの起動 (PWA)
- 動作確認の対象は、iOS の Safari と、ホーム画面に追加した PWA。iPhone で撮った動画 (HEVC) は iPhone でそのまま再生できる

## Performance

- 一覧の表示は、Lambda が温まっている状態で 1 秒以内を目安にする

## UI Policy

- 画面は、文字を大きめにし、操作を少なくする (スマホに慣れていない家族も使えるようにするため)
