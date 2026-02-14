# php/Dockerfile
FROM php:8.3-cli-alpine

WORKDIR /app
COPY . .

ENV PORT=8080
EXPOSE 8080

# Serve /app on :8080
CMD ["sh", "-lc", "php -S 0.0.0.0:${PORT} -t /app /app/index.php"]

