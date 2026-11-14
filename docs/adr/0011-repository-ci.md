# ADR-0011: GitHub の public モノレポ、Actions + OIDC、レビューは `@claude` で頼む

- Status: Accepted
- Date: 2026-11-15

## Context

- PRD の Goals: 個人開発の成果物として公開できる。保守の手間を小さく保つ。
- PRD に入れなかった細目 (Issue #5): 長期間有効な認証情報は発行しない。
- 公開するので、秘密情報や環境固有の値をリポジトリに含められない。

## Decision

- GitHub の public リポジトリで公開し、インフラ (Terraform)・アプリ (Go)・静的ファイルを 1 つのモノレポに置く。インフラとコードの変更を 1 つの PR で済ませるため。
- CI/CD は GitHub Actions にし、AWS への認証は OIDC で行う。長期のアクセスキーは発行しない。
- アカウント ID やドメインなどの環境固有の値は、GitHub の Environment 変数から渡す。`*.tfstate` と `*.tfvars` はコミットしない。
- PR のレビューは、PR のコメントで `@claude` と書いて Claude に頼む形にする。自動レビューはやめた (#26)。マージは自分で判断する。
- Claude の認証には `CLAUDE_CODE_OAUTH_TOKEN` を使う。自分の Claude のサブスクリプションの範囲で使え、API の従量課金がかからない。
- GitHub Copilot による PR の承認は使わない。
- main への直接 push は禁止し、PR を必須にする。必須の承認数は 0 にする (自分の PR は自分で承認できないため)。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| インフラを別リポジトリに分ける | インフラとコードの変更を 1 つの PR で済ませられなくなる |
| Code Review (Anthropic の管理型) | Team・Enterprise のみで、1 回 $15〜$25 かかる |
| API キー / Amazon Bedrock | 従量課金がかかる。OAuth トークンなら自分のサブスクリプションの範囲で使える |
| GitHub Copilot のコードレビューと承認 | 承認機能はプレビュー版で標準ではオフ。有料プランと AI クレジットが Claude とは別にかかり、AI の承認だけでマージできてしまう |
| PR ごとの自動レビュー | push のたびに動き、レビューが要らない変更でもサブスクリプションの使用量を消費していた。レビューは必要なときに頼めば足りる (#26) |
| PR を完全に無効にする | 自分の PR の流れも使えなくなる。PR を作れる人を「コラボレーターのみ」に制限し、コラボレーターは自分だけにする |

## Consequences

- レビューは頼んだときだけ走る。頼み忘れた PR はレビューされないまま、自分の判断でマージできてしまう。
- トークンは自分のサブスクリプションに結びついている。期限が切れたら、または漏れた疑いがあれば、`claude setup-token` で作り直して Secret を差し替える。
- レビューの観点は `CLAUDE.md` に書く。
- CI の構成・ブランチのルール・デプロイの流れは [設計書](../architecture.md) にまとめる。

## References

- [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions)
- [anthropics/claude-code-action のセキュリティ](https://github.com/anthropics/claude-code-action/blob/main/docs/security.md)
- [New repository settings for configuring pull request access (GitHub Changelog)](https://github.blog/changelog/2026-02-13-new-repository-settings-for-configuring-pull-request-access/)
- [Disabling pull requests (GitHub Docs)](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/disabling-pull-requests)
