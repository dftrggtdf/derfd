#!/bin/bash

set -e

echo "======================================"
echo " DERFD - PACKAGE INSTALLATION"
echo "======================================"

# ======================================
# 1. UPDATE APT
# ======================================

echo "[1/4] Updating APT..."

sudo apt update

# ======================================
# 2. DESKTOP / OPENBOX
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
    feh

# ======================================
# 3. UTILITIES / APPLICATIONS
# ======================================

echo "[3/4] Installing utilities and applications..."

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
    package-update-indicator \
    audacity \
    kdenlive

# ======================================
# 4. FLATPAK
# ======================================

echo "[4/4] Installing Flatpak..."

sudo apt install -y flatpak

flatpak remote-add --if-not-exists \
    flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

# ======================================
# COMPLETE
# ======================================

echo
echo "======================================"
echo " INSTALLATION COMPLETE"
echo "======================================"
echo
echo "Please reboot your system."
echo