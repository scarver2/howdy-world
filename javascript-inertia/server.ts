import express, { type Request, type Response } from "express";
import { type InertiaPage, type InertiaProps } from "./types.js";

// type InertiaPage = {
//     component: string;
//     props: Record<string, unknown>;
//     url: string;
//     version: string;
// };

const app = express();

// const PORT: number = process.env.PORT ? Number(process.env.PORT) : 3000;
const PORT = Number.parseInt(process.env.PORT || "3000", 10);

const BASE_PATH: string = (process.env.BASE_PATH || "/").replace(/\/?$/, "/"); // ensure trailing slash

// Serve assets under BASE_PATH so /javascript-inertia/app.js works
app.use(BASE_PATH, express.static("public"));

function isInertia(req: Request): boolean {
    return String(req.get("X-Inertia") || "").toLowerCase() === "true";
}

function page(
    req: Request,
    component: string,
    props: Omit<InertiaProps, "errors"> = {}
): InertiaPage {
    return {
        component,
        props: { errors: {}, ...props },
        url: req.originalUrl,
        version: "dev"
    };
}

function respond(req: Request, res: Response, inertiaPage: InertiaPage) {
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

function escapeHtml(str: string): string {
    return str
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}

// Route lives at BASE_PATH (e.g. /javascript-inertia/)
app.get(BASE_PATH, (req: Request, res: Response) => {
    respond(req, res, page(req, "Home", { message: "Howdy, World!" }));
});

// (Optional) redirect /javascript-inertia -> /javascript-inertia/
app.get(BASE_PATH.replace(/\/$/, ""), (req: Request, res: Response) => {
    res.redirect(301, BASE_PATH);
});

app.listen(PORT, () => {
    console.log(`Running: http://localhost:${PORT}${BASE_PATH}`);
});
