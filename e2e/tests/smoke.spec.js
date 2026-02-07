// e2e/tests/smoke.spec.js
const fs = require("node:fs");
const path = require("node:path");
const { test, expect } = require("@playwright/test");

function loadManifest() {
    const p = path.join(__dirname, "..", "endpoints.json");
    return JSON.parse(fs.readFileSync(p, "utf8"));
}

function mergedDefaults(defaults, route) {
    // shallow merge for the common fields + nested merge for metadata
    const md = { ...(defaults.metadata || {}), ...(route.metadata || {}) };
    return { ...defaults, ...route, metadata: md };
}

function requireHowdy(meta, routeName) {
    const selector = meta.selector || "#howdyworld-metadata";
    return { selector, requiredKeys: meta.requiredKeys || [], routeName };
}

test.describe("Howdy World prod smoke", () => {
    const manifest = loadManifest();
    const baseUrl = manifest.baseUrl || "http://nginx";
    const defaults = manifest.defaults || {};

    for (const route of manifest.routes) {
        const cfg = mergedDefaults(defaults, route);

        test(`${cfg.name} ${cfg.path}`, async ({ page, request }, testInfo) => {
            const url = `${baseUrl}${cfg.path}`;

            // 1) HTTP-level check first (fast fail)
            const res = await request.get(url, { maxRedirects: 5 });
            expect(res.status(), `HTTP ${cfg.name} should return ${cfg.expectStatus}`).toBe(cfg.expectStatus);

            const body = await res.text();

            if (cfg.expectHowdyText) {
                expect(body, `${cfg.name} should include "${cfg.expectHowdyText}"`).toContain(cfg.expectHowdyText);
            }

            // If we don't need DOM checks or screenshots, we can stop here.
            const needsDom =
                cfg.expectH1 ||
                (cfg.metadata && cfg.metadata.enabled) ||
                cfg.screenshot;

            if (!needsDom) return;

            // 2) Browser-level checks
            await page.goto(url, { waitUntil: "domcontentloaded" });

            if (cfg.expectH1) {
                const h1 = page.locator("h1").first();
                await expect(h1, `${cfg.name} should have an H1`).toBeVisible();

                if (cfg.expectHowdyText) {
                    await expect(h1, `${cfg.name} H1 should include Howdy text`).toContainText(cfg.expectHowdyText);
                }
            }

            if (cfg.metadata && cfg.metadata.enabled) {
                const { selector, requiredKeys, routeName } = requireHowdy(cfg.metadata, cfg.name);

                const el = page.locator(selector).first();
                await expect(el, `${routeName} metadata element (${selector}) should exist`).toBeVisible();

                const raw = await el.textContent();
                let parsed;
                try {
                    parsed = JSON.parse(raw || "{}");
                } catch (e) {
                    throw new Error(`${routeName} metadata at ${selector} was not valid JSON`);
                }

                for (const key of requiredKeys) {
                    if (!(key in parsed)) {
                        throw new Error(`${routeName} metadata missing required key: ${key}`);
                    }
                }
            }

            if (cfg.screenshot) {
                const safeName = cfg.name.replace(/[^a-z0-9-_]/gi, "_");
                const outDir = path.join(__dirname, "..", "artifacts");
                fs.mkdirSync(outDir, { recursive: true });

                await page.setViewportSize({ width: 1280, height: 720 });
                await page.waitForTimeout(150); // tiny settle for fonts/layout

                await page.screenshot({
                    path: path.join(outDir, `${safeName}.png`),
                    fullPage: true
                });

                testInfo.attachments.push({
                    name: `${safeName}.png`,
                    path: path.join(outDir, `${safeName}.png`),
                    contentType: "image/png"
                });
            }
        });
    }
});
