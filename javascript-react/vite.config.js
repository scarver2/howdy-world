// javascript-react/vite.config.js
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => ({
  // Dev: serve at "/" (e.g., http://localhost:5173/)
  // Prod: build for "/javascript-react/" (served by nginx at http://localhost/javascript-react/)
  base: mode === "production" ? "/javascript-react/" : "/",
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    strictPort: true,
  },
  test: {
    environment: "jsdom",
    setupFiles: "./src/setupTests.js",
    globals: true
  }
}));
