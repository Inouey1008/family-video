[← 目次へ戻る](../README.md)

# Maintainability

| # | 要件 |
|---|---|
| NFR-30 | Lambda は Go の OS-only ランタイム (provided.al2023) で動かす。廃止予定日は 2029-06-30 |
| NFR-31 | Go の外部依存は最小限にする (aws-lambda-go、aws-sdk-go-v2、pgx) |
| NFR-32 | フロントエンドはビルド工程なしにする。htmx (2.0.11 に固定) と素の JS だけを使う |
| NFR-33 | Dependabot (gomod・terraform・github-actions を月1回) と govulncheck (週1回) で依存を管理する |
| NFR-34 | Go のバージョンは年1回上げる。脆弱性の修正版が出たら、その都度上げる |
| NFR-35 | Terraform 本体と AWS プロバイダーのバージョンは固定し、`.terraform.lock.hcl` をコミットする |

## References

- [Lambda ランタイムと廃止予定日](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
- [Lambda のランタイム更新の仕組み](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-update.html)
- [Go 1 の互換性の約束](https://go.dev/doc/go1compat)
- [Go のリリース履歴](https://go.dev/doc/devel/release)
- [govulncheck](https://go.dev/security/vuln)
- [htmx 4.0.0 リリースのお知らせ](https://four.htmx.org/announcements/2026-08-28-htmx-4.0.0-is-released)
- [Terraform AWS プロバイダー 6.0](https://www.hashicorp.com/blog/terraform-aws-provider-6-0-now-generally-available)
