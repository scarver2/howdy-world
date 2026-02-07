# e2e/Dockerfile
FROM mcr.microsoft.com/playwright:v1.50.0-jammy

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY playwright.config.js ./playwright.config.js
COPY endpoints.json ./endpoints.json
COPY tests ./tests

# artifacts volume is mounted by compose
CMD ["npx", "playwright", "test"]
