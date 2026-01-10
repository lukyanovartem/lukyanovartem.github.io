---
title: Шпаргалка по NixOS
published: 07.05.2025
tags: nixos
---

Работа офлайн  
[Скрипт](https://github.com/lukyanovartem/scripts/tree/master/moonix) скачивает все зависимости для сборки пакетов с открытым исходным кодом
```sh
nix build .#<пакет> --offline
```
Деплой
```sh
nixos-rebuild switch --target-host <адрес машины> --sudo
```
Работа с nix store
```sh
sudo nix-collect-garbage -d
sudo nix-store --optimise
sudo nix-store --verify --check-contents --repair
```
Обновление flakes
```sh
nix flake update <flake> --flake <путь до конфигурации nixos>
```
Использование системного nixpkgs в flakes репозитории
```sh
nix flake lock --override-input nixpkgs flake:nixpkgs
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
nix build .#<имя пакета> --builders 'ssh-ng://<адрес машины>' --option builders-use-substitutes true -j0
```
