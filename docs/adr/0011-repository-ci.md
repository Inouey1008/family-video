# ADR-0011: GitHub の public モノレポと Actions + OIDC

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Goals: 個人開発の成果物として公開できる。保守の手間を小さく保つ。
- PRD に入れなかった細目 (Issue #5): 長期間有効な認証情報は発行しない。
- 公開するので、秘密情報や環境固有の値をリポジトリに含められない。

## Decision

- GitHub の public リポジトリで公開し、インフラ (Terraform)・アプリ (Go)・静的ファイルを 1 つのモノレポに置く。インフラとコードの変更を 1 つの PR で済ませるため。
- CI/CD は GitHub Actions にし、AWS への認証は OIDC で行う。長期のアクセスキーは発行しない。
- アカウント ID やドメインなどの環境固有の値は、GitHub の Environment 変数から渡す。`*.tfstate` と `*.tfvars` はコミットしない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| インフラを別リポジトリに分ける | インフラとコードの変更を 1 つの PR で済ませられなくなる |

## Consequences

- CI の構成とデプロイの流れは [設計書](../architecture.md) にまとめる。

