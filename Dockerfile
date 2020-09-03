#
# Copyright (c) 2020
# Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

FROM golang:1.15.1-alpine

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2020: Intel Corporation'

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories

RUN apk add --update --no-cache git linux-headers make gcc musl-dev curl bash