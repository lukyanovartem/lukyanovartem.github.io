---
title: NetBSD на Raspberry Pi 3
published: 08.01.2026
tags: netbsd
---
На версии 10.1 глючит ввод с клавиатуры

Создание пользователя
```sh
useradd -m -G wheel Artem
```
Доступ к видеоядру под пользователем
```sh
chmod 660 /dev/vchiq
```
Редактирование /etc/passwd
```sh
vipw
```
Настройка времени
```sh
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
```
Настройка разрешения экрана  
/boot/config.txt
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
Имя хоста  
/etc/dhcpcd.conf
```default
hostname
``` 
/etc/rc.conf
```default
hostname=rpi3
```
Настройка XDM  
/etc/rc.conf
```default
xdm=YES
```
Разрешаем локальный беспарольный вход  
/etc/X11/xdm/Xresources
```default
xlogin*allowNullPasswd: true
```
/etc/pam.d/display_manager
```default
auth            required        pam_unix.so             no_warn try_first_pass nullok
```
Русская раскладка  
/etc/X11/xdm/Xsession
```sh
        ...
        # xrandr из-за ошибки BadRROutput
        xrandr && setxkbmap -layout 'us,ru' -option 'grp:caps_toggle,grp_led:caps'
        exec /usr/X11R7/bin/ctwm -W
```
~/.profile
```sh
export LANG="ru_RU.UTF-8"
export PKG_PATH="https://cdn.NetBSD.org/pub/pkgsrc/packages/NetBSD/$$$$(uname -p)/$$$$(uname -r|cut -f '1 2' -d.|cut -f 1 -d_)/All"
```
Исправление ошибки "No entry for terminal type" при удалённом входе. На других машинах  
~/.ssh/config
```default
host rpi3
   SetEnv TERM=xterm
```
Монтирование сетевой файловой системы sshfs  
/etc/fstab
```default
ssh@server:/data /mnt psshfs ro,noauto,-O=BatchMode=yes,-O=IdentityFile=/home/Artem/.ssh/id_ed25519,-t=-1
```
Запрещаем удалённый вход по паролю  
/etc/ssh/sshd_config
```default
PasswordAuthentication no
UsePAM no
```
