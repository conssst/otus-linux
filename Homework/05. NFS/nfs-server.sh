#/bin/bash
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
sudo su
dnf install -y nfs-utils
mkdir /srv/nfs
mkdir /srv/nfs/upload
chmod -R 777 /srv/nfs/upload
systemctl enable --now nfs-server
systemctl enable rpcbind
systemctl start nfs-server
systemctl start rpcbind
echo '/srv/nfs 192.168.50.13(rw,sync)' >> /etc/exports
exportfs -r
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-source=192.168.50.0/24 --permanent
firewall-cmd --add-service=nfs --permanent
firewall-cmd --add-service=mountd --permanent
firewall-cmd --add-service=rpc-bind --permanent
firewall-cmd --add-port=111/udp
firewall-cmd --add-port=111/tcp
firewall-cmd --add-port=20048/udp
firewall-cmd --add-port=20048/tcp
firewall-cmd --reload