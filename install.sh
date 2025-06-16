#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "❌ You must run this script as root. Try: sudo ./install.sh" >&2
  exit 1
fi

username="kanasu"
builddir=$(pwd)

echo "🔧 Running system setup for headless Raspberry Pi..."

# Basic System Update
apt update && apt upgrade -y

# Set hostname and timezone
hostnamectl set-hostname pi-server
timedatectl set-timezone Australia/Melbourne

# Create user and add to sudo (only if not existing)
if ! id "$username" &>/dev/null; then
  adduser "$username"
fi
usermod -aG sudo "$username"

# Enable SSH
systemctl enable ssh
systemctl start ssh

# Install useful base packages
apt install -y \
  curl wget unzip git \
  vim neovim \
  sudo ufw fail2ban \
  net-tools htop btop \
  zoxide

# Setup UFW firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw --force enable

# Enable fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# ---- Check and Install Docker ---- #
if ! command -v docker &>/dev/null; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
else
  echo "✅ Docker is already installed."
fi

# Ensure user is in docker group
usermod -aG docker "$username"

# ---- Check and Install Docker Compose Plugin ---- #
if ! docker compose version &>/dev/null; then
  echo "🔧 Installing Docker Compose Plugin..."
  apt install -y docker-compose-plugin
else
  echo "✅ Docker Compose Plugin is already installed."
fi

# Setup Docker Compose working directory
mkdir -p /home/$username/pi.docker
chown -R $username:$username /home/$username/pi.docker

# Optional: Setup mounts (uncomment and edit UUIDs as needed)
# echo "UUID=XXXX-XXXX    /mnt/data    ext4    defaults   0  2" | tee -a /etc/fstab
# mkdir -p /mnt/data && mount -a

# Configure zoxide in .bashrc
echo 'eval "$(zoxide init bash)"' >> /home/$username/.bashrc

# Font cache rebuild (if needed)
fc-cache -fv

# Final cleanup
apt autoremove -y
apt clean

echo "✅ Setup complete. Rebooting..."
reboot
