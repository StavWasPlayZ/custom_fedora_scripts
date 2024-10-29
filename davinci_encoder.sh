#!/bin/bash

# For Davinci Resolve.
# Source: https://www.youtube.com/watch?v=WLcW4UWPC5Y&lc=UgzCqHeTZjg1ms_5ATR4AaABAg

usage_err() {
    echo "Usage: $0 <e|encode | d|decode> <f|file | d|dir> <input_path> [out_path] [y|n (add out name extension?)]"
    exit 1
}

main() {
    out_path="./"
    add_extension=true

    # Prameter processing
    if [ "$#" -lt 3 ]; then
        echo "Invalid parameter amount"
        usage_err
    fi; if [ "$#" -ge 4 ]; then
        out_path=$4
    fi; if [ "$#" -eq 5 ]; then
        [[ "$5" == "y" ]] && add_extension=true || add_extension=false
    fi

    case "$2" in
        "f" | "file")
            file_decoder "$1" "$3" "$out_path"
            ;;
        "d" | "dir")
            dir_decoder "$1" "$3" "$out_path"
            ;;
        *)
            echo "Invalid path processing type"
            usage_err
            ;;
    esac
}


##
# $1 - input file path
# $2 - output file path
##
encode_davinci() {    
    # ffmpeg -i "$1" -vcodec mjpeg -q:v 2 -acodec pcm_s16be -q:a 0 -f mov "$1.encoded.mov"
    echo "Source: $1"
    echo "Target: $2"
    ffmpeg -i "$1" -map 0 -c:v mpeg4 -q:v 2 -c:a flac "$2"
}
##
# $1 - input file path
# $2 - output file path
##
decode_davinci() {
    echo "Source: $1"
    echo "Target: $2"
    ffmpeg -i "$1" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k "$2"
}

##
# $1 - codec method
# $2 - input file path
# $3 - output directory path
##
file_decoder() {
    file_out_path="${3%/}/$(basename "$2")"
    if [ "$add_extension" == true ]; then
        file_out_path="${file_out_path}.out.mp4"
    fi

    case "$1" in
        "e" | "encode")
            encode_davinci "$2" "$file_out_path"
            ;;
        "d" | "decode")
            decode_davinci "$2" "$file_out_path"
            ;;
        *)
            echo "Invalid codec type"
            usage_err
            ;;
    esac
}

##
# $1 - codec method
# $2 - input directory path
# $3 - output directory path
##
dir_decoder() {
    echo "Processing for directory $3"
    echo "${2%/}/*"
    for file in "${2%/}"/*; do
        if [ -f "$file" ]; then
            echo "Processing video: $file"
            file_decoder "$1" "$file" "$3"
        fi
    done
}

main "$@"