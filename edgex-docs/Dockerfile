#
# Copyright (c) 2019
# Intel
#
# SPDX-License-Identifier: Apache-2.0
# 
# Migrated from https://github.com/edgexfoundry/edgex-docs/blob/master/Dockerfile.build
#
FROM ubuntu:16.04

LABEL license='SPDX-License-Identifier: Apache-2.0' \
  copyright='Copyright (c) 2019: Intel' \
  maintainer='EdgeX Foundry <edgex-devel@lists.edgexfoundry.org>'

RUN apt-get update && apt-get dist-upgrade -y && \
  apt-get install -y git python-pip latexmk texlive-latex-recommended \
  texlive-latex-extra texlive-fonts-recommended nodejs npm \
  make linkchecker wget curl
RUN apt-get install -y --no-install-recommends texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN pip install sphinx==1.7.9 sphinxcontrib-googleanalytics==0.1
RUN npm i -g raml2html@3.0.1

RUN mkdir docbuild
WORKDIR /docbuild