# ADR-0002: クライアントは PWA にし、iPhone の Safari だけを対象にする

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Users: 家族は全員 iPhone を使う。スマホに慣れていない人もいる。
- PRD の User Stories: ホーム画面から、アプリのように起動したい。
- PRD の Goals: 保守の手間を小さく保つ。
- 利用者を家族に限る役割は、配布方法ではなく認証が担う ([ADR-0006](0006-auth-cognito.md))。

## Decision

- PWA としてホーム画面に追加して使い、ネイティブアプリは作らない。
- 対象は iPhone の Safari と、ホーム画面から起動した PWA だけにする。Windows・Android は対象にしない。
- Service Worker がキャッシュするのは画面の部品だけにし、動画はキャッシュしない。オフラインでの閲覧は初期リリースの範囲外にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| ネイティブアプリ (TestFlight) | 90 日ごとに再配布が必要になる |
| ネイティブアプリ (Ad Hoc) | 毎年の再署名が必要になる |
| ネイティブアプリ (非公開配布) | App Review が必要で、リンクを知っていれば誰でも入手できる |
| ネイティブアプリ全般 | 毎年 Xcode と SDK の更新が必要になる |

## Consequences

- iPhone で撮った HEVC の動画は、Apple の端末ならそのまま再生できる。Windows・Android では再生できない場合があり、必要になったらカメラ設定を H.264 にするか、サーバー側の変換を足す。
- iOS ではアプリを離れるとアップロードが止まる。送信済みのパートを残し、IndexedDB の進捗情報から再開する。それでも困るようになったら、アップロード専用の小さなネイティブアプリ (TestFlight で配布) を検討する。
- iOS でファイルを選び直すと前の選択が消えるので、選択後に JS のリストへファイルをコピーする。
- 動作確認は iPhone の Safari とホーム画面の PWA で行う。
- 方式の細目は [設計書](../architecture.md) にまとめる。
