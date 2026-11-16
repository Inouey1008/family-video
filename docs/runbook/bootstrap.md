# Bootstrap

state のバケット・GitHub OIDC のプロバイダー・IAM ロール・予算を作る手順。Terraform は `infra/terraform/initial_setup/` にあり、手元の IAM Identity Center (SSO) の管理者だけが apply する。

[設計書](../architecture.md) / [Operations](../specs/operations.md)

## Prerequisites

- IAM Identity Center (SSO) で、管理者の権限を持つプロファイルにログインできる
- `mise install` で Terraform 1.17.1 を入れる
- `gh` にログインしている

## Prepare Values

1. `sub` に入れる owner と repo の ID を調べる。このリポジトリは新しく作ったので、`sub` は ID を含む形 (`repo:<owner>@<owner_id>/<repo>@<repo_id>:environment:<env>`) になる

   ```sh
   gh api repos/<owner>/<repo> --jq '.owner.id, .id'
   ```

2. 例のファイルをコピーし、値を入れる。どちらもコミットしない (gitignore 済み)

   ```sh
   cd infra/terraform/initial_setup
   cp terraform.tfvars.example terraform.tfvars
   cp backend.hcl.example backend.hcl
   ```

| ファイル | 変数 | 内容 |
|---|---|---|
| `terraform.tfvars` | `aws_account_id` | AWS アカウント ID |
| | `state_bucket_name` | state のバケット名 |
| | `github_owner` / `github_owner_id` | owner の名前と ID |
| | `github_repo` / `github_repo_id` | repo の名前と ID |
| | `monthly_budget_usd` | 月額の予算 (USD) |
| | `budget_notification_emails` | 予算の通知先のメール |
| `backend.hcl` | `bucket` | `state_bucket_name` と同じ値 |

## First Apply

state のバケットは bootstrap 自身が作る。最初はローカルの state で apply し、バケットができてから S3 に移す。

```
AWS_PROFILE を設定 → aws sso login
        │
backend_override.tf で local backend を宣言
        │
terraform init → terraform apply     (バケットなどができる)
        │
backend_override.tf を消す
        │
terraform init -migrate-state -backend-config=backend.hcl
        │
ローカルの terraform.tfstate* を消す
```

1. `AWS_PROFILE` を設定し、`aws sso login` でログインする
2. `infra/terraform/initial_setup/backend_override.tf` (gitignore 済み) に local backend を書く

   ```hcl
   terraform {
     backend "local" {}
   }
   ```

3. `terraform init` → `terraform apply`
4. `backend_override.tf` を消す
5. `terraform init -migrate-state -backend-config=backend.hcl` (移すかを聞かれたら yes)
6. ローカルの `terraform.tfstate*` を消す

## Update

```sh
aws sso login
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## GitHub Settings

1. リポジトリのシークレットに、AWS アカウント ID を入れる。ロールの ARN は命名規則から組み立てる

   | ロール | 名前 |
   |---|---|
   | 読み取り専用 (PR の `plan`) | `family-video-ci-readonly` |
   | dev | `family-video-dev` |
   | prod | `family-video-prod` |

2. Environment `dev`: deployment branch を `main` だけにする
3. Environment `prod`: deployment tag を `v*` だけにし、Required reviewers を付ける。一人で開発するので、自分で承認できるようにする
4. タグ `v*` を作れる人を自分だけに絞る。リポジトリのルールセット (Settings → Rules → Rulesets) でタグ `v*` を対象にし、作成を制限して、bypass できるのを自分だけにする

`sub` にタグは入らない。prod をタグからだけ実行する制限は、Environment の設定が担う。

## Cautions

- `sensitive` が隠すのは表示だけで、state には平文で残る。state は暗号化 (SSE-S3) と権限で守る
- `pull_request_target`・`workflow_run` のワークフローでは、`id-token: write` と `environment` を使わない。main の文脈でフォークのコードが動き、dev のロールを引き受けられてしまう
- dev / prod のロールに IAM の権限 (Lambda の実行ロールの作成・`PassRole` など) を足すときは、ロール名の prefix の制限と permissions boundary を条件にする
- 秘密の値は state に入れない (Secrets Manager の値は Terraform の外で入れる)。Lambda の環境変数にも秘密を入れない。`family-video-ci-readonly` は state と Lambda の設定を読めるため
- bootstrap (`infra/terraform/initial_setup/`) は CI で plan しない。手元の SSO の管理者だけが plan と apply をする
- ロールの権限を足すたびに、この手順で bootstrap を apply する
