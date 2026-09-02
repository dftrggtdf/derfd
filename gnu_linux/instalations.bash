#!/bin/bash

# ============================================================
# DERFD - Instalare pachete
# ============================================================

# Actualizare liste APT - o singură dată
sudo apt update

# ============================================================
# PACHETE NECESARE
# ============================================================

# 1. CopyQ
sudo apt install copyq copyq-plugins -y

# 2. Falkon
sudo apt install falkon -y

# 3. XTerm
sudo apt install xterm -y

# 4. System information / monitoring
sudo apt install inxi fastfetch htop btop -y

# 5. Dconf
sudo apt install dconf-cli -y

# 6. Network / download utilities
sudo apt install curl wget -y

# 7. SSH
sudo apt install openssh-server -y

# 8. Stress testing
sudo apt install stress -y

# 9. Screenshot
sudo apt install scrot -y

# 10. Python + utilities
sudo apt install python3-pip python3-pil python3-tk python3-venv -y

# 11. OCR
sudo apt install tesseract-ocr -y

# 12. Rofi + xcape
sudo apt install rofi xcape -y

# 13. Openbox
sudo apt install openbox -y

# 14. Tint2
sudo apt install tint2 -y

# 15. Wallpaper
sudo apt install feh -y

# 16. Openbox configuration
sudo apt install obconf lxappearance -y

# 17. Compositor
sudo apt install picom -y

# 18. MATE utilities
sudo apt install caja mate-terminal mate-calc mate-utils mate-power-manager -y

# 19. File manager
sudo apt install pcmanfm -y

# 20. Multimedia
sudo apt install ffmpeg -y

# 21. Disk usage
sudo apt install qdirstat -y

# 22. Text editor
sudo apt install pluma -y

# 23. JSON utility
sudo apt install jq -y

# 24. Hex editor
sudo apt install hexedit -y

# 25. Calendar
sudo apt install gsimplecal -y

# 26. Update Manager + system tray indicator
sudo apt install gnome-package-updater package-update-indicator -y

# ============================================================
# FLATPAK
# ============================================================

sudo apt install flatpak -y

flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

# Sober
flatpak install flathub org.vinegarhq.Sober -y

# FreeTube
flatpak install flathub io.freetubeapp.FreeTube -y

# ============================================================
# OPȚIONALE / INSTALARE MANUALĂ
# ============================================================

# Kamoso
# sudo apt install kamoso -y

# Alte aplicații care nu sunt necesare pentru configurația
# standard pot fi instalate manual aici.