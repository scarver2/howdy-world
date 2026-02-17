# Howdy PHP

This is a simple PHP application that demonstrates the use of PHP as a web server.

## Usage

From the root of this repository, launch the Dockerized containers, then visit http://localhost.

```bash
docker-compose up --build
open http://howdy.localhost
```
The page will open with a list of endpoints of the currently supported languages, each clickable to demonstrate NGINX' reverse proxy functionality.
