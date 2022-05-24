FROM golang:1.17-alpine3.15 as builder

ARG SPIRE_RELEASE=1.2.1

RUN sed -e 's/dl-cdn[.]alpinelinux.org/nl.alpinelinux.org/g' -i~ /etc/apk/repositories

RUN apk add --update --no-cache make git build-base curl

# build spire from the source in order to be compatible with arch arm64 as well
WORKDIR /edgex-go/spire-build

RUN wget -q "https://github.com/spiffe/spire/archive/refs/tags/v${SPIRE_RELEASE}.tar.gz" && \
    tar xv --strip-components=1 -f "v${SPIRE_RELEASE}.tar.gz"

RUN echo "building spire from source..." && \
    make bin/spire-server bin/spire-agent

FROM alpine:3.15

COPY --from=builder /edgex-go/spire-build/bin/spire-server /usr/local/bin/spire-server
COPY --from=builder /edgex-go/spire-build/bin/spire-agent /usr/local/bin/spire-agent