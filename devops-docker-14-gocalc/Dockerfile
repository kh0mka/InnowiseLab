FROM golang:1.19.1-alpine

ENV GO111MODULE=auto
ENV GOPATH=/root/go
ENV GOBIN=$GOPATH/bin

WORKDIR $GOPATH

COPY main.go .

RUN apk add git \
    && go get \
    && go build -o /bin/app main.go

FROM alpine:3.10.3

WORKDIR /bin

COPY --from=0 /bin/app .

ENTRYPOINT ["./app"]
