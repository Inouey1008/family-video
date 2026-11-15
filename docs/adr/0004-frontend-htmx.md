# ADR-0004: 画面は html/template + htmx にし、フロントエンドのビルドを持たない

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Maintenance は、外部の部品を最小限にすること。操作の滑らかさより、セキュリティと保守性を優先する。

## Decision

- 画面は Go の `html/template` でサーバー側で作り、htmx 2 で部分更新する。
- フロントエンドのビルド (npm・バンドラー) は使わず、htmx (2.0.11 に固定) と素の JS だけを使う。素の JS は、端末の中でしかできない処理 (アップロード・選んだ動画の保存) に限る。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| SPA (素の HTML + JS / React + Vite / Astro) | トークンを JS から隠せることと、自動エスケープによる XSS への強さで htmx 方式を選んだ |
| Alpine.js | CSP の制約がある |

## Consequences

- htmx は 4 系 (4.0.0 は 2026-08-28) が出ているが、2 系に固定する。移行は今回は決めない。
- 画面をサーバーが作るので、オフラインでの閲覧はできない ([ADR-0002](0002-client-web.md))。
- CSP などの細目は [設計書](../specs/security.md) を参照。

## References

- [htmx 4.0.0 リリースのお知らせ](https://four.htmx.org/announcements/2026-08-28-htmx-4.0.0-is-released)
