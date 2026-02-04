![Howdy World](https://raw.githubusercontent.com/scarver2/howdy-world/main/nginx/www/howdy-world.png)

# Howdy World

Howdy World is a web server demonstration of many software languages and frameworks. It uses NGINX as a reverse-proxy and Docker for deployment. It's _Hello World_ Texas-style!

## Usage

From the root of this repository, launch the Dockerized containers, then visit http://localhost.

```bash
docker-compose up --build
open http://localhost
```
The page will open with a list of endpoints of the currently supported languages, each clickable to demonstrate NGINX' reverse proxy functionality.

### Supported Languages and Frameworks.

* [Go](./go)
* [JavaScript](./javascript)
    * [Inertia](./javascript-inertia)
    * [jQuery](./javascript-jquery)
    * [Stimulus](./javascript-stimulus)
    * [Vue](./javascript-vue)
* [NGINX](./nginx) (static HTML file)
* [Ruby](./ruby)
    * [Ruby on Rails](./ruby-on-rails)
* [Zig](./zig)

&copy;2026 [Stan Carver II](http://stancarver.com)

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/main/nginx/www/made-in-texas.png)
