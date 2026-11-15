# ADR-0025: dev と prod は同じ AWS アカウントで分ける

- Status: Accepted
- Date: 2026-11-15

## Context

dev と prod の分け方を決める必要があった。個人開発なので、管理の手間を小さくしたい。

## Decision

- dev と prod は同じ AWS アカウントに置き、リソース名・IAM ロール・GitHub Environment で分ける。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| 別の AWS アカウント | 利点は、dev の誤操作が prod に届かないこと。ただし、アカウントの管理 (ルートユーザーの MFA・請求・IAM の設定) が 2 倍になり、家族向けの個人開発では手間に見合わない |

## Consequences

- 同じアカウントなので、強い権限での誤操作は両方の環境に及びうる。
- 環境の細目は [設計書](../architecture.md) を参照。
