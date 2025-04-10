FROM python:3.12-slim

WORKDIR /app

# Устанавливаем системные зависимости, необходимые для Playwright
RUN apt-get update && apt-get install -y \
    gcc \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libdbus-1-3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libxkbcommon0 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install playwright && playwright install-deps && playwright install

COPY . .

ENV PYTHONUNBUFFERED=1 \
    FLASK_ENV=production \
    PORT=8000

EXPOSE 8000

CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:6000", "app:app"]
