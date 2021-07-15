#
# Copyright (c) 2021
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#
FROM alpine:3.12

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2021: Intel'

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories

RUN apk add --update --no-cache \
  git build-base cmake linux-headers \
  yaml yaml-dev libmicrohttpd-dev libcurl curl-dev