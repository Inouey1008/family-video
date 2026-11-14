# ADR-0007: 動画は S3 Intelligent-Tiering に置き、CloudFront の署名付き URL で配信する

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Goals: 容量を気にせずアップロードできる。費用は保存量に比例する分だけにする。
- PRD の Cost: 古くなって見られなくなった動画は、保存費用が自動で下がるようにする。
- PRD の Security: 動画は、ログインした家族しか取得できない。
- 動画は大きく、API Gateway (10 MB) と Lambda (6 MB) のペイロード制限を超える。

## Decision

- 動画とサムネイルは S3 の Intelligent-Tiering に保存する。取り出し料金がなく、古い動画は自動で安い階層に移る。
- 配信は CloudFront の署名付き URL (短い有効期限) でだけ行う。S3 のパブリックアクセスはすべてブロックし、CloudFront の OAC からだけ読み取れるようにする。
- アップロードは、署名付き URL で S3 に直接送る (マルチパート)。Lambda を経由しない。
- API は API Gateway の HTTP API にする。スロットリングが使え、htmx の POST がそのまま通る。
- S3 のバージョニングを有効にし、古い版は 30 日で削除する。誤操作からの復元はこれで行う。
- 完了しなかったマルチパートアップロードは、7 日後に自動で削除する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| R2 / B2 / Google One / iCloud+ | 個別の比較は記録していない。取り出し料金がなく自動で安い階層に移る点で S3 を選んだ |
| API 経由のアップロード | API Gateway と Lambda のペイロード制限を超える |
| Lambda 関数 URL + OAC | POST にペイロードの署名が必要になる |
| 別リージョンへの複製 | 保存料が 2 倍になる |

## Consequences

- 東京の単価 (/GB-月、2026-11-15 に確認) は Frequent $0.025、Infrequent $0.0138、Archive Instant $0.005。監視料は 1,000 オブジェクトごとに $0.0025/月。採用前に AWS Pricing Calculator で再確認する。
- 30 日より前に削除・上書きしたオブジェクトには、最低保存期間の料金がかかる。
- アカウントの乗っ取りで動画を失うリスクは受け入れる (動画の控えは取らない)。元の動画は家族の iPhone に残る。対策は、ルートユーザーの MFA と最小権限。誤操作からは 30 日以内なら戻せる。
- 削除から 30 日を過ぎた動画は、古いバージョンも含めて全バージョンを完全に削除する (PRD #14 の 30 日どおりにするため)。
- アップロード前のブラウザ内圧縮はしない。対応ブラウザと依存ライブラリが増えるため。
- 署名付き URL の期限が切れたら、再生前に取り直す。
- フローと署名の細目は [設計書](../architecture.md) にまとめる。

## References

- [S3 Intelligent-Tiering の仕組み](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html)
- [API Gateway HTTP API のクォータ](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-quotas.html)
- [S3 へのファイルアップロード API のパターン (AWS Compute Blog)](https://aws.amazon.com/blogs/compute/patterns-for-building-an-api-to-upload-files-to-amazon-s3)
- [CloudFront による Lambda 関数 URL へのアクセス制限](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html)
