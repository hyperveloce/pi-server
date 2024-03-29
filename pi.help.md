
sudo blkid
sudo nano /etc/fstab
paste into fstab
UUID=736ad9f7-0696-419d-8948-576617a285dc /mnt/usb ext4 rw,user,nofail 0 0
sudo mkdir /mnt/usb
sudo mount /dev/sda2

-------

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install docker.io -y
sudo usermod -aG docker pi
docker version

--------

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install samba samba-common-bin -y
sudo nano /etc/samba/smb.conf

[pihome]
path = /home/pi
writeable=Yes
create mask=0777
directory mask=0777
public=no

[piusb]
path = /mnt/usb
writeable=Yes
create mask=0777
directory mask=0777
public=no

sudo smbpasswd -a pi
sudo systemctl restart smbd


2. Install Docker Compose
sudo apt-get install docker-compose

3. mount network drive
sudo chown -R pi:pi /mnt/

sudo nano /etc/fstab
//192.168.50.2/k_media /mnt/asus87u/k_media cifs vers=1.0,username=pi,password=,domain=WORKGROUP 0 0
//192.168.50.2/k_Cinema /mnt/asus87u/k_Cinema cifs vers=1.0,username=pi,password=,domain=WORKGROUP 0 0

make directories
sudo reboot
sudo mount -av

4. symlink external

ln -s /mnt/usb/pi.docker /home/pi/pi.docker
ln -s /mnt/usb/incomplete /home/pi/local
ln -s /mnt/asus87u/k_Cinema/m.complete /home/pi/ext;
ln -s /mnt/asus87u/k_Cinema/movies.latest /home/pi/ext;
ln -s /mnt/asus87u/k_Cinema/sna.movies /home/pi/ext;
ln -s /mnt/asus87u/k_media/current.shows /home/pi/ext;
ln -s /mnt/asus87u/k_media/pi.complete /home/pi/ext;

sudo nano /etc/environment
PUID=1000
PGID=995
TZ="Australia/Melbourne"
USERDIR="/home/pi"

https://pimylifeup.com/raspberry-pi-swap-file/
sudo free -h


top
docker stats
docker-compose -f ~/docker/docker-compose.yml up -d

docker-compose pull
docker-compose up -d
docker-compose -f /home/kserver/kserver-docker/docker-compose_kserver.yml up -d

docker system prune
docker image prune
docker network prune
docker volume prune

https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
docker rmi $(docker images -a -q)
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

nextCloud --
#https://labs.bilimedtech.com/cloud-computing/3/3.6.html

sudo du -s /*
 sudo du . | sort -n
 df -h

https://smarthomepursuits.com/how-to-reboot-raspberry-pi-on-a-schedule/?expand_article=1
