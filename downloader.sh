#!/bin/bash

if [ "$#" = "0" ]
    then
        echo "Enter url from youtube"
else

    #create temporary dir
    current_time="$(date +%s)"
    temp_load_dir="temp_load_$current_time"
    mkdir "$temp_load_dir" && cd "$temp_load_dir"

    #temporary filename
    temp_load_file="temp_load_file"
    url="$1"

    #cookies file
    cookiesfile="cookies.txt"

    #get youtube page
    wget -Ncq -e "convert-links=off" --keep-session-cookies --save-cookies "$cookiesfile" --no-check-certificate -O "$temp_load_file" "$url"

    #find url in page for download video
    download_url=$(cat "$temp_load_file" | grep -o 'url_encoded_fmt_stream_map\":\"\([^",]\+\)' | grep -o '\(https.*\)' | sed -e 's/%3A/:/g' -e 's/%2F/\//g' -e 's/%3F/\?/g' -e 's/%3D/\=/g' -e 's/\\u0026/\&/g' -e 's/%26/\&/g' -e 's/%252C/%2C/g' -e 's/%252F/\//g')

    #result video filename
    out_file="../video_${current_time}.flv"

    #log file
    logfile="log.txt"

    #download video
    wget -e "convert-links=off" --load-cookies "$cookiesfile" --tries=50 --timeout=45 --no-check-certificate -o "$logfile" -O "$out_file" "$download_url"

    #delete temporary dir
    cd .. && rm -r "$temp_load_dir" 

fi

exit 0