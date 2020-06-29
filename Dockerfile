ARG DOCKER_VERSION=19.03.11
FROM docker:${DOCKER_VERSION} AS docker-cli

FROM alpine:3.11

COPY --from=docker-cli  /usr/local/bin/docker   /usr/local/bin/docker

# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
RUN apk add --update --no-cache \
  docker-compose \
  py-pip \
  python-dev \
  libffi-dev \
  openssl-dev \
  gcc \
  libc-dev \
  make \
  unzip \
  bash \
  curl

ENTRYPOINT ["/usr/bin/docker-compose"]
