# javascript-react/Dockerfile

# ---- build stage ----
FROM oven/bun:1.3.8 AS build

WORKDIR /app

COPY package.json bun.lock* ./
RUN bun install

COPY . .
RUN bun run build

# ---- runtime stage ----
FROM alpine:3.20 AS runtime

# lighttpd + basic certs for completeness
RUN apk add --no-cache lighttpd ca-certificates \
    && mkdir -p /run/lighttpd /var/log/lighttpd \
    && chown -R lighttpd:lighttpd /run/lighttpd /var/log/lighttpd

# Copy compiled static assets into a subfolder so alias.url can map /javascript-react
RUN mkdir -p /var/www/localhost/htdocs/javascript-react
COPY --from=build /app/dist /var/www/localhost/htdocs/javascript-react

# Lighttpd config
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

# was EXPOSE 5173
EXPOSE 8080

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
