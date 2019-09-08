
## 1. LMV

Проделаны все шаги из приложения к уроку https://otus.ru/media/82/4b/%D0%9F%D1%80%D0%B0%D0%BA%D1%82%D0%B8%D0%BA%D0%B0_LVM-5373-824bd9.pdf 

Вывод терминала можно найти в файле [shell_lvm] (shell_lvm).

## 2. ZFS

Задание: на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снапшотами - разметить здесь каталог /opt.

Вывод терминала можно найти в файле [shell_zfs](shell_zfs).
***
Устанавливаем zfs репозитарий.

`sudo yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_5.noarch.rpm`

Редактируем файл /etc/yum.repos.d/zfs.repo 
Для установки готового модуля в файле репозитария выбираем "zfs-kmod".
В секции [zfs] редактируем параметр на `enabled=0`.
В секции [zfs-kmod] редактируем параметр на `enabled=1`.

    [zfs]
    name=ZFS on Linux for EL7 - dkms
    baseurl=http://download.zfsonlinux.org/epel/7.5/$basearch/
    enabled=0
    metadata_expire=7d
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux

    [zfs-kmod]
    name=ZFS on Linux for EL7 - kmod
    baseurl=http://download.zfsonlinux.org/epel/7.5/kmod/$basearch/
    enabled=1
    metadata_expire=7d
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux


Устанавливаем zfs

`yum install -y zfs`

Загружаем модуль

`modprobe zfs`

`lsmod | grep zfs`

    zfs                  3564468  0
    zunicode              331170  1 zfs
    zavl                   15236  1 zfs
    icp                   270148  1 zfs
    zcommon                73440  1 zfs
    znvpair                89131  2 zfs,zcommon
    spl                   102412  4 icp,zfs,zcommon,znvpair

Создадим пул данных на дисках sdb, sdb.

`zpool create myzfs /dev/sdb /dev/sdc`

Создаём файловую систему и монтируем в /opt.

`zfs create myzfs/opt -o mountpoint=/opt`

Создадим журнал записи и кэш на дисках sdd, sde, далее проверяем что всё получилось.

`zpool add myzfs log /dev/sdd`

`zpool add myzfs cache /dev/sde`

`zpool status -v`

          pool: myzfs
         state: ONLINE
          scan: none requested
        config:

                NAME        STATE     READ WRITE CKSUM
                myzfs       ONLINE       0     0     0
                  sdb       ONLINE       0     0     0
                  sdc       ONLINE       0     0     0
                logs
                  sdd       ONLINE       0     0     0
                cache
                  sde       ONLINE       0     0     0

        errors: No known data errors

Создадим снэпшот snap1.

`zfs snapshot myzfs/opt@snap1`

Создадим 20 файлов в директории /opt.

`touch /opt/file{1..20}`

Восстановимся со снэпшота snap1.
 
`zfs rollback myzfs/opt@snap1`
 
Проверяем что восстановились (директория должна быть пустая).

`ls /opt`


