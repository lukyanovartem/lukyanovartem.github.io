---
title: 9Front
published: 24.03.2026
tags: plan9
---
**Для Raspberry Pi 1**  
```sh
cd /sys/src/9/bcm
hget https://lukyanovartem.github.io/content/bcm-audio.diff | patch
mk 'CONF=pi'
bind -b '#S' /dev
9fs 9fat /dev/sdM0/dos
cp 9pi /n/9fat
```
