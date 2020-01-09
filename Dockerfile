#
# Copyright (c) 2020
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#

FROM maven:3.6.3-jdk-8

ARG HTTPS_PROXY=""
ARG PROXY_HOST=""
ARG PROXY_PORT=""

ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV PROXY_HOST=${PROXY_HOST}
ENV PROXY_PORT=${PROXY_PORT}

RUN mkdir /edgex-global-pipelines

WORKDIR /edgex-global-pipelines

RUN curl -O https://raw.githubusercontent.com/edgexfoundry/edgex-global-pipelines/master/pom.xml
COPY settings.xml /root/.m2/settings.xml

RUN mvn dependency:resolve

CMD [ "mvn", "clean", "test" ]
