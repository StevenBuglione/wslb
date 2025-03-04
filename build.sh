#!/bin/bash

# Logging functions
log() {
    local level=$1
    local message=$2

    case $level in
        "info")    echo -e "\e[1;34m${message}\e[0m" ;;
        "step")    echo -e "\e[1;33m>> ${message}\e[0m" ;;
        "success") echo -e "\e[1;32m${message}\e[0m" ;;
        "error")   echo -e "\e[1;31m${message}\e[0m" ;;
        "result")  echo -e "\e[1;36m${message}\e[0m" ;;
        *)         echo -e "${message}" ;;
    esac
}

# Check if distro parameter is provided
if [ $# -eq 0 ]; then
    log "error" "Please provide a distro name as parameter"
    exit 1
fi

distro=$1

# Build process
log "info" "===== Starting build for ${distro} WSL distro ====="

log "step" "Building Docker image..."
cd "distro/${distro}" && docker build -t "${distro}-wsl" .

log "step" "Creating output directory..."
mkdir -p "bin/${distro}"

log "step" "Running container to prepare filesystem..."
docker run -t --name "${distro}-wsl" "${distro}-wsl"

log "step" "Exporting container to tarball..."
docker export "${distro}-wsl" | tar --delete --wildcards "etc/resolv.conf" > "bin/${distro}/${distro}-wsl.tar"

log "step" "Cleaning up container..."
docker rm "${distro}-wsl"

log "step" "Finalizing WSL image..."
mv "bin/${distro}/${distro}-wsl.tar" "bin/${distro}/${distro}.wsl"

log "success" "===== ${distro} WSL distro build completed successfully ====="
log "result" "Output file: bin/${distro}/${distro}.wsl"