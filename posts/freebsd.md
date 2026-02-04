---
title: FreeBSD
published: 03.02.2026
tags: freebsd
---
Интерактивное создание пользователя
```sh
adduser
```
Редактирование /etc/passwd
```sh
vipw
```
Настройка времени
```sh
tzsetup Europe/Moscow
```
Синхронизация времени  
```sh
sysrc ntpd_enable="YES"
```
Имя хоста
```sh
sysrc hostname="myhost"
```
Русский язык
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
Монтирование сетевой файловой системы sshfs  
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
Запрещаем удалённый вход по паролю
```diff
--- /tmp/sshd_config	2026-02-03 17:57:55.388157000 +0300
+++ /etc/ssh/sshd_config	2026-02-03 17:56:18.635920000 +0300
@@ -65,7 +65,7 @@ AuthorizedKeysFile	.ssh/authorized_keys
 # the system's configuration, this may involve passwords, challenge-response,
 # one-time passwords or some combination of these and other methods.
 # Keyboard interactive authentication is also used for PAM authentication.
-#KbdInteractiveAuthentication yes
+KbdInteractiveAuthentication no
 
 # Kerberos options
 #KerberosAuthentication no
```
Список установленных вручную пакетов
```
pkg prime-list
```
Отключить дампы ядра
```sh
sysrc dumpdev="NO"
```
**Для Raspberry Pi 3**  
Звук появится в релизе 16. Пока можно пропатчить и пересобрать ядро с изменениями из 16 ветки
```sh
git clone https://git.FreeBSD.org/src.git -b release/15.0.0 /usr/src
cd /usr/src
git cherry-pick 1d100747d747 70e73c43a472 df764dd133ec 8b43286fc3ba
git diff HEAD..78c5026ae13b -- sys/arm/broadcom/bcm2835/bcm2835_audio.c | git apply && git commit -am "."
git cherry-pick aa6b871ea77e
make -j4 kernel
```
Уменьшить износ SD  
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
Настройка разрешения экрана
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
Сделать HDMI основной консолью
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
