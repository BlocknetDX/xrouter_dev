# Pull down alpine
FROM alpine:latest

RUN apk add --no-cache ca-certificates nodejs npm && npm install web3

ADD . /

RUN mv /listener /usr/local/ && mv /listen /usr/local/bin && chmod +x /usr/local/bin/listen

EXPOSE 8545 8546 8547 30303 30303/udp
ENTRYPOINT ["listen"]
