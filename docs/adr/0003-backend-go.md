# ADR-0003: バックエンドは Go (provided.al2023・zip) にする

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Maintenance は、外部の部品を最小限にし、保守に時間をかけないため安定した技術を選ぶこと。

## Decision

- Lambda は Go で書き、OS-only ランタイム (`provided.al2023`) に zip でデプロイする。
- 外部依存は aws-lambda-go・aws-sdk-go-v2・pgx に限る。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Node.js / Python / Rust / Java / .NET | 個別の比較は記録していない。Go は言語ランタイムに依存せず、標準ライブラリが充実している |
| コンテナイメージ | ベースイメージのパッチを自分で当てる必要がある |

## Consequences

- `provided.al2023` の廃止予定日は 2029-06-30 (2026-11-15 に確認)。それまでに次の OS-only ランタイムへ移る。

## References

- [Lambda ランタイムと廃止予定日](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
