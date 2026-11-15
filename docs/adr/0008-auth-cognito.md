# ADR-0008: 認証は Cognito にし、招待制とパスキーにする

- Status: Accepted
- Date: 2026-11-15

## Context

- 招待した家族だけが動画を見られる (PRD の Goals)
- ログインの方法は、安全であれば何でもよい
- Lambda と同じ AWS の中にそろえると、IAM の認証でつなげられ、構成が単純になる ([ADR-0005](0005-lambda.md) / [ADR-0006](0006-no-vpc.md))

## Decision

- Amazon Cognito の Essentials プランにする (月 10,000 MAU まで無料、期限なし)。
- 開発者が家族を招待する。自己サインアップは無効にする。
- パスキーを主にし、予備はパスワードと TOTP。パスキーはフィッシングに強く、パスワードの漏えいや使い回しの心配がない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Firebase Authentication | AWS の外にあり、管理するアカウントが増える |
| Auth0 | AWS の外にあり、管理するアカウントと秘密情報が増える |
| 自前で実装する (WebAuthn など) | 総当たりへの対策・アカウントの復旧・トークンの管理まで自分で作り、安全性を自分で担保する必要がある |
| Cognito の脅威保護 (Plus) | 追加料金がかかる。招待制とパスキーで代わりとする |

## Consequences

- 家族の追加・削除とアカウントの復旧は、開発者が AWS 側で行う。手順は手順書にまとめる。
- ログイン状態の保持は [ADR-0009](0009-session-cookie.md) を参照。

## References

- [Amazon Cognito 料金](https://aws.amazon.com/cognito/pricing/)
