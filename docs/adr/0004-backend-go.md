# ADR-0004: バックエンドは Go にし、1 つのバイナリで動かす

- Status: Accepted
- Date: 2026-11-15

## Context

- 保守に時間をかけない (PRD の Maintenance)。言語ランタイムやコンテナのベースイメージを、定期的に更新する手間を避けたい
- 外部依存を最小限にする (PRD の Maintenance)
- 画面の HTML はサーバーが組み立てる ([ADR-0003](0003-mpa.md))

## Decision

- バックエンドは Go で書き、依存を含めて 1 つのバイナリにビルドする。
- HTTP・HTML のテンプレート・暗号は標準ライブラリを使う。外部依存は aws-lambda-go・aws-sdk-go-v2・pgx に限る。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| TypeScript (Node.js) / Python / Ruby / Java | 言語ランタイムの上で動く。ランタイムは数年ごとにサポートが切れ、そのたびに移行が要る。TypeScript は npm のパッケージの間接的な依存が多く、更新と脆弱性の確認が重い |
| Rust | 1 つのバイナリにできるが、HTTP・テンプレート・非同期処理に外部の crate が要る。Go は標準ライブラリで足りる |
| C++ | 1 つのバイナリにできるが、HTTP・テンプレートに外部のライブラリが要る。メモリ安全ではなく、脆弱性を作り込みやすい |
| Swift | 1 つのバイナリにできるが、サーバー向けのエコシステムが小さく、HTTP・テンプレートに外部のパッケージ (Vapor など) が要る |
| Dart | 1 つのバイナリにできるが、サーバー向けの AWS の公式 SDK と Lambda のランタイムがなく、コミュニティのパッケージに頼ることになる |

## Consequences

- バイナリを動かす場所は [ADR-0005](0005-lambda.md) を参照。

## References

- [Lambda ランタイムと廃止予定日](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
