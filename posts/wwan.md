---
title: Убираем белый список на WWAN модемы для ThinkPad T480s 
published: 09.04.2024
tags: модем
---

**Неактуально, появился порт [Libreboot](https://libreboot.org/docs/install/t480.html)**

Ох уж эта сертификация на модемы, из-за которой можно установить модем только из небольшого списка одобренных. Чтобы убрать ограничение, нужно пропатчить биос. Есть [неплохая статья](https://thrimbor.github.io/2019/09/24/removing-the-m2-whitelist-on-a-thinkpad-t440p.html), однако с ней у меня не вышло. Во-первых бесплатный инструмент Ghidra, рассматриваемый в статье, у меня падает при анализе модуля LenovoWmaPolicyDxe. Пришлось временно воспользоваться пиратской IDA Pro 😳 Кроме того, в статье много воды и лишних телодвижений. В частности, предлагается менять каждый if, делающий проверку на id модема, вместо того, чтобы просто перепрыгнуть подпрограмму, выводящую информационное сообщение и запускающую бесконечный цикл. Да, такой патч получается неуниверсальный, привязанный к конкретной версии, но элементарно создать аналогичный для любой другой версии прошивки.

$gallery("wwan")$

# Настройки WWAN модема Sierra EM7455
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
