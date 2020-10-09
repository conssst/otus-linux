#/bin/bash
# копируем ключи, чтобы сразу могли зайти под root
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
# устанавливаем необходимые пакеты для работы nfs сервера
dnf install -y nfs-utils
# создаём каталоги, которые хотим расшарить
mkdir /srv/nfs
mkdir /srv/nfs/upload
# задаём права на каталог
chmod -R 777 /srv/nfs/upload
# включаем поддержку udp для nfs сервера
sed -i '50i\udp=y' /etc/nfs.conf
# запускаем nfs сервер и rpc
systemctl enable --now nfs-server
systemctl enable --now rpcbind
# указываем каталог, ip клиента и права в конфигурации экспорта
echo '/srv/nfs 192.168.50.13(rw,sync)' >> /etc/exports
# чтобы изменения вступили в силу перечитываем конфиг экспорта
exportfs -r
# запускаем firewall, добавляем необходимые порты для работы nfs по udp и перечитываем правила firewall'a
systemctl enable --now firewalld
firewall-cmd --add-port=111/udp --permanent
firewall-cmd --add-port=2049/udp --permanent
firewall-cmd --add-port=20048/udp --permanent
firewall-cmd --reload