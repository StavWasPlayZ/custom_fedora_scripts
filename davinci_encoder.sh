#!/bin/bash

# For Davinci Resolve.
# Source: https://www.youtube.com/watch?v=WLcW4UWPC5Y&lc=UgzCqHeTZjg1ms_5ATR4AaABAg

usage_err() {
    echo "Usage: $0 <e|encode|d|decode> <input_file>"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage_err
fi


encode_davinci() {
    # ffmpeg -i "$1" -vcodec mjpeg -q:v 2 -acodec pcm_s16be -q:a 0 -f mov "$1"
    ffmpeg -i "$1" -c:v mpeg4 -q:v 2 -c:a flac "${1}.flac.mp4"
}
decode_davinci() {
    # ffmpeg -i "$1" -c:v libx264 -preset ultrafast -crf 0 "${1}.out.mp4"
    ffmpeg -i "$1" -c:v copy -c:a aac -b:a 192k "${1}.regular.mp4" # Note: Untested
}

case "$1" in
    "e" | "encode")
        encode_davinci "$2"
        ;;
    "d" | "decode")
        decode_davinci "$2"
        ;;
    *)
        usage_err
        ;;
esac