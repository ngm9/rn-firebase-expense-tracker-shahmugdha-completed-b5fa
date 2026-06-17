#!/bin/bash
set -e

echo "[kill.sh] Stopping and removing containers..."
cd /root/task || true
docker-compose down --remove-orphans --volumes || true

echo "[kill.sh] Force removing firebase-emulator image..."
docker rmi -f andreysenov/firebase-tools || true

echo "[kill.sh] Running full Docker system prune..."
docker system prune -a --volumes -f || true

echo "[kill.sh] Removing /root/task directory..."
rm -rf /root/task || true

echo "[kill.sh] Cleanup complete."
