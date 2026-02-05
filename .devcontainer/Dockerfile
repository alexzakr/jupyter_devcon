FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

# Remove broken Yarn repository (not needed for Python/Jupyter)
RUN rm -f /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN pip install --upgrade pip \
    && pip install --no-cache-dir jupyterlab notebook

# Install Python dependencies if requirements.txt exists
COPY requirements.txt /tmp/requirements.txt
RUN if [ -f /tmp/requirements.txt ]; then pip install -r /tmp/requirements.txt; fi


