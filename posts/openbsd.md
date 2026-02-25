---
title: OpenBSD
published: 19.02.2026
tags: bsd
---
Интерактивное создание пользователя
```sh
adduser
```
Редактирование /etc/passwd
```sh
vipw
```
Синхронизация времени  
Синхронизировать с локальным сервером времени  
/etc/rc.local
```default
rdate server
```
```sh
rcctl disable ntpd
```
Русский язык  
~/.profile
```sh
export LANG="ru_RU.UTF-8"
```
Настройка X11  
```sh
rcctl enable xenodm
```
Разрешаем локальный беспарольный вход  
/etc/X11/xenodm/Xresources
```default
xlogin*allowNullPasswd: true
```
Русская раскладка  
~/.xsession
```sh
setxkbmap -layout 'us,ru' -option 'grp:caps_toggle,grp_led:caps'
```
Изменить размер шрифта терминала  
~/.Xresources
```default
xterm*faceName: Monospace
xterm*faceSize: 14
```
Кастомизация fvwm
```sh
cp /usr/X11R6/lib/X11/fvwm/.fvwmrc ~/
chmod +w ~/.fvwmrc
```
Монтирование сетевой файловой системы sshfs  
Устанавливаем sshfs-fuse
```sh
pkg_add sshfs-fuse
```
/etc/rc.local
```sh
/usr/local/bin/sshfs -o ro,allow_other,IdentityFile=/home/Artem/.ssh/id_ed25519 ssh@server:/data /mnt
```
Запрещаем удалённый вход по паролю
```diff
--- /tmp/sshd_config	Sat Feb 21 19:20:06 2026
+++ /etc/ssh/sshd_config	Sat Feb 21 19:20:37 2026
@@ -52,13 +52,13 @@ AuthorizedKeysFile	.ssh/authorized_keys
 #IgnoreRhosts yes
 
 # To disable tunneled clear text passwords, change to "no" here!
-#PasswordAuthentication yes
+PasswordAuthentication no
 #PermitEmptyPasswords no
 
 # Change to "no" to disable keyboard-interactive authentication.  Depending on
 # the system's configuration, this may involve passwords, challenge-response,
 # one-time passwords or some combination of these and other methods.
-#KbdInteractiveAuthentication yes
+KbdInteractiveAuthentication no
 
 #AllowAgentForwarding yes
 #AllowTcpForwarding yes
```
Настройка doas  
/etc/doas.conf
```default
permit nopass :wheel
```
Отключение рандомизаций
```diff
--- /tmp/rc	Fri Feb 20 11:07:05 2026
+++ /etc/rc	Fri Feb 20 11:00:41 2026
@@ -677,7 +677,7 @@ echo '.'
 
 # Re-link the kernel, placing the objects in a random order.
 # Replace current with relinked kernel and inform root about it.
-/usr/libexec/reorder_kernel &
+#/usr/libexec/reorder_kernel &
 
 date
 exit 0
```
```sh
rcctl disable library_aslr
```
Включить динамическое изменение частоты процессора
```sh
rcctl enable apmd
rcctl set apmd flags -A
```

**Для Rock Pi 4**  
В отличие от других BSD, у OpenBSD нет готового предустановленного образа. Требуется установка подобная установке на обычный ПК. В [официальной документации](https://ftp.openbsd.org/pub/OpenBSD/7.8/arm64/INSTALL.arm64) всё описано. Если кратко, то нужно подготовить SD карту с установочным образом для данного одноплатника
```sh
wget https://cdn.openbsd.org/pub/OpenBSD/7.8/arm64/miniroot78.img
wget https://cdn.openbsd.org/pub/OpenBSD/7.8/packages/aarch64/u-boot-aarch64-2021.10p11.tgz
tar xzf u-boot-aarch64-2021.10p11.tgz
dd if=miniroot78.img of=/dev/sdX bs=1M
dd if=share/u-boot/rock-pi-4-rk3399/idbloader.img of=/dev/sdX seek=64
dd if=share/u-boot/rock-pi-4-rk3399/u-boot.itb of=/dev/sdXc seek=16384
```
Также miniroot образ не поддерживает графическую консоль, поэтому к [соответствующим пинам](https://docs.radxa.com/en/rock4/rock4d/system-config/uart_debug) одноплатника нужно подключить USB-TTL адаптер на время установки. Miniroot образ загружается в память, так что можно спокойно устанавливать OpenBSD на ту же самую карту, откуда загрузился установщик. Для корректной работы системы обязательно создание раздела подкачки. После установки делаем
```sh
echo "set tty fb0" > /etc/boot.conf
```
После чего можно отключать USB-TTL адаптер и подключать монитор и клавиатуру.

OpenBSD [поддерживает звук](https://man.openbsd.org/escodec) данного одноплатника, однако чтобы система увидела звуковую карту, надо пропатчить загрузчик
```sh
# зависимости для сборки u-boot
pkg_add aarch64-none-elf-gcc py3-elftools arm-trusted-firmware bison dtc swig py3-setuptools pythran gmake
ftp -o /usr/ports/sysutils/u-boot/aarch64/patches/patch-rockpiaudio https://github.com/torvalds/linux/commit/65bd2b8bdb3bddc37bea695789713916327e1c1f.patch
sed -i 's#b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi#arch/arm/dts/rk3399-rock-pi-4.dtsi#' /usr/ports/sysutils/u-boot/aarch64/patches/patch-rockpiaudio
cd /usr/ports/sysutils/u-boot
# нужно убрать все лишние платформы и платы в Makefile-ах перед сборкой
make
dd if=/usr/ports/pobj/u-boot-aarch64-2021.10/u-boot-2021.10/build/rock-pi-4-rk3399/u-boot.itb of=/dev/sd0c seek=16384
```
Уменьшить износ SD  
/etc/fstab
```diff
--- /tmp/fstab	Sat Feb 21 19:23:08 2026
+++ /etc/fstab	Sat Feb 21 19:23:20 2026
@@ -1,2 +1,2 @@
 7cfd13b5a74b3fca.b none swap sw
-7cfd13b5a74b3fca.a / ffs rw,wxallowed 1 1
+7cfd13b5a74b3fca.a / ffs rw,wxallowed,noatime 1 1
```
