#!/bin/bash

# ============================================================
# derfd - Verificator
# Verifică instalarea și configurația derfd
# ============================================================

set +e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PASS=0
WARN=0
FAIL=0

# ------------------------------------------------------------
# Culori
# ------------------------------------------------------------

if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    RESET='\033[0m'
else
    GREEN=''
    YELLOW=''
    RED=''
    BLUE=''
    RESET=''
fi

# ------------------------------------------------------------
# Funcții
# ------------------------------------------------------------

ok() {
    echo -e "  ${GREEN}[OK]${RESET} $1"
    PASS=$((PASS + 1))
}

warn() {
    echo -e "  ${YELLOW}[WARN]${RESET} $1"
    WARN=$((WARN + 1))
}

fail() {
    echo -e "  ${RED}[FAIL]${RESET} $1"
    FAIL=$((FAIL + 1))
}

section() {
    echo
    echo -e "${BLUE}============================================================${RESET}"
    echo -e "${BLUE} $1${RESET}"
    echo -e "${BLUE}============================================================${RESET}"
}

check_package() {
    local package="$1"

    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
        local version
        version="$(dpkg-query -W -f='${Version}' "$package" 2>/dev/null)"
        ok "$package — $version"
    else
        fail "$package — NU este instalat"
    fi
}

check_command() {
    local command="$1"

    if command -v "$command" >/dev/null 2>&1; then
        local path
        path="$(command -v "$command")"

        local version=""

        case "$command" in
            openbox)
                version="$(openbox --version 2>&1 | head -n 1)"
                ;;
            tint2)
                version="$(tint2 --version 2>&1 | head -n 1)"
                ;;
            rofi)
                version="$(rofi -version 2>&1 | head -n 1)"
                ;;
            picom)
                version="$(picom --version 2>&1 | head -n 1)"
                ;;
            xcape)
                version="$(xcape -v 2>&1 | head -n 1)"
                ;;
            pcmanfm)
                version="$(pcmanfm --version 2>&1 | head -n 1)"
                ;;
            mate-terminal)
                version="$(mate-terminal --version 2>&1 | head -n 1)"
                ;;
            falkon)
                version="$(falkon --version 2>&1 | head -n 1)"
                ;;
            gimp)
                version="$(gimp --version 2>&1 | head -n 1)"
                ;;
            vlc)
                version="$(vlc --version 2>&1 | head -n 1)"
                ;;
            ffmpeg)
                version="$(ffmpeg -version 2>&1 | head -n 1)"
                ;;
            audacity)
                version="$(audacity --version 2>&1 | head -n 1)"
                ;;
            kdenlive)
                version="$(kdenlive --version 2>&1 | head -n 1)"
                ;;
            mpv)
                version="$(mpv --version 2>&1 | head -n 1)"
                ;;
            python3)
                version="$(python3 --version 2>&1)"
                ;;
            feh)
                version="$(feh --version 2>&1 | head -n 1)"
                ;;
            inxi)
                version="$(inxi --version 2>&1 | head -n 1)"
                ;;
            fastfetch)
                version="$(fastfetch --version 2>&1 | head -n 1)"
                ;;
            htop)
                version="$(htop --version 2>&1 | head -n 1)"
                ;;
            btop)
                version="$(btop --version 2>&1 | head -n 1)"
                ;;
            curl)
                version="$(curl --version 2>&1 | head -n 1)"
                ;;
            wget)
                version="$(wget --version 2>&1 | head -n 1)"
                ;;
            ffmpeg)
                version="$(ffmpeg -version 2>&1 | head -n 1)"
                ;;
            jq)
                version="$(jq --version 2>&1)"
                ;;
            dunst)
                version="$(dunst --version 2>&1 | head -n 1)"
                ;;
            copyq)
                version="$(copyq --version 2>&1 | head -n 1)"
                ;;
            gsimplecal)
                version="$(dpkg-query -W -f='${Version}' gsimplecal 2>/dev/null)"
                ;;
            xterm)
                version="$(xterm -version 2>&1 | head -n 1)"
                ;;
            xrandr)
                version="$(xrandr --version 2>&1 | head -n 1)"
                ;;
            setxkbmap)
                version="$(setxkbmap -version 2>&1 | head -n 1)"
                ;;
            scrot)
                version="$(scrot --version 2>&1 | head -n 1)"
                ;;
            qdirstat)
                version="$(dpkg-query -W -f='${Version}' qdirstat 2>/dev/null)"
                ;;
            pluma)
                version="$(pluma --version 2>&1 | head -n 1)"
                ;;
            tesseract)
                version="$(tesseract --version 2>&1 | head -n 1)"
                ;;
            openssh-server)
                version="$(dpkg-query -W -f='${Version}' openssh-server 2>/dev/null)"
                ;;
        esac

        if [ -n "$version" ]; then
            ok "$command — $version"
        else
            ok "$command — $path"
        fi
    else
        fail "$command — comandă lipsă"
    fi
}

check_file() {
    local file="$1"
    local description="$2"

    if [ -f "$file" ]; then
        ok "$description"
    else
        fail "$description — lipsește"
    fi
}

check_executable_file() {
    local file="$1"
    local description="$2"

    if [ -x "$file" ]; then
        ok "$description — executabil"
    elif [ -f "$file" ]; then
        warn "$description — există, dar NU este executabil"
    else
        fail "$description — lipsește"
    fi
}

# ============================================================
# START
# ============================================================

clear

echo
echo "============================================================"
echo "                 DERFD - VERIFICATOR"
echo "============================================================"
echo
echo "Director verificat:"
echo "  $SCRIPT_DIR"
echo
echo "Home:"
echo "  $HOME"

# ------------------------------------------------------------
# 1. Sistem
# ------------------------------------------------------------

section "1. SISTEM"

if [ -f /etc/os-release ]; then
    . /etc/os-release

    echo "  OS      : $PRETTY_NAME"
    echo "  Kernel  : $(uname -r)"
    echo "  Arch    : $(uname -m)"
else
    warn "Nu s-a putut identifica sistemul de operare"
fi

# ------------------------------------------------------------
# 2. Pachete desktop
# ------------------------------------------------------------

section "2. PACHETE DESKTOP"

DESKTOP_PACKAGES=(
    openbox
    tint2
    rofi
    xcape
    picom
    obconf
    lxappearance
    pcmanfm
    mate-terminal
    engrampa
    mate-utils
    mate-calc
    mate-power-manager
    network-manager
    network-manager-gnome
    mate-polkit
    volumeicon-alsa
    dunst
    adwaita-icon-theme
    xinit
    x11-xserver-utils
    xterm
    dconf-cli
    dbus-user-session
    dbus-x11
    xdg-utils
    feh
)

for package in "${DESKTOP_PACKAGES[@]}"; do
    check_package "$package"
done

# ------------------------------------------------------------
# 3. Utilități și aplicații
# ------------------------------------------------------------

section "3. UTILITĂȚI ȘI APLICAȚII"

APPLICATION_PACKAGES=(
    copyq
    copyq-plugins
    falkon
    gimp
    vlc
    inxi
    fastfetch
    htop
    btop
    curl
    wget
    openssh-server
    stress
    scrot
    python3-pip
    python3-pil
    python3-tk
    python3-venv
    tesseract-ocr
    ffmpeg
    qdirstat
    pluma
    jq
    gsimplecal
    gnome-package-updater
    package-update-indicator
    audacity
    kdenlive
    mpv
)

for package in "${APPLICATION_PACKAGES[@]}"; do
    check_package "$package"
done

# ------------------------------------------------------------
# 4. Flatpak
# ------------------------------------------------------------

section "4. FLATPAK"

check_package "flatpak"

if command -v flatpak >/dev/null 2>&1; then

    if flatpak remotes --columns=name 2>/dev/null | grep -qx "flathub"; then
        ok "Flathub — configurat"
    else
        fail "Flathub — NU este configurat"
    fi

    if flatpak list --app --columns=application,version 2>/dev/null | \
        grep -q "^org.chromium.Chromium"; then

        chromium_version="$(flatpak list --app --columns=application,version 2>/dev/null | \
            awk '$1=="org.chromium.Chromium"{print $2; exit}')"

        ok "Chromium Flatpak — $chromium_version"
    else
        fail "Chromium Flatpak — NU este instalat"
    fi

    if flatpak list --app --columns=application,version 2>/dev/null | \
        grep -q "^org.kde.krita"; then

        krita_version="$(flatpak list --app --columns=application,version 2>/dev/null | \
            awk '$1=="org.kde.krita"{print $2; exit}')"

        ok "Krita Flatpak — $krita_version"
    else
        fail "Krita Flatpak — NU este instalat"
    fi
fi

# ------------------------------------------------------------
# 5. Comenzi importante
# ------------------------------------------------------------

section "5. COMENZI IMPORTANTE"

COMMANDS=(
    openbox
    tint2
    rofi
    xcape
    picom
    pcmanfm
    mate-terminal
    falkon
    gimp
    vlc
    ffmpeg
    audacity
    kdenlive
    mpv
    python3
    feh
    inxi
    fastfetch
    htop
    btop
    curl
    wget
    jq
    dunst
    copyq
    gsimplecal
    xterm
    xrandr
    setxkbmap
    scrot
    pluma
    tesseract
)

for command in "${COMMANDS[@]}"; do
    check_command "$command"
done

# ------------------------------------------------------------
# 6. Configurații derfd
# ------------------------------------------------------------

section "6. CONFIGURAȚII DERFD"

check_file \
    "$HOME/.config/openbox/rc.xml" \
    "Openbox rc.xml"

check_file \
    "$HOME/.config/tint2/tint2rc" \
    "Tint2 tint2rc"

check_executable_file \
    "$HOME/.config/openbox/autostart" \
    "Openbox autostart"

check_executable_file \
    "$HOME/.config/tint2/keyboard-layout.sh" \
    "Keyboard layout indicator"

check_file \
    "$HOME/.xinitrc" \
    ".xinitrc"

check_file \
    "$HOME/.config/gtk-3.0/settings.ini" \
    "GTK 3 settings"

check_file \
    "$HOME/.gtkrc-2.0" \
    "GTK 2 settings"

check_file \
    "$HOME/Pictures/Wallpapers/desktop_wallpaper.png" \
    "Desktop wallpaper"

# ------------------------------------------------------------
# 7. Verificare conținut keyboard
# ------------------------------------------------------------

section "7. KEYBOARD"

if [ -f "$HOME/.config/openbox/autostart" ]; then

    if grep -q "setxkbmap -layout us,ro,ru" \
        "$HOME/.config/openbox/autostart"; then

        ok "US / RO / RU — configurat"
    else
        fail "US / RO / RU — configurația lipsește"
    fi

    if grep -q "grp:alt_shift_toggle" \
        "$HOME/.config/openbox/autostart"; then

        ok "Alt+Shift — configurat"
    else
        fail "Alt+Shift — configurația lipsește"
    fi
fi

if [ -f "$HOME/.config/tint2/tint2rc" ]; then

    if grep -q "execp_command.*keyboard-layout.sh" \
        "$HOME/.config/tint2/tint2rc"; then

        ok "Tint2 — keyboard indicator conectat"
    else
        fail "Tint2 — keyboard indicator NU este conectat"
    fi
fi

# ------------------------------------------------------------
# 8. X11
# ------------------------------------------------------------

section "8. X11"

if [ -n "$DISPLAY" ]; then
    ok "DISPLAY — $DISPLAY"
else
    warn "DISPLAY — nu este setat (scriptul poate rula din TTY)"
fi

if command -v xset >/dev/null 2>&1; then
    xset_version="$(xset -version 2>&1 | head -n 1)"
    ok "X11 xset — $xset_version"
else
    fail "xset — lipsește"
fi

# ------------------------------------------------------------
# 9. Openbox / Tint2 procese
# ------------------------------------------------------------

section "9. PROCESE"

if pgrep -x openbox >/dev/null 2>&1; then
    ok "Openbox — rulează"
else
    warn "Openbox — nu rulează acum"
fi

if pgrep -x tint2 >/dev/null 2>&1; then
    ok "Tint2 — rulează"
else
    warn "Tint2 — nu rulează acum"
fi

if pgrep -x picom >/dev/null 2>&1; then
    ok "Picom — rulează"
else
    warn "Picom — nu rulează acum"
fi

# ------------------------------------------------------------
# 10. PackageKit / update indicator
# ------------------------------------------------------------

section "10. UPDATE SYSTEM"

check_package "gnome-package-updater"
check_package "package-update-indicator"

if command -v pkcon >/dev/null 2>&1; then
    ok "pkcon — disponibil"
else
    fail "pkcon — lipsește"
fi

if systemctl is-active --quiet packagekit 2>/dev/null; then
    ok "PackageKit — activ"
else
    warn "PackageKit — nu este activ în acest moment"
fi

# ------------------------------------------------------------
# 11. MATE Terminal / dconf
# ------------------------------------------------------------

section "11. MATE TERMINAL"

if command -v dconf >/dev/null 2>&1; then

    terminal_font="$(dconf read /org/mate/terminal/profiles/default/font 2>/dev/null)"

    if [ -n "$terminal_font" ]; then
        ok "Font terminal — $terminal_font"
    else
        warn "Font terminal — nu a putut fi citit"
    fi

    unlimited="$(dconf read /org/mate/terminal/profiles/default/scrollback-unlimited 2>/dev/null)"

    if [ "$unlimited" = "true" ]; then
        ok "Scrollback unlimited — activ"
    else
        warn "Scrollback unlimited — nu este activ"
    fi

else
    fail "dconf — lipsește"
fi

# ------------------------------------------------------------
# 12. Fișiere repo
# ------------------------------------------------------------

section "12. FIȘIERE REPO"

REPO_FILES=(
    "$SCRIPT_DIR/apps.bash"
    "$SCRIPT_DIR/openbox.sh"
    "$SCRIPT_DIR/setup.sh"
    "$SCRIPT_DIR/verificator.sh"
    "$SCRIPT_DIR/2q1yk0tc0r0f1.png"
    "$SCRIPT_DIR/openbox/rc.xml"
    "$SCRIPT_DIR/openbox/tint2.rc"
    "$SCRIPT_DIR/openbox/autostart(openbox)"
    "$SCRIPT_DIR/openbox/keyboard-layout.sh"
)

for file in "${REPO_FILES[@]}"; do
    if [ -f "$file" ]; then
        ok "Repo: $(basename "$file")"
    else
        fail "Repo: $(basename "$file") — lipsește"
    fi
done

# ------------------------------------------------------------
# Rezultat final
# ------------------------------------------------------------

section "REZULTAT"

TOTAL=$((PASS + WARN + FAIL))

echo
echo "  Verificări totale : $TOTAL"
echo -e "  ${GREEN}OK                : $PASS${RESET}"
echo -e "  ${YELLOW}WARN              : $WARN${RESET}"
echo -e "  ${RED}FAIL              : $FAIL${RESET}"
echo

if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
    echo -e "${GREEN}============================================================${RESET}"
    echo -e "${GREEN} DERFD: TOTUL ESTE OK${RESET}"
    echo -e "${GREEN}============================================================${RESET}"
elif [ "$FAIL" -eq 0 ]; then
    echo -e "${YELLOW}============================================================${RESET}"
    echo -e "${YELLOW} DERFD: OK, DAR EXISTĂ AVERTISMENTE${RESET}"
    echo -e "${YELLOW}============================================================${RESET}"
else
    echo -e "${RED}============================================================${RESET}"
    echo -e "${RED} DERFD: EXISTĂ PROBLEME${RESET}"
    echo -e "${RED}============================================================${RESET}"
fi

echo