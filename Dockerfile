#
# Copyright (c) 2020-2023 Intel Corporation
# Copyright (c) 2024-2026 IOTech Ltd
#
# SPDX-License-Identifier: Apache-2.0
#
ARG GOLANGCI_VERSION=2.5.0

FROM golangci/golangci-lint:v${GOLANGCI_VERSION}-alpine AS golangci-lint

FROM golang:1.25-alpine3.22

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020-2023: Intel Corporation' \
      copyright='Copyright (c) 2024-2026: IOTech Ltd'

ENV HADOLINT_VERSION=2.12.0

COPY ./.golangci.yml /etc/.golangci.yml

COPY --from=golangci-lint /usr/bin/golangci-lint /usr/local/bin/golangci-lint

RUN if [ $(uname -m) == "x86_64" ]; then wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ; chmod +x /usr/local/bin/hadolint; fi

RUN apk add --update --no-cache make git curl bash pkgconfig build-base linux-headers musl-dev zeromq-dev \
    && apk upgrade \
    && ln -s /bin/touch /usr/bin/touch

RUN go install github.com/gotesttools/gotestfmt/v2/cmd/gotestfmt@latest
