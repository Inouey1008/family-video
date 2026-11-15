# Upload

[設計書](../architecture.md) の詳細。アップロードと再開。

判断の理由: [ADR-0013](../adr/0013-video-transfer.md)

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

- 動画は圧縮・変換せず、元の形式のまま保存する。1 本あたり 10 GB までで、利用者ごとの本数と容量に上限は設けない
- サムネイルは canvas で作り直すので、位置情報を含まない
- 署名付き URL は、サーバーが決めたキーにだけ、短い有効期限で発行する
- Content-Type は、サーバーがアップロードの開始時に決める (`video/mp4`・`video/quicktime`・`image/jpeg`)。ほかの種類は受け付けず、ブラウザからは変えられない
- 同時に送る動画は 2 本まで。状態は 待機中・送信中・完了・失敗 で、失敗した動画だけ再送できる
- 完了時に確認するのは、申告されたサイズと実際のサイズの一致だけ。不一致は WARN で記録して失敗にする
- 中断したら、S3 に残した送信済みパートと IndexedDB の進捗から再開する。未送信パートの URL は取り直す
- iOS でファイルを選び直すと前の選択が消えるので、選択後に JS のリストへコピーしておく
- 完了しなかったマルチパートは、ライフサイクルルールで 7 日後に削除する
