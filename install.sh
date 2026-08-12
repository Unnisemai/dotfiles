#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "======================================"
echo "       INSTALADOR DE DOTFILES"
echo "======================================"
echo

cd "$DOTFILES"

echo "==> Repositorio: $DOTFILES"
echo

PACKAGES=(
    stow
    hyprland
    noctalia
    kitty
    cava
    btop
    fastfetch
    fish
    micro
    polkit
    polkit-kde-agent
    uwsm
    xdg-user-dirs
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    hyprcursor
    hyprpicker
    sddm
)

echo "==> Instalando paquetes..."
sudo pacman -S --needed "${PACKAGES[@]}"

echo
echo "==> Comprobando configuraciones existentes..."

PACKAGES_TO_STOW=(
    hypr
    noctalia
    kitty
    cava
    btop
    fastfetch
    fish
    micro
)

mkdir -p "$BACKUP"

for package in "${PACKAGES_TO_STOW[@]}"; do
    CONFIG="$HOME/.config/$package"

    if [ -e "$CONFIG" ] && [ ! -L "$CONFIG" ]; then
        echo "  Backup: $CONFIG"
        mv "$CONFIG" "$BACKUP/"
    fi
done

echo
echo "==> Aplicando configuraciones con GNU Stow..."

for package in "${PACKAGES_TO_STOW[@]}"; do
    echo "  -> $package"
    stow "$package"
done

echo
echo "======================================"
echo "       INSTALACIÓN COMPLETADA"
echo "======================================"
echo

if [ "$(find "$BACKUP" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "Se creó un backup en:"
    echo "  $BACKUP"
    echo
fi

echo "Configuraciones aplicadas:"
echo "  ✓ Hyprland"
echo "  ✓ Noctalia"
echo "  ✓ Kitty"
echo "  ✓ Cava"
echo "  ✓ Btop"
echo "  ✓ Fastfetch"
echo "  ✓ Fish"
echo "  ✓ Micro"
echo
echo "Reiniciá tu sesión para aplicar todo."
