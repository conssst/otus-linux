#/bin/bash
# копируем ключи, чтобы сразу могли зайти под root
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
# устанавливаем необходимые пакеты для работы nfs
dnf install -y nfs-utils
# создадим дирректорию к которой будем монтировать удалённую дирректорию
mkdir /srv/nfs
systemctl enable --now firewalld
# монтируем удалённую дирректорию по протоколу udp, используя nfs 3 версии
mount -t nfs -o vers=3,udp 192.168.50.12:/srv/nfs /srv/nfs
# добавляем данные в fstab, чтобы после перезагрузки автоматически монтировалась удалённая дирректория
echo '192.168.50.12:/srv/nfs /srv/nfs nfs vers=3,timeo=900,proto=udp,retrans=5 0 0' >> /etc/fstab