# ADR-0030: dev の CloudFront には地域制限をかけない

- Status: Accepted
- Date: 2026-11-25

## Context

- [ADR-0021](0021-attack-protection.md) で、CloudFront の地域制限は `JP` だけを許可した
- GitHub のランナーは国外にある。デプロイ後のスモークテスト (`deploy.yml`) と E2E (`e2e.yml`) が dev の CloudFront に届かず、403 になる
- PRD の Security の「日本国内からのアクセスだけを許可する」は、家族が使う prod の要件。dev にあるのはテスト用の家族のデータだけ

## Decision

- dev の CloudFront には地域制限をかけない。
- prod は ADR-0021 のまま `JP` だけを許可する。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| スモークは Lambda を `aws lambda invoke` で直接呼び、E2E は手元の Mac だけで動かす | CloudFront と API Gateway を通る経路を試せない。E2E を macOS のランナーで回せない |
| dev だけランナーの国を許可する | ランナーがどの国で動くかを GitHub は保証していない |
| 国内に self-hosted のランナーを置く | 常に動かす機器が要り、サーバーレスで固定費をほぼ 0 円にする方針 ([ADR-0001](0001-serverless.md) / [ADR-0021](0021-attack-protection.md)) と合わない |

## Consequences

- dev は国外からも届く。残る対策はスロットリング・オリジン検証 ([ADR-0020](0020-origin-lock.md))・予約同時実行数・Cognito のログインで、課金の暴走には上限がある (値は [Security](../specs/security.md))。
- 地域外の 403 の画面 ([UI](../specs/ui.md)) は prod だけで出る。
- ADR-0021 は prod について有効なまま。

## References

- [CloudFront の地域制限](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistValuesEnableGeoRestriction.html)
- [GitHub-hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/using-github-hosted-runners/about-github-hosted-runners)
