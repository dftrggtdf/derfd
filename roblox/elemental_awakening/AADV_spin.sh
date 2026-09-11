#!/bin/bash

# ============================================================
# AADV Spin Target Finder - V1
# ============================================================

set -u

# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

KEYBOARD_ID=13

TARGET_HEX="79ff77"

RECOVERY_HEX="ffffff"
RECOVERY_X=1251
RECOVERY_Y=914

STOP_FILE="/tmp/aadv_spin_stop_$$"

# ------------------------------------------------------------
# LEVEL UP SETTINGS
# ------------------------------------------------------------

SAFE_ZONE_X=970
SAFE_ZONE_Y=870

LEVEL_ONE_X=955
LEVEL_ONE_Y=995

LEVEL_UP_TIME=10

# ------------------------------------------------------------
# BUTTON COORDINATES
# ------------------------------------------------------------

PLAY_X=730
PLAY_Y=925

CHANGE_X=1230
CHANGE_Y=930

SPIN_X=970
SPIN_Y=685

CONTINUE_X=1145
CONTINUE_Y=755

EXIT_X=1005
EXIT_Y=885

# ------------------------------------------------------------
# RESULT TEXT AREA
# ------------------------------------------------------------

RESULT_X=900
RESULT_Y=490
RESULT_W=120
RESULT_H=115

# ------------------------------------------------------------
# TARGET ELEMENT
# ------------------------------------------------------------

TARGET_ELEMENT="light"

# ------------------------------------------------------------
# RARITY SETTINGS
# ------------------------------------------------------------

# These are the rarities which require Continue after the
# second spin instead of Exit.
#
# IMPORTANT:
# The current RESULT area must actually contain the rarity
# text for this detection to work.

HIGH_RARITY_1="exotic"

# Add more rarities here if the game has them.
# Example:
# HIGH_RARITY_2="legendary"
# HIGH_RARITY_3="mythic"

# ------------------------------------------------------------
# COUNTER / TIMER
# ------------------------------------------------------------

COUNT=0
START_TIME=$(date +%s)

KEY_PID=""
MAIN_PID=$$

# ------------------------------------------------------------
# CLEANUP
# ------------------------------------------------------------

cleanup() {
    if [[ -n "${KEY_PID:-}" ]]; then
        kill "$KEY_PID" 2>/dev/null || true
    fi
    rm -f "$STOP_FILE"
}

# ------------------------------------------------------------
# REAL STOP HANDLER
# ------------------------------------------------------------

stop_script() {
    echo
    echo "[#] SCRIPT STOPPED"
    trap - INT TERM EXIT

    if [[ -n "${KEY_PID:-}" ]]; then
        kill "$KEY_PID" 2>/dev/null || true
    fi

    rm -f "$STOP_FILE"
    exit 0
}

trap stop_script INT TERM
trap cleanup EXIT

# ------------------------------------------------------------
# STOP CHECK
# ------------------------------------------------------------

check_stop() {
    if [[ -f "$STOP_FILE" ]]; then
        stop_script
    fi
}

# ------------------------------------------------------------
# EMERGENCY C LISTENER
# ------------------------------------------------------------

(
    stdbuf -oL xinput test "$KEYBOARD_ID" 2>/dev/null |
    while read -r type action keycode; do
        if [[ "$type" == "key" &&
              "$action" == "press" &&
              "$keycode" == "54" ]]; then

            touch "$STOP_FILE"

            echo
            echo "[#] EMERGENCY STOP - C"

            kill -TERM "$MAIN_PID" 2>/dev/null || true
            break
        fi
    done
) &

KEY_PID=$!

# ------------------------------------------------------------
# BUTTON CLICK
# ------------------------------------------------------------

click_button() {
    local X="$1"
    local Y="$2"

    check_stop

    xdotool mousemove "$X" "$Y"

    sleep 0.2

    check_stop

    xdotool click 1
}

# ------------------------------------------------------------
# READ EXACT PIXEL HEX
# ------------------------------------------------------------

get_pixel_hex() {
    local X="$1"
    local Y="$2"

    import -window root \
        -crop 1x1+"$X"+"$Y" \
        txt:- 2>/dev/null |
        grep -o '#[0-9A-Fa-f]\{6\}' |
        head -n 1 |
        tr '[:upper:]' '[:lower:]'
}

# ------------------------------------------------------------
# CHECK TARGET HEX
# ------------------------------------------------------------

screen_has_target_hex() {
    local TARGET="$1"
    local SCREENSHOT
    local FOUND

    SCREENSHOT=$(mktemp --suffix=.png)

    import -window root "$SCREENSHOT" 2>/dev/null

    FOUND=$(python3 - "$SCREENSHOT" "$TARGET" <<'PY'
import sys
from PIL import Image

filename = sys.argv[1]
target_hex = sys.argv[2].lstrip("#").lower()

try:
    target = (
        int(target_hex[0:2], 16),
        int(target_hex[2:4], 16),
        int(target_hex[4:6], 16)
    )

    img = Image.open(filename).convert("RGB")

    for pixel in img.getdata():
        if pixel == target:
            print("1")
            sys.exit(0)

    print("0")

except Exception:
    print("0")
PY
)

    rm -f "$SCREENSHOT"

    [[ "$FOUND" == "1" ]]
}

# ------------------------------------------------------------
# ELAPSED TIME
# ------------------------------------------------------------

show_status() {
    local NOW
    local ELAPSED
    local HOURS
    local MINUTES
    local SECONDS

    NOW=$(date +%s)

    ELAPSED=$((NOW - START_TIME))

    HOURS=$((ELAPSED / 3600))
    MINUTES=$(((ELAPSED % 3600) / 60))
    SECONDS=$((ELAPSED % 60))

    echo
    echo "----------------------------------------"
    echo "Cycles completed: $COUNT"

    printf "Elapsed: %02d:%02d:%02d\n" \
        "$HOURS" \
        "$MINUTES" \
        "$SECONDS"

    echo "----------------------------------------"
    echo
}

# ------------------------------------------------------------
# LEVEL UP
# ------------------------------------------------------------

level_up() {
    check_stop

    echo "[LEVEL UP]"
    echo "[LEVEL UP] Moving to 1..."

    xdotool mousemove "$LEVEL_ONE_X" "$LEVEL_ONE_Y"

    sleep 0.2

    check_stop

    echo "[LEVEL UP] Pressing 1..."
    xdotool click 1

    check_stop

    echo "[LEVEL UP] Moving to Safe Zone..."

    xdotool mousemove "$SAFE_ZONE_X" "$SAFE_ZONE_Y"

    sleep 0.2

    check_stop

    echo "[LEVEL UP] Clicking Safe Zone..."
    xdotool click 1

    check_stop

    echo "[LEVEL UP] Moving to 1..."

    xdotool mousemove "$LEVEL_ONE_X" "$LEVEL_ONE_Y"

    sleep 0.2

    check_stop

    echo "[LEVEL UP] Pressing 1..."
    xdotool click 1

    check_stop

    echo "[LEVEL UP] Moving to Safe Zone..."

    xdotool mousemove "$SAFE_ZONE_X" "$SAFE_ZONE_Y"

    sleep 0.2

    check_stop

    echo "[LEVEL UP] Clicking Safe Zone..."
    xdotool click 1

    check_stop

    echo "[LEVEL UP] Moving to 1..."

    xdotool mousemove "$LEVEL_ONE_X" "$LEVEL_ONE_Y"

    sleep 0.2

    check_stop

    echo "[LEVEL UP] Pressing 1..."
    xdotool click 1

    check_stop

    echo "[LEVEL UP] Moving to Safe Zone..."

    xdotool mousemove "$SAFE_ZONE_X" "$SAFE_ZONE_Y"

    sleep 0.2

    check_stop

    echo "[LEVEL UP] Starting ${LEVEL_UP_TIME} second click..."

    local START_NS
    local NOW_NS
    local ELAPSED_NS
    local LEVEL_UP_TIME_NS
    local REMAINING_NS
    local REMAINING_TENTHS

    START_NS=$(date +%s%N)

    LEVEL_UP_TIME_NS=$(
        awk "BEGIN {printf \"%.0f\", $LEVEL_UP_TIME * 1000000000}"
    )

    while true; do
        check_stop

        NOW_NS=$(date +%s%N)

        ELAPSED_NS=$((NOW_NS - START_NS))

        if (( ELAPSED_NS >= LEVEL_UP_TIME_NS )); then
            break
        fi

        REMAINING_NS=$((LEVEL_UP_TIME_NS - ELAPSED_NS))

        REMAINING_TENTHS=$((REMAINING_NS / 100000000))

        xdotool mousemove "$SAFE_ZONE_X" "$SAFE_ZONE_Y"
        xdotool click 1

        printf "\r[LEVEL UP] Clicking... %d.%d seconds remaining" \
            "$((REMAINING_TENTHS / 10))" \
            "$((REMAINING_TENTHS % 10))"

        sleep 0.1
    done

    echo

    echo "[LEVEL UP] ${LEVEL_UP_TIME} seconds completed."

    sleep 1

    check_stop
}

# ------------------------------------------------------------
# RESET
# ------------------------------------------------------------

reset_game() {
    check_stop

    echo "[RESET]"

    xdotool mousemove 500 500

    sleep 0.5

    check_stop

    xdotool key Escape

    sleep 1

    check_stop

    xdotool key r

    sleep 1

    check_stop

    xdotool key Return

    sleep 1
}

# ------------------------------------------------------------
# CHANGE ELEMENT
# ------------------------------------------------------------

change_element() {
    check_stop

    echo "[CHANGE ELEMENT]"

    click_button "$CHANGE_X" "$CHANGE_Y"

    sleep 1
}

# ------------------------------------------------------------
# SPIN
# ------------------------------------------------------------

do_spin() {
    check_stop

    echo "[SPIN]"

    click_button "$SPIN_X" "$SPIN_Y"

    sleep 0.5
}

# ------------------------------------------------------------
# WAIT FOR RESULT
# ------------------------------------------------------------

wait_for_result() {
    echo "[HEX CHECK] Waiting for #$TARGET_HEX..."

    local RECOVERY_ACTIVE=0
    local HEX

    while true; do
        check_stop

        HEX=$(get_pixel_hex "$RECOVERY_X" "$RECOVERY_Y")

        if [[ "$HEX" == "#$RECOVERY_HEX" ]]; then

            if [[ "$RECOVERY_ACTIVE" == "0" ]]; then

                echo
                echo "[RECOVERY] #$RECOVERY_HEX FOUND"
                echo "[RECOVERY] Opening Change Element..."

                RECOVERY_ACTIVE=1

                change_element

                echo "[RECOVERY] Change Element pressed."
                echo "[RECOVERY] Spinning again..."

                do_spin

                echo "[HEX CHECK] Waiting for #$TARGET_HEX again..."
            fi

            sleep 0.2

            continue
        fi

        if [[ "$RECOVERY_ACTIVE" == "1" ]]; then
            RECOVERY_ACTIVE=0
        fi

        if screen_has_target_hex "$TARGET_HEX"; then

            echo
            echo "[HEX CHECK] #$TARGET_HEX FOUND"

            return 0
        fi

        sleep 0.25
    done
}

# ------------------------------------------------------------
# CONTINUE
# ------------------------------------------------------------

press_continue() {
    check_stop

    echo "[CONTINUE]"

    click_button "$CONTINUE_X" "$CONTINUE_Y"

    sleep 1
}

# ------------------------------------------------------------
# EXIT
# ------------------------------------------------------------

press_exit() {
    check_stop

    echo "[EXIT]"

    click_button "$EXIT_X" "$EXIT_Y"

    sleep 1
}

# ------------------------------------------------------------
# PLAY
# ------------------------------------------------------------

press_play() {
    check_stop

    echo "[PLAY]"

    click_button "$PLAY_X" "$PLAY_Y"

    sleep 1
}

# ------------------------------------------------------------
# CAPTURE FINAL RESULT TEXT
# ------------------------------------------------------------

capture_final_result() {
    local OUTPUT="$1"

    check_stop

    echo "[RESULT] Capturing result text area..."

    import -window root \
        -crop "${RESULT_W}x${RESULT_H}+${RESULT_X}+${RESULT_Y}" \
        "$OUTPUT" 2>/dev/null

    if [[ ! -s "$OUTPUT" ]]; then

        echo "[RESULT] ERROR: Could not capture result."

        return 1
    fi

    return 0
}

# ------------------------------------------------------------
# NORMALIZE OCR TEXT
# ------------------------------------------------------------

normalize_ocr_text() {
    echo "$1" |
        tr '[:upper:]' '[:lower:]' |
        tr -cd '[:alnum:]'
}

# ------------------------------------------------------------
# CHECK HIGH RARITY
# ------------------------------------------------------------

is_high_rarity() {
    local OCR_TEXT="$1"

    if [[ "$OCR_TEXT" == *"exotic"* ]]; then
        return 0
    fi

    # Future rarities can be added here.
    #
    # if [[ "$OCR_TEXT" == *"legendary"* ]]; then
    #     return 0
    # fi
    #
    # if [[ "$OCR_TEXT" == *"mythic"* ]]; then
    #     return 0
    # fi

    return 1
}

# ------------------------------------------------------------
# RECOGNIZE FINAL RESULT
# ------------------------------------------------------------

recognize_final_result() {
    local RESULT_IMAGE="$1"

    check_stop

    if ! command -v tesseract >/dev/null 2>&1; then

        echo
        echo "[OCR] ERROR: tesseract is not installed."
        echo
        echo "Install it with:"
        echo "sudo apt install tesseract-ocr"
        echo

        return 2
    fi

    if [[ ! -f "$RESULT_IMAGE" ]]; then

        echo
        echo "[OCR] ERROR: Result image does not exist."

        return 2
    fi

    local OCR_OUTPUT
    local RAW_TEXT
    local OCR_TEXT
    local TARGET_TEXT

    OCR_OUTPUT=$(mktemp)

    echo "[OCR] Reading final result text..."

    tesseract \
        "$RESULT_IMAGE" \
        stdout \
        --psm 6 \
        2>/dev/null > "$OCR_OUTPUT"

    if [[ ! -s "$OCR_OUTPUT" ]]; then

        rm -f "$OCR_OUTPUT"

        echo
        echo "[OCR] ERROR: No text was recognized."

        return 2
    fi

    RAW_TEXT=$(cat "$OCR_OUTPUT")

    rm -f "$OCR_OUTPUT"

    echo
    echo "----------------------------------------"
    echo "[OCR] RAW TEXT:"
    echo "$RAW_TEXT"
    echo "----------------------------------------"
    echo

    OCR_TEXT=$(normalize_ocr_text "$RAW_TEXT")

    TARGET_TEXT=$(normalize_ocr_text "$TARGET_ELEMENT")

    echo "[OCR] Recognized: $OCR_TEXT"
    echo "[OCR] Target:     $TARGET_TEXT"

    if [[ -z "$OCR_TEXT" ]]; then

        echo
        echo "[OCR] ERROR: Recognized text is empty."

        return 2
    fi

    # --------------------------------------------------------
    # HIGH RARITY CHECK
    # --------------------------------------------------------

    if is_high_rarity "$OCR_TEXT"; then

        echo
        echo "[RARITY] HIGH RARITY DETECTED"
        echo "[RARITY] This result requires Continue."

        return 3
    fi

    # --------------------------------------------------------
    # TARGET ELEMENT CHECK
    # --------------------------------------------------------

    if [[ "$OCR_TEXT" == "$TARGET_TEXT" ]]; then

        echo
        echo "[OCR] TARGET MATCHED"

        return 0
    fi

    echo
    echo "[OCR] DIFFERENT ELEMENT DETECTED"

    return 1
}

# ------------------------------------------------------------
# CHECK FINAL RESULT
# ------------------------------------------------------------

check_final_result() {
    local TEMP_RESULT
    local STATUS

    TEMP_RESULT=$(mktemp --suffix=.png)

    if ! capture_final_result "$TEMP_RESULT"; then

        rm -f "$TEMP_RESULT"

        return 2
    fi

    echo
    echo "[OCR] Recognizing final spin..."

    recognize_final_result "$TEMP_RESULT"

    STATUS=$?

    rm -f "$TEMP_RESULT"

    return "$STATUS"
}

# ------------------------------------------------------------
# FAIL-SAFE PAUSE
# ------------------------------------------------------------

pause_forever() {
    echo
    echo "========================================"
    echo " RESULT VERIFICATION FAILED"
    echo "========================================"
    echo
    echo "The final result could not be verified."
    echo
    echo "The script is paused indefinitely."
    echo
    echo "Press C to stop the script."
    echo
    echo "No automatic Exit will be performed."
    echo "No new cycle will be started."
    echo

    while true; do
        check_stop
        sleep 86400
    done
}

# ------------------------------------------------------------
# STARTUP
# ------------------------------------------------------------

clear

echo "========================================"
echo " AADV Spin Target Finder - V1"
echo "========================================"
echo
echo "Emergency stop: C"
echo
echo "Target HEX: #$TARGET_HEX"
echo "Recovery HEX: #$RECOVERY_HEX"
echo "Recovery pixel: X=$RECOVERY_X Y=$RECOVERY_Y"
echo
echo "Target element:"
echo "$TARGET_ELEMENT"
echo
echo "High rarity:"
echo "$HIGH_RARITY_1"
echo
echo "Result text area:"
echo "X=$RESULT_X Y=$RESULT_Y"
echo "Size: ${RESULT_W}x${RESULT_H}"
echo
echo "Level Up time: ${LEVEL_UP_TIME}s"
echo
echo "Starting in 5 seconds..."
echo "Move your mouse to the game/client."

sleep 5

check_stop

echo
echo "Starting in 1..."

sleep 1

check_stop

echo "STARTING..."

# ------------------------------------------------------------
# MAIN LOOP
# ------------------------------------------------------------

while true; do

    check_stop

    echo
    echo "========================================"
    echo " NEW CYCLE"
    echo "========================================"

    press_play

    check_stop

    level_up

    check_stop

    reset_game

    check_stop

    change_element

    check_stop

    # --------------------------------------------------------
    # SPIN #1
    # --------------------------------------------------------

    echo
    echo "========== SPIN #1 =========="

    do_spin

    check_stop

    wait_for_result

    check_stop

    press_continue

    check_stop

    # --------------------------------------------------------
    # SPIN #2
    # --------------------------------------------------------

    echo
    echo "========== SPIN #2 =========="

    do_spin

    check_stop

    wait_for_result

    check_stop

    # --------------------------------------------------------
    # FINAL RESULT
    # --------------------------------------------------------

    echo
    echo "========== FINAL RESULT =========="

    check_final_result

    RESULT_STATUS=$?

    check_stop

    # --------------------------------------------------------
    # TARGET FOUND
    # --------------------------------------------------------

    if (( RESULT_STATUS == 0 )); then

        echo
        echo "========================================"
        echo " TARGET FOUND"
        echo "========================================"
        echo
        echo "Target:"
        echo "$TARGET_ELEMENT"
        echo
        echo "The second spin matches the target."
        echo
        echo "Script stopped."

        exit 0
    fi

    # --------------------------------------------------------
    # HIGH RARITY
    # --------------------------------------------------------

    if (( RESULT_STATUS == 3 )); then

        echo
        echo "========================================"
        echo " HIGH RARITY RESULT"
        echo "========================================"
        echo
        echo "A rare result was detected."
        echo "Pressing Continue..."
        echo

        press_continue

        check_stop

        echo "[RESULT] Continuing to next result..."

        continue
    fi

    # --------------------------------------------------------
    # OCR / VERIFICATION ERROR
    # --------------------------------------------------------

    if (( RESULT_STATUS == 2 )); then

        pause_forever
    fi

    # --------------------------------------------------------
    # DIFFERENT ELEMENT
    # --------------------------------------------------------

    echo
    echo "[RESULT] Target does not match."
    echo "[RESULT] Pressing Exit..."

    press_exit

    COUNT=$((COUNT + 1))

    show_status

done