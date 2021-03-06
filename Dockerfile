FROM golang:1.11 as builder

WORKDIR /ethereum_exporter
COPY . .

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -ldflags '-s -w' github.com/pmitra43/geth-prometheus-exporter/cmd/ethereum_exporter

FROM ubuntu:xenial

USER nobody
EXPOSE 9368

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /ethereum_exporter/ethereum_exporter /ethereum_exporter

ENTRYPOINT ["/ethereum_exporter"]