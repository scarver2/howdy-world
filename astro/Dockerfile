FROM node:24-alpine AS build
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY astro.config.mjs ./
COPY src ./src
RUN npm run build

FROM alpine:3.20
RUN apk add --no-cache lighttpd ca-certificates \
  && mkdir -p /srv/www /var/cache/lighttpd/compress \
  && chown -R lighttpd:lighttpd /srv/www /var/cache/lighttpd
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=build --chown=lighttpd:lighttpd /app/dist/ /srv/www/
USER lighttpd
EXPOSE 8080
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
