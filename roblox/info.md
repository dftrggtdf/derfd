# automations, scripts (not exploits)

## scripts/automations

### 1. Elemental Awakening

#### 1.1 AADV_spin.sh

* * features:

    * target element detection
    * automatic level-up
    * automatic spin handling
    * OCR result verification
    * recovery handling
    * emergency stop
    * fail-safe pause on OCR/result verification failure

* * requirements:

    * X11 session
    * xdotool
    * xinput
    * imagemagick
    * python3
    * python3-pil
    * tesseract-ocr
    * coreutils (`stdbuf`)
    * 1920x1080 display resolution
        * (its actually 1920x1017)

* * install requirements:

    * Debian:

      * `sudo apt install xdotool xinput imagemagick python3 python3-pil tesseract-ocr coreutils`

* * important:

    * The script requires an X11 session.
    * Wayland is not supported.
    * `stdbuf` is provided by the `coreutils` package.
    * `stdbuf` does not need to be installed as a separate package.
    * `tesseract-ocr` is required for level detection and final result OCR.
    * The script uses fixed screen coordinates.
    * The display must be 1920x1080.
    * I run the script at 1920x1080 with a 1017px usable game area because of the taskbar.
    * Different display scaling, resolution, or UI positioning may require coordinate changes.

#### 1.2 AADV_SCG.sh

* * requirements:

    * X11 session
    * xdotool
    * xinput
    * imagemagick
    * python3
    * python3-pil
    * tesseract-ocr
    * coreutils (`stdbuf`)
    * 1920x1080 display resolution

* * install requirements:

    * Debian:

      * `sudo apt install xdotool xinput imagemagick python3 python3-pil tesseract-ocr coreutils`

* * important:

    * The script requires an X11 session.
    * Wayland is not supported.
    * `stdbuf` is provided by the `coreutils` package.
    * `stdbuf` does not need to be installed as a separate package.
    * The script uses fixed screen coordinates.
    * The display must be 1920x1080.
    * I run the script at 1920x1080 with a 1017px usable game area because of the taskbar.

---

## * tested

### Sober

#### AADV_SCG.sh

* input problems for me
* random freezes sometimes, causing high CPU usage
* `C` emergency stop does not seem to work consistently

  * use `Ctrl+C` to stop it when necessary
* script works

#### AADV_spin.sh

* initially developed and tested under Sober
* input problems and occasional client freezing
* `C` emergency stop does not seem to work consistently

  * use `Ctrl+C` to stop it when necessary
* script works

### Mocktail

#### AADV_SCG.sh

* no input problems
* project seems to be in an experimental stage as of right now
* `C` emergency stop does not seem to work consistently

  * use `Ctrl+C` to stop it when necessary
* script works

#### AADV_spin.sh

* same general situation as AADV_SCG.sh
* no confirmed reliable `C` emergency stop
* script works

---

## * how it works

### AADV_SCG.sh

1. clicks PLAY at local X and Y

   * coordinates depend on where PLAY is located

2. checks the level crop and verifies Level 1

   * the level is detected from the crop
   * reference crop images are included/documented with their resolution

3. checks the HEX of the `1` inventory button

   * also checks the HEX when the `1` button becomes visible/available

4. starts the level-up sequence

5. clicks the `1` inventory button and the Safe Zone as required

   * moves to `1`
   * sleeps 0.2 seconds
   * clicks
   * moves to Safe Zone
   * sleeps 0.2 seconds
   * clicks
   * moves to `1`
   * sleeps 0.2 seconds
   * clicks
   * moves to Safe Zone
   * sleeps 0.2 seconds
   * clicks
   * moves to `1`
   * sleeps 0.2 seconds
   * clicks
   * moves to Safe Zone
   * sleeps 0.2 seconds
   * clicks to level up

6. continuously checks the level crop

7. detects when the level changes from Level 1 to Level 2

8. resets the game using Escape → R → Enter

   * presses Escape
   * sleeps 1 second
   * presses R
   * sleeps 1 second
   * presses Enter
   * sleeps 1 second

9. clicks CHANGE ELEMENT

   * checks the required HEX before pressing
   * if the expected HEX is not present, it does not press

10. clicks SPIN

11. checks the recovery pixel for the recovery HEX

    * this represents the end/recovery state of the spin

12. if recovery is detected, clicks CHANGE ELEMENT and SPIN again

13. scans the screen for the target HEX

14. when the target HEX is found, clicks CONTINUE

15. clicks EXIT

16. increases the completed spin counter

17. displays the total spins and elapsed time

18. starts the next cycle

19. `C` is intended to perform an emergency stop

    * currently not reliable on all clients
    * use `Ctrl+C` if necessary

---

### AADV_spin.sh

1. clicks PLAY at local X and Y

2. starts the Level Up sequence

3. clicks the `1` inventory button and the Safe Zone repeatedly

   * moves to `1`
   * sleeps 0.2 seconds
   * clicks
   * moves to Safe Zone
   * sleeps 0.2 seconds
   * clicks
   * moves to `1`
   * sleeps 0.2 seconds
   * clicks
   * moves to Safe Zone
   * sleeps 0.2 seconds
   * clicks
   * moves to `1`
   * sleeps 0.2 seconds
   * clicks
   * moves to Safe Zone
   * starts checking for Level 2

4. continuously checks the level crop for Level 2 using OCR

5. when Level 2 is detected, resets the character

   * presses Escape
   * sleeps 1 second
   * presses R
   * sleeps 1 second
   * presses Enter
   * sleeps 1 second

6. clicks CHANGE ELEMENT

   * checks the required HEX before pressing
   * if the expected HEX is not present, it does not press

7. starts Spin #1

8. checks the recovery pixel and waits for the target HEX

   * the recovery pixel represents the end/recovery state of the spin

9. if the recovery HEX is detected, clicks CHANGE ELEMENT and spins again

10. scans the screen for the target HEX

11. when the target HEX is found, clicks CONTINUE

    * the first spin is not used as the final result

12. starts Spin #2

13. checks the recovery pixel and waits for the target HEX again

14. scans the screen for the target HEX

15. captures the final result text area

    * captures a crop of the configured result area

16. uses Tesseract OCR to read the final result

17. normalizes the OCR text for comparison

18. checks if the result is a high-rarity result (`exotic`)

19. if the result is `exotic`, clicks CONTINUE and starts another cycle

20. if the result matches the target element (`YOUR_ELEMENT`), stops the script

21. if the result is a different element:

    * clicks Continue
    * then clicks Exit
    * starts a new cycle

22. increases the completed cycle counter

    * by 1

23. displays the total completed cycles and elapsed time

    * elapsed time is calculated by the script when status is displayed

24. starts the next cycle

25. `C` performs an emergency stop when the input listener works

    * behavior is not reliable between clients
    * works on Sober in testing
    * did not work reliably on Mocktail
    * use `Ctrl+C` if necessary

26. if OCR/result verification fails, the script enters a permanent fail-safe pause

    * no automatic Exit is performed
    * no new cycle is started
    * the script waits for an emergency stop
    * this behavior has not been fully confirmed in all clients
