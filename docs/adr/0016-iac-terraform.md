# ADR-0016: インフラは Terraform で構築する

- Status: Accepted
- Date: 2026-11-15

## Context

インフラをコードで管理し、同じコードから dev と prod を作りたい。

## Decision

- IaC は Terraform にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| AWS SAM | 使い慣れている Terraform を使う |

## Consequences

- 環境の分け方は [ADR-0017](0017-environments.md) を参照。
