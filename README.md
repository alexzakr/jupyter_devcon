# Python + Jupyter DevContainer

## Overview

This repository provides a **VS Code DevContainer** for Python development with **JupyterLab** as the primary runtime service.

The container is designed for:
- data engineering and analytics work
- exploratory analysis in Jupyter notebooks
- reproducible local development
- secure interaction with private Git repositories via SSH agent forwarding

The container is **not** a production runtime image. It is a **development environment**, optimized for interactive work in VS Code.

---

## Key Characteristics

- Python 3.12 (official VS Code DevContainers base image)
- JupyterLab started automatically on container start
- VS Code Jupyter and Python extensions preinstalled
- SSH agent forwarding (no private keys stored in container)
- Git user configuration via environment variables
- Non-root user (`vscode`)
- Designed for future extension (Docker networks, docker-compose, Airflow/dbt sidecars)

---

## Container Responsibilities

This DevContainer is responsible for:
- providing a consistent Python environment
- running JupyterLab as a background service
- exposing Jupyter on a fixed internal port (`8888`)
- integrating cleanly with VS Code port forwarding

It deliberately does **not**:
- expose ports via `docker run -p`
- manage external services (databases, message queues)
- embed secrets or SSH private keys

---

## Repository Structure

```text
.devcontainer/
├── devcontainer.json      # VS Code DevContainer configuration
├── Dockerfile             # Container image definition
├── start_jupyter.sh       # JupyterLab startup script
.env.example               # Environment variables template
requirements.txt           # Python dependencies (optional)
```

---

## Prerequisites

On the host machine:

- Docker (recent version)
- VS Code
- VS Code extensions:
  - Remote Development (Dev Containers)
- SSH agent running on the host
- GitHub SSH keys loaded into the agent (`ssh-add -l`)

---

## Environment Variables

The container reads variables from a `.env` file located at the repository root.

### Required variables

```env
GIT_USER_NAME=Your Name
GIT_USER_EMAIL=your@email.com
```

### Optional variables

```env
JUPYTER_PORT=8888
JUPYTER_TOKEN=dev
```

Notes:
- `.env` should **not** be committed
- use `.env.example` as a template

---

## SSH and GitHub Access

SSH access is implemented via **agent forwarding**:

- the host SSH agent socket is mounted into the container
- `~/.ssh/config` and `known_hosts` are mounted read-only
- private keys never leave the host

This setup supports:
- multiple GitHub accounts
- private repositories
- secure, enterprise-grade workflows

---

## JupyterLab Behavior

- JupyterLab is started automatically on container start
- listens on `0.0.0.0:${JUPYTER_PORT}` (default: 8888)
- logs are written to:

```text
/workspace/.jupyter-runtime/jupyter.log
```

Port access is handled by **VS Code port forwarding**, not Docker port publishing.

---

## How to Use

### 1. Prepare environment

```bash
cp .env.example .env
# edit .env with your values
```

Ensure your SSH agent is running and has the correct keys loaded:

```bash
ssh-add -l
```

---

### 2. Open in DevContainer

From VS Code:

1. Open the repository
2. `Cmd/Ctrl + Shift + P`
3. `Dev Containers: Reopen in Container`

The container will build and start automatically.

---

### 3. Access Jupyter

After startup:

- Open the **Ports** tab in VS Code
- Port `8888` will be forwarded automatically
- Use "Open in Browser" or VS Code Jupyter integration

---

## Extensibility Notes

This DevContainer is intentionally designed to be extended:

- add `docker-compose.yml` for additional services
- attach databases or message brokers via Docker networks
- reuse the image in CI pipelines
- run Jupyter as a sidecar in larger development stacks

No assumptions are baked in that would block future growth.

---

## License

This project is released under the **MIT License**.

Copyright (c) 2025 Aleksy Zakrzewski

You are free to:
- use
- copy
- modify
- merge
- publish
- distribute
- sublicense

With no warranty and no restrictions beyond attribution.

---

## Possible Future Additions (Please Confirm)

The following sections can be added if you find them useful:

- Architecture diagram (DevContainer + future services)
- Security model (SSH, secrets, isolation)
- Recommended VS Code settings
- Docker Compose integration guide
- CI usage example

