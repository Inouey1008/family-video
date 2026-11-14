# Security

[設計書](../architecture.md) の詳細。認証・配信・権限・乱用対策の設計。

判断の理由: [ADR-0006](../adr/0006-auth-cognito.md) / [ADR-0007](../adr/0007-video-storage-delivery.md) / [ADR-0010](../adr/0010-abuse-protection.md)

## Authentication

- アカウントは開発者が Cognito で招待して作る。自己サインアップは無効にする
- ログインはパスキーが主。予備としてパスワードと TOTP を使える
- ログイン状態は HttpOnly Cookie で保持する。トークンは JS から読めない
- `/auth/callback` では `state`・PKCE・`nonce` を必ず検証する
- JWT の検証と認可の判定は、Lambda (Go) で行う
- ログインなしで通すのは `/auth/login`・`/auth/callback`・`/static/*` だけ。それ以外はログイン画面へリダイレクトし、DB には触れない
- アカウントの復旧は、パスキーの再登録を可能にして行う。開発者自身が締め出されたときの手段も用意する (Runbook)

## Delivery and Transport

| 項目 | 内容 |
|---|---|
| S3 | パブリックアクセスをすべてブロックし、CloudFront の OAC からだけ読む |
| 動画・サムネイルの配信 | CloudFront の署名付き URL (短い有効期限) だけ |
| アップロード | サーバーが決めたキーへの署名付き URL (短い有効期限) だけ |
| Cookie | `Secure`・`HttpOnly`・`SameSite=Lax` |
| CSRF | 書き込み系のリクエストで、`HX-Request` ヘッダーと Origin を確認する |
| CSP など | 外部のスクリプトは読み込まない。厳しい CSP・HSTS・`X-Content-Type-Options` を付ける |
| htmx | `allowEval = false`。自分のオリジン (`/static/`) から配信する |
| 検索エンジン | `robots.txt` で全ページ Disallow。CloudFront のレスポンスヘッダーポリシーで `X-Robots-Tag: noindex` を付ける |

## Permissions

- IAM は Lambda ごとに最小権限にする。DSQL への接続は IAM 認証で、対象のクラスターだけに絞る
- デプロイは GitHub OIDC で行い、長期のアクセスキーは発行しない
- AWS のルートユーザーには MFA を設定し、普段は使わない
- Slack から AWS を操作する機能は使わない。通知に使うロールとガードレールは CloudWatch の読み取りだけにする

## Abuse Protection

WAF は使わず、次の層で防ぐ。

```text
CloudFront の地域制限 (JP のみ)
  → API Gateway のスロットリング
    → Lambda の middleware (オリジン検証・回数制限)
      → Lambda の予約同時実行数
```

### Throttling

| 対象 | レート (/秒) | バースト | 実装 |
|---|---|---|---|
| ステージ全体 | 20 | 40 | API Gateway の既定のスロットリング |
| `POST /api/uploads` | 2 | 5 | API Gateway のルートごとの設定 |
| `POST /api/client-log` | 1 | 3 | API Gateway のルートごとの設定。Lambda のメモリ上のトークンバケットでも制限し、1 回あたりのサイズに上限を付ける |
| Lambda の予約同時実行数 | 10 | - | 全体の上限 |

- 値は運用しながら調整する
- 上限を超えたら `429` と `Retry-After` を返し、画面に再試行を促す表示を出す
- Terraform では `throttling_burst_limit` と `throttling_rate_limit` を必ず明記する。消すと 0 になり、すべての通信が止まる
- ログインの総当たりは、Cognito の標準のロック機能で防ぐ。パスワードで 5 回失敗すると 1 秒ロックされ、失敗のたびに倍になり、最大約 15 分になる
- アップロードの本数と容量に上限は設けない。保存量の増加と費用は、AWS Budgets のアラートと S3 の保存量のメトリクスで把握する

### Geo Restriction and Origin Verification

- CloudFront の地域制限で、日本 (`JP`) だけを許可する (追加料金なし)
- CloudFront からオリジンへのリクエストに、秘密のカスタムヘッダー `X-Origin-Verify` を付ける。Go の middleware で最初に検証し、一致しなければ `403` を返す。API Gateway の URL に直接アクセスされても、地域制限を回避されない
- ヘッダーの値は SSM Parameter Store に置き、定期的に入れ替える (Runbook)
- 独自ドメインを使わないので ([環境](../architecture.md#environments))、API Gateway の既定のエンドポイントは無効にできない。直接アクセスへの備えは `X-Origin-Verify` が担う
- 海外旅行のときは、Terraform で旅行先の国を一時的に許可リストへ加える (Runbook)
- iCloud プライベートリレーを使っている端末が日本と判定されるかを、リリース前に確認する
