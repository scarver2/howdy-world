# caddy/Dockerfile

FROM caddy:2-alpine

WORKDIR /srv

# Copy static files
COPY public/ /srv/

# Copy Caddy config
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 8080
