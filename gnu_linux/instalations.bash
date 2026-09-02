# if from zero helpfull i always mess up
# 1. copyq
sudo apt update -y
sudo apt install copyq copyq-plugins -y

# 2. sober
sudo apt update -y
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# reboot gnu/linux
flatpak install flathub org.vinegarhq.Sober -y

# 3. flakon
sudo apt update -y
sudo apt install falkon -y

# 4. freetube
flatpak update -y
sudo apt update -y
flatpak install io.freetubeapp.FreeTube -y

# 5. xterm terminal
sudo apt update -y
sudo apt install xterm -y

# 6. inxi
sudo apt update -y
sudo apt install inxi -y

# 7. fastfetch
sudo apt update -y
sudo apt install fastfetch -y

# 8. htop
sudo apt update -y
sudo apt install htop -y

# 9. btop
sudo apt update -y
sudo apt install btop -y

# 10. dconf
sudo apt update -y
sudo apt install dconf-cli -y

# 11. curl
sudo apt update -y
sudo apt install curl -y

# 12. wget
sudo apt update -y
sudo apt install wget -y

# 13. ssh
sudo apt update -y
sudo apt install openssh-server -y

# 14. stress (cpu,ram etc)
sudo apt update -y
sudo apt install stress -y

# 15. scrot
sudo apt update -y
sudo apt install scrot -y

# 16. python3 and some utilities
sudo apt update -y
sudo apt install -y python3-pip python3-pil python3-tk scrot

# 17. python environment (env)
sudo apt update -y
sudo apt install -y python3-venv

# 18. ocr
sudo apt update -y
sudo apt install tesseract-ocr -y

# 19. kamoso
sudo apt update -y
sudo apt install org.kde.kamoso -y

# 20. rofi
sudo apt update -y
sudo apt install rofi xcape -y

# 21. openbox
sudo apt update -y
sudo apt install openbox -y

# 22. tint2
sudo apt update -y
sudo apt install tint2 -y

# 23. rofi
sudo apt update -y
sudo apt install rofi -y

# 24. xcape
sudo apt update -y
sudo apt install xcape -y

# 25. feh
sudo apt update -y
sudo apt install feh -y

# 26. obconf
sudo apt update -y
sudo apt install obconf -y

# 27. lxappearance
sudo apt update -y
sudo apt install lxappearance -y

# 28. picom
sudo apt update -y
sudo apt install picom -y

# 29. mate utilities
sudo apt update -y
sudo apt install caja mate-terminal mate-calc mate-utils -y

# 30. pcmanfm
sudo apt update -y
sudo apt install pcmanfm -y

# 31. ffmpeg
sudo apt update -y
sudo apt install ffmpeg -y

# 32. qdirstat
sudo apt update -y
sudo apt install qdirstat -y

# 33. pluma (text editor)
sudo apt update -y
sudo apt install pluma -y

# 34. jq
sudo apt update -y
sudo apt install jq -y

# 35. hexedit
sudo apt update -y
sudo apt install hexedit -y

# 36. gsimplecal - calendar pentru ceasul din tint2
sudo apt update -y
sudo apt install gsimplecal -y

# 37. gnome package updater & notificator systray
sudo apt install gnome-package-updater package-update-indicator -y