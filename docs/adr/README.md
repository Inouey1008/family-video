# Architecture Decision Records

あとから変えにくい大きな技術判断の記録。要件は [PRD](../prd.md)、全体構成は [設計書](../architecture.md) にある。

| 番号 | タイトル | Status |
|---|---|---|
| [0001](0001-cloud-aws-serverless.md) | AWS 東京のサーバーレス構成にする | Accepted |
| [0002](0002-client-web.md) | クライアントは Web アプリにし、サポートは iPhone の Safari だけにする | Accepted |
| [0003](0003-backend-go.md) | バックエンドは Go (provided.al2023・zip) にする | Accepted |
| [0004](0004-frontend-htmx.md) | 画面は html/template + htmx にし、フロントエンドのビルドを持たない | Accepted |
| [0005](0005-database-dsql.md) | DB に Aurora DSQL を使い、AWS Backup で毎日バックアップする | Accepted |
| [0006](0006-auth-cognito.md) | 認証は Cognito (招待制・パスキー) と HttpOnly Cookie にする | Accepted |
| [0007](0007-video-storage-delivery.md) | 動画は S3 Intelligent-Tiering に置き、CloudFront の署名付き URL で配信する | Accepted |
| [0008](0008-iac-environments.md) | Terraform で構築し、dev / prod は同じ AWS アカウントで分ける | Accepted |
| [0009](0009-observability.md) | 監視は CloudWatch の標準機能だけで構成する | Accepted |
| [0010](0010-abuse-protection.md) | 乱用対策は WAF を使わず、スロットリングと地域制限で行う | Accepted |
| [0011](0011-repository-ci.md) | GitHub の public モノレポと Actions + OIDC | Accepted |

変えるときは ADR を書き換えず、新しい ADR を足して古い ADR の Status を `Superseded by ADR-XXXX` にする。
