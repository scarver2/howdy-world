// javascript-react/vite.config.js
import { defineConfig } from "vitest/config";
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
    // Use happy-dom instead of jsdom to avoid the lru-cache issue
    environment: "happy-dom",

    // Setup file for @testing-library/jest-dom
    setupFiles: ["./src/setupTests.js"],

    // Enable globals (test, expect, describe, etc.)
    globals: true,

    // Coverage configuration (optional)
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      exclude: [
        "node_modules/",
        "src/setupTests.js",
      ],
    },
  },
}));
