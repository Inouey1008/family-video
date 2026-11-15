# ADR-0015: API への入り口は、秘密のヘッダーで CloudFront に限る

- Status: Accepted
- Date: 2026-11-15

## Context

- 入り口は CloudFront の 1 つにする ([ADR-0013](0013-entry.md))
- API Gateway (HTTP API) は自分の公開 URL を持ち、CloudFront を通らずに直接呼べる。直接呼ばれると、CloudFront の地域制限 ([ADR-0016](0016-attack-protection.md)) が効かない
- HTTP API には、CloudFront からだけ受け付ける設定がない

## Decision

- CloudFront からオリジンへ、秘密のヘッダー (`X-Origin-Verify`) を付ける。
- Lambda の middleware が最初にヘッダーを確かめ、一致しなければ `403` を返す。

## Alternatives

| 案 | 選ばなかった理由 |
|---|---|
| Lambda 関数 URL + OAC | CloudFront だけに確実に絞れるが、POST の本文のハッシュをブラウザの JS で計算して付ける必要がある |
| REST API + リソースポリシー | 送信元の IP で絞るが、CloudFront の IP は多く、変わる。料金も HTTP API の 3.5 倍 (100 万リクエストあたり 3.50 ドルと 1.00 ドル) |
| REST API のプライベート API | VPC エンドポイントの固定費がかかり、CloudFront からも直接は届かない |

## Consequences

- 直接のアクセスも Lambda まで届くので、`403` を返すまでの実行は課金される。量はスロットリングと予約同時実行数で抑える ([ADR-0016](0016-attack-protection.md))。
- 直接のアクセスでも、ログインしていなければ動画は見られない。この対策は、地域制限の回避を防ぐためのもの。
- 値の置き場所と入れ替えの手順は [設計書](../specs/security.md) を参照。

## References

- [プライベート REST API (REST API だけが対応)](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-apis.html)
- [API Gateway 料金](https://aws.amazon.com/api-gateway/pricing/)
