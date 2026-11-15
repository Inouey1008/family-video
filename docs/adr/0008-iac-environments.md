# ADR-0008: Terraform で構築し、dev / prod は同じ AWS アカウントで分ける

- Status: Accepted
- Date: 2026-11-15

## Context

IaC のツール、dev と prod の分け方 (#20)、独自ドメインの要否 (#19) を決める必要があった。固定費はほぼ 0 円にしたい。

## Decision

- IaC は Terraform にする。
- dev と prod は同じ AWS アカウントに置き、リソース名・IAM ロール・GitHub Environment で分ける (#20)。
- 独自ドメインは使わない (#19)。URL は CloudFront の既定のものを使い、公開リポジトリには書かない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| AWS SAM | 使い慣れている Terraform を使う |
| 別の AWS アカウント | 利点は、dev の誤操作が prod に届かないこと。ただし、アカウントの管理 (ルートユーザーの MFA・請求・IAM の設定) が 2 倍になり、家族向けの個人開発では手間に見合わない (#20) |
| 独自ドメイン | ドメインの登録料と DNS の費用がかかる。家族はホーム画面から起動するので、URL を覚える必要もない (#19) |

## Consequences

- 同じアカウントなので、強い権限での誤操作は両方の環境に及びうる。
- 独自ドメインがないので、API Gateway の既定のエンドポイントを無効にできない。対策は [ADR-0010](0010-abuse-protection.md) のオリジン検証ヘッダーで行う。
- 環境の運用の細目は [設計書](../architecture.md) を参照。
