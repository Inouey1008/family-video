# ADR-0006: 処理は Lambda の OS-only ランタイムで動かし、VPC には入れない

- Status: Accepted
- Date: 2026-11-15

## Context

- サーバーレスで作る ([ADR-0001](0001-serverless.md))
- クラウドは AWS にする ([ADR-0002](0002-cloud-aws.md))
- バックエンドは Go の 1 つのバイナリで動かす ([ADR-0005](0005-backend-go.md))
- NAT ゲートウェイなど、VPC にかかる固定費は持ちたくない

## Decision

- 処理は Lambda にし、OS-only ランタイム (`provided.al2023`) に zip でデプロイする。Go のバイナリをそのまま OS の上で動かし、OS の保守は AWS が行う。
- VPC・NAT ゲートウェイは使わない。DB・S3・Cognito には IAM の認証で接続する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Lambda のコンテナイメージ | ベースイメージのパッチを自分で当てる必要がある |
| Lambda in VPC + PrivateLink | NAT やインターフェースエンドポイントの固定費がかかる |

## Consequences

- `provided.al2023` の廃止予定日は 2029-06-30 (2026-11-15 に確認)。それまでに次の OS-only ランタイムへ移る。
- Lambda のペイロード制限 (6 MB) を超える動画は、Lambda を通さずに送る ([ADR-0008](0008-entry-delivery.md))。

## References

- [Lambda ランタイムと廃止予定日](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
- [Lambda 料金](https://aws.amazon.com/lambda/pricing/)
