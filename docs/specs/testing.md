# Testing

[設計書](../architecture.md) の詳細。テストの種類・場所・タイミング。

判断の理由: [ADR-0029](../adr/0029-playwright.md)

## Test types

| 種類 | 対象 | 場所 | いつ |
|---|---|---|---|
| 単体 | 業務のルール・アダプター・再試行 | 手元・CI | PR ごと |
| ハンドラー | ステータス・ヘッダー (CSP・Cookie)・本文の要点 (`httptest`) | 手元・CI | PR ごと |
| テンプレート | HTML の golden file (`-update` で更新)。XSS のエスケープ・htmx の部分応答も含む | 手元・CI | PR ごと |
| 結合 | store と `cmd/migrate` を、PostgreSQL 16 のコンテナに当てる | 手元・CI (services) | PR ごと |
| DSQL のスモーク | 接続・マイグレーション・競合の再試行 | `dev` | デプロイの後 |
| VRT | 主な画面の見た目 (WebKit・iPhone の画面幅) | CI (Playwright の公式 Docker イメージ) | 画面に関わる PR ごと |
| E2E | 一覧・再生・お気に入り・削除と復元・アップロード | `dev` (Playwright の WebKit) | 手動。リリースの前に必ず |
| 実機 | パスキー・ホーム画面・アプリを離れたときの中断 | iPhone | リリースの前 |

## Integration

- DSQL の公式のエミュレーターはないので、結合テストは PostgreSQL 16 のコンテナ (照合順序 C) で行う。大半はこれで賄える
- コンテナでは再現できないことは `dev` の DSQL で確かめる (DSQL のスモーク)
  - DDL と DML を混ぜられない
  - `CREATE INDEX ASYNC`
  - 競合での 40001
  - 1 トランザクション 3,000 行まで

## VRT

- 手元の Go のサーバー・PostgreSQL のコンテナ・合成のテストデータで動かす。`dev` のデータは使わない
- 基準画像は OS とブラウザごとに別になるので、Playwright の公式 Docker イメージの中で作って比べ、git に入れる
- 家族の動画や名前は入れない。日時などは決まった値にするか、`mask` で隠す
- Playwright の WebKit は iPhone の Safari とは別物なので、実機の確認は残る

## E2E

- Playwright の WebKit で `dev` を操作する。CI には組み込まず、`e2e.yml` (workflow_dispatch) か手元から手動で実行する
- ログインは `dev` にだけ作ったテスト用の家族で、予備のパスワードと TOTP を使う (秘密は GitHub のシークレット)
- パスキー・ホーム画面からの起動・アプリを離れたときの中断は自動で試せないので、iPhone で手動確認する
- リリース前に iPhone で手動確認する (ログイン・複数アップロード・再開・再生・選んだ動画の保存・ホーム画面からの起動)

## Regression

- 回帰のための別の仕組みは持たない。上のテストを毎回流すことが回帰の確認になる
- 不具合を直すときは、いちばん低い層に再現するテストを足す

## Tools

- Playwright は yarn で入れ、`e2e/` に置く
