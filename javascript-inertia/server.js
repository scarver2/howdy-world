import express from "express";

const app = express();
const PORT = process.env.PORT || 3000;
const BASE_PATH = (process.env.BASE_PATH || "/")
    .replace(/\/?$/, "/"); // ensure trailing slash

// Serve assets under BASE_PATH so /javascript-inertia/app.js works
app.use(BASE_PATH, express.static("public"));

function isInertia(req) {
    return String(req.get("X-Inertia") || "").toLowerCase() === "true";
}

function page(req, component, props = {}) {
    return {
        component,
        props: { errors: {}, ...props },
        url: req.originalUrl,
        version: "dev"
    };
}

function respond(req, res, inertiaPage) {
    if (isInertia(req)) {
        res.set("Vary", "X-Inertia");
        res.set("X-Inertia", "true");
        return res.json(inertiaPage);
    }

    const html = `<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Howdy from InertiaJS</title>
  </head>
  <body>
    <div id="app" data-page='${escapeHtml(JSON.stringify(inertiaPage))}'></div>
    <script type="module" src="${BASE_PATH}app.js"></script>
  </body>
</html>`;

    res.type("html").send(html);
}

function escapeHtml(str) {
    return str
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}

// Route lives at BASE_PATH (e.g. /javascript-inertia/)
app.get(BASE_PATH, (req, res) => {
    respond(req, res, page(req, "Home", { message: "Howdy, World!" }));
});

// (Optional) redirect /javascript-inertia -> /javascript-inertia/
app.get(BASE_PATH.replace(/\/$/, ""), (req, res) => {
    res.redirect(301, BASE_PATH);
});

app.listen(PORT, () => {
    console.log(`Running: http://localhost:${PORT}${BASE_PATH}`);
});
