FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Build deps for bcrypt / aiomysql wheels, plus Noto fonts so the localized
# PDF can render Indic scripts (Gujarati/Devanagari/Tamil/Telugu/Kannada/
# Malayalam/Bengali/Gurmukhi/Oriya). fonts-noto-core carries the Sans faces the
# PDF registers per language; without them Indic text would be blank boxes.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential default-libmysqlclient-dev pkg-config \
    fonts-noto-core \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
