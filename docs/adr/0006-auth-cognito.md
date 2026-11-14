# ADR-0006: 認証は Cognito (招待制・パスキー) と HttpOnly Cookie にする

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Goals: 招待した家族だけが動画を見られる。
- PRD の Users・User Stories: スマホに慣れていない家族がいる。パスワードを覚えなくてもログインしたい。
- PRD に入れなかった細目 (Issue #5): ログインの資格情報は画面のスクリプトから読み取れないようにする。権限の判定はサービス側で行う。

## Decision

- 認証は Amazon Cognito の Essentials プランにする。月 10,000 MAU まで無料で、期限はない (2026-11-15 に確認)。
- 開発者が家族を招待してアカウントを作る。自己サインアップは無効にする。
- ログインはパスキーを主にし、予備としてパスワードと TOTP の多要素認証を使えるようにする。パスキーは Essentials で使える。
- ログイン状態は HttpOnly Cookie で保持する。JWT の検証と認可の判定は Go (Lambda) 側で行う。
- ログインの総当たりは、Cognito 標準のロック機能で防ぐ。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| PKCE + JS でのトークン保持 | トークンを JS から読み取れてしまう |
| Cognito の脅威保護 (Plus プラン) | 追加料金がかかる。招待制とパスキーで代わりとする |

## Consequences

- 家族の追加・削除とアカウントの復旧は、開発者が AWS 側で行う。手順は手順書にまとめる。
- パスキーを登録した端末をなくした家族には、パスキーの再登録で対応する。開発者自身が締め出されたときの復旧手段も用意する。
- Cookie の属性・CSRF 対策・コールバックの検証など、方式の細目は [設計書](../architecture.md) にまとめる。
- 認証の失敗の急増は、アラームで検知する ([ADR-0009](0009-observability.md))。

## References

- [Amazon Cognito 料金](https://aws.amazon.com/cognito/pricing/)
- [Cognito のサインイン失敗時のロック](https://docs.aws.amazon.com/cognito/latest/developerguide/authentication-flow-things-to-know.html)
