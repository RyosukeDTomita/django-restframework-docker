# Django REST Framework を試してみる

![un license](https://img.shields.io/github/license/RyosukeDTomita/django-restframework-docker)

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

### copilot cli を使って ECS on Fargate に載せる

```shell
copilot app init --name drf-app # 名前は任意
DOCKER_DEFAULT_PLATFORM=linux/amd64 copilot init # Load Balanced Web Serviceを選択する。svc名とenv名は適宜
copilot pipeline init
```

- 先に Github に push してから pipeline を deploy

```shell
copilot pipeline deploy
```

> [!NOTE]
>
> - ACTION REQUIRED が出るので URL にアクセスし，pending になっている pipeline と GitHub を接続する設定を追加する。
> - 一度 pipeline をデプロイすると以後，指定した GitHub のブランチにマージされるたびに Code Pipeline を通してデプロイが進むようになる。

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

### ECS on Fargate に載せたら Allowed HOST に入っていないというエラーがでる。

```shell
copilot svc logs --previous
Found only one application, defaulting to: drf-app
Found only one deployed service drf-svc in environment drf-env
previously stopped task: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
copilot/drf-svc/c295c36e2   File "/usr/local/lib/python3.10/site-packages/django/core/handlers/exception.py", line 55, in inner
copilot/drf-svc/c295c36e2     response = get_response(request)
copilot/drf-svc/c295c36e2   File "/usr/local/lib/python3.10/site-packages/django/utils/deprecation.py", line 133, in __call__
copilot/drf-svc/c295c36e2     response = self.process_request(request)
copilot/drf-svc/c295c36e2   File "/usr/local/lib/python3.10/site-packages/django/middleware/common.py", line 48, in process_request
copilot/drf-svc/c295c36e2     host = request.get_host()
copilot/drf-svc/c295c36e2   File "/usr/local/lib/python3.10/site-packages/django/http/request.py", line 151, in get_host
copilot/drf-svc/c295c36e2     raise DisallowedHost(msg)
copilot/drf-svc/c295c36e2 django.core.exceptions.DisallowedHost: Invalid HTTP_HOST header: 'drf-ap-publi-xeajkwo0z4gm-187516618.ap-northeast-1.elb.amazonaws.com'. You may need to add 'drf-ap-publi-xxxxxxxxxxx-xxxxxxxxx.ap-northeast-1.elb.amazonaws.com' to ALLOWED_HOSTS.
copilot/drf-svc/c295c36e2 Bad Request: /favicon.ico
```

- ./my_sample_project/my_sample_project/settings.py の ALLOWED_HOST に\*を追加することでアクセス可能になった。

### コンテナで起動しているアプリにはアクセスできるのに最終的にサービスが health check エラーで落ちてしまう

> due to (reason Health checks failed with these codes: [404]).

- copilot/drf-svc/manifest.yml の healthcheck がデフォルトでは/になっているが/が 404 を返しているのが原因。別の URL を指定すれば解決。
