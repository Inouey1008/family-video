[← 目次へ戻る](../README.md)

# Abuse Protection

## Rate Limiting

| # | 要件 |
|---|---|
| NFR-90 | ログインの総当たりは、Cognito の標準のロック機能で防ぐ (パスワードで 5回失敗すると 1秒ロックされ、以降は失敗するたびに倍になり、最大約15分) |
| NFR-91 | API Gateway のステージ全体に既定のスロットリングを設定し、負荷の高いルートには、さらに厳しい値をルートごとに設定する |
| NFR-92 | Terraform では `throttling_burst_limit` と `throttling_rate_limit` を必ず明記する (消すと 0 になり、すべての通信がブロックされるため) |
| NFR-93 | アップロードの本数と容量には上限を設けない ([FR-15](../functional.md#32-upload))。保存量の増加と費用は、AWS Budgets のアラートと S3 の保存量のメトリクスで把握する |
| NFR-94 | `POST /api/client-log` は、Lambda のメモリ上のトークンバケットで回数を制限し、1回あたりのサイズにも上限を付ける |
| NFR-95 | 上限を超えたら `429` と `Retry-After` を返し、画面に再試行を促す表示を出す |
| NFR-96 | Lambda の予約同時実行数で、全体の上限を付ける |

設定値の例 (運用しながら調整する):

| 対象 | 制限 |
|---|---|
| ステージ全体 | 20 リクエスト/秒、バースト 40 |
| `POST /api/uploads` | 2 リクエスト/秒、バースト 5 |
| `POST /api/client-log` | 1 リクエスト/秒、バースト 3 |
| Lambda の予約同時実行数 | 10 |

## Bot Protection

| # | 要件 |
|---|---|
| NFR-100 | ログインせずにアクセスできるのは `/auth/login`、`/auth/callback`、`/static/*` だけにする。それ以外はログイン画面にリダイレクトし、DB にはアクセスしない |
| NFR-101 | `/auth/callback` では、`state`、PKCE、`nonce` を必ず検証する |
| NFR-102 | `robots.txt` ですべてのページを Disallow にし、CloudFront のレスポンスヘッダーポリシーで `X-Robots-Tag: noindex` を付ける |
| NFR-103 | 公開リポジトリには、ドメインや CloudFront の URL を書かない |

## Geo Restriction

| # | 要件 |
|---|---|
| NFR-110 | CloudFront の地域制限で、日本 (`JP`) だけを許可する (追加料金なし) |
| NFR-111 | CloudFront からオリジンへのリクエストに秘密のカスタムヘッダー (`X-Origin-Verify`) を付ける。Go の middleware で最初に検証し、一致しなければ `403` を返す。API Gateway の URL に直接アクセスされても、地域制限を回避されないようにするため |
| NFR-112 | カスタムヘッダーの値は SSM Parameter Store に置き、定期的に入れ替える。独自ドメインを使う場合は、API Gateway の既定のエンドポイントを無効にする |
| NFR-113 | 家族が海外へ旅行するときは、Terraform で一時的に旅行先の国を許可リストに加える |
| NFR-114 | iCloud プライベートリレーを使っている端末が日本と判定されるかを、リリース前に確認する |

## References

- [HTTP API のスロットリング](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html)
- [Cognito のサインイン失敗時のロック](https://docs.aws.amazon.com/cognito/latest/developerguide/authentication-flow-things-to-know.html)
- [CloudFront の地域制限](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistValuesEnableGeoRestriction.html)
- [CloudFront を使った地域制限の方法 (AWS)](https://aws.amazon.com/developer/application-security-performance/articles/geo-blocking)
- [API Gateway と境界防御サービスで API を保護する (AWS Security Blog)](https://aws.amazon.com/blogs/security/protect-apis-with-amazon-api-gateway-and-perimeter-protection-services)
- [HTTP API の既定のエンドポイントを無効にする](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-disable-default-endpoint.html)
