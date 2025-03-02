#!/bin/bash

# Update all packages
dnf update -y

# Install specific packages
PACKAGES=(
  vim
  git
  curl
  wget
  htop
)

# Install the packages
dnf install -y "${PACKAGES[@]}"