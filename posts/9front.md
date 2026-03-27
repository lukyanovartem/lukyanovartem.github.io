---
title: 9Front
published: 24.03.2026
tags: plan9
---
Виджеты  
/bin/riostart
```sh
window 0,0,100,100 clock
window 100,0,200,100 kbmap /sys/lib/kbmap/us /sys/lib/kbmap/ru
window 200,0,400,100 winwatch -e '^(winwatch|clock|kbmap)'
```
Настройка времени  
/adm/timezone/local
```default
MSK 10800 MSK 10800
...
```
Синхронизация с локальным сервером времени  
/bin/riostart
```sh
aux/timesync -n server.lan
```
Удалённый терминал  
/bin/riostart
```sh
echo 'key proto=dp9ik dom=plan9 user=glenda !password=mypassword' > /mnt/factotum/ctl
aux/listen1 -t tcp!*!rcpu /rc/bin/service/tcp17019 -R &
```
На удалённом хосте
```sh
drawterm -h myname -u glenda
```
Отключение вывода сообщений ядра поверх графического окружения
```sh
mkdir -p /sys/log/consoles
```
/bin/riostart
```sh
cat /dev/kprint >>/sys/log/consoles/$$$$sysname >[2=1] &
```
Настройка сети  
/bin/riostart
```sh
ip/ipconfig -h $$$$sysname
```
**Для Raspberry Pi 1**  
Могут глючить мыши от Logitech, можно попробовать другую мышь

Монтировать загрузочный раздел
```sh
9fs dos
```
Для поддержки звука надо пропатчить и пересобрать ядро. Патч проверялся на версии 9front-11554
```sh
cd /sys/src/9/bcm
hget https://lukyanovartem.github.io/content/bcm-audio.diff | patch -p5
mk 'CONF=pi'
cp 9pi /n/dos
```
Настройка разрешения экрана  
/n/dos/config.txt
```default
# последняя единица чтобы убрать рамки
hdmi_cvt=1920 1080 60 3 0 0 1
# игнорировать разрешение монитора
hdmi_ignore_edid=0xa5000080
hdmi_group=2
hdmi_mode=87
# игнорировать отсутствие монитора
hdmi_force_hotplug=1
```
Автозагрузка  
/n/dos/cmdline.txt
```default
console=0 user=glenda nobootprompt=local!/dev/sdM0/fs sysname=myname
```
