# ADR-0029: バックエンドはオニオンアーキテクチャ (DDD) で作る

- Status: Accepted
- Date: 2026-11-25

## Context

- アプリの入口が 3 つある。Lambda が受ける HTTP と EventBridge Scheduler の日次の完全削除、手元か `task.yml` で動かす手動作業の `cmd/task` ([ADR-0028](0028-manual-tasks.md))。どの入口でも同じ規則を通す必要がある
- DSQL・S3・Cognito は手元で動かせない。外部をつなぎ替えて試せる形にしたい
- 動画のライフサイクルには規則があり、同時の操作は楽観的並行制御で防ぐ ([Data](../specs/data.md))
- 保守に時間をかけない (PRD の Maintenance)
- 外部依存は aws-lambda-go・aws-sdk-go-v2・pgx の 3 つまで ([ADR-0005](0005-backend-go.md))
- SQL へのアクセスは 1 か所に集める ([ADR-0012](0012-database-dsql.md))

## Decision

- 核をドメインモデル (`domain`) とアプリケーションサービス (`usecase`) に分け、その周りにアダプター (`adapter`) を置く。依存はすべて中心へ向ける。
- `domain` は DDD の集約・値オブジェクト・ドメインイベント・リポジトリで作る。
- 読み取りは集約を通さず、`usecase` が画面の形で直接読む。
- 外側のつなぎ方の呼び名は、ヘキサゴナルアーキテクチャの用語 (ポート・アダプター) を使う。ヘキサゴナル + DDD と同じ形でもある。
- リポジトリの interface は `domain` の集約のパッケージに置く。Go の通例 (使う側に置く) の例外で、理由は [Domain](../specs/domain.md) の Repositories を参照。
- 構成と規則の詳細は [Backend](../specs/backend.md) と [Domain](../specs/domain.md) を参照。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| レイヤード (web → service → store) | 最も単純だが、規則が service に散る。入口が 3 つあり、手元で動かせない外部がある事情への答えを型として持たない |
| ヘキサゴナルだけ (DDD なし) | 外側のつなぎ方は決まるが、ライフサイクルの規則を置く場所が決まらない。集約・トランザクション・楽観的並行制御の単位もそろわない |
| クリーンアーキテクチャ | 操作ごとの Input/Output Data・Input/Output ポート・Presenter は、HTML だけを返すこのアプリでは過剰 |
| 機能ごとのパッケージ (Grafana 型・Ben Johnson 型) | SQL が機能ごとに分かれ、ADR-0012 と合わない。開発者が 1 人で機能も少なく、機能で分ける効果が小さい |
| 機能ごとの縦割り (vertical slice) | 機能の中に規則と SQL が閉じ、規則を集約に集める形と合わない。SQL が機能ごとに分かれ、ADR-0012 とも合わない |

## Consequences

- 集約のフィールドを守るための詰め替えと、集約ごとのリポジトリ・偽物の分だけコードが増える。
- 機能が大きく増え、まとまりごとに分けたくなったら、機能ごとのパッケージへの移行を検討する。

## References

- [Hexagonal Architecture (Alistair Cockburn)](https://alistair.cockburn.us/hexagonal-architecture/)
- [The Onion Architecture (Jeffrey Palermo)](https://jeffreypalermo.com/2008/07/the-onion-architecture-part-1/)
- [The Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Hexagonal architecture pattern - AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html)
- [Developing evolutionary architecture with AWS Lambda - AWS Compute Blog](https://aws.amazon.com/blogs/compute/developing-evolutionary-architecture-with-aws-lambda/)
- [Ready for changes with Hexagonal Architecture - Netflix TechBlog](https://netflixtechblog.com/ready-for-changes-with-hexagonal-architecture-b315ec967749)
- [Wild Workouts (Three Dots Labs)](https://github.com/ThreeDotsLabs/wild-workouts-go-ddd-example)
- [Go Code Review Comments: Interfaces](https://go.dev/wiki/CodeReviewComments#interfaces)
- [Google Go Style Decisions: Interfaces](https://google.github.io/styleguide/go/decisions#interfaces)
- [Grafana: Package hierarchy](https://github.com/grafana/grafana/blob/main/contribute/backend/package-hierarchy.md)
- [GitLab: Go standards and style guidelines](https://docs.gitlab.com/development/go_guide/)
