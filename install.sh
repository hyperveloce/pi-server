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

# Install and enable SSH
apt install -y openssh-server
systemctl enable ssh
systemctl start ssh

# Install useful base packages (skip btop)
apt install -y \
  curl wget unzip git \
  vim neovim \
  sudo fail2ban \
  net-tools htop neofetch\
  zoxide gnupg lsb-release ca-certificates software-properties-common

# UFW firewall (install separately and conditionally)
if ! command -v ufw &>/dev/null; then
  echo "🔐 Installing UFW..."
  apt install -y ufw
fi

# Setup UFW firewall if now available
if command -v ufw &>/dev/null; then
  echo "⚙️ Configuring UFW firewall..."
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow 22/tcp
  ufw --force enable
else
  echo "⚠️ UFW is still not available — skipping firewall setup"
fi

# Enable and start fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# Install Docker if not installed
if ! command -v docker &>/dev/null; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
else
  echo "✅ Docker is already installed."
fi

# Ensure user is in docker group
usermod -aG docker "$username"

# Install Docker Compose Plugin if needed
if ! docker compose version &>/dev/null; then
  echo "🔧 Installing Docker Compose Plugin..."
  apt install -y docker-compose-plugin
else
  echo "✅ Docker Compose Plugin is already installed."
fi

# Create Docker folder
mkdir -p /home/$username/pi.docker
chown -R $username:$username /home/$username/pi.docker

# Optional: Setup mounts
# echo "UUID=XXXX-XXXX    /mnt/data    ext4    defaults   0  2" | tee -a /etc/fstab
# mkdir -p /mnt/data && mount -a

# Add zoxide init to bashrc if not already present
if ! grep -q 'zoxide init bash' /home/$username/.bashrc; then
  echo 'eval "$(zoxide init bash)"' >> /home/$username/.bashrc
fi

# Rebuild font cache (optional)
fc-cache -fv

# Clean up
apt autoremove -y
apt clean

echo "✅ Setup complete. Rebooting..."
reboot
