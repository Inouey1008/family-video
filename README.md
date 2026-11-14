# family-video

家族内で動画を共有するアプリ。

## Motivation

動画を共有できるサービスの多くは、保存できる量に上限があり、超えると費用がかかる。家族の動画を容量を気にせず残せる場所として、自分で作ることにした。

## Development

- タスクは GitHub Issues と Milestone で管理する
- main への直接 push は禁止。PR のレビューは `@claude` で Claude に頼み、自分でマージする
- PR や Issue で `@claude` と書くと Claude が応答する
- GitHub Actions の更新は Dependabot が月 1 回 PR を作る
- 要件は [docs/prd.md](docs/prd.md) にまとめている
- 設計は [docs/architecture.md](docs/architecture.md) と [docs/adr/](docs/adr/) を参照

## License

[MIT](LICENSE)
