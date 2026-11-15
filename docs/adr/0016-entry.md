# ADR-0016: 入り口は CloudFront の 1 つにする

- Status: Accepted
- Date: 2026-11-15

## Context

- 画面・静的ファイル・動画・API を、1 つの URL から使えるようにしたい
- 固定費はほぼ 0 円にする (PRD の Goals)

## Decision

- 入り口は CloudFront の 1 つにまとめ、パスごとに S3 と API へ振り分ける。同一オリジンなので CORS は要らない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| S3 と API を別の URL で公開する | CORS の設定が要り、Cookie の扱いも複雑になる |

## Consequences

- CloudFront の Always Free (毎月データ転送 1 TB、2026-11-15 に確認) に収まる範囲では、配信の固定費がかからない。
- API の種類は [ADR-0017](0017-api-http.md)、URL は [ADR-0018](0018-no-custom-domain.md) を参照。

## References

- [CloudFront 料金](https://aws.amazon.com/cloudfront/pricing/pay-as-you-go/)
