#!/bin/bash
# Script doing the following tasks
# 1 ... downloading the youtube-video given as parameter as mp4
# 2 ... extracting audio and writing it as mp3
# 3 ... splitting audio into chunks of 3 minutes with a numbering in the filename

# Parameters:
# $1 ... youtube-url
# $2 ... desired outfile-name e.g. My_Audio_Project, also used as working subdir

# globale Konstante
LOGFILE="ytac.log"

VIDEO="$1"
OUTFILE="$2"
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
