FROM golang:1.14-alpine AS build

ARG TARGETPLATFORM

ENV GO111MODULE=on \
    CGO_ENABLED=0

RUN apk add --no-cache git

WORKDIR /go/src/github.com/billimek/k8s-hostdev-plugin

RUN export GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) && \
    export GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) && \
    GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3); export GOARM=${GOARM:1} && \
    git clone --depth 1 https://github.com/billimek/k8s-hostdev-plugin.git . && \
    go build -o k8s-hostdev-plugin -a -ldflags '-extldflags "-static"' main.go server.go watcher.go && \
    chmod +x /go/src/github.com/billimek/k8s-hostdev-plugin/k8s-hostdev-plugin

FROM scratch

COPY --from=build /go/src/github.com/billimek/k8s-hostdev-plugin/k8s-hostdev-plugin /k8s-hostdev-plugin

ENTRYPOINT ["/k8s-hostdev-plugin"]
