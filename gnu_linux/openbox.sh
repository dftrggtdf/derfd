#!/bin/bash

set -e

# ============================================================
# derfd - Debian MATE -> Openbox
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo " derfd - configurare Openbox"
echo "=========================================="

# ------------------------------------------------------------
# 1. Instalare pachete
# ------------------------------------------------------------

echo "[1/7] Instalare pachete..."

bash "$SCRIPT_DIR/apps.bash"

# ------------------------------------------------------------
# 2. Eliminare componente MATE care nu mai sunt necesare
# ------------------------------------------------------------

echo "[2/7] Eliminare componente MATE..."

sudo apt purge -y \
    mate-desktop-environment \
    mate-desktop-environment-core \
    mate-core \
    mate-panel \
    mate-applets \
    mate-indicator-applet \
    mate-control-center \
    mate-session-manager \
    mate-settings-daemon \
    mate-screensaver \
    mate-backgrounds \
    caja \
    caja-common \
    2>/dev/null || true

sudo apt autoremove -y

# ------------------------------------------------------------
# 3. Eliminare display manager
#
# derfd foloseste startx + ~/.xinitrc
# ------------------------------------------------------------

echo "[3/7] Eliminare display manager..."

sudo apt purge -y \
    lightdm \
    gdm3 \
    sddm \
    nodm \
    slim \
    2>/dev/null || true

sudo apt autoremove -y

# ------------------------------------------------------------
# 4. Configurare MATE Terminal
# ------------------------------------------------------------

echo "[4/7] Configurare MATE Terminal..."

dconf write /org/mate/terminal/profiles/default/use-system-font false
dconf write /org/mate/terminal/profiles/default/font "'Monospace 9'"
dconf write /org/mate/terminal/profiles/default/scrollback-unlimited true

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
mkdir -p "$HOME/.config/rofi"
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
# 7. Finalizare
# ------------------------------------------------------------

echo
echo "=========================================="
echo " Openbox a fost configurat."
echo "=========================================="
echo
echo "Poti da reboot la sistem."
echo
echo "Pentru a porni noua sesiune:"
echo "  startx"
echo