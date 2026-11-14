[← 目次へ戻る](../README.md)

# Cost

| # | 要件 |
|---|---|
| NFR-20 | 固定費はほぼ0円にする (配信・DB・認証・Lambda は無料枠に収める) |
| NFR-21 | 保存は S3 Intelligent-Tiering にし、古い動画は自動で安い階層に移す |
| NFR-22 | AWS Budgets で月額のアラートを設定する |
| NFR-23 | 完了しなかったマルチパートアップロードは、7日後に自動削除する |

## Storage Cost Estimate

保存料の目安 (東京リージョン、Intelligent-Tiering):

| 保存量 | 月額 (すべて最近見られている場合) | 月額 (ほぼすべて古い場合) |
|---|---|---|
| 100 GB | 約 $2.5 | 約 $0.5 |
| 500 GB | 約 $12.5 | 約 $2.5 |
| 1 TB | 約 $25.6 | 約 $5.1 |

> 単価は 2026年11月時点で調べた値です。採用前に AWS Pricing Calculator で確認すること。

## References

- [Aurora DSQL 料金](https://aws.amazon.com/rds/aurora/dsql/pricing/)
- [CloudFront 料金](https://aws.amazon.com/cloudfront/pricing/pay-as-you-go)
- [Amazon Cognito 料金](https://aws.amazon.com/cognito/pricing)
- [S3 Intelligent-Tiering の仕組み](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html)
