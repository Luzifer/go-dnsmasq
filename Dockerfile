FROM golang:alpine as builder

ADD . /go/src/github.com/Luzifer/go-dnsmasq
WORKDIR /go/src/github.com/Luzifer/go-dnsmasq

RUN set -ex \
 && apk add --update git \
 && go install -ldflags "-X main.version=$(git describe --tags || git rev-parse --short HEAD || echo dev)"

FROM alpine:latest

ENV DNSMASQ_LISTEN=0.0.0.0

LABEL maintainer "Knut Ahlers <knut@ahlers.me>"

RUN set -ex \
 && apk --no-cache add ca-certificates

COPY --from=builder /go/bin/go-dnsmasq /usr/local/bin/go-dnsmasq

EXPOSE 53 53/udp

ENTRYPOINT ["/usr/local/bin/go-dnsmasq"]
CMD ["--"]

# vim: set ft=Dockerfile:
