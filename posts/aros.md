---
title: AROS
published: 06.10.2026
tags: amiga
---
### Настройка сети
Как альтернатива настройке через графическую утилиту Network Preferences
```sh
cd SYS:System/Network/arostcp
makedir SYS:Storage/NetConfig
copy db SYS:Storage/NetConfig ALL
SetEnv SAVE AROSTCP/Config SYS:Storage/NetConfig
```
DNS не прилетает по DHCP, нужно настроить вручную
```diff
--- SYS:System/Network/arostcp/db/netdb-myhost	2026-10-06 18:56:54.404488603 +0300
+++ SYS:Storage/NetConfig/netdb-myhost	2026-10-06 08:29:42.000000000 +0300
@@ -4,6 +4,6 @@
 ; name we can disregard the HOST and DOMAIN entry.
 HOST 192.168.0.188 arosbox.arosnet arosbox
 ; Domain names
-DOMAIN arosnet 192.168.0.
+;DOMAIN arosnet 192.168.0.
 ; Name servers
-NAMESERVER 192.168.0.1
+NAMESERVER 1.2.3.4
```
## Для Raspberry Pi 3 Model B+  
### Поддержка сети
Драйвер `usblan78xx.device` не отображается в сетевых устройствах в Network Preferences. Необходимо добавить вручную. Либо как альтернатива настроить через файл интерфейсов AROSTCP
```diff
--- SYS:System/Network/arostcp/db/interfaces	2026-10-06 18:52:39.620727017 +0300
+++ SYS:Storage/NetConfig/interfaces	2026-10-06 08:29:42.000000000 +0300
@@ -117,6 +117,5 @@
 # .. Linux-hosted AROS (using the TUN/TAP driver)
 #
 #eth0 DEV=DEVS:networks/tap.device UNIT=0 IP=192.168.0.188 UP
-eth0 DEV=DEVS:networks/usblan78xx.device UNIT=0 IP=DHCP UP
 #
 # EOF
```
Для автозапуска сети  
S:User-Startup
```sh
Set count 0

Lab loop
    Set count `Eval $$$$count + 1`

    PsdDevLister >RAM:devlist.txt
    Search RAM:devlist.txt "lan78xx.class"

    If Not warn
        SetEnv SAVE AROSTCP/Config SYS:Storage/NetConfig
        Execute SYS:System/Network/AROSTCP/S/startnet

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
+hdmi_cvt=1920 1080 60 3 0 0 1
+hdmi_ignore_edid=0xa5000080
+hdmi_group=2
+hdmi_mode=87
+hdmi_force_hotplug=1
+
 [pi5]
 enable_rp1_uart=1
 pciex4_reset=0
```