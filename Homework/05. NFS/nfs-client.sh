#/bin/bash
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
dnf install -y nfs-utils
mkdir /srv/nfs
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-source=192.168.50.0/24 --permanent
firewall-cmd --add-service=mountd
firewall-cmd --add-service=rpc-bind
firewall-cmd --reload
mount -t nfs -o vers=3 192.168.50.12:/srv/nfs /srv/nfs
echo '192.168.50.12:/srv/nfs /srv/nfs nfs vers=3,timeo=900,retrans=5 0 0' >> /etc/fstab