FROM golang:1.25-alpine AS build

ARG TARGETPLATFORM

ENV GO111MODULE=on \
  CGO_ENABLED=0

RUN apk add --no-cache make

COPY . /k8s-hostdev-plugin

RUN cd /k8s-hostdev-plugin \
  && export GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) \
  && export GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
  && GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3); export GOARM=${GOARM:1} \
  && go mod download \
  && make bin \
  && chmod +x k8s-hostdev-plugin

FROM scratch

COPY --from=build /k8s-hostdev-plugin/k8s-hostdev-plugin /k8s-hostdev-plugin

ENTRYPOINT ["/k8s-hostdev-plugin"]
