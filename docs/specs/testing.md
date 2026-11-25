# Testing

[設計書](../architecture.md) の詳細。テストの種類・実行する場所・タイミング。

判断の理由: [ADR-0029](../adr/0029-backend-onion.md) / [ADR-0003](../adr/0003-support-safari.md) / [ADR-0027](../adr/0027-ci-cd.md) / [ADR-0030](../adr/0030-dev-no-geo-restriction.md)

Go のコードの構成は [Backend](backend.md) にある。

## Types

| 種類 | 対象 | 依存 | 場所 | いつ |
|---|---|---|---|---|
| 単体 | domain (集約の不変条件。遷移の表は表駆動ですべて)・command (偽物で)・web (httptest)・apigw・auth (JWT の検証)・media の署名・middleware・テンプレート・migrations/ の書き方の検査・COMMIT 時の 40001 の再試行・偽物への契約テスト | なし | 手元・CI | PR ごと (`app/**` の変更時) |
| 結合 | store への契約テスト・query の読み取り・UPDATE 時の 40001 の再試行・HTTP から DB までの通し (主な操作だけ) | ローカル PostgreSQL。S3・Cognito は偽物 | 手元・CI (services の postgres) | PR ごと |
| スモーク | デプロイ後、dev の CloudFront の URL で `/auth/login` が Cognito への 302 を返す | dev | `deploy.yml` | main へのマージごと |
| E2E | 一覧・再生・お気に入り・削除と復元・小さな動画のアップロード | dev | 手元 (Mac)・`e2e.yml` (macOS のランナー) | リリースのタグを打つ前・大きな変更の後 (手動) |
| 手動確認 | パスキー・ホーム画面・中断・リリース前の項目 | iPhone | 手元 | リリース前 |

dev の CloudFront には地域制限がないので、GitHub のランナーからスモークテストと `e2e.yml` が届く ([ADR-0030](../adr/0030-dev-no-geo-restriction.md))。

## Regression

リグレッションは独立した種類にしない。上の全部を回帰として使う。不具合を直すときは、再現するテストを先に足す。

## VRT

VRT (見た目の回帰テスト) は、今は入れない。

- 描画が OS・版で変わり、基準画像に OS が付く ([Playwright のスクリーンショット比較](https://playwright.dev/docs/test-snapshots))
- Playwright の WebKit は Safari 本体と別物 ([Playwright のブラウザ](https://playwright.dev/docs/browsers))
- dev のデータが変わる
- 画面が少ない

見直す条件は、`/_catalog` (#28 で方針を決める部品の見本ページ) ができたとき。`/_catalog` だけを撮る形で再検討する。

## CI

Go の単体テストと、ローカルの PostgreSQL を使った結合テストを CI で実行する。`ci.yml` に、Go のコードを作るとき (#10) に次のジョブを足す。

- `gofmt -l`
- `go vet`
- `go test -race ./...`
- `govulncheck`

結合テストの PostgreSQL は、ジョブの services で起動する。

## Local PostgreSQL

結合テストと手元の開発は、ローカルの PostgreSQL に接続する。DSQL とは次の点が違う。

- DSQL は REPEATABLE READ に固定で、PostgreSQL は `TxOptions` で明示して合わせる
- 40001 は、DSQL では COMMIT のとき、PostgreSQL では 2 つ目の UPDATE のときに起きる
- `CREATE INDEX ASYNC` は PostgreSQL では通らないので、`cmd/migrate` が `INDEX` に置き換える ([Backend](backend.md))

差は、次のテストで埋める。

- COMMIT 時の 40001 の再試行は、単体テストで確かめる
- UPDATE 時の 40001 の再試行は、結合テストで確かめる。40001 を決まって起こす手順は次のとおり
  1. tx2 で SELECT する
  2. tx1 が UPDATE して COMMIT する
  3. tx2 が UPDATE する (PostgreSQL はスナップショットを最初の文で取るので、先に SELECT が要る)
- 契約テストは、メモリ上の偽物と store の両方に同じ関数で流し、振る舞いが同じことを保つ

## E2E

E2E は Playwright の WebKit (Safari のエンジン) で `dev` を操作する。CI には組み込まず、`e2e.yml` (workflow_dispatch) か手元から手動で実行する。

- 対象は一覧・再生・お気に入り・削除と復元・小さな動画のアップロード
- ログインは `dev` にだけ作ったテスト用の家族で、予備のパスワードと TOTP を使う (秘密は GitHub のシークレット)
- テストは `e2e/` に置く。依存は `@playwright/test` だけ
- `e2e/` は配らない開発用のツールなので、[ADR-0004](../adr/0004-mpa.md) の「フロントエンドのビルド (npm・バンドラー) は使わない」 (配る画面のビルドの話) の対象外
- `e2e.yml` は macOS のランナーで動かす。動画のコーデックが Linux の WebKit と大きく違い、再生を試せないため。public リポジトリなので、macOS のランナーも無料

## Manual

パスキー・ホーム画面からの起動・アプリを離れたときの中断は自動で試せないので、iPhone で手動確認する。

リリース前に iPhone で手動確認する項目は次のとおり。

- ログイン
- 複数アップロード
- 再開
- 再生
- 選んだ動画の保存
- ホーム画面からの起動

## Dependabot

`app/` (gomod) と `e2e/` (npm) は、作るときに Dependabot の対象へ足す。e2e は CI で動かないので、自動マージの対象から外す。
