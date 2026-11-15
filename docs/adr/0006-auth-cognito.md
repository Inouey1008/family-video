# ADR-0006: 認証は Cognito にし、招待制とパスキーにする

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Goals は、招待した家族だけが動画を見られること。スマホに慣れていない家族もいるので、パスワードを覚えなくてもログインしたい。

## Decision

- Amazon Cognito の Essentials プランにする (月 10,000 MAU まで無料、期限なし)。
- 開発者が家族を招待する。自己サインアップは無効にする。
- パスキーを主にし、予備はパスワードと TOTP。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cognito の脅威保護 (Plus) | 追加料金がかかる。招待制とパスキーで代わりとする |

## Consequences

- 家族の追加・削除とアカウントの復旧は、開発者が AWS 側で行う。手順は手順書にまとめる。
- ログイン状態の保持は [ADR-0014](0014-session-cookie.md) を参照。

## References

- [Amazon Cognito 料金](https://aws.amazon.com/cognito/pricing/)
