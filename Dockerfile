#
# Copyright (c) 2019-2022 Intel Corporation
# Copyright (c) 2024 IOTech Ltd
#
# SPDX-License-Identifier: Apache-2.0
#
FROM golang:1.23-alpine3.20

LABEL license='SPDX-License-Identifier: Apache-2.0' \
    copyright='Copyright (c) 2019-2022: Intel'

ARG SNYK_VERSION=1.1293.1
ENV SNYK_VERSION=${SNYK_VERSION}

COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/docker
RUN apk add --update --no-cache git gcc libc-dev expect nodejs npm \
  && wget https://github.com/snyk/snyk/releases/download/v${SNYK_VERSION}/snyk-alpine -O /usr/local/bin/snyk \
  && chmod +x /usr/local/bin/snyk \
  && npm i -g snyk-to-html
ENV GO111MODULE=on

ENTRYPOINT [ "snyk" ]
CMD [ "monitor" ]
