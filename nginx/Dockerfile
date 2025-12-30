# Use the official, minimal NGINX image
FROM nginx:1.26-alpine

# Remove the default config to avoid conflicts
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy our opinionated NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy per-language reverse proxy configs
COPY conf.d/ /etc/nginx/conf.d/

# Copy the static dashboard
COPY www/ /usr/share/nginx/html/

# Expose HTTP
EXPOSE 80

# Run nginx in the foreground (Docker best practice)
CMD ["nginx", "-g", "daemon off;"]
