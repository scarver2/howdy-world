# javascript-react/Dockerfile
FROM oven/bun:1.3.8

WORKDIR /app

COPY package.json bun.lockb* ./
RUN bun install

COPY . .

EXPOSE 5173

# Default to dev; compose overrides this for the production build container
CMD ["bun", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
