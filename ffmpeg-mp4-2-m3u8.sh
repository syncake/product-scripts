#!/usr/bin/env bash
# ffmpeg/openssl required

epi=$1
keyinfo_path="${epi}/key.keyinfo"
if [ -z $1 ] || [ ! -f "${epi}.mp4" ]; then
    echo "mp4 file name expected or file supplied not exists"
    echo "usage: ./ffmpeg-mp4-2-m3u8.sh filename"
    echo "filename is mp4 file without file extension name, for example abc.mp4 then use \"abc\" as filename"
    exit 1
fi

mkdir $epi
openssl rand 16 > $epi/key.key
echo -e "key.key\n${epi}/key.key" > $keyinfo_path
openssl rand -hex 16 >> $keyinfo_path

ffmpeg -i $epi.mp4 \
    -profile:v baseline \
    -level 3.0 \
    -c:v h264_videotoolbox \
    -start_number 100 \
    -hls_time 10 \
    -hls_list_size 0 \
    -hls_key_info_file $keyinfo_path \
    -hls_segment_filename "${epi}/${epi}-%03d.ts" \
    $epi/playlist.m3u8
