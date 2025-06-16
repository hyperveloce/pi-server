🧰 Raspberry Pi Setup (Cleaned & Updated)
1. 🧱 Mount Local USB Drive
```bash
sudo blkid
sudo mkdir /mnt/usb
sudo nano /etc/fstab
Add this line to /etc/fstab (replace UUID with yours):
```

```ini
UUID=736ad9f7-0696-419d-8948-576617a285dc /mnt/usb ext4 rw,user,nofail 0 0
```

Then mount:

```bash
sudo mount -a
```

2. 🐳 Install Docker & Docker Compose
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install docker.io docker-compose -y
sudo usermod -aG docker pi
```

Verify:

```bash
docker version
3. 🧩 Install Samba (for network sharing)
```

```bash
sudo apt-get install samba samba-common-bin -y
sudo nano /etc/samba/smb.conf
```

Add:

```ini
[pihome]
path = /home/pi
writeable = Yes
create mask = 0777
directory mask = 0777
public = no

[piusb]
path = /mnt/usb
writeable = Yes
create mask = 0777
directory mask = 0777
public = no
```

Then:

```bash
sudo smbpasswd -a pi
sudo systemctl restart smbd
```

4. 🌐 Mount Network Shares
```bash
sudo mkdir -p /mnt/asus87u/k_media
sudo mkdir -p /mnt/asus87u/k_Cinema
sudo chown -R pi:pi /mnt/

sudo nano /etc/fstab
```

Add:

```bash
# Network Shares
//192.168.50.2/k_media   /mnt/asus87u/k_media   cifs vers=1.0,username=pi,password=,domain=WORKGROUP,nofail 0 0
//192.168.50.2/k_Cinema  /mnt/asus87u/k_Cinema  cifs vers=1.0,username=pi,password=,domain=WORKGROUP,nofail 0 0
```

Apply:

```bash
sudo mount -av
```

5. 🔗 Symlink External Media (Optional)

```bash
ln -s /mnt/usb/pi.docker /home/pi/pi.docker
ln -s /mnt/usb/incomplete /home/pi/local
ln -s /mnt/asus87u/k_Cinema/m.complete /home/pi/ext
ln -s /mnt/asus87u/k_Cinema/movies.latest /home/pi/ext
ln -s /mnt/asus87u/k_Cinema/sna.movies /home/pi/ext
ln -s /mnt/asus87u/k_media/current.shows /home/pi/ext
ln -s /mnt/asus87u/k_media/pi.complete /home/pi/ext
```

6. ⚙️ Environment Variables
```bash
sudo nano /etc/environment
```

Add:
```bash
PUID=1000
PGID=995
TZ="Australia/Melbourne"
USERDIR="/home/pi"
```

7. 🧠 Monitor & Maintenance
Basic Usage:

```bash
top
free -h
df -h
```

Docker Usage:

```bash
docker stats
docker-compose -f ~/docker/docker-compose.yml up -d
docker-compose pull
docker-compose up -d
```

Clean Up Docker:

```bash
docker system prune -f
docker image prune -f
docker network prune -f
docker volume prune -f
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -aq)
```

8. 📦 Disk Usage Checks
```bash
sudo du -sh /*
sudo du -sh . | sort -h
```

9. 🕒 Optional: Scheduled Reboots
Auto reboot guide



# Additional Tools & References

# Authelia (SSO + 2FA): https://www.authelia.com/
# Docker Compose Examples: https://github.com/frankyw/home-server
# Pi-hole + DoH Example: https://github.com/docker/awesome-compose/tree/master/pihole-cloudflared-DoH
# Mount USB: https://raspberrytips.com/mount-usb-drive-raspberry-pi/
# Samba Share: https://pimylifeup.com/raspberry-pi-samba/
# Duplicati (GUI Backup): https://hub.docker.com/r/linuxserver/duplicati
