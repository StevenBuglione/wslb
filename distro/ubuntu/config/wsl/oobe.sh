#!/bin/bash

set -ue

# Check if critical sudo configuration files have correct ownership
if [ "$(stat -c '%u' /etc/sudo.conf)" -ne 0 ] || [ "$(stat -c '%u' /etc/sudoers)" -ne 0 ]; then
  echo "Error: /etc/sudo.conf and/or /etc/sudoers are not owned by root."
  echo "Please fix the file ownership by running:"
  echo "  chown root:root /etc/sudo.conf /etc/sudoers"
  exit 1
fi

DEFAULT_GROUPS='adm,cdrom,sudo,dip,plugdev'
DEFAULT_UID='1000'

echo 'Please create a default UNIX user account. The username does not need to match your Windows username.'
echo 'For more information visit: https://aka.ms/wslusers'

if getent passwd "$DEFAULT_UID" > /dev/null; then
  echo 'User account already exists, skipping creation'
  exit 0
fi

while true; do
  # Prompt for the username
  read -p 'Enter new UNIX username: ' username

  # Prompt for the password (input hidden)
  read -s -p 'Enter password for user: ' password
  echo
  read -s -p 'Confirm password: ' password_confirm
  echo

  if [ "$password" != "$password_confirm" ]; then
    echo "Passwords do not match, please try again."
    continue
  fi

  # Create the user with a specific UID, a home directory, and bash as the default shell
  if sudo useradd -u "$DEFAULT_UID" -m -s /bin/bash -c "" "$username"; then
    # Add the user to the default groups
    if sudo usermod -aG "$DEFAULT_GROUPS" "$username"; then
      # Set the user's password using chpasswd
      echo "$username:$password" | sudo chpasswd
      echo "User '$username' created successfully."
      break
    else
      sudo userdel "$username"
    fi
  fi
done