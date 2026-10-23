# Aşama 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /build
COPY app/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Aşama 2: Sıkılaştırılmış (Hardened) Final İmajı
FROM python:3.11-slim

# Güvenlik güncellemelerini uygula ve gereksiz önbelleği temizle
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# [TEST 4 - CONTAINER SECURITY]: Konteyneri root olarak çalıştırmak güvenlik kapısını kırar.
# Bu yüzden kısıtlı yetkiye sahip 'appuser' oluşturuyoruz:
RUN groupadd -r appgroup && useradd -r -g appgroup -d /app -s /sbin/nologin appuser

WORKDIR /app
COPY --from=builder /install /usr/local
COPY --chown=appuser:appgroup app/ /app/

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]