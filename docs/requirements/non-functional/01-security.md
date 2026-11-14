[← 目次へ戻る](../README.md)

# Security

| # | 要件 |
|---|---|
| NFR-01 | S3 バケットのパブリックアクセスはすべてブロックし、CloudFront の OAC からだけ読み取れるようにする |
| NFR-02 | 動画とサムネイルは、CloudFront の署名付き URL (短い有効期限) でだけ配信する |
| NFR-03 | アップロード用の署名付き URL は、サーバーが決めたキーにだけ、短い有効期限で発行する |
| NFR-04 | Cookie には `Secure`、`HttpOnly`、`SameSite=Lax` を付ける。書き込み系のリクエストでは、`HX-Request` ヘッダーと Origin を確認する (CSRF 対策) |
| NFR-05 | JWT の検証と認可の判定は、Go (Lambda) 側で行う |
| NFR-06 | 外部のスクリプトは読み込まない。厳しい CSP、HSTS、`X-Content-Type-Options` を付ける |
| NFR-07 | htmx は `allowEval = false` にし、自分のドメインから配信する |
| NFR-08 | IAM は Lambda ごとに最小権限にする。デプロイには GitHub OIDC を使い、長期のアクセスキーは発行しない |
| NFR-09 | レートリミット、ボット対策、地域制限で、乱用と課金の暴走を防ぐ (詳細は [4.7](07-abuse-protection.md)) |
| NFR-10 | ルートユーザーには MFA を設定し、普段は使わない |
