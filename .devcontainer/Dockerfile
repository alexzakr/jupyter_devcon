FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/vscode/.ssh && chown -R vscode:vscode /home/vscode/.ssh

WORKDIR /workspace

RUN pip install --upgrade pip \
    && pip install --no-cache-dir jupyterlab notebook

# If requirements.txt exists in build context root
COPY requirements.txt /tmp/requirements.txt
RUN if [ -f /tmp/requirements.txt ]; then pip install -r /tmp/requirements.txt; fi

