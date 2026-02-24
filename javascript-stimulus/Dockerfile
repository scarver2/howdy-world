# javascript-stimulus/Dockerfile
FROM alpine:3.20

RUN apk add --no-cache lighttpd ca-certificates \
  && mkdir -p /srv/www /var/cache/lighttpd/compress \
  && chown -R lighttpd:lighttpd /srv/www /var/cache/lighttpd

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY . /srv/javascript-jquery/

EXPOSE 8080
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
