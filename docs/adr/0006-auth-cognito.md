# ADR-0006: 認証は Cognito (招待制・パスキー) と HttpOnly Cookie にする

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Goals は、招待した家族だけが動画を見られること。スマホに慣れていない家族もいるので、パスワードを覚えなくてもログインしたい。

## Decision

- Amazon Cognito の Essentials プランにする (月 10,000 MAU まで無料、期限なし)。
- 開発者が家族を招待する。自己サインアップは無効にする。
- パスキーを主にし、予備はパスワードと TOTP。ログイン状態は HttpOnly Cookie で保持し、JWT の検証と認可は Go 側で行う。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| PKCE + JS でのトークン保持 | トークンを JS から読み取れてしまう |
| Cognito の脅威保護 (Plus) | 追加料金がかかる。招待制とパスキーで代わりとする |

## Consequences

- 家族の追加・削除とアカウントの復旧は、開発者が AWS 側で行う。手順は手順書にまとめる。
- Cookie・CSRF 対策などの細目は [設計書](../specs/security.md) を参照。

## References

- [Amazon Cognito 料金](https://aws.amazon.com/cognito/pricing/)
