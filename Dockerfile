FROM docker.io/golang:1.25-alpine AS builder

RUN set -exu \
 && apk update \
 && apk add \
  --no-cache \
  make

RUN set -exu \
  && make bin

FROM scratch

COPY --from=builder k8s-hostdev-plugin /

ENTRYPOINT ["/k8s-hostdev-plugin"]
