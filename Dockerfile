FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app

RUN addgroup --system app && adduser --system --ingroup app app
COPY app.py ./app.py

USER app
EXPOSE 8080

CMD ["python3", "app.py"]
