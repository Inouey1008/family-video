# ADR-0008: 入り口は CloudFront の 1 つにし、動画は署名付き URL でやり取りする

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Security は、動画をログインした家族しか取得できないこと。動画は API Gateway (10 MB) と Lambda (6 MB) のペイロード制限を超える。動画は大きいので、配信の転送量を無料枠に収めたい。

## Decision

- 入り口は CloudFront の 1 つにまとめ、パスごとに S3 と API へ振り分ける (同一オリジンなので CORS は不要)。
- 独自ドメインは使わない。URL は CloudFront の既定のものを使い、公開リポジトリには書かない。
- 動画の配信は CloudFront の署名付き URL でだけ行う。S3 は CloudFront の OAC からだけ読み取れる。
- アップロードは署名付き URL で S3 に直接送る (マルチパート)。
- API は API Gateway の HTTP API にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| API 経由のアップロード | ペイロード制限を超える |
| Lambda 関数 URL + OAC | POST にペイロードの署名が必要になる |
| 独自ドメイン | ドメインの登録料と DNS の費用がかかる。家族はホーム画面から起動するので、URL を覚える必要もない |

## Consequences

- CloudFront の Always Free (毎月データ転送 1 TB、2026-11-15 に確認) に収まる範囲では、配信の固定費がかからない。
- CloudFront のディストリビューションを作り直すと、URL が変わる。
- API Gateway の既定のエンドポイントは公開されたままになる。直接のアクセスへの対策は [ADR-0009](0009-origin-lock.md) を参照。
- 配信の細目は [設計書](../specs/playback.md)、アップロードの細目は [設計書](../specs/upload.md) を参照。

## References

- [CloudFront 料金](https://aws.amazon.com/cloudfront/pricing/pay-as-you-go/)
