# ADR-0003: 処理は Lambda にし、VPC には入れない

- Status: Accepted
- Date: 2026-11-15

## Context

- サーバーレスで作る ([ADR-0001](0001-serverless.md))
- クラウドは AWS にする ([ADR-0002](0002-cloud-aws.md))
- NAT ゲートウェイなど、VPC にかかる固定費は持ちたくない

## Decision

- 処理は Lambda にする。
- VPC・NAT ゲートウェイは使わない。DB・S3・Cognito には IAM の認証で接続する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Lambda in VPC + PrivateLink | NAT やインターフェースエンドポイントの固定費がかかる |

## Consequences

- Lambda のペイロード制限 (6 MB) を超える動画は、Lambda を通さずに送る ([ADR-0008](0008-entry-delivery.md))。

## References

- [Lambda 料金](https://aws.amazon.com/lambda/pricing/)
