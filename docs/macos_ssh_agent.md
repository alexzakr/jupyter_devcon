# macOS: SSH Agent Forwarding in DevContainer

This document describes a common SSH agent issue on **macOS** when using VS Code DevContainers and explains the recommended fix.

---

## Problem

On macOS, the DevContainer may fail to start with the following error:

```
A mount config is invalid
```

This usually happens when mounting the SSH agent socket:

```json
"source=${env:SSH_AUTH_SOCK},target=/ssh-agent,type=bind"
```

---

## Root Cause

`SSH_AUTH_SOCK` is a path to the SSH agent socket on the host machine.

On macOS, VS Code Dev Containers may:
- not see this environment variable at startup, or
- receive an empty or changed value.

As a result, Docker gets an invalid mount definition like:

```
source=,target=/ssh-agent
```

and fails with `mount config is invalid`.

---

## Recommended Fix (macOS)

Use `localEnv` instead of `env` when mounting the SSH agent socket.

### Correct configuration

In `.devcontainer/devcontainer.json`:

```json
"mounts": [
  "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached",
  "source=${localEnv:SSH_AUTH_SOCK},target=/ssh-agent,type=bind"
],
"containerEnv": {
  "SSH_AUTH_SOCK": "/ssh-agent"
}
```

### Why this works

- `localEnv` always resolves variables from the **host environment**
- it is evaluated before the container starts
- this avoids empty or missing values on macOS

---

## Security Notes

- Private SSH keys are **not copied** into the container
- The SSH agent remains on the host
- The container only accesses the agent socket

This setup supports:
- multiple GitHub accounts
- SSH config with host aliases
- secure access to private repositories

---

## Linux Notes

On most Linux systems, `${env:SSH_AUTH_SOCK}` works correctly.

If no issues appear, no changes are required.

---

## Summary

- The error is macOS-specific and common
- The fix is simple and safe
- Using `localEnv` is the recommended approach on macOS

If you encounter other SSH-related issues, please check your local SSH agent setup and ensure it is running before opening the DevContainer.

