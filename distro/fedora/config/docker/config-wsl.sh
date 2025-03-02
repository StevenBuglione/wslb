#!/bin/bash
echo "Starting WSL Configuration"

echo "Configuring WSL Configuration"
cp /tmp/config/wsl/wsl.conf /etc/wsl.conf
chmod 0644 /etc/wsl.conf

echo "Configuring WSL Distribution Configuration"
cp /tmp/config/wsl/wsl-distribution.conf /etc/wsl-distribution.conf
chmod 0644 /etc/wsl-distribution.conf

echo "Configuring WSL Out Of The Box Experience"
cp /tmp/config/wsl/oobe.sh /etc/oobe.sh

echo "Configuring WSL Windows Terminal Icon"
mkdir -p /usr/lib/wsl && cp /tmp/config/wsl/terminal-icon/fedora.ico /usr/lib/wsl/fedora.ico

echo "Configuring WSL Windows Terminal Profile"
mkdir -p /usr/lib/wsl && cp /tmp/config/wsl/terminal-profile.json /usr/lib/wsl/terminal-profile.json
