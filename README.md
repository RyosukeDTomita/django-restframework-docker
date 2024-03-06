# Django REST Framework を試してみる

![un license](https://img.shields.io/github/license/RyosukeDTomita/django-restframework-test)

## INDEX

- [ABOUT](#about)
- [LICENSE](#license)
- [ENVIRONMENT](#environment)
- [PREPARING](#preparing)
- [HOW TO USE](#how-to-use)
- [REFERENCE](#reference)
- [MEMO](#MEMO)

---

## ABOUT

- Django と比べて Django REST Framework は RESTful な API 開発に特化している。
- DRF と略される。

- このリポジトリでは docker コンテナ内の gunicorn で Django REST Framework を起動している。

---

## LICENSE

[UN LICENSE](./LICENSE)

---

## ENVIRONMENT

- see[requirements.txt](app/requirements.txt) and [Dockerfile](Dockerfile)

---

## PREPARING

### 現状態のリポジトリを作るための操作

- プロジェクトとアプリの作成

```shell
django-admin startproject myproject
cd myproject
# myappの作成
python3 manage.py startapp myapp
```

- myapp/views.py を編集して画面の設定を作る。
- myproject/urls.py でルーティングを設定するために path を追加する。

---

## HOW TO USE

```shell
docker compose up
```

Then, go to localhost/hello

---

## REFERENCE
- [環境構築とかの参考にした](https://qiita.com/kimihiro_n/items/86e0a9e619720e57ecd8)

---

## MEMO

### docker コンテナ内で起動した django にアクセスできない。

- 0.0.0.0 をつけて起動する必用がある。

```shell
python3 manage.py runserver 0.0.0.0:8000
```
