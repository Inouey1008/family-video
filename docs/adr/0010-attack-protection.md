# ADR-0010: 攻撃への対策は WAF を使わず、スロットリングと地域制限で行う

- Status: Accepted
- Date: 2026-11-15

## Context

- 不正アクセス・攻撃・課金の暴走を防ぐ (PRD の Security)
- 日本国内からのアクセスだけを許可する (PRD の Security)
- 固定費はほぼ 0 円にする

## Decision

- API Gateway のスロットリング、Go での利用者ごとの制限、Lambda の予約同時実行数で、大量のリクエストによる攻撃と課金の暴走を防ぐ。
- 地域制限は CloudFront の機能で、日本 (`JP`) だけを許可する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| WAF (レートベースのルール・Bot Control・地域一致ルール) | Web ACL ごとに月額の固定費がかかる |
| REST API の使用量プラン | REST API は HTTP API より料金が高い。HTTP API のスロットリングで足りる |

## Consequences

- 地域制限は CloudFront を通るリクエストにしか効かない。API Gateway への直接のアクセスは [ADR-0009](0009-origin-lock.md) で防ぐ。
- 値や旅行時の扱いなどの細目は [設計書](../specs/security.md) を参照。

## References

- [HTTP API のスロットリング](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html)
- [CloudFront の地域制限](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistValuesEnableGeoRestriction.html)
