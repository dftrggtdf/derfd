#!/bin/bash

set -e

echo "======================================"
echo " DERFD - PACKAGE INSTALLATION"
echo "======================================"

# Actualizare APT
echo "[1/4] Updating APT..."
sudo apt update

# ======================================
# DESKTOP / OPENBOX
# ======================================

echo "[2/4] Installing desktop packages..."

sudo apt install -y \
    openbox \
    tint2 \
    rofi \
    xcape \
    picom \
    obconf \
    lxappearance \
    pcmanfm \
    mate-terminal \
    engrampa \
    mate-utils \
    mate-calc \
    mate-power-manager \
    network-manager-gnome \
    volumeicon-alsa \
    dunst \
    adwaita-icon-theme \
    xinit \
    xterm \
    dconf-cli \
    feh \
    caja

# ======================================
# UTILITIES
# ======================================

echo "[3/4] Installing utilities..."

sudo apt install -y \
    copyq \
    copyq-plugins \
    falkon \
    inxi \
    fastfetch \
    htop \
    btop \
    curl \
    wget \
    openssh-server \
    stress \
    scrot \
    python3-pip \
    python3-pil \
    python3-tk \
    python3-venv \
    tesseract-ocr \
    ffmpeg \
    qdirstat \
    pluma \
    jq \
    gsimplecal \
    gnome-package-updater \
    package-update-indicator

# ======================================
# FLATPAK
# ======================================

echo "[4/4] Installing Flatpak applications..."

sudo apt install -y flatpak

flatpak remote-add --if-not-exists \
    flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.vinegarhq.Sober -y
flatpak install flathub io.freetubeapp.FreeTube -y

echo
echo "======================================"
echo " INSTALLATION COMPLETE"
echo "======================================"