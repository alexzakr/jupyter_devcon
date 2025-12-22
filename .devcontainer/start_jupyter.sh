#!/usr/bin/env bash
set -euo pipefail

# Start JupyterLab only if it is not already running
if pgrep -f "jupyter-lab" >/dev/null 2>&1; then
  exit 0
fi

PORT="${JUPYTER_PORT:-8888}"
TOKEN="${JUPYTER_TOKEN:-dev}"

mkdir -p /workspace/.jupyter-runtime

nohup jupyter lab \
  --ip=0.0.0.0 \
  --port="${PORT}" \
  --no-browser \
  --ServerApp.token="${TOKEN}" \
  --ServerApp.allow_origin="*" \
  --ServerApp.root_dir="/workspace" \
  > /workspace/.jupyter-runtime/jupyter.log 2>&1 &
