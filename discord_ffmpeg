for file in *.mp4; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file")
        if [ "$size" -gt 25000000 ]; then
            echo "Compressing $file for Discord..."
            ffmpeg -y -i "$file" -vcodec libx264 -b:v 1500k -acodec aac -b:a 128k "discord_${file}"
        fi
    fi
done
