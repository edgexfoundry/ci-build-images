#
# Copyright (c) 2020-2023 Intel Corporation
# Copyright (c) 2024-2025 IOTech Ltd
#
# SPDX-License-Identifier: Apache-2.0
#
FROM golang:1.23-alpine3.20

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020-2023: Intel Corporation'

ENV HADOLINT_VERSION=2.12.0 \
    GOLANGCI_VERSION=1.61.0

COPY ./.golangci.yml /etc/.golangci.yml

RUN if [ $(uname -m) == "x86_64" ]; then wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ; chmod +x /usr/local/bin/hadolint; fi

RUN apk add --update --no-cache make git curl bash pkgconfig build-base linux-headers musl-dev zeromq-dev \
    && apk upgrade \
    && ln -s /bin/touch /usr/bin/touch \
    && wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v${GOLANGCI_VERSION}

RUN go install github.com/gotesttools/gotestfmt/v2/cmd/gotestfmt@latest
