#
# Copyright (c) 2020
# Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

FROM golang:1.16.5-alpine3.13

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020: Intel Corporation'

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories

ENV HADOLINT_VERSION=2.6.0

ADD https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 /usr/local/bin/hadolint

RUN apk add --update --no-cache git linux-headers make gcc musl-dev curl bash \
  && chmod +x /usr/local/bin/hadolint

