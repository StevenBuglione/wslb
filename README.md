# WSLB: WSL Builder

WSLB is a demonstration project showing how to build your own custom Windows Subsystem for Linux (WSL) distributions. Using Docker as the build environment and a mix of shell and PowerShell scripts, WSLB converts a Docker container into a WSL-compatible image.

## Overview

WSLB uses several scripts and configuration files to:

1. Convert file line endings (with tools like `dos2unix`).
2. Build a Docker image for your chosen Linux distribution.
3. Run a container to prepare the filesystem.
4. Export the container’s filesystem into a tarball.
5. Finalize the image for WSL use.

Different entry points (scripts) are provided depending on your environment:
- **Linux / Git Bash**: Use `build.sh`.
- **Windows PowerShell**: Use `build.ps1`.
- **Windows Git Bash**: Use `build-win.sh`.

Additionally, a `Justfile` is available to simplify common commands including logging build steps.

## Prerequisites

Before you start, please ensure:

- Docker Desktop is installed on your machine.
- `dos2unix` is available in your paths (either installed on your Windows system or via a Linux shell distribution).
- On Windows, if you use the PowerShell version or Git Bash, ensure Git is installed along with its GNU tools.
- Your WSL distributions configuration files (such as `wsl.conf`, `wsl-distribution.conf`, etc.) are correctly located under `distro/<distro>/config/wsl`.

## Project Structure

The project is structured as follows:

- `/distro/<distro>`  
  Contains the Dockerfile and configuration scripts for the target Linux distribution.
    - `Dockerfile` – Defines how the Docker image is built (copies configuration and runs installation scripts).
    - `/config/docker`  
      Contains scripts for package updates and installations (e.g., `packages.sh` and `config-wsl.sh`).
    - `/config/wsl`  
      Contains configuration files for WSL (e.g., `wsl.conf`, `wsl-distribution.conf`, `oobe.sh`, etc.).
- `/bin/<distro>`  
  Output folder for the final WSL image.
- `build.sh`  
  A shell script version that builds the WSL image from the Docker container.
- `build.ps1`  
  A PowerShell script that mirrors the steps of `build.sh` for Windows.
- `build-win.sh`  
  A variant of the shell build script that uses Git Bash tar (for Windows users).
- `Justfile`  
  Contains recipes for logging and build commands.

## How It Works

### 1. Convert File Line Endings(Windows Only Build Scripts)

Each build script converts files from DOS to Unix line endings using `dos2unix`. This conversion is applied to text files under:
- `/distro/<distro>/config/docker`
- `/distro/<distro>/config/wsl`

This ensures consistency in file formats between Windows and Linux environments.

### 2. Build the Docker Image

The Dockerfile in `/distro/<distro>` is used to build your custom Linux image. It copies configuration files into the image and executes scripts (such as `packages.sh` to install packages and `config-wsl.sh` to setup configuration files).

_Note:_ Ensure the scripts located in `/tmp/config/docker` have the proper execution permissions (use `chmod +x` if needed).

### 3. Prepare the Filesystem

After building the Docker image, a container is started from it to run initial configuration steps. This container simulates the final Linux environment and allows extraction of the filesystem.

### 4. Export Container to Tarball

Once the container has prepared the filesystem, the build scripts export it to a tarball. On Windows, the built-in `tar.exe` does not support the required options (e.g., `--delete`), so the scripts allow you to use Git Bash’s version of tar instead.

### 5. Finalize the WSL Image

Post-export, the tarball is renamed and moved to the output folder (e.g., `/bin/<distro>/<distro>.wsl`). This file becomes your custom WSL distribution image.

## How to Build Your Custom WSL Distro

### Using Linux or Git Bash

1. Open a terminal.
2. Run the following command, replacing `<distro>` with your distro name (folder under `/distro`):

   ```bash
   ./build.sh <distro>
   ```

### Using Windows PowerShell

1. Open PowerShell.
2. Run the script with the distro parameter:

   ```powershell
   .\build.ps1 <distro>
   ```

_Note:_ Ensure Git Bash tar is used correctly if necessary. The PowerShell script incorporates path settings for Git Bash tar.

### Using Windows Git Bash

1. Open Git Bash.
2. Run:

   ```bash
   ./build-win.sh <distro>
   ```

This script will call the GNU tar from Git Bash (e.g., located at `C:\Program Files\Git\usr\bin\tar.exe`) so that the `--delete` option is supported.

## Dockerfile Requirements

The Dockerfile must copy the configuration folder and run the configuration scripts. For example:

```dockerfile
FROM fedora:latest

COPY ./config /tmp/config

# Make sure the scripts are executable or do chmod +x as shown below
RUN chmod +x /tmp/config/docker/packages.sh \
    && /tmp/config/docker/packages.sh

RUN chmod +x /tmp/config/docker/config-wsl.sh \
    && /tmp/config/docker/config-wsl.sh

# Clean UP
RUN rm -rf /tmp/config

CMD ["ls", "/"]
```

Review the Dockerfile in `/distro/<distro>` to ensure all paths and permissions are set correctly.

## Customization

- **Configuration Files:**  
  Edit files under `/distro/<distro>/config/wsl` to change terminal profiles, WSL configuration, or initial user setup.

- **Package Installation:**  
  Update `/distro/<distro>/config/docker/packages.sh` to include or remove package installations as needed.

- **OOBE Script:**  
  Customize `/distro/<distro>/config/wsl/oobe.sh` to adjust the out-of-box experience for setting up a default user account.

## Logging and Debugging

The various scripts output detailed steps for each process. If errors occur, check the output messages:
- Look for permission issues in the Dockerfile.
- Ensure `dos2unix` is installed on your system.
- Confirm that Git Bash’s tar is used when required on Windows.
