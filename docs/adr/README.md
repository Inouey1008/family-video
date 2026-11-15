# Architecture Decision Records

あとから変えにくい大きな技術判断の記録。要件は [PRD](../prd.md)、全体構成は [設計書](../architecture.md) にある。

| 番号 | タイトル | Status |
|---|---|---|
| [0001](0001-serverless.md) | 常駐サーバーを持たず、サーバーレスにする | Accepted |
| [0002](0002-client-web.md) | クライアントは Web アプリにし、サポートは iPhone の Safari だけにする | Accepted |
| [0003](0003-mpa.md) | フロントエンドは SPA ではなく MPA にする (サーバーが HTML を返す) | Accepted |
| [0004](0004-backend-go.md) | バックエンドは Go にし、1 つのバイナリで動かす | Accepted |
| [0005](0005-lambda.md) | バックエンドの実行環境は Lambda (OS-only ランタイム) にする | Accepted |
| [0006](0006-no-vpc.md) | Lambda は VPC に入れず、ほかの AWS のサービスには IAM の認証で接続する | Accepted |
| [0007](0007-htmx.md) | フロントエンドは html/template と htmx 2 で作る | Accepted |
| [0008](0008-auth-cognito.md) | 認証は Cognito にし、招待制とパスキーにする | Accepted |
| [0009](0009-session-cookie.md) | ログイン状態は HttpOnly Cookie で保持する | Accepted |
| [0010](0010-database-dsql.md) | DB に Aurora DSQL を使う | Accepted |
| [0011](0011-database-backup.md) | DB は AWS Backup で毎日バックアップする | Accepted |
| [0012](0012-video-storage.md) | 動画は S3 に置く | Accepted |
| [0013](0013-entry.md) | 入り口は CloudFront の 1 つにする | Accepted |
| [0014](0014-video-transfer.md) | 動画の配信とアップロードは、署名付き URL で行う | Accepted |
| [0015](0015-origin-lock.md) | API への入り口は、秘密のヘッダーで CloudFront に限る | Accepted |
| [0016](0016-attack-protection.md) | 攻撃への対策は WAF を使わず、スロットリングと地域制限で行う | Accepted |
| [0017](0017-observability.md) | 監視は CloudWatch の標準機能だけで構成する | Accepted |
| [0018](0018-iac-terraform.md) | インフラは Terraform で構築する | Accepted |
| [0019](0019-environments.md) | dev と prod は同じ AWS アカウントで分ける | Accepted |
| [0020](0020-repository-ci.md) | GitHub の public モノレポと Actions + OIDC | Accepted |
| [0021](0021-manual-tasks.md) | 手動の作業はコードにして実行し、対話型のコンソールは設けない | Accepted |

変えるときは ADR を書き換えず、新しい ADR を足して古い ADR の Status を `Superseded by ADR-XXXX` にする。
