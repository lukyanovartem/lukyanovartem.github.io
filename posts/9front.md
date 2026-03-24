---
title: 9Front
published: 24.03.2026
tags: plan9
---
**Для Raspberry Pi 1**  
```sh
ip/ipconfig
cd /src
hget https://lukyanovartem.github.io/content/bcm-audio.patch | patch -p2
cd 9/bcm
mk 'CONF=pi'
bind -b '#S' /dev
9fs 9fat /dev/sdM0/dos
cp 9pi /n/9fat
```
