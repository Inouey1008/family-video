# ADR-0007: Lambda は VPC に入れず、ほかの AWS のサービスには IAM の認証で接続する

- Status: Accepted
- Date: 2026-11-15

## Context

- バックエンドは Lambda で動かす ([ADR-0006](0006-lambda.md))
- NAT ゲートウェイなど、VPC にかかる固定費は持ちたくない (PRD の Goals)
- AWS のサービスの API への通信は TLS で暗号化され、リクエストごとに IAM の署名で認証される。VPC で通信の経路を閉じなくても、IAM の権限で守れる
- Lambda が使う認証情報は実行ロールの一時的なもので、長期の鍵を持たない

## Decision

- Lambda は VPC に入れない。NAT ゲートウェイも使わない。
- ほかの AWS のサービスには、VPC を通さずに IAM の認証で接続する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Lambda in VPC + NAT ゲートウェイ | NAT ゲートウェイの固定費がかかる |
| Lambda in VPC + PrivateLink (インターフェースエンドポイント) | エンドポイントごとに固定費がかかる |

## Consequences

- ネットワークで閉じないので、IAM のポリシーを最小権限にすることが前提になる ([Security](../specs/security.md))。
- VPC の中で接続するサービス (RDS・ElastiCache など) は使えない。
