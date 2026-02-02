import { createApp, h } from "https://esm.sh/vue@3";
import { createInertiaApp } from "https://esm.sh/@inertiajs/vue3";

const pages = {
    Home: () => import("./Pages/Home.js")
};

createInertiaApp({
    resolve: async (name) => (await pages[name]()).default,
    setup({ el, App, props, plugin }) {
        createApp({ render: () => h(App, props) })
            .use(plugin)
            .mount(el);
    }
});
