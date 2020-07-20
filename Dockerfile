#
# Copyright (c) 2020
# Intel
#
# SPDX-License-Identifier: Apache-2.0
# 
#
FROM node:lts-alpine

LABEL license='SPDX-License-Identifier: Apache-2.0' \
  copyright='Copyright (c) 2019: Intel' \
  maintainer='EdgeX Foundry <edgex-devel@lists.edgexfoundry.org>'

RUN yarn global add --silent raml2html@3.0.1 \
  && yarn cache clean --silent

COPY ./scripts/raml-verify.sh /scripts/