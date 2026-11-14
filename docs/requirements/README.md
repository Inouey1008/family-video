# Requirements

家族動画共有アプリの要件・与件定義。

- 作成日: 2026-11-14
- ステータス: 要件整理済み (設計前)

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
| 4.6 | [Observability](non-functional/06-observability.md) | 記録・エラー監視・通知 |
| 4.7 | [Abuse Protection](non-functional/07-abuse-protection.md) | 利用回数の制限・不正アクセス対策・地域制限 |
| 4.8 | [Backup](non-functional/08-backup.md) | バックアップ・復元 |
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
- 個人開発の成果物として公開する。

## 2. Constraints

| # | 区分 | 内容 |
|---|---|---|
| C-01 | 利用者 | 家族のみ。招待した人だけが使える |
| C-02 | 端末 | 家族は全員 iPhone を使っている |
| C-03 | 予算 | できるだけお金をかけない。固定費はほぼ 0 円にし、費用は保存量に比例する従量課金だけにする |
| C-04 | 保守 | 保守に時間をかけない。バージョン更新が頻繁な技術は避け、安定したものを選ぶ |
| C-05 | セキュリティ | 家族だけで使うアプリでも、セキュリティはしっかり確保する |
| C-06 | 公開 | 成果物として公開する。秘密情報や環境固有の値は公開物に含めない |
| C-07 | UX | 操作の滑らかさより、セキュリティと保守性を優先する (家族向けアプリのため) |

## 5. Out of Scope

初期リリースの対象外とする項目。

| 項目 | 理由 |
|---|---|
| 動画の変換・圧縮 (サービス側・アップロード前の端末側とも) | 費用・複雑さ・依存する部品が増えるため。必要になったら後から追加する |
| オフラインでの閲覧 | 初期リリースの範囲を絞るため |
| アルバム・コメント機能 | 後から追加して対応する |
