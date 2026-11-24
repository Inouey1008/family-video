# Architecture Decision Records

あとから変えにくい大きな技術判断の記録。要件は [PRD](../prd.md)、全体構成は [設計書](../architecture.md) にある。

| 番号 | タイトル | Status |
|---|---|---|
| [0001](0001-serverless.md) | 常駐サーバーを持たず、サーバーレスにする | Accepted |
| [0002](0002-client-web.md) | クライアントは Web アプリ (PWA) にする | Accepted |
| [0003](0003-support-safari.md) | サポートは iPhone の Safari だけにする | Accepted |
| [0004](0004-mpa.md) | フロントエンドは SPA ではなく MPA にする (サーバーが HTML を返す) | Accepted |
| [0005](0005-backend-go.md) | バックエンドは Go にし、1 つのバイナリで動かす | Accepted |
| [0006](0006-lambda.md) | バックエンドの実行環境は Lambda (OS-only ランタイム) にする | Accepted |
| [0007](0007-no-vpc.md) | Lambda は VPC に入れず、ほかの AWS のサービスには IAM の認証で接続する | Accepted |
| [0008](0008-htmx.md) | フロントエンドは html/template と htmx 2 で作る | Accepted |
| [0009](0009-auth-cognito.md) | 認証のサービスは Cognito にする | Accepted |
| [0010](0010-login-passkey.md) | 招待制にし、ログインはパスキーを主にする | Accepted |
| [0011](0011-session-cookie.md) | ログイン状態は HttpOnly Cookie で保持する | Accepted |
| [0012](0012-database-dsql.md) | DB に Aurora DSQL を使う | Accepted |
| [0013](0013-database-backup.md) | DB は AWS Backup で毎日バックアップする | Accepted |
| [0014](0014-video-storage.md) | 動画は S3 (Intelligent-Tiering) に置く | Accepted |
| [0015](0015-video-deletion.md) | 動画は S3 のバージョニングで戻せるようにし、削除から 30 日で完全に消す | Accepted |
| [0016](0016-entry.md) | 入り口は CloudFront の 1 つにする | Accepted |
| [0017](0017-api-http.md) | API は API Gateway の HTTP API にする | Accepted |
| [0018](0018-no-custom-domain.md) | 独自ドメインは使わず、CloudFront の既定の URL を使う | Accepted |
| [0019](0019-video-transfer.md) | 動画の配信とアップロードは、署名付き URL で行う | Accepted |
| [0020](0020-origin-lock.md) | API への入り口は、秘密のヘッダーで CloudFront に限る | Accepted |
| [0021](0021-attack-protection.md) | 攻撃への対策は WAF を使わず、スロットリングと地域制限で行う | Accepted |
| [0022](0022-observability.md) | ログとアラームは CloudWatch の標準機能だけで作る | Accepted |
| [0023](0023-notification.md) | 通知は Amazon Q Developer 経由で Slack に送る | Accepted |
| [0024](0024-iac-terraform.md) | インフラは Terraform で構築する | Accepted |
| [0025](0025-environments.md) | dev と prod は同じ AWS アカウントで分ける | Accepted |
| [0026](0026-repository.md) | リポジトリは GitHub の public なモノレポにする | Accepted |
| [0027](0027-ci-cd.md) | CI/CD は GitHub Actions にし、AWS へは OIDC で認証する | Accepted |
| [0028](0028-manual-tasks.md) | 手動の作業はコードにして実行し、対話型のコンソールは設けない | Accepted |
| [0029](0029-playwright.md) | E2E と VRT に Playwright (Node・yarn) を使う | Accepted |

変えるときは ADR を書き換えず、新しい ADR を足して古い ADR の Status を `Superseded by ADR-XXXX` にする。
