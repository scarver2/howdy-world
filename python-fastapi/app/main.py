# python-fastapi/app/main.py
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
# from fastapi.staticfiles import StaticFiles

app = FastAPI(title="Howdy World")

HOWDY_HTML = """<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Howdy from Python FastAPI</title>
</head>
<body>
  <h1>Howdy, World!</h1>
</body>
</html>
"""

@app.get("/", response_class=HTMLResponse)
def root():
    return HOWDY_HTML

# app.mount("/", StaticFiles(directory="public", html=True), name="public")
