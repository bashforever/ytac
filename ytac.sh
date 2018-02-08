#!/bin/bash
# Script doing recursive search for image files and reduces quality not resolution

# Parameters:
# $1 ... youtube-url
# $2 ... outfile-name

# globale Konstante
LOGFILE="ytac.log"

# testparameter: falls 1 wird keine konversion durchgefuehrt
NOCONV=0

# groessenlimit fuer das ignorieren von kleinen files (bytes)
LIMIT=6000000
VIDEO="$1"
OUTFILE="$2"
# for test only (Bibi Blocksberg)
# VIDEO="https://www.youtube.com/watch?v=TM6b4pAKP0Y"
WORKDIR="/home/immanuel/Downloads"
WORKDIR="/home/immanuel/Skripts/ytac"


# ====================== function getmovie =========================
getmovie () {
    cd "$WORKDIR"
    logtext "Looking for $VIDEO"

    mkdir "$OUTFILE"
    cd "$OUTFILE"

    echo "using command line: youtube-dl -x -audio-format mp3 --restrict-filenames $VIDEO"
    youtube-dl -v -f mp4  --restrict-filenames "$VIDEO" -o "$OUTFILE.mp4"

# extract mp3
    ffmpeg -i "$OUTFILE".mp4 "$OUTFILE".mp3

# now split into junks

    ffmpeg -i "$OUTFILE".mp3 -f segment -segment_time 180 -c copy "$OUTFILE"_%03d.mp3

}











# ===================== function logtext ======================================
# Parameter: Text der ins Logfile geschrieben werden soll
# function for writing text to logfile
logtext () {
   echo "`date`: " $1 2>&1 | tee -a $LOGFILE
}   

# ============================ MAIN ===================================

logtext  "==================  Starting ytac ==================  "
cd $WORKDIR
logtext "starting at dir: $WORKDIR"
getmovie

logtext "ytac finished!"

exit 0

# End of Main


# EOF
