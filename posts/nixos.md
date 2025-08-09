---
title: Шпаргалка по NixOS
published: 07.05.2025
tags: nixos
---

Проверка NUR репозитория
```
nix-env -f . -qa \* --meta \
  --allowed-uris https://static.rust-lang.org \
  --option restrict-eval true \
  --option allow-import-from-derivation true \
  --drv-path --show-trace \
  -I nixpkgs=$$$$(nix-instantiate --find-file nixpkgs) \
  -I ./ \
  --json | , jq -r 'values | .[].name'
```
```
nix shell -f '<nixpkgs>' nix-build-uncached -c nix-build-uncached ci.nix -A cacheOutputs
```
Работа офлайн  
[Скрипт](https://github.com/lukyanovartem/scripts/tree/master/moonix) скачивает все зависимости для сборки пакетов с открытым исходным кодом
```
nix build .#<пакет> --offline
```
Деплой
```
nixos-rebuild switch --target-host <адрес машины> --use-remote-sudo
```
Работа с nix store
```
sudo nix-collect-garbage -d
sudo nix-store --optimise
```
Обновление flakes
```
nix flake update <flake> --flake <путь до конфигурации nixos>
```
nix-output-monitor
```
<команда> --log-format internal-json -v |& nom --json
```
Тестирование конфигурации
```
sudo nixos-rebuild test
```
Путь до исходников в установленной системе
```
nix flake metadata nixpkgs
```
Использование локальной инфраструктуры для сборки
```
nix build .#<имя пакета> --builders 'ssh-ng://<адрес машины>' --option builders-use-substitutes true -j0 --substituters 'ssh-ng://<адрес машины>'
```
