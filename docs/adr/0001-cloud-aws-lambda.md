# ADR-0001: AWS 東京で、処理は Lambda にする

- Status: Accepted
- Date: 2026-11-15

## Context

- 費用は保存量に比例する分だけにし、固定費はほぼ 0 円にする (PRD の Goals)
- 保守に時間をかけない (PRD の Maintenance)
- 使うのは家族数人で、アクセスはまばら

## Decision

- AWS の東京リージョンを使う。
- 処理は Lambda にする。リクエストがあるときだけ動き、使った分だけ課金される。OS の保守は AWS が行う。
- VPC・NAT ゲートウェイは使わない。DB・S3・Cognito には IAM の認証で接続する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare / Firebase / Supabase / VPS | Cloudflare は Go が Wasm 経由になる。ほかは個別の比較を記録していない |
| EC2 / Fargate | 動いている間ずっと課金され、アクセスがなくても固定費になる。OS やベースイメージのパッチを自分で当てる必要がある |
| Lambda in VPC + PrivateLink | NAT などの固定費がかかる |

## Consequences

- アクセスがなければ、処理の費用はかからない。
- Lambda のペイロード制限 (6 MB) を超える動画は、Lambda を通さずに送る ([ADR-0013](0013-entry-delivery.md))。

## References

- [Lambda 料金](https://aws.amazon.com/lambda/pricing/)
