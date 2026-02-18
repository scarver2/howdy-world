

# python-fastapi

## Run (venv)

python3 -m venv .venv
source .venv/bin/activate
python -m pip install -e ".[dev]"

uvicorn app.main:app --reload
# open http://127.0.0.1:8000/howdy

## Test

python -m pytest

