# ADR-0004: 画面は html/template + htmx にし、ビルド工程を持たない

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Maintenance: 外部の部品を最小限にし、安定した技術を選ぶ。
- PRD に入れなかった細目 (Issue #5): ログインの資格情報は画面のスクリプトから読み取れないようにする。外部サイトのスクリプトは読み込まない。
- 操作の滑らかさより、セキュリティと保守性を優先する (家族向けのアプリのため)。

## Decision

- 画面は Go の `html/template` でサーバー側で作り、htmx 2 で部分更新する。
- フロントエンドにビルド工程は置かない。使うのは htmx と素の JS だけにする。
- htmx は 2.0.11 に固定し、自分のオリジンから配信する。`allowEval = false` にする。
- 状態は URL とサーバーに持たせる。素の JS を使うのはアップロードだけにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| 素の HTML + JS (SPA) / React + Vite / Astro | トークンを JS から隠せることと、自動エスケープによる XSS への強さで htmx 方式を選んだ。ビルド工程と依存も増える |
| Alpine.js (状態管理) | CSP の制約がある。依存も増える |

## Consequences

- 2 系の最新は 2.0.11 (2026-09-22)。4.0.0 (2026-08-28) と 4.0.1 (2026-11-01) が出ているが、固定した 2 系のまま使う。4 系への移行は今回は決めない。
- 画面をサーバーが作るので、オフラインでの閲覧はできない ([ADR-0002](0002-client-pwa.md))。
- CSP は外部スクリプトなしで厳しくできる。値は [設計書](../architecture.md) にまとめる。

## References

- [htmx 4.0.0 リリースのお知らせ](https://four.htmx.org/announcements/2026-08-28-htmx-4.0.0-is-released)
