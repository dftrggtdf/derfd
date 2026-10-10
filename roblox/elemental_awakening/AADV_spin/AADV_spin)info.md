# AADV_spin.sh

## Overview

`AADV_spin.sh` is an automation script for Roblox Elemental Awakening. It uses screen-color detection, level detection, and Tesseract OCR to automate a two-spin sequence and stop when the configured target element is found.

The main idea is to obtain the wanted element while the spin count is still at **2**. The long-term goal is to reach level 1000 with a spin count of 2000 while keeping the chosen element. The low starting spin count is an important part of the intended result.

**Target element:** Configured through `TARGET_ELEMENT` in the script.

## Requirements

Install the required packages on Debian:

```bash
sudo apt update
sudo apt install xdotool xinput imagemagick python3 python3-pil tesseract-ocr coreutils
```

The script requires an X11 session and matching screen coordinates. Its coordinates and image crops are configured for the author's setup.

## Execution sequence

### 1. Startup

1. Displays the script configuration.
2. Starts the emergency-stop listener for the `C` key.
3. Waits for the startup countdown to finish.

### 2. Play and level-up

1. Clicks `PLAY`.
2. Clicks the inventory item in slot `1`.
3. Clicks the Safe Zone.
4. Repeats the inventory and Safe Zone sequence three times.
5. Continuously checks the configured level crop using Tesseract OCR.
6. Detects Level 2 and starts the reset sequence.

### 3. Reset

The script performs these actions in order:

1. Presses `Escape`.
2. Waits `0.5` seconds.
3. Presses `R`.
4. Waits `0.5` seconds.
5. Presses `Enter`.

After resetting, the script continues with the spin sequence.

### 4. First spin — ignored for target selection

1. Clicks `CHANGE ELEMENT`.
2. Clicks `SPIN`.
3. Checks the recovery pixel and scans the screen for the configured target HEX.
4. If the recovery HEX is detected, clicks `CHANGE ELEMENT` and spins again.
5. Waits until the target HEX is detected on the screen.
6. Double-clicks `CONTINUE`.

The first spin is part of the two-spin sequence, but it is not the spin used for the final target-element decision.

### 5. Second spin — target selection

1. Clicks `SPIN` again.
2. Checks the recovery pixel and scans the screen for the target HEX.
3. If the recovery HEX is detected, clicks `CHANGE ELEMENT` and spins again.
4. Waits until the target HEX is detected on the screen.
5. Double-clicks `CONTINUE`.

### 6. Final result verification

1. Captures the configured result-text area.
2. Uses Tesseract OCR to read the result.
3. Normalizes the recognized text before comparing it with the target element.
4. If OCR returns empty or unrecognized text, captures and checks the result again after a `0.5`-second delay.
5. Repeats OCR indefinitely until it recognizes a valid result or the script is manually stopped.

The OCR retry loop has no maximum attempt count. Unrecognized text is not automatically treated as a different element.

### 7. Result handling

* **Target element found:** Stops the script.
* **High-rarity result (`exotic`):** Performs the configured Continue action and proceeds to the next cycle.
* **Different valid element:** Clicks `EXIT`, increments the completed-cycle counter, displays the total cycles and elapsed time, and starts another cycle.
* **Invalid or unreadable OCR:** Keeps retrying instead of pressing `EXIT`.

### 8. Session timeout

The game may disconnect the player after approximately 20 minutes of inactivity or other session conditions. This is a game-side behavior, not a timer implemented by the script. The exact timeout may vary.

### 9. Emergency stop

Press `C` to request an emergency stop while the script is running.

## Detection settings

* **Target HEX:** `79ff77`
* **Recovery HEX:** `ffffff`
* **Level detection:** OCR on a fixed screen crop
* **Final result detection:** Tesseract OCR on a fixed screen crop
* **OCR retry interval:** `0.5` seconds
* **OCR retry limit:** Unlimited

## Important limitations

* Screen coordinates, crop positions, and keyboard device ID are environment-specific.
* The script depends on the game interface remaining in the expected position and scale.
* OCR can require repeated attempts if the result text is not yet readable.
* The current high-rarity check explicitly recognizes `exotic`. Other special result names must be added to the script's recognition logic if they need separate handling.
* The script has been tested on specific setups; behavior may differ on other systems.