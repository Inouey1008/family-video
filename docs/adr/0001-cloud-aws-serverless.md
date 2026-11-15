# ADR-0001: AWS 東京のサーバーレス構成にする

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Goals は、費用を保存量に比例する分だけにすること (固定費はほぼ 0 円)。動画は大きいので、配信の転送量を無料枠に収めたい。

## Decision

- AWS の東京リージョンで、Lambda などのサーバーレスで動かす。
- 配信は CloudFront の 1 つの入り口にまとめ、パスごとに振り分ける (同一オリジンなので CORS は不要)。
- VPC・NAT ゲートウェイ・コンテナは使わない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare / Firebase / Supabase / VPS | Cloudflare は Go が Wasm 経由になる。ほかは個別の比較を記録していない |
| Lambda in VPC + PrivateLink | NAT などの固定費がかかる |
| コンテナ (Lambda イメージ・Fargate) | ベースイメージのパッチを自分で当てる必要がある |

## Consequences

- CloudFront の Always Free (毎月データ転送 1 TB、2026-11-15 に確認) に収まる範囲では、配信の固定費がかからない。
- 構成の詳細は [設計書](../architecture.md) を参照。

## References

- [CloudFront 料金](https://aws.amazon.com/cloudfront/pricing/pay-as-you-go/)
