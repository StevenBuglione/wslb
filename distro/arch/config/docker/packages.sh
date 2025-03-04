#!/bin/bash
set -e

echo "Updating the package database..."
pacman -Syu --noconfirm

# Define packages to install
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
  dialog
  man-db
  less
  net-tools
  iputils
  openssh
  iproute2
)

echo "Installing packages..."
pacman -S --noconfirm "${PACKAGES[@]}"