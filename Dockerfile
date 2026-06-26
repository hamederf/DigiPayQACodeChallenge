# ── Stage 1: base ────────────────────────────────────────────────────────────
FROM python:3.12-slim AS base

# Install system dependencies required by Playwright's Chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0  \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1      \
    libxfixes3 libxrandr2 libgbm1 libasound2                       \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ── Stage 2: dependencies ──────────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers (Chromium only — keeps image small)
RUN python -m Browser.entry init

# ── Stage 3: copy project ──────────────────────────────────────────────────
COPY . .

# Create reports directory
RUN mkdir -p reports/screenshots

# ── Runtime ────────────────────────────────────────────────────────────────
# Default: run all tests headless, generate HTML + XML reports
CMD ["robot", \
     "--outputdir", "reports", \
     "--loglevel", "INFO", \
     "tests/"]
