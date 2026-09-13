automations, scripts (not exploits)

scrpts/automations:
1. elemental awakening
    - 1.1 AADV_spin.sh
        - * features:
            - cooming soon i forgor

        - * requirements:
            - xdotool
            - xinput
            - imagemagick
            - python3
            - python3-pil
            - tesseract-ocr
            - coreutils
            - gawk
            - 1920x1080 resolution
                - i run those scripts on 1920x1017 (with taskbar)
            - x11

        - * verify:
            - command -v xdotool
            - command -v xinput
            - command -v import
            - command -v python3
            - command -v tesseract
            - command -v awk
            - command -v stdbuf
            - python3 -c 'from PIL import Image; print("Pillow OK")'
            - tesseract --version
            - echo "$XDG_SESSION_TYPE"
            - #!/bin/bash

    - 1.2 AADV_SCG.sh
        - * requirements:
            - xdotool
            - xinput
            - imagemagick
            - python3
            - python3-pil
            - stdbuf