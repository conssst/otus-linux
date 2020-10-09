#/bin/bash
# копируем ключи, чтобы сразу могли зайти под root
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
# устанавливаем необходимые пакеты для работы nfs
dnf install -y nfs-utils
# создадим каталог к которому будем монтировать удалённый каталог
mkdir /srv/nfs
systemctl enable --now firewalld
# монтируем удалённый каталог по протоколу udp, используя nfs 3 версии
mount -t nfs -o vers=3,udp 192.168.50.12:/srv/nfs /srv/nfs
# добавляем данные в fstab, чтобы после перезагрузки автоматически монтировался удалённый каталог
echo '192.168.50.12:/srv/nfs /srv/nfs nfs vers=3,timeo=900,proto=udp,retrans=5 0 0' >> /etc/fstab