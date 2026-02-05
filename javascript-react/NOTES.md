# React 19 Notes

## Prerequisities

```bash
bun -version
````

## App creation

```bash
bun create vite javascript-react --template react
cd react-vite-bun
bun install
````

## Production build
```bash
bun run build
bun run preview
```
then visit http://localhost:4173



Tooling: Vite + Bun

Scaffold: bun create vite <name> --template react
│  Use rolldown-vite (Experimental)?:
│  No
│
◇  Install with bun and start now?
│  Yes

or to use TypeScript

Scaffold: bun create vite <name> --template react-ts

Install: bun install

Run: bun run dev

Build/serve: bun run build && bun run preview

React version verification: bun pm ls react react-dom
