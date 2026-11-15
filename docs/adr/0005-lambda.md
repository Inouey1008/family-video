# ADR-0005: 処理は Lambda の OS-only ランタイムで動かし、VPC には入れない

- Status: Accepted
- Date: 2026-11-15

## Context

- サーバーレスで作る ([ADR-0001](0001-serverless.md))
- バックエンドは Go の 1 つのバイナリで動かす ([ADR-0004](0004-backend-go.md))
- NAT ゲートウェイなど、VPC にかかる固定費は持ちたくない
- サーバーレスの実行環境の中では、Lambda がいちばん使い慣れている

## Decision

- 処理は AWS Lambda にし、OS-only ランタイム (`provided.al2023`) に zip でデプロイする。Go のバイナリをそのまま OS の上で動かし、OS の保守は AWS が行う。
- VPC・NAT ゲートウェイは使わない。ほかの AWS のサービスには、VPC を通さずに IAM の認証で接続する。
- リージョンは東京にする。家族に物理的に近く、通信の遅れが小さい。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare Workers | Go が Wasm 経由になり、バイナリをそのまま動かせない |
| Google Cloud Run | アクセスがなければ 0 台まで減り、無料枠もある。ただしコンテナイメージで動かすので、イメージの置き場所 (Artifact Registry) とベースイメージの管理が要る |
| Fly.io | コンテナイメージで動かすので、ベースイメージの管理が要る。新しい組織には無料枠がない (月 5 ドル未満の請求は免除) |
| Railway | Hobby プランは、使わなくても月 5 ドルの固定費がかかる。無料プランは月 1 ドル分の利用枠しかない |
| Lambda のコンテナイメージ | ベースイメージのパッチを自分で当てる必要がある |
| Lambda in VPC + PrivateLink | NAT やインターフェースエンドポイントの固定費がかかる |

## Consequences

- `provided.al2023` の廃止予定日は 2029-06-30 (2026-11-15 に確認)。それまでに次の OS-only ランタイムへ移る。
- Lambda のペイロード制限 (6 MB) を超える動画は、Lambda を通さずに送る ([ADR-0007](0007-entry-delivery.md))。

## References

- [Lambda ランタイムと廃止予定日](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
- [Lambda 料金](https://aws.amazon.com/lambda/pricing/)
- [Cloud Run 料金](https://cloud.google.com/run/pricing)
- [Fly.io 料金](https://docs.fly.io/about/pricing)
- [Railway の料金プラン](https://docs.railway.com/pricing/plans)
