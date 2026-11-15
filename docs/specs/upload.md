# Upload

[設計書](../architecture.md) の詳細。アップロードと再開。

判断の理由: [ADR-0019](../adr/0019-video-transfer.md)

## Upload

```mermaid
sequenceDiagram
  participant B as ブラウザ
  participant A as API (Lambda)
  participant S as S3

  B->>B: サムネイルと再生時間を生成 (canvas)
  B->>A: POST /api/uploads
  A-->>B: 各パートの署名付き URL (status=uploading の行を作る)
  B->>S: PUT (パートを並列で)
  B->>A: POST /api/uploads/{id}/complete
  A->>S: 保存されたサイズを確認
  A-->>B: 完了 (status=ready)
  B->>A: 一覧を読み直す (htmx)
```

- 動画は 10 MB ほどの「パート」に分けて送り、S3 が最後に 1 つのファイルに組み立てる (S3 のマルチパートアップロード)
- 動画は圧縮・変換せず、元の形式のまま保存する。1 本あたり 10 GB までで、利用者ごとの本数と容量に上限は設けない
- サムネイルは canvas で作り直すので、位置情報を含まない
- 署名付き URL は、サーバーが決めたキーにだけ、短い有効期限で発行する
- Content-Type は、サーバーがアップロードの開始時に決める (`video/mp4`・`video/quicktime`・`image/jpeg`)。ほかの種類は受け付けず、ブラウザからは変えられない
- 同時に送る動画は 2 本まで。状態は 待機中・送信中・完了・失敗 で、失敗した動画だけ再送できる
- 完了時に確認するのは、申告されたサイズと実際のサイズの一致だけ。不一致は WARN で記録して失敗にする
- 中断したら、S3 に残した送信済みパートと IndexedDB の進捗から再開する。未送信パートの URL は取り直す
- iOS でファイルを選び直すと前の選択が消えるので、選択後に JS のリストへコピーしておく
- 完了しなかったマルチパートは、ライフサイクルルールで 7 日後に削除する

## Failures

正常系の図のうち、失敗した手順から描く。

### 中断と再開

```mermaid
sequenceDiagram
  participant B as ブラウザ
  participant A as API (Lambda)
  participant S as S3

  Note over B: アプリを離れて送信が止まる
  B->>B: IndexedDB から進捗 (動画 ID) を読む
  B->>A: 未送信のパートの URL を要求
  A->>S: 送信済みのパートを確認 (ListParts)
  A-->>B: 未送信のパートだけの署名付き URL
  B->>S: PUT (残りのパート)
  B->>A: POST /api/uploads/{id}/complete
```

### サイズの不一致

```mermaid
sequenceDiagram
  participant B as ブラウザ
  participant A as API (Lambda)
  participant S as S3

  B->>A: POST /api/uploads/{id}/complete
  A->>S: 保存されたサイズを確認
  S-->>A: 申告と違うサイズ
  A->>A: WARN を記録し、status=failed にする
  A-->>B: 失敗
  B->>B: 失敗と表示し、再送できるようにする
```

### 混み合ったとき (429)

```mermaid
sequenceDiagram
  participant B as ブラウザ
  participant A as API (Lambda)

  B->>A: POST /api/uploads
  A-->>B: 429 (Retry-After)
  B->>B: Retry-After の秒数だけ待つ
  B->>A: POST /api/uploads (再試行)
```
