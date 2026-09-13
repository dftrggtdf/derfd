#!/bin/bash

set -e

REPO_DIR="$HOME/derfd"

echo "=== DERFD SETUP ==="

# Instalează toate pachetele definite în apps.bash
bash "$REPO_DIR/gnu_linux/apps.bash"

# Configurații Openbox
mkdir -p "$HOME/.config/openbox"
mkdir -p "$HOME/.config/tint2"
mkdir -p "$HOME/.config/rofi"

cp "$REPO_DIR/gnu_linux/openbox/rc.xml" \
   "$HOME/.config/openbox/rc.xml"

cp "$REPO_DIR/gnu_linux/openbox/tint2.rc" \
   "$HOME/.config/tint2/tint2rc"

cp "$REPO_DIR/gnu_linux/openbox/autostart(openbox)" \
   "$HOME/.config/openbox/autostart"

chmod +x "$HOME/.config/openbox/autostart"

# Wallpaper
mkdir -p "$HOME/Pictures/Wallpapers"

cp "$REPO_DIR/gnu_linux/2q1yk0tc0r0f1.png" \
   "$HOME/Pictures/Wallpapers/desktop_wallpaper.png"

# Xinit
echo "exec openbox-session" > "$HOME/.xinitrc"

# GTK dark theme
mkdir -p "$HOME/.config/gtk-3.0"

cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name = Adwaita-dark
gtk-application-prefer-dark-theme = true
EOF

echo 'gtk-theme-name = "Adwaita-dark"' > "$HOME/.gtkrc-2.0"

# MATE Terminal
dconf write /org/mate/terminal/profiles/default/use-system-font false
dconf write /org/mate/terminal/profiles/default/font "'Monospace 9'"

echo
echo "=== INSTALARE FINALIZATĂ ==="
echo "Repornește sistemul pentru aplicarea completă a configurației."