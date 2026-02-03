import { h } from "https://esm.sh/vue@3";

export default {
    props: { message: String },
    render() {
        return h("h1", this.message || "Howdy, World!");
    }
};
