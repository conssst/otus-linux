
1. LMV

��������� ��� ���� �� ���������� � ����� https://otus.ru/media/82/4b/%D0%9F%D1%80%D0%B0%D0%BA%D1%82%D0%B8%D0%BA%D0%B0_LVM-5373-824bd9.pdf
����� ��������� ����� ����� � ����� shell_lvm.

2. ZFS

����� ��������� ����� ����� � ����� shell_zfs.

* �� ����� ���� ������ ����������� ��������� btrfs/zfs - � �����, ���������� - ��������� ����� ������� /opt.

������������� zfs �����������.

sudo yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_5.noarch.rpm

����������� ���� /etc/yum.repos.d/zfs.repo 
��� ��������� �������� ������ � ����� ����������� �������� "zfs-kmod".
� ������ "zfs" ����������� �������� �� enabled=0.
� ������ "zfs-kmod" ����������� �������� �� enabled=1.

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


������������� zfs

yum install -y zfs

��������� ������

modprobe zfs
lsmod | grep zfs

zfs                  3564468  0
zunicode              331170  1 zfs
zavl                   15236  1 zfs
icp                   270148  1 zfs
zcommon                73440  1 zfs
znvpair                89131  2 zfs,zcommon
spl                   102412  4 icp,zfs,zcommon,znvpair

�������� ��� ������ �� ������ sdb, sdb.

zpool create myzfs /dev/sdb /dev/sdc

������ �������� ������� � ��������� � /opt.

zfs create myzfs/opt -o mountpoint=/opt

�������� ������ ������ � ��� �� ������ sdd, sde, ����� ��������� ��� �� ����������.

zpool add myzfs log /dev/sdd
zpool add myzfs cache /dev/sde
zpool status -v

NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk
??sda1                    8:1    0    1M  0 part
??sda2                    8:2    0    1G  0 part /boot
??sda3                    8:3    0   39G  0 part
  ??VolGroup00-LogVol00 253:0    0 37.5G  0 lvm  /
  ??VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
sdb                       8:16   0   10G  0 disk
??sdb1                    8:17   0   10G  0 part
??sdb9                    8:25   0    8M  0 part
sdc                       8:32   0    2G  0 disk
??sdc1                    8:33   0    2G  0 part
??sdc9                    8:41   0    8M  0 part
sdd                       8:48   0    1G  0 disk
sde                       8:64   0    1G  0 disk

�������� ������� snap1.

zfs snapshot myzfs/opt@snap1

�������� 20 ������ � ���������� /opt.

touch /opt/file{1..20}

������������� �� �������� snap1.
 
zfs rollback myzfs/opt@snap1
 
��������� ��� �������������� (���������� ������ ���� ������).

ls /opt

