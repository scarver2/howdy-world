// e2e/playwright.config.js
const { defineConfig } = require("@playwright/test");

module.exports = defineConfig({
    testDir: "./tests",
    timeout: 60_000,
    expect: { timeout: 10_000 },
    retries: 0,
    reporter: [["list"]],
    use: {
        headless: true,
        trace: "retain-on-failure"
    },
    outputDir: "./artifacts"
});
