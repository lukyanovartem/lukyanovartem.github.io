---
title: NetBSD
published: 08.01.2026
tags: netbsd
---
Создание пользователя
```sh
useradd -m -G wheel Artem
```
Редактирование /etc/passwd
```sh
vipw
```
Настройка времени
```sh
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
```
Имя хоста
```diff
--- /tmp/dhcpcd.conf	2026-01-25 10:57:09.781276564 +0300
+++ /etc/dhcpcd.conf	2026-01-17 12:23:12.225890653 +0300
@@ -5,7 +5,7 @@
 #controlgroup wheel
 
 # Inform the DHCP server of our hostname for DDNS.
-#hostname
+hostname
 
 # Use the hardware address of the interface for the Client ID.
 #clientid
```
```diff
--- /tmp/rc.conf	2026-01-25 10:58:39.683671207 +0300
+++ /etc/rc.conf	2026-01-17 12:24:34.656929201 +0300
@@ -46,7 +46,7 @@ is_cloud() {
 }
 
 rc_configured=YES
-hostname=armv7
+hostname=myname
 no_swap=YES
 savecore=NO
 sshd=YES
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
```diff
--- /tmp/display_manager	2026-01-25 10:59:47.108565775 +0300
+++ /etc/pam.d/display_manager	2026-01-17 12:24:53.049180985 +0300
@@ -11,7 +11,7 @@ auth		sufficient	pam_skey.so		no_warn tr
 auth		optional	pam_afslog.so		no_warn try_first_pass
 # pam_ssh has potential security risks.  See pam_ssh(8).
 #auth		sufficient	pam_ssh.so		no_warn try_first_pass
-auth		required	pam_unix.so		no_warn try_first_pass
+auth		required	pam_unix.so		no_warn try_first_pass nullok
 
 # account
 #account 	required	pam_krb5.so
```
Русская раскладка
```diff
--- /tmp/Xsession	2026-01-25 11:01:45.856937940 +0300
+++ /etc/X11/xdm/Xsession	2026-01-25 11:02:40.089933473 +0300
@@ -133,5 +133,7 @@ fi
 	/usr/X11R7/bin/uxterm &
 	/usr/X11R7/bin/xclock -digital -strftime '%a %Y-%m-%d %H:%M' \
 		-face "spleen:pixelsize=$$$$fontsize" -g +0+0 &
+	# xrandr из-за ошибки BadRROutput
+	xrandr && setxkbmap -layout 'us,ru' -option 'grp:caps_toggle,grp_led:caps'
 	exec /usr/X11R7/bin/ctwm -W
 fi
```
~/.profile
```sh
export LANG="ru_RU.UTF-8"
export PKG_PATH="https://cdn.NetBSD.org/pub/pkgsrc/packages/NetBSD/$$$$(uname -p)/$$$$(uname -r|cut -f '1 2' -d.|cut -f 1 -d_)/All"
```
Исправление ошибки "No entry for terminal type" при удалённом входе. На других машинах  
~/.ssh/config
```default
host myname
   SetEnv TERM=xterm
```
Монтирование сетевой файловой системы sshfs  
/etc/fstab
```default
ssh@server:/data /mnt psshfs ro,noauto,-O=BatchMode=yes,-O=IdentityFile=/home/Artem/.ssh/id_ed25519,-t=-1
```
Запрещаем удалённый вход по паролю
```diff
--- /tmp/sshd_config	2026-01-25 11:04:17.729054414 +0300
+++ /etc/ssh/sshd_config	2026-01-17 12:46:13.649271081 +0300
@@ -54,7 +54,7 @@ AuthorizedKeysFile	.ssh/authorized_keys
 #IgnoreRhosts yes
 
 # To disable password authentication, set this and UsePAM to no
-#PasswordAuthentication yes
+PasswordAuthentication no
 #PermitEmptyPasswords no
 
 # Change to no to disable s/key passwords
@@ -79,7 +79,7 @@ AuthorizedKeysFile	.ssh/authorized_keys
 # If you just want the PAM account and session checks to run without
 # PAM authentication, then enable this but set PasswordAuthentication
 # and KbdInteractiveAuthentication to 'no'.
-#UsePAM yes
+UsePAM no
 
 #AllowAgentForwarding yes
 #AllowTcpForwarding yes
```

**Для Raspberry Pi 3**  
**На версии 10.1 глючит ввод с клавиатуры**  
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
Доступ к видеоядру под пользователем
```sh
chmod 660 /dev/vchiq
```
**Для Raspberry Pi 4**  
В образ arm64.img, в раздел /boot положить файлы из [архива](https://github.com/pftf/RPi4/releases/download/v1.42/RPi4_UEFI_Firmware_v1.42.zip), иначе не будет изображения
