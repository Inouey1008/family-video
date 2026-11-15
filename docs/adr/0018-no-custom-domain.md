# ADR-0018: 独自ドメインは使わず、CloudFront の既定の URL を使う

- Status: Accepted
- Date: 2026-11-15

## Context

- 入り口は CloudFront の 1 つにする ([ADR-0016](0016-entry.md))
- 固定費はほぼ 0 円にする (PRD の Goals)
- 公開リポジトリには、ドメインなどの環境固有の値を書かない

## Decision

- 独自ドメインは使わない。URL は CloudFront の既定のものを使う。
- URL はリポジトリに書かず、GitHub Environment の値や手元で扱う。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| 独自ドメイン | ドメインの登録料と DNS の費用がかかる。更新を忘れると止まる。URL は家族に一度伝えれば済む |

## Consequences

- CloudFront のディストリビューションを作り直すと、URL が変わる。
- API Gateway の既定のエンドポイントを無効にできない。直接のアクセスへの対策は [ADR-0020](0020-origin-lock.md) を参照。
