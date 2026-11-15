# ADR-0011: ログイン状態は HttpOnly Cookie で保持する

- Status: Accepted
- Date: 2026-11-15

## Context

トークンを盗まれると、家族の動画を見られてしまう。画面にスクリプトを差し込まれても、トークンを読み取られないようにしたい。

## Decision

- Cognito のトークンは HttpOnly Cookie に入れ、JS からは読めないようにする。
- JWT の検証と認可は Go 側で行う。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| トークンをブラウザの JS で保持する (SPA 型) | 画面に差し込まれたスクリプトから、トークンを読み取れてしまう |

## Consequences

- Cookie はブラウザが自動で送るので、CSRF の対策が要る。
- 有効期限・CSRF 対策などの細目は [設計書](../specs/security.md) を参照。
