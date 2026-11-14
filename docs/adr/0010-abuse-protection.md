# ADR-0010: 乱用対策は WAF を使わず、スロットリングと地域制限で行う

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Security: 不正アクセス・乱用・課金の暴走を防ぐ。日本国内からのアクセスだけを許可する。
- PRD の Cost: 固定費はほぼ 0 円にする。
- アップロードの本数と容量には上限を設けないので、保存量の増加は費用の通知で把握する。

## Decision

- API Gateway のステージ全体に既定のスロットリングを設定し、負荷の高いルートにはさらに厳しい値をルートごとに設定する。
- Go 側で利用者ごとの制限を判定し、Lambda の予約同時実行数で全体の上限を付ける。上限を超えたら `429` と `Retry-After` を返す。
- 地域制限は CloudFront の機能で、日本 (`JP`) だけを許可する。追加料金はかからない。
- CloudFront からオリジンへのリクエストに秘密のカスタムヘッダー (`X-Origin-Verify`) を付け、Go の middleware で最初に検証する。API Gateway に直接アクセスされても地域制限を回避されないようにする。
- WAF は使わない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| WAF (レートベースのルール・Bot Control・CAPTCHA) | Web ACL ごとに月額の固定費がかかる |
| WAF の地域一致ルール | 同上。CloudFront の地域制限なら追加料金がない |
| REST API の使用量プラン | 個別の比較は記録していない。HTTP API のスロットリングを使う |

## Consequences

- 独自ドメインを使わない ([ADR-0008](0008-iac-environments.md)) ので、API Gateway の既定のエンドポイントは無効にできない。オリジン検証ヘッダーが唯一の対策になる。ヘッダーの値は SSM Parameter Store に置き、定期的に入れ替える。
- Terraform では `throttling_burst_limit` と `throttling_rate_limit` を必ず明記する。消すと 0 になり、すべての通信がブロックされる。
- 海外へ旅行するときは、Terraform で一時的に旅行先の国を許可リストに加える。
- iCloud プライベートリレーを使う端末が日本と判定されるかを、リリース前に確認する。
- 具体的な値と実装の細目は [設計書](../architecture.md) にまとめる。値は運用しながら調整する。

## References

- [HTTP API のスロットリング](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html)
- [CloudFront の地域制限](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistValuesEnableGeoRestriction.html)
- [CloudFront を使った地域制限の方法 (AWS)](https://aws.amazon.com/developer/application-security-performance/articles/geo-blocking)
- [API Gateway と境界防御サービスで API を保護する (AWS Security Blog)](https://aws.amazon.com/blogs/security/protect-apis-with-amazon-api-gateway-and-perimeter-protection-services)
- [HTTP API の既定のエンドポイントを無効にする](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-disable-default-endpoint.html)
