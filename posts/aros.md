---
title: AROS
published: 06.10.2026
tags: amiga
---
### Русский язык
В настройках локали поддерживается русский язык, однако в настройках выбора шрифтов по умолчанию выбраны шрифты без поддержки кириллицы. Нужно выбрать шрифты семейств `Open Sans` или `Spectral` в качестве основных, и `xen` в качестве системного. Дополнительно нужно аналогичным образом поменять шрифты в настройках `Zune`

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

### Синхронизация с локальным сервером времени
S:User-Startup
```sh
Set count 0

Lab loop
    Set count `Eval $$$$count + 1`

    Route get default >RAM:User-Startup.txt
    Search RAM:User-Startup.txt "(0)"

    If Not warn
        PiNTP -s 1.2.3.4

        Skip done
    EndIf
    If $$$$count Ge 10 Val
        Skip done
    EndIf

    Wait 1
    Skip loop Back

Lab done
```
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
