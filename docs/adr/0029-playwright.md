# ADR-0029: E2E と VRT に Playwright (Node・yarn) を使う

- Status: Accepted
- Date: 2026-11-24

## Context

- 画面の見た目の崩れと、一覧・再生・アップロードなどの操作を、自動で確かめたい
- サポートは iPhone の Safari だけ ([ADR-0003](0003-support-safari.md))。Playwright の WebKit は Safari のエンジンで、画面幅も指定できる
- [ADR-0004](0004-mpa.md) で npm を使わないと決めたのは、画面のビルドについて。テストの道具は本番に入らないので、別に扱う
- VRT (`toHaveScreenshot`) の基準画像は OS とブラウザごとに別になる。公式の Docker イメージの中で作れば、環境の差を抑えられる

## Decision

- E2E と VRT に Playwright を使う。Node と yarn で入れ、`e2e/` に置く。
- VRT は公式の Docker イメージの中で CI に流す。E2E は `dev` に手動で流す ([Testing](../specs/testing.md))。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| playwright-go | 非公式で、公式の Docker イメージや `toHaveScreenshot` の最新の機能に追従する保証がない |
| VRT を入れない | 画面は少ないが、CSS や HTML の変更で崩れても気づけない |

## Consequences

- Node と yarn の依存が増える。本番のコードには入らず、ビルドにも使わない。Dependabot で更新を追う。
- Playwright の WebKit は iPhone の Safari とは別物なので、実機の確認は残る。

## References

- [Playwright: Visual comparisons](https://playwright.dev/docs/test-snapshots)
- [Playwright: Docker](https://playwright.dev/docs/docker)
