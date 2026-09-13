#!/bin/bash

# Ensure required tools are installed
if ! command -v xdotool &> /dev/null; then
    echo "Installing required dependencies..."
    sudo apt update && sudo apt install -y xdotool
fi

# Fetch screen dimensions safely
MAX_X=$(xdotool getdisplaygeometry | awk '{print $1}')
MAX_Y=$(xdotool getdisplaygeometry | awk '{print $2}')

# Start at the center of your screen
X=$((MAX_X / 2))
Y=$((MAX_Y / 2))

# Speed settings (adjust these values to make it faster or slower)
X_SPEED=5
Y_SPEED=5

echo "DVD Mouse simulation running. Press [CTRL + C] in this terminal to stop."

while true; do
    # Calculate next steps
    X=$((X + X_SPEED))
    Y=$((Y + Y_SPEED))

    # Handle wall collisions and clamp inside screen boundaries
    if [ "$X" -ge "$MAX_X" ]; then 
        X=$((MAX_X - 5))
        X_SPEED=$((X_SPEED * -1))
    fi
    if [ "$X" -le 0 ]; then 
        X=5; 
        X_SPEED=$((X_SPEED * -1))
    fi
    if [ "$Y" -ge "$MAX_Y" ]; then 
        Y=$((MAX_Y - 5))
        Y_SPEED=$((Y_SPEED * -1))
    fi
    if [ "$Y" -le 0 ]; then 
        Y=5; 
        Y_SPEED=$((Y_SPEED * -1))
    fi

    # Execute movement
    xdotool mousemove "$X" "$Y"
    
    # Speed control delay
    sleep 0.01
done

