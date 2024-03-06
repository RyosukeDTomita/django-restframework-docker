#!/bin/bash
cd /usr/local/app/my_sample_project
# NOTE: 0.0.0.0を指定しないとdockerコンテナ内にブラウザからアクセスできない。
#python3 manage.py runserver 0.0.0.0:8000
/usr/local/bin/gunicorn my_sample_project.wsgi:application -b 0.0.0.0:8000 --chdir /usr/local/app/my_sample_project
