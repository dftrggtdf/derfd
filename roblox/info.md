automations, scripts (not exploits)

scrpts/automations:
1. elemental awakening
    - AADV_spin.sh
        - * requirements:
            - xdotool
            - xinput
            - imagemagick
            - python3
            - python3-pil
            - tesseract-ocr
            - coreutils
            - gawk

        - * verify
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