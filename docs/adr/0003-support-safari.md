# ADR-0003: サポートは iPhone の Safari だけにする

- Status: Accepted
- Date: 2026-11-15

## Context

- 家族は全員 iPhone を使う (PRD の Users)
- クライアントは Web アプリ (PWA) にする ([ADR-0002](0002-client-web.md))
- 確かめる環境を増やすと、保守に時間がかかる (PRD の Maintenance)

## Decision

- 動作を保証するのは、iPhone の Safari (ホーム画面からの起動を含む) だけにする。
- ほかのブラウザで開くことは止めないが、確かめず、不具合も直さない。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| 主要なブラウザすべて (Chrome・Android・PC) | 使う人がいない環境の確認に時間がかかる |

## Consequences

- Windows・Android は対象外。iPhone で撮った HEVC の動画を再生できないブラウザが多い。必要になったら、カメラの設定を H.264 にするか、サーバー側の変換を足す。
- 実機での確認項目は [設計書](../specs/operations.md) を参照。
