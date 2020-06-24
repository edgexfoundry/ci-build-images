FROM alpine:3.11
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
