---
title: Модем EM7455
published: 09.04.2024
tags: модем
---

Включение эхо-режима
```default
ATE1
```
Прошивание модема
```default
AT!ENTERCND="A710"
# Очистить все изменения и откатиться к заводским настройкам Lenovo/Sierra
AT!RMARESET=1
AT!IMAGE=0
AT!RESET
```
```sh
qmi-firmware-update --reset -d "1199:9079"
qmi-firmware-update --update-download -d "1199:9079" SWI9X30C_02.33.03.00.cwe SWI9X30C_02.33.03.00_GENERIC_002.072_001.nvu
qmicli -d /dev/cdc-wdm0 --dms-set-firmware-preference=02.33.03.00,002.072_001,GENERIC
```
```default
AT!ENTERCND="A710"
AT!USBVID=1199
AT!USBPID=9071,9070
AT!USBPRODUCT="EM7455"
AT!PRIID?
# Carrier PRI: 9999999_9904609_SWI9X30C_02.24.05.06_00_GENERIC_002.026_000
AT!PRIID="9904609","002.026","Generic-Laptop"
# Заставить модем работать в USB2 режиме для совместимости с современными M.2 интерфейсами
AT!USBSPEED=0
AT!RESET
```
Отключение необходимости запуска скрипта по разблокировке модема
```default
AT!OPENLOCK?
sierrakeygen.py -l <code> -d MDM9x30
AT!OPENLOCK="<newcode>"
AT!PCFCCAUTH=0
AT!RESET
```
