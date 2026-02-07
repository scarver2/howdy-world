// rust-leptos/src/main.rs
use leptos::prelude::*;

fn main() {
    leptos::mount::mount_to_body(
        || view! { <h1>"Howdy, World!"</h1> }
    )
}

// <!-- Optional mount point for app-->
// <div id="app"></div>
// fn main() {
//     leptos::mount::mount_to(
//         || document().get_element_by_id("app").unwrap(),
//         || view! { <h1>"Howdy, World!"</h1> },
//     );
// }
