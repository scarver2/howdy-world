# __ENDPOINT__/Dockerfile
FROM alpine:3.20
RUN apk add --no-cache lighttpd
COPY index.html /var/www/localhost/htdocs/index.html
EXPOSE 3000
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
