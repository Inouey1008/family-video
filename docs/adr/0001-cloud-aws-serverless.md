# ADR-0001: AWS 東京のサーバーレス構成にする

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Goals: 費用は、保存量に比例する分だけにする (固定費はほぼ 0 円)。
- PRD の Maintenance: 保守に時間をかけないため、安定した技術を選ぶ。
- 動画は大きいので、配信の転送量を無料枠に収めたい。

## Decision

- クラウドは AWS の東京リージョンにする。
- 実行環境は Lambda などのサーバーレスにし、常時稼働するサーバーは持たない。
- 配信は CloudFront の 1 つの入り口にまとめ、パスごとに振り分ける。同一オリジンになるので CORS は不要になる。
- VPC・NAT ゲートウェイ・PrivateLink は使わない。外から接続できるサーバーがなく、公開エンドポイントと IAM 認証で足りる。
- コンテナ (Lambda コンテナイメージ・Fargate) は使わない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare | Go は Wasm 経由になる |
| Firebase / Supabase / VPS | 個別の比較は記録していない。Go の正式サポートと CloudFront の無料枠で AWS を選んだ |
| Lambda in VPC + PrivateLink | NAT などの固定費がかかる |
| コンテナ | ベースイメージのパッチを自分で当てる必要がある |

## Consequences

- CloudFront の Always Free (毎月データ転送 1 TB・リクエスト 1,000 万、2026-11-15 に確認) に収まる範囲では、配信の固定費がかからない。
- 構成の詳細は [設計書](../architecture.md) にまとめる。
- DSQL の仕様変更への備えは [ADR-0005](0005-database-dsql.md) に書く。

## References

- [CloudFront 料金](https://aws.amazon.com/cloudfront/pricing/pay-as-you-go/)
