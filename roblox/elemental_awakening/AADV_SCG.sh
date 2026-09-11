#!/bin/bash

# ============================================================
# AADV Spins Counter Giver - V1
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

STOP_FILE="/tmp/aadv_scg_stop_$$"

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
    echo "Spins completed: $COUNT"

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

    # --------------------------------------------------------
    # TIMED CLICK
    # --------------------------------------------------------

    echo "[LEVEL UP] Starting ${LEVEL_UP_TIME} second click..."

    local START_NS
    local NOW_NS
    local ELAPSED_NS
    local LEVEL_UP_TIME_NS
    local REMAINING_NS
    local REMAINING_TENTHS

    START_NS=$(date +%s%N)

    # Convert LEVEL_UP_TIME seconds to nanoseconds.
    LEVEL_UP_TIME_NS=$(awk "BEGIN {printf \"%.0f\", $LEVEL_UP_TIME * 1000000000}")

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

        # ----------------------------------------------------
        # CHECK RECOVERY PIXEL
        # ----------------------------------------------------

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

        # ----------------------------------------------------
        # CHECK TARGET HEX
        # ----------------------------------------------------

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
# STARTUP
# ------------------------------------------------------------

clear

echo "========================================"
echo " AADV Spins Counter Giver - V1"
echo "========================================"
echo
echo "Emergency stop: C"
echo "Target HEX: #$TARGET_HEX"
echo "Recovery HEX: #$RECOVERY_HEX"
echo "Recovery pixel: X=$RECOVERY_X Y=$RECOVERY_Y"
echo "Level Up time: ${LEVEL_UP_TIME}s"
echo "1 button: X=$LEVEL_ONE_X Y=$LEVEL_ONE_Y"
echo "Safe Zone: X=$SAFE_ZONE_X Y=$SAFE_ZONE_Y"
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
    echo "========== NEW CYCLE =========="

    # 1. PLAY
    press_play

    check_stop

    # 2. LEVEL UP
    level_up

    check_stop

    # 3. RESET
    reset_game

    check_stop

    # 4. CHANGE ELEMENT
    change_element

    check_stop

    # 5. SPIN
    do_spin

    check_stop

    # 6. WAIT FOR TARGET HEX / RECOVERY
    wait_for_result

    check_stop

    # 7. CONTINUE
    press_continue

    check_stop

    # 8. EXIT
    press_exit

    COUNT=$((COUNT + 1))

    show_status

done