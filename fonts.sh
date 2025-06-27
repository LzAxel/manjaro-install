#!/bin/bash

echo "Обновление системы..."
sudo pacman -Syu --noconfirm

echo "Установка fontconfig..."
sudo pacman -S fontconfig --noconfirm

echo "Скачивание JetBrains Mono Nerd Font..."
wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

echo "Создание директории для шрифтов..."
mkdir -p ~/.local/share/fonts

echo "Установка шрифта..."
unzip JetBrainsMono.zip -d ~/.local/share/fonts/

echo "Обновление кэша шрифтов..."
fc-cache -fv

echo "Удаление временного файла..."
rm JetBrainsMono.zip

echo "Проверка установленных шрифтов..."
fc-list | grep "JetBrains Mono"

echo "Установка завершена! Шрифт JetBrains Mono Nerd Font теперь доступен."
echo "Чтобы использовать шрифт, выберите его в настройках KDE (Системные настройки -> Внешний вид -> Шрифты)"