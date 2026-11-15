# ADR-0007: 動画は S3 Intelligent-Tiering に置き、CloudFront の署名付き URL で配信する

- Status: Accepted
- Date: 2026-11-15

## Context

PRD の Cost は、古くなった動画の保存費用が自動で下がること。Security は、動画をログインした家族しか取得できないこと。動画は API Gateway (10 MB) と Lambda (6 MB) のペイロード制限を超える。

## Decision

- 動画は S3 の Intelligent-Tiering に保存する。取り出し料金がなく、古い動画は自動で安い階層に移る。
- 配信は CloudFront の署名付き URL でだけ行う。S3 は CloudFront の OAC からだけ読み取れる。
- アップロードは署名付き URL で S3 に直接送る (マルチパート)。API は API Gateway の HTTP API にする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| R2 / B2 / Google One / iCloud+ | 個別の比較は記録していない |
| API 経由のアップロード / Lambda 関数 URL + OAC | 前者はペイロード制限を超える。後者は POST にペイロードの署名が必要になる |
| 別リージョンへの複製 | 保存料が 2 倍になる |

## Consequences

- アカウントの乗っ取りで動画を失うリスクは受け入れる (動画の控えは取らない)。誤操作からは 30 日以内なら戻せる。
- 削除から 30 日を過ぎた動画は、全バージョンを完全に削除する。
- アップロード前のブラウザ内圧縮はしない。対応ブラウザと依存ライブラリが増えるため。単価は [設計書](../specs/data.md)、配信の細目は [設計書](../specs/playback.md) を参照。

## References

- [S3 Intelligent-Tiering の仕組み](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html)
