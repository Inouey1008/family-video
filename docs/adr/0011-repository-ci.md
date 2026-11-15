# ADR-0011: GitHub の public モノレポと Actions + OIDC

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Goals は、個人開発の成果物として公開できること。公開するので、秘密情報や環境固有の値は含められず、長期間有効な認証情報も発行しない。

## Decision

- GitHub の public リポジトリで公開し、インフラ・アプリ・静的ファイルを 1 つのモノレポに置く。
- CI/CD は GitHub Actions にし、AWS への認証は OIDC で行う (長期のアクセスキーなし)。
- 環境固有の値は、GitHub の Environment の変数とシークレットから渡す。アカウント ID を含む値はシークレットにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| インフラを別リポジトリに分ける | インフラとコードの変更を 1 つの PR で済ませられなくなる |

## Consequences

- CI の構成とデプロイの流れは [設計書](../architecture.md) を参照。
