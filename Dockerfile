FROM docker.io/alpine:3 AS builder

RUN set -exu \
 && apk update \
 && apk add \
  --no-cache \
  git \
  make \
  musl-dev \
  go

RUN set -exu \
  && make bin

FROM scratch

COPY --from=builder k8s-hostdev-plugin /

ENTRYPOINT ["/k8s-hostdev-plugin"]
