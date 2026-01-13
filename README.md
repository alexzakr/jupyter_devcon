  # Python + Jupyter DevContainer

  ## Overview

  This repository provides a **VS Code DevContainer** for Python development with support for **Jupyter Notebooks** via VS Code.

  The container is designed for:
  - data engineering and analytics work
  - exploratory analysis in Jupyter notebooks
  - reproducible local development
  - secure interaction with private Git repositories via SSH agent forwarding

  The container is **not** a production runtime image. It is a **development environment**, optimized for interactive work in VS Code.

  ---

  ## Key Characteristics

  - Python 3.12 (official VS Code DevContainers base image)
  - Jupyter notebooks available with manual startup
  - VS Code Jupyter and Python extensions preinstalled
  - SSH agent forwarding (no private keys stored in container)
  - Git user configuration via environment variables
  - Non-root user (`vscode`)
  - Designed for future extension (Docker networks, docker-compose, Airflow/dbt sidecars)

  ---

  ## Container Responsibilities

  This DevContainer is responsible for:
  - providing a consistent Python environment
  - supporting optional Jupyter notebook execution when explicitly started
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
  ├── start_jupyter.sh       # Jupyter notebooks startup script

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
  GIT_USER_NAME="Your Name"
  GIT_USER_EMAIL="your@email.com"
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

  SSH access is implemented using **SSH agent forwarding only**.

  Key principles:

  - private SSH keys are managed **exclusively on the host**
  - the container never mounts or stores SSH private keys
  - the container interacts only with the forwarded SSH agent socket

  ### macOS note
  On macOS, SSH agent forwarding may fail with mount config is invalid if SSH_AUTH_SOCK is not available at container startup.
  A recommended fix using localEnv is documented here: [docs/macos-ssh-agent.md]

  ### Multi-account GitHub workflow (host-driven)

  Switching between multiple GitHub accounts is handled **on the host**, before starting VS Code or the DevContainer.

  The container itself remains unchanged and always relies on the SSH agent.

  #### Bash aliases (host side)

  Add the following aliases to `~/.bashrc` (or equivalent shell config):

  ```bash
  # Switch SSH key for first GitHub account
  alias ssh_git_first='ssh-add -D >/dev/null 2>&1 && ssh-add ~/.ssh/ed25519_git_first_key'

  # Switch SSH key for second GitHub account
  alias ssh_git_second='ssh-add -D >/dev/null 2>&1 && ssh-add ~/.ssh/ed25519_git_second_key'
  ```

  Reload shell configuration:

  ```bash
  source ~/.bashrc
  ```

  Usage workflow:

  ```bash
  # Select the desired GitHub identity
  ssh_git_first   # or ssh_git_second

  # Start VS Code / Docker / DevContainer
  code .
  ```

  This approach ensures:
  - clean separation of responsibilities (host vs container)
  - no SSH key material inside containers
  - predictable GitHub identity selection
  - compatibility with CI and ephemeral containers

  ---

  ## Jupyter Notebook Behavior

  A standalone Jupyter Notebook server is not started automatically.

  This allows two equally supported workflows:

  - working purely in Python (scripts, REPL, tests)
  - running Jupyter Notebook only when it is explicitly needed

  ### Manual Jupyter startup

  From inside the container:

  ```bash
  bash .devcontainer/start_jupyter.sh
  ```

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

### 3. Working with Jupyter Notebooks

In this DevContainer, Jupyter is intended to be used **through VS Code**, not via a browser on the host.

To create and work with a Jupyter notebook:

1. Press `Ctrl + Shift + P` (or `Cmd + Shift + P` on macOS)
2. Select **`Jupyter: Create New Jupyter Notebook`**
3. Choose the Python kernel from the DevContainer environment

Notebooks will open and run **directly inside VS Code** using the Jupyter extension.

#### Important notes

- Jupyter is **not exposed to the host browser**
- There is no supported workflow to access Jupyter via `http://localhost:8888`
- All notebook interaction is expected to happen inside VS Code

This design keeps the DevContainer:
- simple and predictable
- aligned with VS Code workflows
- free from unnecessary port exposure


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
