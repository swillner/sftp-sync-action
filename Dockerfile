FROM alpine

RUN apk update && \
    apk upgrade && \
    apk add lftp openssh-client && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
