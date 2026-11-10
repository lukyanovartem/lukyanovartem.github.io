---
title: AROS
published: 06.10.2026
tags: amiga
---
### Русский язык
В настройках локали поддерживается русский язык, однако в настройках выбора шрифтов по умолчанию выбраны шрифты без поддержки кириллицы. Нужно выбрать шрифты семейств `Open Sans` или `Spectral` в качестве основных, и `xen` в качестве системного. Дополнительно нужно аналогичным образом поменять шрифты в настройках `Zune`

### Синхронизация с локальным сервером времени
```diff
--- timesync.conf	2026-11-04 10:41:24.313200576 +0300
+++ ENVARC:AROSTCP/timesync.conf	2026-11-01 12:17:12.000000000 +0300
@@ -7,7 +7,7 @@

 # NTP servers, tried in this order until one answers.  Repeat the key or
 # list several separated by spaces or commas.  Host names or IPv4 addresses.
-Server=pool.ntp.org
+Server=server

 # Seconds between synchronisations (60 .. 604800).
 Interval=3600
```
### SSH сервер  
```sh
copy sshd_config.example sshd_config
bebbosshkeygen -f ssh_host_ed25519_key

makedir ENVARC:.ssh
edit ENVARC:.ssh/authorized_keys
```
S:User-Startup
```sh
stack 262144
RUN >NIL: bebbosshd
```
### Обновление системы
Перед обновлением не забыть перезаписать папку `SYS:Prefs/Env-Archive` поверх дистрибутивной

## Для Raspberry Pi 3 Model B+  
### Поддержка сети
Драйвер `usblan78xx.device` не отображается в сетевых устройствах в настройках сети. Необходимо прописать вручную

### Настройка разрешения экрана
```diff
--- config.txt.orig	2026-10-06 16:09:48.780558428 +0300
+++ SYS:config.txt	2026-10-06 16:10:13.845250413 +0300
@@ -6,6 +6,16 @@ gpu_mem=256
 enable_uart=1
 framebuffer_depth=32
 framebuffer_ignore_alpha=1
+
+# последняя единица чтобы убрать рамки
+hdmi_cvt=1920 1080 60 3 0 0 1
+# игнорировать разрешение монитора
+hdmi_ignore_edid=0xa5000080
+hdmi_group=2
+hdmi_mode=87
+# игнорировать отсутствие монитора
+hdmi_force_hotplug=1
+
 [pi5]
 enable_rp1_uart=1
 pciex4_reset=0
```
