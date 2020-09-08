1. Определить алгоритм с наилучшим сжатием

[root@zfs vagrant]# zfs create storage/gzip
[root@zfs vagrant]# zfs create storage/zle
[root@zfs vagrant]# zfs create storage/lzjb
[root@zfs vagrant]# zfs create storage/lz4
[root@zfs vagrant]# zfs set compression= storage/gzip
cannot set property for 'storage/t': 'compression' must be one of 'on | off | lzjb | gzip | gzip-[1-9] | zle | lz4'
[root@zfs vagrant]# zfs set compression=gzip storage/gzip
[root@zfs vagrant]# zfs set compression=zle storage/zle
[root@zfs vagrant]# zfs set compression=lzjb storage/lzjb
[root@zfs vagrant]# zfs set compression=lz4 storage/lz4
[root@zfs vagrant]# echo "/storage/gzip/ /storage/lz4/ /storage/lzjb/ /storage/zle/" | xargs -n 1 cp -v War_and_Peace.txt
'War_and_Peace.txt' -> '/storage/gzip/War_and_Peace.txt'
'War_and_Peace.txt' -> '/storage/lz4/War_and_Peace.txt'
'War_and_Peace.txt' -> '/storage/lzjb/War_and_Peace.txt'
'War_and_Peace.txt' -> '/storage/zle/War_and_Peace.txt
[root@zfs vagrant]# zfs list
NAME           USED  AVAIL     REFER  MOUNTPOINT
storage       8.90M  9.19G       28K  /storage
storage/gzip  1.22M  9.19G     1.22M  /storage/gzip
storage/lz4   2.00M  9.19G     2.00M  /storage/lz4
storage/lzjb  2.38M  9.19G     2.38M  /storage/lzjb
storage/zle   3.17M  9.19G     3.17M  /storage/zle
[root@zfs vagrant]# zfs get compression,compressratio
NAME            PROPERTY       VALUE     SOURCE
storage         compression    off       default
storage         compressratio  4.52x     -
storage/gzip    compression    gzip      local
storage/gzip    compressratio  8.87x     -
storage/lz4     compression    lz4       local
storage/lz4     compressratio  8.11x     -
storage/lzjb    compression    lzjb      local
storage/lzjb    compressratio  6.76x     -
storage/zle     compression    zle       local
storage/zle     compressratio  6.92x     -


2. Определить настройки pool’a

[root@zfs vagrant]# tar xvfz zfs_task1.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
[root@zfs vagrant]# zpool import -d /home/vagrant/zpoolexport/ otus
[root@zfs vagrant]# zfs list
NAME             USED  AVAIL     REFER  MOUNTPOINT
otus            2.04M   350M       24K  /otus
otus/hometask2  1.88M   350M     1.88M  /otus/hometask2
storage          294K  9.20G     28.5K  /storage
storage/gzip    29.5K  9.20G     29.5K  /storage/gzip
storage/lz4       31K  9.20G       31K  /storage/lz4
storage/lzjb    34.5K  9.20G     34.5K  /storage/lzjb
storage/zle       34K  9.20G       34K  /storage/zle
[root@zfs vagrant]# zpool status
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                                 STATE     READ WRITE CKSUM
	otus                                 ONLINE       0     0     0
	  mirror-0                           ONLINE       0     0     0
	    /home/vagrant/zpoolexport/filea  ONLINE       0     0     0
	    /home/vagrant/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors

  pool: storage
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	storage     ONLINE       0     0     0
	  sdb       ONLINE       0     0     0

errors: No known data errors
[root@zfs vagrant]# zfs get recordsize
NAME            PROPERTY    VALUE    SOURCE
otus            recordsize  128K     local
otus/hometask2  recordsize  128K     inherited from otus
storage         recordsize  128K     default
storage/gzip    recordsize  128K     default
storage/lz4     recordsize  128K     default
storage/lzjb    recordsize  128K     default
storage/zle     recordsize  128K     default
[root@zfs vagrant]# zfs get compression,compressratio
NAME            PROPERTY       VALUE     SOURCE
otus            compression    zle       local
otus            compressratio  1.00x     -
otus/hometask2  compression    zle       inherited from otus
otus/hometask2  compressratio  1.00x     -
storage         compression    off       default
storage         compressratio  4.52x     -
storage/gzip    compression    gzip      local
storage/gzip    compressratio  8.87x     -
storage/lz4     compression    lz4       local
storage/lz4     compressratio  8.11x     -
storage/lzjb    compression    lzjb      local
storage/lzjb    compressratio  6.76x     -
storage/zle     compression    zle       local
storage/zle     compressratio  6.92x     -
[root@zfs vagrant]# zfs get checksum
NAME            PROPERTY  VALUE      SOURCE
otus            checksum  sha256     local
otus/hometask2  checksum  sha256     inherited from otus
storage         checksum  on         default
storage/gzip    checksum  on         default
storage/lz4     checksum  on         default
storage/lzjb    checksum  on         default
storage/zle     checksum  on         default


3. Найти сообщение от преподавателей

[root@zfs vagrant]# zfs receive storage/otus_task < otus_task2.file
[root@zfs vagrant]# cd /storage/otus_task/
[root@zfs otus_task]# ls -lah
total 3.4M
drwxr-xr-x. 3 root    root      11 May 15 07:08 .
drwxr-xr-x. 8 root    root       8 Sep  3 09:16 ..
-rw-r--r--. 1 root    root       0 May 15 06:46 10M.file
-rw-r--r--. 1 root    root    710K May 15 07:08 cinderella.tar
-rw-r--r--. 1 root    root      65 May 15 06:39 for_examaple.txt
-rw-r--r--. 1 root    root       0 May 15 06:39 homework4.txt
-rw-r--r--. 1 root    root    303K May 15 06:39 Limbo.txt
-rw-r--r--. 1 root    root    498K May 15 06:39 Moby_Dick.txt
drwxr-xr-x. 3 vagrant vagrant    4 Dec 18  2017 task1
-rw-r--r--. 1 root    root    1.2M May  6  2016 War_and_Peace.txt
-rw-r--r--. 1 root    root    390K May 15 06:45 world.sql
[root@zfs otus_task]# cat task1/
file_mess/ README     
[root@zfs otus_task]# cat task1/file_mess/secret_message 
https://github.com/sindresorhus/awesome

