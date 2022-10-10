#
# Copyright (c) 2020-2022
# Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

FROM golang:1.18.7-alpine3.16 as spire-base

RUN apk add --update --no-cache make git curl build-base linux-headers musl-dev

ARG SPIRE_RELEASE=1.3.1

# build spire from the source in order to be compatible with arch arm64 as well
WORKDIR /edgex-go/spire-build

RUN wget -q "https://github.com/spiffe/spire/archive/refs/tags/v${SPIRE_RELEASE}.tar.gz" && \
    tar xv --strip-components=1 -f "v${SPIRE_RELEASE}.tar.gz"

RUN echo "building spire from source..." && \
    make bin/spire-server bin/spire-agent && \
    cp bin/spire* /usr/local/bin/

FROM golang:1.18.7-alpine3.16

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020-2022: Intel Corporation'

ENV HADOLINT_VERSION=2.10.0 \
    GOLANGCI_VERSION=1.46.2

COPY ./.golangci.yml /etc/.golangci.yml

RUN if [ $(uname -m) == "x86_64" ]; then wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ; chmod +x /usr/local/bin/hadolint; fi

RUN apk add --update --no-cache make git curl bash zeromq-dev libsodium-dev pkgconfig build-base linux-headers musl-dev \
    && ln -s /bin/touch /usr/bin/touch \
    && wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v${GOLANGCI_VERSION}

COPY --from=spire-base /usr/local/bin/spire* /usr/local/bin/