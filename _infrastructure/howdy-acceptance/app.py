# _infrastructure/howdy-acceptance/app.py
"""Disposable HTTP fixture. Only the private root endpoint is served."""
import os
import sqlite3
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

TOKEN = Path("/fixture/token").read_text().strip()


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/":
            self.send_error(404)
            return
        with sqlite3.connect("/state/worker.db") as db:
            token, identity = db.execute("select token, identity from marker").fetchone()
            body = f"{token} {identity}".encode()
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    os.umask(0o077)
    with sqlite3.connect("/state/worker.db") as db:
        db.execute("create table if not exists marker (id integer primary key, token text, identity text)")
        db.execute("insert or ignore into marker values (1, ?, ?)", (TOKEN, uuid.uuid4().hex))
        if db.execute("select token from marker").fetchone() != (TOKEN,):
            raise SystemExit("database belongs to another fixture")
    ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
