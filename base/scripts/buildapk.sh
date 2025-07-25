#!/data/data/com.termux/files/usr/bin/bash

ANDROID_JAR="/sdcard/android.jar"
INPUT_DIR=$(pwd)
OUTPUT_DIR="gen"
OUTPUT_FILE="app.apk"

GRADLE="false"

show_full_help() {
    echo
    echo "usage: buildapk [-d input dir][-o output dir][-f output file][-j android jar]"
    echo
    echo "Compile and package android applications."
    echo
    echo "Example:"
    echo "   buildapk -d /sdcard/app -o build -f lol.apk -j /sdcard/lol/android.jar"
    echo
    echo "(None of the aguments required - just execute from same dir as AndroidManifest.xml)"
}

show_help() {
    echo "usage: buildapk [-d input dir][-o output dir][-f output file][-j android jar]"
}

set_in_directory() {
    INPUT_DIR=$1

}

set_out_directory() {
    OUTPUT_DIR=$1

}

set_out_file() {
    OUTPUT_FILE=$1
}

set_jar_path() {
    ANDROID_JAR=$1
}

do_build() {
    if [ ! -f $ANDROID_JAR ]; then
        echo "Error: android.jar not found in $ANDROID_JAR. Aborting..."
        exit 1
    fi

    type aapt > /dev/null || { echo >&2 "Error: Please install 'aapt'. Aborting..."; exit 1; }
    type jack > /dev/null || { echo >&2 "Error: Please install 'jack'. Aborting..."; exit 1; }
    type apksigner > /dev/null || { echo >&2 "Error: Please install 'apksigner'. Aborting..."; exit 1; }

    if [ ! -d $OUTPUT_DIR ]; then
        mkdir $OUTPUT_DIR
    else
        rm -rf $OUTPUT_DIR
        mkdir $OUTPUT_DIR
    fi
    mkdir $OUTPUT_DIR/build

    echo "#########################"
    echo "     Starting Build      "
    echo "#########################"

    if [ -f  ]; then
        GRADLE="true"
        echo "Gradle project detected."
        echo 
    fi

    echo -n "Creating R.java..."
    if [ ! -f "$INPUT_DIR/AndroidManifest.xml" ]; then
        echo "fail"
        echo "Error: not an app project. Aborting..."
        rm -rf $OUTPUT_DIR
        exit 1
    fi
    aapt package -m -J $OUTPUT_DIR/build -M ./AndroidManifest.xml -S res -I $ANDROID_JAR
    echo "done"

    echo -n "Compilng and dexing source files..."
    jack --output-dex $OUTPUT_DIR/build
    echo "done"

    echo -n "Creating apk and adding dexed classes..."
    cd $OUTPUT_DIR
    aapt package -f -M ../AndroidManifest.xml -S ../res -I $ANDROID_JAR -F build/app.apk.unaligned
    aapt add -f build/app.apk.unaligned build/classes.dex
    echo "done"

    echo -n "Signing finished apk..."
    apksigner keystore build/app.apk.unaligned $OUTPUT_FILE
    echo "done"

    echo "Done! Finished apk is in the $OUTPUT_DIR folder."
    echo "https://github.com/TheDiamondYT1/termux-buildapk"
}

while getopts ":h:d:o:f:j:" o; do
    case "${o}" in
        h)
            show_full_help
            exit 1;;
        d)
            set_in_directory ${OPTARG};;
        o)
            set_out_directory ${OPTARG};;
        f)
            set_out_file ${OPTARG};;
        j)
            set_jar_path ${OPTARG};;
        *)
            echo "Invalid option $1"
            show_help
            exit 1;;
    esac
done

echo 
do_build
