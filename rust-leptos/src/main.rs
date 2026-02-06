use axum::{response::Html, routing::get, Router};
use leptos::prelude::*;

async fn howdy() -> Html<String> {
    // Render a Leptos view to an HTML string (SSR-only, no client hydration).
    let html = leptos::ssr::render_to_string(|| {
        view! {
            <main style="font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; padding: 2rem;">
                <h1>"Howdy, World!"</h1>
                <p>"Rust + Leptos (SSR) behind NGINX at /rust-leptos/"</p>
            </main>
        }
    });

    Html(html)
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(howdy));

    let addr = "0.0.0.0:3000";
    println!("rust-leptos listening on http://{addr}");

    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
