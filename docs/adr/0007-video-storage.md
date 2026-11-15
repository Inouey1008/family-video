# ADR-0007: 動画は S3 に置く

- Status: Accepted
- Date: 2026-11-15

## Context

- 古くなった動画の保存費用が自動で下がる (PRD の Cost)
- 動画の控えは取らない (PRD の Decisions)
- 処理は AWS の Lambda で動かす ([ADR-0001](0001-cloud-aws-lambda.md))

## Decision

- 動画は S3 に保存する。IAM で Lambda と CloudFront からだけ扱えるようにする。
- ストレージクラスは Intelligent-Tiering にする。取り出し料金がなく、古い動画は自動で安い階層に移る。
- バージョニングを有効にする。誤って上書き・削除しても、前のバージョンから戻せる。
- 動画は圧縮・変換せず、元のまま保存する。
- 削除から 30 日を過ぎた動画は、全バージョンを完全に削除する。バージョニングで保存料が増え続けないようにする。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare R2 / Backblaze B2 | AWS の外にあり、IAM で権限を絞れない。アクセスキーを秘密情報として管理する必要がある |
| Google One / iCloud+ | 個人向けのストレージで、アプリから保存・配信する API がない |
| S3 Standard | 古い動画も同じ料金のまま |
| S3 Glacier | 取り出しに料金と時間がかかり、すぐに再生できない |
| 別リージョンへの複製 | 保存料が 2 倍になる |
| アップロード前のブラウザ内圧縮 | 対応ブラウザと依存ライブラリが増える |

## Consequences

- アカウントの乗っ取りで動画を失うリスクは受け入れる。誤操作からは 30 日以内なら戻せる。
- 単価は [設計書](../specs/data.md) を参照。

## References

- [S3 Intelligent-Tiering の仕組み](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html)
