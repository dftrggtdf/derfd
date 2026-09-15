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

    - 1.2 AADV_SCG.sh
        - * requirements:
            - xdotool
            - xinput
            - imagemagick
            - python3
            - python3-pil
            - stdbuf
        
        - * tested:
            - sober
                - AADV_SCG.sh
                    - input problems for me, random freezes sometimes to heat cpu
                    - it works
                - AADV_spin.sh
                    - initially developed under it, problems with input and freezing cpu (whole client)
                    - it works
            - mocktail
                    - no input problems at all
                    - project seems in experimental stage as of right now
                    - it works