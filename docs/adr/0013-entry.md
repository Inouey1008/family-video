# ADR-0013: 入り口は CloudFront の 1 つにする

- Status: Accepted
- Date: 2026-11-15

## Context

- 画面・静的ファイル・動画・API を、1 つの URL から使えるようにしたい
- 固定費はほぼ 0 円にする (PRD の Goals)

## Decision

- 入り口は CloudFront の 1 つにまとめ、パスごとに S3 と API へ振り分ける。同一オリジンなので CORS は要らない。
- API は API Gateway の HTTP API にする。
- 独自ドメインは使わない。URL は CloudFront の既定のものを使い、公開リポジトリには書かない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Lambda 関数 URL + OAC | POST にペイロードの署名が必要になる |
| 独自ドメイン | ドメインの登録料と DNS の費用がかかる。URL は家族に一度伝えれば済む |

## Consequences

- CloudFront の Always Free (毎月データ転送 1 TB、2026-11-15 に確認) に収まる範囲では、配信の固定費がかからない。
- CloudFront のディストリビューションを作り直すと、URL が変わる。
- API Gateway の既定のエンドポイントは公開されたままになる。直接のアクセスへの対策は [ADR-0015](0015-origin-lock.md) を参照。

## References

- [CloudFront 料金](https://aws.amazon.com/cloudfront/pricing/pay-as-you-go/)
