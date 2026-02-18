# Clojure Endpoint — Howdy World

This endpoint demonstrates a minimal Clojure web application using:

- Clojure 1.11+
- Ring
- Compojure
- Jetty
- Leiningen
- Docker (dev + prod separation)

It follows Howdy World's endpoint conventions.

---

## Purpose

This endpoint exists to:

- Demonstrate a working Clojure service
- Showcase functional + immutable design
- Provide unit + integration test examples
- Explore JVM-hosted Lisp in a production-ready structure

---

## Architecture

- `homepage` — pure function (unit-test target)
- `app` — Ring handler (integration-test target)
- Jetty — embedded server
- Docker — containerized runtime

---

## Running

### Dev Mode

```bash
bin/run
```

then visit http://localhost:3000

### Prod Mode

```bash
bin/up
```

then visit http://localhost:3000
Hot reload via Lein.

Production Mode
```bash
bin/up
```

Runs standalone JAR via Docker.

Stop:
```bash
bin/down
```

Local (No Docker)

Install Leiningen:
```bash
brew install leiningen


Then:
```bash
lein run
```


Run tests:
```bash
lein test
```