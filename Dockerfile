#
# Copyright (c) 2020
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#
FROM golang:1.15-alpine

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2019: Intel'

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories

ARG SNYK_VERSION=1.419.1
ENV SNYK_VERSION=${SNYK_VERSION}

COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/docker
RUN apk add --update --no-cache git gcc libc-dev expect \
  && wget https://github.com/snyk/snyk/releases/download/v${SNYK_VERSION}/snyk-alpine -O /usr/local/bin/snyk \
  && chmod +x /usr/local/bin/snyk
ENV GO111MODULE=on

ENTRYPOINT [ "snyk" ]
CMD [ "monitor" ]
