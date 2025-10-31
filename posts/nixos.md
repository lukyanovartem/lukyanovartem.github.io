---
title: Шпаргалка по NixOS
published: 07.05.2025
tags: nixos
---

Проверка NUR репозитория
```sh
nix-env -f . -qa \* --meta \
  --allowed-uris https://static.rust-lang.org \
  --option restrict-eval true \
  --option allow-import-from-derivation true \
  --drv-path --show-trace \
  -I nixpkgs=$$$$(nix-instantiate --find-file nixpkgs) \
  -I ./ \
  --json | , jq -r 'values | .[].name'
```
```sh
nix shell -f '<nixpkgs>' nix-build-uncached -c nix-build-uncached ci.nix -A cacheOutputs
```
Работа офлайн  
[Скрипт](https://github.com/lukyanovartem/scripts/tree/master/moonix) скачивает все зависимости для сборки пакетов с открытым исходным кодом
```sh
nix build .#<пакет> --offline
```
Деплой
```sh
nixos-rebuild switch --target-host <адрес машины> --use-remote-sudo
```
Работа с nix store
```sh
sudo nix-collect-garbage -d
sudo nix-store --optimise
```
Обновление flakes
```sh
nix flake update <flake> --flake <путь до конфигурации nixos>
```
nix-output-monitor
```sh
<команда> --log-format internal-json -v |& nom --json
```
Тестирование конфигурации
```sh
sudo nixos-rebuild test
```
Путь до исходников в установленной системе
```sh
nix flake metadata nixpkgs
```
Использование локальной инфраструктуры для сборки
```sh
nix build .#<имя пакета> --builders 'ssh-ng://<адрес машины>' --option builders-use-substitutes true -j0 --substituters 'ssh-ng://<адрес машины>'
```
