#!/usr/bin/env bash
set -euo pipefail

URL="${1:-}"

if [ -z "$URL" ]; then
  echo "Uso: ./scripts/smoke_test.sh <url>"
  exit 2
fi

echo "[smoke] Probando: $URL"

for i in {1..15}; do
  if curl -fsS "$URL" >/dev/null; then
    echo "[smoke] OK (200)"
    exit 0
  fi
  echo "[smoke] esperando... intento $i/15"
  sleep 2
done

echo "[smoke] FAIL: no respondió OK a tiempo"
exit 1

