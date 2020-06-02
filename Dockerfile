ARG DOCKER_VERSION=19.03.5
ARG PYTHON_VERSION=3.7.5
ARG BUILD_ALPINE_VERSION=3.10
ARG RUNTIME_ALPINE_VERSION=3.10.3
ARG COMPOSE_TAG=1.25.4

FROM docker:${DOCKER_VERSION} AS docker-cli

FROM python:${PYTHON_VERSION}-alpine${BUILD_ALPINE_VERSION} AS build

RUN apk add --no-cache \
    bash \
    build-base \
    ca-certificates \
    curl \
    gcc \
    git \
    libc-dev \
    libffi-dev \
    libgcc \
    make \
    musl-dev \
    openssl \
    openssl-dev \
    python2 \
    python2-dev \
    zlib-dev
ENV BUILD_BOOTLOADER=1

COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker

WORKDIR /code/

ARG COMPOSE_TAG
RUN git clone --branch ${COMPOSE_TAG} --quiet --recurse-submodules https://github.com/docker/compose.git .

# FIXME(chris-crone): virtualenv 16.3.0 breaks build, force 16.2.0 until fixed
RUN pip install virtualenv==16.2.0
RUN pip install tox==2.9.1

RUN tox --notest
ARG GIT_COMMIT=unknown
ENV DOCKER_COMPOSE_GITSHA=$GIT_COMMIT
RUN script/build/linux-entrypoint
RUN cp docker-compose-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["sh", "/usr/local/bin/docker-compose-entrypoint.sh"]

FROM alpine:${RUNTIME_ALPINE_VERSION} AS runtime
ARG COMPOSE_TAG
RUN wget https://raw.githubusercontent.com/docker/compose/${COMPOSE_TAG}/docker-compose-entrypoint.sh
RUN cp docker-compose-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["sh", "/usr/local/bin/docker-compose-entrypoint.sh"]
COPY --from=docker-cli  /usr/local/bin/docker           /usr/local/bin/docker
COPY --from=build       /usr/local/bin/docker-compose   /usr/local/bin/docker-compose
