# ADR-0002: クライアントは PWA にし、iPhone の Safari だけを対象にする

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Users は全員 iPhone で、User Stories はホーム画面からアプリのように起動したいこと。保守の手間も小さく保ちたい。

## Decision

- PWA としてホーム画面に追加して使い、ネイティブアプリは作らない。
- 対象は iPhone の Safari と、ホーム画面から起動した PWA だけにする。
- 動画はキャッシュしない。オフラインでの閲覧は初期リリースの範囲外にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| ネイティブアプリ | TestFlight は 90 日ごとの再配布、Ad Hoc は毎年の再署名、非公開配布は App Review が必要でリンクを知れば誰でも入手できる。どれも毎年の Xcode と SDK の更新が要る |

## Consequences

- iOS ではアプリを離れるとアップロードが止まる。送信済みのパートを残して再開できるようにする。それでも困るなら、アップロード専用の小さなネイティブアプリ (TestFlight) を検討する。
- Windows・Android は対象外。HEVC が再生できないため、必要になったらカメラ設定を H.264 にするか、サーバー側の変換を足す。
