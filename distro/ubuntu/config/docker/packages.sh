#!/bin/bash

# Update all packages
apt update && apt upgrade -y

# Install specific packages
PACKAGES=(
  sudo
  vim
  git
  curl
  wget
  htop
  bash-completion
  ca-certificates
  gnupg
  apt-utils
  dialog
  locales
  man-db
  less
  net-tools
  iputils-ping
  ssh
  iproute2
)

# Install the packages
apt install -y "${PACKAGES[@]}"