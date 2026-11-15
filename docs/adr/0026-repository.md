# ADR-0026: リポジトリは GitHub の public なモノレポにする

- Status: Accepted
- Date: 2026-11-15

## Context

- 個人開発の成果物として公開できる (PRD の Goals)
- 公開するので、秘密情報や環境固有の値は含められない

## Decision

- GitHub の public リポジトリで公開する。
- インフラ・アプリ・静的ファイルを 1 つのモノレポに置く。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| インフラを別リポジトリに分ける | インフラとコードの変更を 1 つの PR で済ませられなくなる |
| private リポジトリ | 成果物として公開できない |

## Consequences

- 秘密情報と環境固有の値は、リポジトリの外 (GitHub Environment・SSM) に置く ([ADR-0027](0027-ci-cd.md))。
