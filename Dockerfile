FROM golang:1.13-alpine as build-base

RUN go env -w GOPROXY=https://goproxy.cn,direct && go env && apk update && apk upgrade && \
    apk add --no-cache bash git openssh make
ADD . /go/src/github.com/travisjeffery/jocko
WORKDIR /go/src/github.com/travisjeffery/jocko
RUN GOOS=linux GOARCH=amd64 make build

FROM alpine:latest
COPY --from=build-base /go/src/github.com/travisjeffery/jocko/cmd/jocko/jocko /usr/local/bin/jocko
EXPOSE 9092 9093 9094 9095
VOLUME "/tmp/jocko"
CMD ["jocko", "broker"]
