# javascript-inertia/Dockerfile
FROM node:20-alpine

WORKDIR /app

# Install deps first (better layer caching)
COPY package*.json ./
RUN npm ci --omit=dev || npm install --omit=dev

# Copy the app
COPY . .

ENV NODE_ENV=production
ENV PORT=3000
ENV BASE_PATH=/javascript-inertia/

EXPOSE 3000

CMD ["node", "server.js"]
