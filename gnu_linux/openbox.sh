#!/bin/bash

set -e

# ============================================================
# derfd - Debian MATE -> Openbox
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================="
echo " derfd - configurare Openbox"
echo "=========================================="

# ------------------------------------------------------------
# 1. Actualizare lista de pachete
# ------------------------------------------------------------

echo "[1/7] Actualizare APT..."
sudo apt update

# ------------------------------------------------------------
# 2. Eliminare desktop MATE si display manager
# ------------------------------------------------------------

echo "[2/7] Eliminare MATE desktop si display manager..."

sudo apt purge -y \
    'mate-desktop-environment*' \
    'mate-core' \
    'mate-desktop*' \
    lightdm \
    gdm3 \
    sddm \
    nodm \
    slim

sudo apt autoremove -y

# ------------------------------------------------------------
# 3. Instalare Openbox si componentele necesare
# ------------------------------------------------------------

echo "[3/7] Instalare Openbox si componente..."

sudo apt install -y \
    openbox \
    tint2 \
    rofi \
    xcape \
    picom \
    obconf \
    lxappearance \
    pcmanfm \
    engrampa \
    mate-terminal \
    mate-utils \
    mate-calc \
    mate-power-manager \
    network-manager-gnome \
    volumeicon-alsa \
    dunst \
    adwaita-icon-theme \
    xinit \
    xterm \
    dconf-cli

# ------------------------------------------------------------
# 4. Configurare MATE Terminal
# ------------------------------------------------------------

echo "[4/7] Configurare MATE Terminal..."

dconf write /org/mate/terminal/profiles/default/use-system-font false
dconf write /org/mate/terminal/profiles/default/font "'Monospace 10'"

# ------------------------------------------------------------
# 5. Configurare X11 si GTK
# ------------------------------------------------------------

echo "[5/7] Configurare X11 si GTK..."

echo "exec openbox-session" > "$HOME/.xinitrc"

mkdir -p "$HOME/.config/gtk-3.0"

cat > "$HOME/.config/gtk-3.0/settings.ini" <<'EOF'
[Settings]
gtk-theme-name = Adwaita-dark
gtk-application-prefer-dark-theme = true
EOF

cat > "$HOME/.gtkrc-2.0" <<'EOF'
gtk-theme-name = "Adwaita-dark"
EOF

# ------------------------------------------------------------
# 6. Instalare configuratii derfd
# ------------------------------------------------------------

echo "[6/7] Instalare configuratii..."

mkdir -p "$HOME/.config/openbox"
mkdir -p "$HOME/.config/tint2"
mkdir -p "$HOME/.config/pcmanfm/default"
mkdir -p "$HOME/Pictures/Wallpapers"

if [ -f "$SCRIPT_DIR/openbox/rc.xml" ]; then
    cp "$SCRIPT_DIR/openbox/rc.xml" \
       "$HOME/.config/openbox/rc.xml"
fi

if [ -f "$SCRIPT_DIR/openbox/tint2.rc" ]; then
    cp "$SCRIPT_DIR/openbox/tint2.rc" \
       "$HOME/.config/tint2/tint2rc"
fi

if [ -f "$SCRIPT_DIR/openbox/autostart(openbox)" ]; then
    cp "$SCRIPT_DIR/openbox/autostart(openbox)" \
       "$HOME/.config/openbox/autostart"
    chmod +x "$HOME/.config/openbox/autostart"
fi

# ------------------------------------------------------------
# Wallpaper
# ------------------------------------------------------------

if [ -f "$SCRIPT_DIR/2q1yk0tc0r0f1.png" ]; then
    cp "$SCRIPT_DIR/2q1yk0tc0r0f1.png" \
       "$HOME/Pictures/Wallpapers/desktop_wallpaper.png"
fi

# ------------------------------------------------------------
# PCManFM desktop
# ------------------------------------------------------------

cat > "$HOME/.config/pcmanfm/default/desktop-items-0.conf" <<EOF
[*]
wallpaper_mode=crop
wallpaper_common=1
wallpaper=$HOME/Pictures/Wallpapers/desktop_wallpaper.png
EOF

# ------------------------------------------------------------
# 7. Finalizare
# ------------------------------------------------------------

echo
echo "=========================================="
echo " Openbox a fost configurat."
echo "=========================================="
echo
echo "Nu se face reboot automat."
echo
echo "Pentru a porni noua sesiune:"
echo "  startx"
echo