#
# Copyright (c) 2020-2023
# Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

FROM golang:1.20.6-alpine3.17 as spire-base

RUN apk add --update --no-cache make git curl build-base linux-headers musl-dev

ARG SPIRE_RELEASE=1.6.3

# build spire from the source in order to be compatible with arch arm64 as well
WORKDIR /edgex-go/spire-build

RUN wget -q "https://github.com/spiffe/spire/archive/refs/tags/v${SPIRE_RELEASE}.tar.gz" && \
    tar xv --strip-components=1 -f "v${SPIRE_RELEASE}.tar.gz"

RUN echo "building spire from source..." && \
    go version | sed -n -e 's/.*go\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p' > .go-version && \
    make bin/spire-server bin/spire-agent && \
    cp bin/spire* /usr/local/bin/

FROM golang:1.20.6-alpine3.17

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020-2023: Intel Corporation'

ENV HADOLINT_VERSION=2.12.0 \
    GOLANGCI_VERSION=1.51.2

COPY ./.golangci.yml /etc/.golangci.yml

RUN if [ $(uname -m) == "x86_64" ]; then wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ; chmod +x /usr/local/bin/hadolint; fi

RUN apk add --update --no-cache make git curl bash zeromq-dev libsodium-dev pkgconfig build-base linux-headers musl-dev \
    && apk upgrade \
    && ln -s /bin/touch /usr/bin/touch \
    && wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v${GOLANGCI_VERSION}

COPY --from=spire-base /usr/local/bin/spire* /usr/local/bin/