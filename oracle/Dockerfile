# Pull down alpine
FROM alpine:latest

RUN apk add --no-cache ca-certificates nodejs npm && npm install web3

ADD . /

RUN mv /js /usr/local/ && mv /initialize /usr/local/bin && mv /listen /usr/local/bin && mv /respond /usr/local/bin && chmod +x /usr/local/bin/initialize && chmod +x /usr/local/bin/listen && chmod +x /usr/local/bin/respond


EXPOSE 8545 8546 8547 30303 30303/udp
ENTRYPOINT ["initialize" "listen"]
