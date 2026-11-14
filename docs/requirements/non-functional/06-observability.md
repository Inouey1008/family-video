[← 目次へ戻る](../README.md)

# Observability

方針: CloudWatch の標準機能だけで構成し、無料枠に収める。外部のサービスと追加の SDK は使わない。

## Logs

| # | 要件 |
|---|---|
| NFR-60 | Go 標準の `log/slog` で JSON 形式の構造化ログを出す。Lambda のログ形式は JSON にする |
| NFR-61 | ログレベルは、Lambda が設定する環境変数 `AWS_LAMBDA_LOG_LEVEL` から読み取って反映する |
| NFR-62 | 各ログには、リクエスト ID、メンバー ID (Cognito の sub)、ルート、ステータス、処理時間、動画 ID を記録する |
| NFR-63 | トークン、Cookie、署名付き URL、メールアドレス、ファイル名はログに記録しない |
| NFR-64 | ロググループの保持期間は30日にする (Terraform で設定) |
| NFR-65 | 削除などの操作は、実行したメンバーと対象をアプリのログに記録する。AWS の操作履歴は CloudTrail のイベント履歴 (標準で90日) で確認する |

## Metrics

| # | 要件 |
|---|---|
| NFR-66 | Lambda、API Gateway、CloudFront、S3、DSQL が自動で出すメトリクスを使う |
| NFR-67 | カスタムメトリクスは、無料枠 (10個) に収まる範囲に限る |
| NFR-68 | ダッシュボードは1つにする (Terraform で定義)。無料枠は3つまで |

## Error Monitoring

| # | 要件 |
|---|---|
| NFR-70 | 共通の middleware で panic を `recover` し、スタックトレースとリクエスト ID を付けて ERROR で記録する |
| NFR-71 | 5xx を返す処理は、必ず ERROR で記録する。4xx は ERROR にしない (認証の失敗とサイズの不一致は WARN で記録する) |
| NFR-72 | メトリクスフィルター `{ $.level = "ERROR" }` で ERROR の件数をカスタムメトリクスにし、アラームを設定する |
| NFR-73 | 調査用に、Logs Insights のクエリ `filter level = "ERROR" \| pattern @message` を保存しておく (似たエラーを自動でまとめる) |
| NFR-74 | ブラウザ側のエラー (`window.onerror`、`unhandledrejection`、`htmx:responseError`) は `POST /api/client-log` に送り、`source=client` を付けて ERROR で記録する。回数とサイズに上限を付ける |

## Alarms and Notifications

| # | 要件 |
|---|---|
| NFR-80 | 次のアラームを設定する (無料枠の10個以内) |
| NFR-81 | アラームと AWS Budgets の通知は SNS トピック `alerts` に送り、Amazon Q Developer in chat applications (旧 AWS Chatbot) で Slack のプライベートチャンネルに転送する。予備としてメールにも送る |
| NFR-82 | Slack ワークスペースの連携は、最初の1回だけコンソールで行う。それ以降のチャンネル設定は Terraform で管理し、ワークスペース ID とチャンネル ID は GitHub の Environment 変数から渡す |
| NFR-83 | Slack から AWS を操作する機能は使わない。IAM ロールとガードレールは CloudWatch の読み取りだけにする |
| NFR-84 | アラームの説明欄には、保存した Logs Insights クエリへのリンクを書く |

| アラーム | 条件の例 |
|---|---|
| アプリの ERROR ログ | 5分間に1件以上 |
| Lambda のエラー (タイムアウト・メモリ不足を含む) | 5分間に1件以上 |
| API Gateway の 5xx | 5分間に1件以上 |
| Lambda のスロットリング | 1件以上 |
| Lambda の実行時間 | タイムアウトの8割に近づいた |
| AWS Budgets | 月額予算の80% |
| 認証の失敗・4xx の急増 | 5分間に通常の数倍 (値は運用しながら調整) |

## References

- [Lambda のログレベルによるフィルタリング](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs-log-level.html)
- [Amazon CloudWatch 料金 (無料枠)](https://aws.amazon.com/cloudwatch/pricing/)
- [CloudWatch Logs Insights の pattern コマンド](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax-Pattern.html)
- [X-Ray SDK とデーモンのサポート終了と OpenTelemetry への移行](https://aws.amazon.com/blogs/mt/announcing-aws-x-ray-sdks-daemon-end-of-support-and-opentelemetry-migration)
- [Amazon Q Developer in chat applications で CloudWatch の通知をテストする](https://docs.aws.amazon.com/chatbot/latest/adminguide/test-notifications-cw.html)
- [AWS::Chatbot::SlackChannelConfiguration](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-chatbot-slackchannelconfiguration.html)
- [チャットアプリケーションでの予算アラートの受信](https://docs.aws.amazon.com/ja_jp/cost-management/latest/userguide/sns-alert-chime.html)
