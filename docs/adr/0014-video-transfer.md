# ADR-0014: 動画の配信とアップロードは、署名付き URL で行う

- Status: Accepted
- Date: 2026-11-15

## Context

- 動画はログインした家族しか取得できない (PRD の Security)
- 動画は S3 に置き ([ADR-0012](0012-video-storage.md))、入り口は CloudFront にする ([ADR-0013](0013-entry.md))
- 動画は API Gateway (10 MB) と Lambda (6 MB) のペイロード制限を超える

## Decision

- 動画の配信は、CloudFront の署名付き URL でだけ行う。S3 は CloudFront の OAC からだけ読み取れる。
- アップロードは、S3 の署名付き URL で S3 に直接送る (マルチパート)。動画は Lambda を通さない。
- 署名付き URL は、ログインを確かめたうえで Lambda が短い有効期限で発行する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| API 経由のアップロード・配信 | ペイロード制限を超える。転送している間ずっと Lambda の料金がかかる |
| S3 の公開 URL での配信 | URL を知れば誰でも動画を取得できる |

## Consequences

- URL は短い時間だけ有効で、持っていれば誰でも使える。期限と対象のキーを絞る。
- 配信の細目は [設計書](../specs/playback.md)、アップロードの細目は [設計書](../specs/upload.md) を参照。
