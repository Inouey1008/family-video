# Backend

[設計書](../architecture.md) の詳細。Go のバックエンドの構成・ビルド・DSQL への接続・マイグレーション。

判断の理由: [ADR-0005](../adr/0005-backend-go.md) / [ADR-0006](../adr/0006-lambda.md) / [ADR-0008](../adr/0008-htmx.md) / [ADR-0012](../adr/0012-database-dsql.md)

## Layout

Go のコードは `app/` に置く。

```
app/
├─ go.mod
├─ cmd/api/       Lambda の入口。AWS_LAMBDA_RUNTIME_API の有無で、Lambda と手元の HTTP サーバーを切り替える
├─ cmd/task/      手動の作業 (ADR-0028)
├─ cmd/migrate/   マイグレーション
└─ internal/
   ├─ web/        ルーティング (net/http の ServeMux)・ハンドラー・middleware・テンプレート (go:embed)
   ├─ lambda/     API Gateway のイベントと http.Handler をつなぐアダプター・イベントの振り分け
   ├─ video/      動画のライフサイクル (状態の遷移などのルール)
   ├─ store/      DSQL へのアクセス。SQL はここだけに書く
   ├─ media/      S3 と CloudFront の署名付き URL
   └─ auth/       Cognito・Cookie・JWT の検証
static/           htmx・upload.js・service-worker.js (S3 に置く)
```

## Layers

- 呼び出しは ハンドラー → (要るときだけ) 業務のルール → store の 3 段まで
- interface は使う側に置き、使うメソッドだけを持たせる。対象は S3・時計など、差し替えたいものに限る
- DB はモックしない。store は実際の PostgreSQL に当ててテストする ([Testing](testing.md))
- 依存は `main` で手で組み立てる。DI のフレームワークは使わない

## Lambda

- 1 つの Lambda に、API Gateway (HTTP API) の HTTP リクエストと、EventBridge Scheduler の日次の完全削除が来る。`internal/lambda` がイベントの種類で振り分ける
- `aws-lambda-go` の `lambdaurl.Wrap` は Function URL 専用で、HTTP API では使えない。payload 2.0 のイベントと `http.Handler` をつなぐアダプターを自前で持つ
- `AWS_LAMBDA_RUNTIME_API` がないときは、同じハンドラーを手元の HTTP サーバーで動かす

## Build

- Go 1.27.3 を mise で固定する
- arm64・`CGO_ENABLED=0`・`-tags lambda.norpc` でビルドし、実行ファイル名を `bootstrap` にして zip にする
- Terraform の `architectures` は arm64 に合わせる

## Database

- DSQL へは pgx で接続し、IAM の認証トークンを `BeforeConnect` で入れる
- 接続は 1 時間で切れるので、`MaxConnLifetime` を 1 時間より短くする
- 競合 (SQLSTATE 40001) は、決まった回数だけ再試行する

## Migration

- `cmd/migrate` が、1 文ずつ別のトランザクションで流す。DSQL は 1 つのトランザクションに DDL と DML を混ぜられない
- 索引は `CREATE INDEX ASYNC` で作り、完了を待つ
- テストでも同じ `cmd/migrate` を使う ([Testing](testing.md))
