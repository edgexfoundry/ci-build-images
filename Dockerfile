#
# Copyright (c) 2022
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#
FROM alpine:3.16

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2022: Intel'

RUN apk add --update --no-cache \
  git build-base cmake linux-headers \
  yaml yaml-dev libmicrohttpd-dev libcurl curl-dev \
  && apk upgrade