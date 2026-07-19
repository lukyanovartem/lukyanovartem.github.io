---
title: FreeBSD
published: 03.02.2026
tags: bsd
---
### Интерактивное создание пользователя
```sh
adduser
```
### Редактирование /etc/passwd
```sh
vipw
```
### Настройка времени
```sh
tzsetup Europe/Moscow
```
### Синхронизация времени  
Выключать ntpd после первичной синхронизации и синхронизировать при сильной разнице дат
```sh
sysrc ntpd_enable="YES"
sysrc ntpd_sync_on_start="YES"
sysrc ntpd_flags="-q"
```
Синхронизировать с локальным сервером времени
```diff
--- /tmp/ntp.conf	2014-01-01 01:05:25.997977000 +0400
+++ /etc/ntp.conf	2014-01-01 01:05:53.331831000 +0400
@@ -29,8 +29,9 @@ tos minclock 3 maxclock 6
 #
 # The option `iburst' is used for faster initial synchronization.
 #
-pool 0.freebsd.pool.ntp.org iburst
-pool 2.freebsd.pool.ntp.org iburst
+#pool 0.freebsd.pool.ntp.org iburst
+#pool 2.freebsd.pool.ntp.org iburst
+server server
 
 #
 # If you want to pick yourself which country's public NTP server
```
### Имя хоста
```sh
sysrc hostname="myhost"
```
### Русский язык
```diff
--- /tmp/login.conf	2026-02-03 17:50:43.699057000 +0300
+++ /etc/login.conf	2026-02-03 17:51:22.556223000 +0300
@@ -47,7 +47,7 @@ default:\
 	:priority=0:\
 	:umask=022:\
 	:charset=UTF-8:\
-	:lang=C.UTF-8:
+	:lang=ru_RU.UTF-8:
 
 #
 # A collection of common class names - forward them all to 'default'
```
После чего выполняем
```sh
cap_mkdb /etc/login.conf
```
### Настройка X11
Устанавливаем пакеты
```sh
pkg install -y xdm xorg
```
```diff
--- /tmp/ttys	2026-06-07 18:08:20.462776000 +0300
+++ /etc/ttys	2026-02-04 19:15:01.863939000 +0300
@@ -34,7 +34,7 @@ ttyv7	"/usr/libexec/getty Pc"		xterm	onifexists secure
 ttyv5	"/usr/libexec/getty Pc"		xterm	onifexists secure
 ttyv6	"/usr/libexec/getty Pc"		xterm	onifexists secure
 ttyv7	"/usr/libexec/getty Pc"		xterm	onifexists secure
-ttyv8	"/usr/local/bin/xdm -nodaemon"	xterm	off secure
+ttyv8	"/usr/local/bin/xdm -nodaemon"	xterm	on secure
 # Serial terminals
 # The 'dialup' keyword identifies dialin lines to login, fingerd etc.
 ttyu0	"/usr/libexec/getty 3wire"	vt100	onifconsole secure
```
### Настройка TWM
```diff
--- /usr/local/share/X11/twm/system.twmrc	2025-12-25 11:58:09.000000000 +0300
+++ /home/Artem/.twmrc	2026-06-18 18:16:43.920846000 +0300
@@ -11,12 +11,13 @@ DecorateTransients
 NoGrabServer
 RestartPreviousState
 DecorateTransients
-TitleFont "-adobe-helvetica-bold-r-normal--*-120-*-*-*-*-*-*"
-ResizeFont "-adobe-helvetica-bold-r-normal--*-120-*-*-*-*-*-*"
-MenuFont "-adobe-helvetica-bold-r-normal--*-120-*-*-*-*-*-*"
-IconFont "-adobe-helvetica-bold-r-normal--*-100-*-*-*-*-*-*"
-IconManagerFont "-adobe-helvetica-bold-r-normal--*-100-*-*-*"
+TitleFont "-misc-fixed-bold-r-normal--*-140-*-*-*-*-iso10646-1"
+ResizeFont "-misc-fixed-bold-r-normal--*-140-*-*-*-*-iso10646-1"
+MenuFont "-misc-fixed-bold-r-normal--*-140-*-*-*-*-iso10646-1"
+IconFont "-misc-fixed-bold-r-normal--*-120-*-*-*-*-iso10646-1"
+IconManagerFont "-misc-fixed-bold-r-normal--*-120-*-*-*-*-iso10646-1"
 #ClientBorderWidth
+RightTitleButton "xlogo11" = f.delete

 Color
 {
```

### Разрешаем локальный беспарольный вход  
/usr/local/etc/X11/xdm/Xresources
```default
xlogin*allowNullPasswd: true
```
```diff
--- /tmp/xdm	2026-06-07 18:03:58.833322000 +0300
+++ /etc/pam.d/xdm	2026-02-04 19:12:30.589647000 +0300
@@ -6,7 +6,7 @@
 # auth
 #auth		sufficient	pam_krb5.so		no_warn try_first_pass
 #auth		sufficient	pam_ssh.so		no_warn try_first_pass
-auth		required	pam_unix.so		no_warn try_first_pass
+auth		required	pam_unix.so		no_warn try_first_pass nullok

 # account
 account		required	pam_nologin.so
```
### Русская раскладка  
~/.xsession
```sh
/usr/local/bin/setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle,grp_led:caps'
```
### Монтирование сетевой файловой системы sshfs  
Устанавливаем fusefs-sshfs
```sh
pkg install -y fusefs-sshfs
```
/boot/loader.conf  
```default
fusefs_load="YES"
```
/etc/fstab
```default
ssh@server:/data /mnt fusefs noauto,ro,mountprog=/usr/local/bin/sshfs,allow_other,IdentityFile=/home/Artem/.ssh/id_ed25519 0 0
```
### Отключить дампы ядра
```sh
sysrc dumpdev="NO"
```
### Управление пакетами
```sh
pkg search
pkg install
pkg delete
```
Список вручную установленных пакетов
```sh
pkg prime-list
```
Удаление неиспользуемых пакетов
```sh
pkg autoremove
pkg clean
```
### Обновление на новый релиз
```sh
freebsd-update -r 15.1-RELEASE upgrade
freebsd-update install
rm -r /var/db/freebsd-update/*
```
После обновления на мажорный релиз
```sh
pkg-static upgrade -f
```

## Для Raspberry Pi 3
### Поддержка звука
Поддержки звука ещё нет в 15.1 релизе. Пока можно пропатчить и пересобрать ядро
```sh
git clone https://git.FreeBSD.org/src.git -b release/15.1.0 /usr/src
cd /usr/src
git cherry-pick 1d100747d747 70e73c43a472 df764dd133ec 8b43286fc3ba aa6b871ea77e
make -j4 kernel
```
### Уменьшить износ SD  
/etc/fstab
```diff
--- /tmp/fstab	2026-02-03 18:47:47.025358000 +0300
+++ /etc/fstab	2026-02-03 18:44:33.816719000 +0300
@@ -1,5 +1,5 @@
 # Custom /etc/fstab for FreeBSD embedded images
-/dev/ufs/rootfs		/		ufs	rw		1	1
+/dev/ufs/rootfs		/		ufs	rw,noatime		1	1
 /dev/msdosfs/EFI		/boot/efi	msdosfs	rw,noatime	0	0
 tmpfs			/tmp		tmpfs	rw,mode=1777	0	0
 /dev/label/growfs_swap	none		swap	sw		0	0
```
### Настройка разрешения экрана
```diff
--- /tmp/config.txt	2026-02-03 21:59:35.820476000 +0300
+++ /boot/msdos/config.txt	2026-02-03 21:55:24.000000000 +0300
@@ -6,6 +6,15 @@ kernel=u-boot.bin
 device_tree_address=0x4000
 kernel=u-boot.bin
 
+# последняя единица чтобы убрать рамки
+hdmi_cvt=1920 1080 60 3 0 0 1
+# игнорировать разрешение монитора
+hdmi_ignore_edid=0xa5000080
+hdmi_group=2
+hdmi_mode=87
+# игнорировать отсутствие монитора
+hdmi_force_hotplug=1
+
 [pi4]
 hdmi_safe=1
 armstub=armstub8-gic.bin
```
### Сделать HDMI основной консолью
```diff
--- /tmp/loader.conf	2026-02-04 10:30:23.292759000 +0300
+++ /boot/loader.conf	2026-02-04 10:27:17.990643000 +0300
@@ -3,7 +3,7 @@ boot_multicons="YES"
 umodem_load="YES"
 # Multiple console (serial+efi gop) enabled.
 boot_multicons="YES"
-boot_serial="YES"
+boot_serial="NO"
 # Disable the beastie menu and color
 beastie_disable="YES"
 loader_color="NO"
```
