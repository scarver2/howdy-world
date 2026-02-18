# python-fastapi/Dockerfile

FROM python:3.14-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000 \
    HOST=0.0.0.0

RUN python -m pip install --no-cache-dir -U pip \
    && python -m pip install --no-cache-dir "fastapi>=0.110" "uvicorn[standard]>=0.27"

COPY app ./app

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
