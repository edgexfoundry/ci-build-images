ARG DOCKER_VERSION=24
FROM docker:${DOCKER_VERSION} AS docker-cli

FROM alpine:3.16

COPY --from=docker-cli  /usr/local/bin/docker   /usr/local/bin/docker

# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
RUN apk add --update --no-cache \
  py-pip \
  python3-dev \
  libffi-dev \
  openssl-dev \
  gcc \
  libc-dev \
  make \
  unzip \
  bash \
  wget \
  curl

ENV DOCKER_CONFIG=/usr/local/lib/docker/cli-plugins

RUN mkdir -p $DOCKER_CONFIG
RUN curl -v -SL "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-linux-$(uname -m)" -o $DOCKER_CONFIG/docker-compose \
    && chmod +x $DOCKER_CONFIG/docker-compose \
    && docker compose version
COPY ./docker-compose-shim /usr/local/bin/docker-compose

ENTRYPOINT ["docker", "compose"]
