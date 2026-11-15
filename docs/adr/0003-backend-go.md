# ADR-0003: バックエンドは Go (provided.al2023・zip) にする

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Maintenance: 利用する外部の部品は最小限にし、更新と脆弱性を定期的に確認する。保守に時間をかけないため、安定した技術を選ぶ。
- 言語ランタイムの廃止や更新に追われると、保守の手間が増える。

## Decision

- Lambda は Go で書き、OS-only ランタイム (`provided.al2023`) に zip でデプロイする。
- Go の外部依存は aws-lambda-go・aws-sdk-go-v2・pgx に限る。
- 依存は Dependabot (gomod、月 1 回) と govulncheck (週 1 回) で確認する。
- Go のバージョンは年 1 回上げ、脆弱性の修正版が出たらその都度上げる。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Node.js / Python / Rust / Java / .NET | 個別の比較は記録していない。Go は言語ランタイムに依存せず、標準ライブラリが充実している点で選んだ |
| コンテナイメージ | ベースイメージのパッチを自分で当てる必要がある ([ADR-0001](0001-cloud-aws-serverless.md)) |

## Consequences

- `provided.al2023` の廃止予定日は 2029-06-30 (2026-11-15 に確認)。それまでに次の OS-only ランタイムへ移る。
- Go 1 の互換性の約束により、年 1 回の更新を前提にする。
- 外部依存を絞るので、標準ライブラリで書ける処理は自分で書く。
- 依存管理の細目は [設計書](../specs/operations.md) にまとめる。

## References

- [Lambda ランタイムと廃止予定日](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
- [Lambda のランタイム更新の仕組み](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-update.html)
- [Go 1 の互換性の約束](https://go.dev/doc/go1compat)
- [Go のリリース履歴](https://go.dev/doc/devel/release)
- [govulncheck](https://go.dev/security/vuln)
