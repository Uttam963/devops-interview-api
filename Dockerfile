FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && groupadd --gid 10001 appgroup \
    && useradd --uid 10001 \
               --gid 10001 \
               --no-create-home \
               --shell /usr/sbin/nologin \
               appuser

COPY --chown=10001:10001 app.py .

USER 10001:10001

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "2", "app:app"]