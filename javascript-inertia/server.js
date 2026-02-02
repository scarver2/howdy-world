import express from "express";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static("public"));

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

    // First visit: HTML + data-page JSON boot payload
    const html = `<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Howdy from InertiaJS</title>
  </head>
  <body>
    <div id="app" data-page='${escapeHtml(JSON.stringify(inertiaPage))}'></div>
    <script type="module" src="/app.js"></script>
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

app.get("/", (req, res) => {
    respond(req, res, page(req, "Home", { message: "Howdy, World!" }));
});

app.listen(PORT, () => {
    console.log(`Running: http://localhost:${PORT}`);
});
