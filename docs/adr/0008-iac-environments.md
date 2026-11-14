# ADR-0008: Terraform で構築し、dev / prod は同じ AWS アカウントで分ける

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Operations: 更新に失敗したら前の状態に戻せる。
- PRD の Cost: 固定費はほぼ 0 円にする。
- PRD の Goals: 個人開発の成果物として公開できる。
- PRD に入れなかった細目 (Issue #5): 環境は開発用と本番用の 2 つだけにする。環境固有の値は公開リポジトリに書けない。
- 決める必要があったのは、IaC のツール、dev と prod の分け方 (#20)、独自ドメインの要否 (#19)。

## Decision

- IaC は Terraform にする。状態ファイルは S3 バックエンド (ネイティブロック) に置く。
- Terraform 本体と AWS プロバイダーのバージョンを固定し、`.terraform.lock.hcl` をコミットする。
- 環境は dev と prod の 2 つだけにし (staging は作らない)、同じコードから作る。違いは変数だけにする。
- dev と prod は同じ AWS アカウントに置き、リソース名・IAM ロール・GitHub Environment で分ける (#20)。状態ファイルは環境ごとに別のキーにする。
- 独自ドメインは使わない (#19)。URL は CloudFront の既定のものを使い、公開リポジトリには書かない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| AWS SAM | 使い慣れている Terraform を使う |
| dev と prod を別の AWS アカウントにする | 利点は、dev の誤操作が prod に届かないこと。ただし、アカウントの管理 (ルートユーザーの MFA・請求・IAM の設定) が 2 倍になり、家族向けの個人開発では手間に見合わない (#20) |
| 独自ドメインを使う | ドメインの登録料と DNS (Route 53) の費用がかかり、固定費をほぼ 0 円にする方針に合わない。家族はホーム画面から起動するので、URL を覚える必要もない (#19) |

## Consequences

- 同じアカウントなので、強い権限での誤操作は dev と prod の両方に及びうる。prod の IAM ロールはタグからの実行だけに限り、dev の操作が prod に影響しないようにする。
- 独自ドメインがないので、API Gateway の既定のエンドポイントを無効にできない。直接アクセスへの対策は [ADR-0010](0010-abuse-protection.md) のオリジン検証ヘッダーで行う。
- Terraform プロバイダーのメジャー更新は、`plan` の差分を確認してからマージする。
- 独自ドメインが必要になったら、新しい ADR で見直す。
- 環境の運用とデプロイの細目は [設計書](../architecture.md) にまとめる。

## References

- [Terraform S3 バックエンド](https://developer.hashicorp.com/terraform/language/backend/s3)
- [Terraform AWS プロバイダー 6.0](https://www.hashicorp.com/blog/terraform-aws-provider-6-0-now-generally-available)
