# ADR-0010: 乱用対策は WAF を使わず、スロットリングと地域制限で行う

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Security は、不正アクセス・乱用・課金の暴走を防ぎ、日本国内からのアクセスだけを許可すること。固定費はほぼ 0 円にしたい。

## Decision

- API Gateway のスロットリング、Go での利用者ごとの制限、Lambda の予約同時実行数で、乱用と課金の暴走を防ぐ。
- 地域制限は CloudFront の機能で、日本 (`JP`) だけを許可する。
- CloudFront からオリジンへ秘密のヘッダーを付け、Go で検証する。API Gateway への直接アクセスで地域制限を回避されないようにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| WAF (レートベースのルール・Bot Control・地域一致ルール) | Web ACL ごとに月額の固定費がかかる |
| REST API の使用量プラン | 個別の比較は記録していない |

## Consequences

- 独自ドメインを使わない ([ADR-0008](0008-iac-environments.md)) ので、既定のエンドポイントを無効にできない。オリジン検証ヘッダーが直接アクセスへの唯一の対策になる。
- 値や旅行時の扱いなどの細目は [設計書](../specs/security.md) を参照。

## References

- [HTTP API のスロットリング](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html)
- [CloudFront の地域制限](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistValuesEnableGeoRestriction.html)
