# Requirements

家族動画共有アプリの要件・与件定義。

- 作成日: 2026-11-14
- ステータス: 設計方針確定 (実装前)

## Table of Contents

| 章 | 名前 | 内容 |
|---|---|---|
| 1 | [Background](#1-background) | 背景・目的 |
| 2 | [Constraints](#2-constraints) | 与件 (前提条件・制約) |
| 3 | [Functional Requirements](functional.md) | 機能要件 |
| 4 | Non-functional Requirements | 非機能要件 (下表) |
| 5 | [Out of Scope](#5-out-of-scope) | スコープ外 (初期リリース) |

### 4. Non-functional Requirements

| 節 | 名前 | 内容 |
|---|---|---|
| 4.1 | [Security](non-functional/01-security.md) | セキュリティ |
| 4.2 | [Cost](non-functional/02-cost.md) | コスト |
| 4.3 | [Maintainability](non-functional/03-maintainability.md) | 保守性 |
| 4.4 | [Availability](non-functional/04-availability.md) | 可用性・耐久性 |
| 4.5 | [Compatibility](non-functional/05-compatibility.md) | 互換性 |
| 4.6 | [Observability](non-functional/06-observability.md) | オブザーバビリティ・エラー監視・通知 |
| 4.7 | [Abuse Protection](non-functional/07-abuse-protection.md) | レートリミット・ボット対策・地域制限 |
| 4.8 | [Backup](non-functional/08-backup.md) | バックアップ・リストア |
| 4.9 | [Privacy](non-functional/09-privacy.md) | プライバシー |
| 4.10 | [Performance](non-functional/10-performance.md) | 性能・容量 |
| 4.11 | [Operations](non-functional/11-operations.md) | 運用 |
| 4.12 | [Testing](non-functional/12-testing.md) | テスト・使いやすさ・公開 |

## 1. Background

### Background

- 動画を無料でアップロードできるサービスは、一定の容量を超えると課金される。
- これまで家族の動画は LINE で共有していたが、有料化された。

### Purpose

- 容量を気にせず、家族の動画をどんどんアップロード・共有できるようにする。
- 個人開発の成果物として、GitHub で公開する。

## 2. Constraints

| # | 区分 | 内容 |
|---|---|---|
| C-01 | 利用者 | 家族のみ。招待した人だけが使える |
| C-02 | 端末 | 家族全員が iPhone (iOS の Safari)。ネイティブアプリにはせず、PWA としてホーム画面から使う |
| C-03 | 予算 | できるだけお金をかけない。固定費はほぼ0円にし、費用は保存量に比例する従量課金だけにする |
| C-04 | 保守 | 保守に時間をかけない。バージョン更新が頻繁な技術は避け、安定したスタックにする |
| C-05 | セキュリティ | 家族だけで使うアプリでも、セキュリティはしっかり確保する |
| C-06 | 公開 | GitHub の public リポジトリで公開する。秘密情報や環境固有の値はリポジトリに含めない |
| C-07 | クラウド | AWS のサーバーレス構成 (東京リージョン) |
| C-08 | IaC | 使い慣れている Terraform を使う |
| C-09 | UX | 操作の滑らかさより、セキュリティと保守性を優先する (家族向けアプリのため) |

## 5. Out of Scope

初期リリースの対象外とする項目。

| 項目 | 理由 |
|---|---|
| サーバー側での動画変換・圧縮 | 費用と複雑さを避けるため。必要になったら後から追加する |
| アップロード前のブラウザ内圧縮 | 対応ブラウザと依存ライブラリが増えるため |
| オフラインでの閲覧 | htmx で画面をサーバーから生成する方式のため |
| ネイティブアプリ (iOS) | 利用者を家族に限定するのは認証の役割。TestFlight は90日ごとの再配布、Ad Hoc は毎年の再署名、非公開配布 (Unlisted) は App Review が必要なうえにリンクを知っていれば誰でも入手できる。さらに毎年 Xcode と SDK の更新が必要になるため |
| アルバム・コメント機能 | 後からテーブルを追加して対応する |
| WAF (レートベースのルール・Bot Control・CAPTCHA) | Web ACL ごとに月額の固定費がかかるため。API Gateway のスロットリング、Go での制限、CloudFront の地域制限で代わりとする |
| Cognito の脅威保護 (Plus プラン) | 追加料金がかかるため。招待制とパスキーで代わりとする |
| VPC・NAT ゲートウェイ・PrivateLink | 公開エンドポイントと IAM 認証で十分。固定費がかかるため |
| コンテナ (Lambda コンテナイメージ・Fargate) | ベースイメージのパッチを自分で当てる必要があるため |
| 分散トレーシング (X-Ray SDK・OpenTelemetry) | X-Ray の SDK は2026年2月25日にメンテナンスモードに入り、2027年2月25日にサポートが終了する。OpenTelemetry は依存が増えるため。Lambda が1つだけの構成なので、ログのリクエスト ID でたどれば足りる |
| GitHub Copilot による PR の承認 | 承認機能はプレビュー版で、標準ではオフ。Copilot の有料プランと AI クレジットの費用が Claude とは別にかかり、AI の承認だけでマージできてしまうため。マージは自分で判断する (DEV-13) |
| 外部のエラー監視サービス (Sentry など) | SDK の依存が増え、エラーの内容が外部に送られるため。エラーの調査が大変になったら、Sentry の無料プランを検討する |
