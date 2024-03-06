FROM python:3.10.13-bullseye as dependencies
SHELL ["bash", "-c"]
WORKDIR /usr/local/app
COPY ./requirements.txt /usr/local/app
RUN <<EOF
pip install -r requirements.txt --no-cache-dir
EOF

FROM dependencies as app
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
EXPOSE 8000
