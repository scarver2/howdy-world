# _infrastructure/proxy/nginx/Dockerfile
FROM nginx:alpine

# Remove default config
RUN rm -rf /etc/nginx/nginx.conf /etc/nginx/conf.d/*

# Copy Howdy World full configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy Howdy World endpoint configuration
COPY conf.d/ /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]