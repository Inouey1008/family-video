# ADR-0014: 動画は S3 (Intelligent-Tiering) に置く

- Status: Accepted
- Date: 2026-11-15

## Context

- 古くなった動画の保存費用が自動で下がる (PRD の Cost)
- Lambda と同じ AWS の中にそろえると、IAM の認証でつなげられ、構成が単純になる ([ADR-0006](0006-lambda.md) / [ADR-0007](0007-no-vpc.md))

## Decision

- 動画は S3 に保存する。IAM で Lambda と CloudFront からだけ扱えるようにする。
- ストレージクラスは Intelligent-Tiering にする。取り出し料金がなく、古い動画は自動で安い階層に移る。
- 動画は圧縮・変換せず、元のまま保存する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Cloudflare R2 / Backblaze B2 | AWS の外にあり、IAM で権限を絞れない。アクセスキーを秘密情報として管理する必要がある |
| Google One / iCloud+ | 個人向けの定額プランで、容量に段階がある。アプリの保存先として、期限付きの URL で配信を制御する仕組みがない |
| S3 Standard | 古い動画も同じ料金のまま |
| S3 Glacier | 取り出しに料金と時間がかかり、すぐに再生できない |
| アップロード前のブラウザ内圧縮 | 対応ブラウザと依存ライブラリが増える |

## Consequences

- 削除と復元の扱いは [ADR-0015](0015-video-deletion.md) を参照。
- 単価は [設計書](../specs/data.md) を参照。

## References

- [S3 Intelligent-Tiering の仕組み](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html)
