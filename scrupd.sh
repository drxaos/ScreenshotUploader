#!/bin/bash

# sudo apt-get install inotify-tools zenity xclip curl

WATCHDIR="/home/user/uploads"
HOST="example.com"
SUBDIR="dir"
USER="user"
PASSWD="passwd"

mkdir -p "$WATCHDIR"
inotifywait -m -e close_write -e moved_to --format "%w%f" "$WATCHDIR" | while read "FILE"
do
if [ -f "$FILE" ]; then
filename=$(basename "$FILE")
extension="${filename##*.}"
TONAME="scr_$(date +%s%N | md5sum | head -c13).$extension"
cat "$FILE" | curl -T - "ftp://$USER:$PASSWD@$HOST/$SUBDIR/$TONAME"
echo "https://$HOST/$TONAME" | xclip -filter -selection clipboard;
zenity --info --title="Screenshot Uploader" --ok-label="Close" --text="Url copied to clipboard";

fi
done
: