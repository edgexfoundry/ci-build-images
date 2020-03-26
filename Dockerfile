#
# Copyright (c) 2020
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#

FROM gradle:6.2 as builder

LABEL license='SPDX-License-Identifier: Apache-2.0' \
  copyright='Copyright (c) 2020: Intel'

WORKDIR /code
ENV USER_GRADLE_HOME=/gradleCache
ARG EGP_VERSION=stable

# The workspace needs to contain all the source code in edgex-global-pipelines
# It is only used to force the download of dependencies. The build.gradle
# file is not sufficient
ADD https://github.com/edgexfoundry/edgex-global-pipelines/archive/${EGP_VERSION}.tar.gz .
RUN tar -xzf ${EGP_VERSION}.tar.gz \
  && mv edgex-global-pipelines-${EGP_VERSION}/* . \
  && rm -rf edgex-global-pipelines-${EGP_VERSION} \
  && rm -rf ${EGP_VERSION}.tar.gz
RUN gradle -Dgradle.user.home=${USER_GRADLE_HOME} testClasses

# Only copy the .gradle where all the dependencies are
FROM gradle:6.2
ENV USER_GRADLE_HOME=/gradleCache
COPY --from=builder ${USER_GRADLE_HOME} ${USER_GRADLE_HOME}
