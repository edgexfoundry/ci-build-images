#
# Copyright (c) 2019
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#
FROM hypriot/rpi-alpine

LABEL license='SPDX-License-Identifier: Apache-2.0' \
  copyright='Copyright (c) 2019: Intel'

LABEL maintainer="Sven Walther <sven@walther.world>"

ARG DOCKER_REGISTRY

FROM ${DOCKER_REGISTRY}/kong-arm-parent:82d4fd92b29024a3d5f3184c3100c58fb9e3e0ae as kong-arm-parent

# This layer contains all the components build from src like openssl, openresty, kong, etc
# We are pre-caching these components because they take over 2.5 hours to build
COPY --from=kong-arm-parent /usr/local /usr/local

RUN adduser -Su 1337 -g root kong \
  && apk add --no-cache --virtual .build-deps wget tar ca-certificates \
  && apk add --no-cache libgcc openssl pcre perl tzdata curl libcap su-exec

RUN	mkdir /tmp/openresty \
  && apk del .build-deps \
  && chown -R kong /usr/local/kong \
  && chgrp -R 0 /usr/local/kong \
  && chmod -R g=u /usr/local/kong

COPY docker-entrypoint.sh /docker-entrypoint.sh
USER kong

EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGTERM

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kong", "docker-start"]