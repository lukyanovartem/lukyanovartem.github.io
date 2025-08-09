---
title: Настройки AdGuard Home
published: 28.02.2025
tags: dns, dhcp, adblock
---
# Настройки
## Настройки DNS
### Upstream DNS-серверы
```
# внешние dns сервера для определённых доменов
[/домен1/домен2/]1.2.3.4 5.6.7.8
# использовать глобальные dns для этих поддоменов
[/исключение1.домен1/исключение2.домен2/]#
# для arr стека
[/themoviedb.org/tmdb.org/]4.3.2.1
```
## Настройки клиентов
Имя клиента `yaos`  
Идентификатор `a9:cf:1d:65:79:9a`

# Фильтры
## Пользовательские правила фильтрации
```
# правила для yaos
||quasar.yandex.net^$$$$client=yaos
||appmetrica.yandex.net^$$$$client=yaos
||rpc.alice.yandex.net^$$$$client=yaos
# отключение QUIC
||*^$$$$dnstype=HTTPS
```
