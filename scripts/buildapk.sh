#!/data/data/com.termux/files/usr/bin/bash

# === Config ===
INPUT_DIR=$(pwd)
OUTPUT_DIR="gen"
OUTPUT_FILE="app.apk"
ANDROID_JAR="$INPUT_DIR/libs/android.jar"
WEBDAV_URL="http://10.139.79.104:8080"
WEBDAV_USER="admin"
WEBDAV_PASS="admin"

# === Functions ===

show_help() {
    echo "Usage: buildapk [-d input_dir] [-o output_dir] [-f filename.apk]"
}

set_in_directory() { INPUT_DIR=$1; }
set_out_directory() { OUTPUT_DIR=$1; }
set_out_file() { OUTPUT_FILE=$1; }
set_jar_path() { ANDROID_JAR=$1; }

do_build() {
    # Check tools
    for tool in aapt ecj dx apksigner; do
        command -v $tool >/dev/null || {
            echo "❌ Error: $tool not found in PATH"
            exit 1
        }
    done

    # Check android.jar
    if [ ! -f "$ANDROID_JAR" ]; then
        echo "❌ android.jar not found at $ANDROID_JAR"
        exit 1
    fi

    mkdir -p "$OUTPUT_DIR"

    echo "📦 Compiling APK..."
    aapt package -f -m -J src -M AndroidManifest.xml -S res -I "$ANDROID_JAR"
    ecj -d out -sourcepath src $(find src -name "*.java") -classpath "$ANDROID_JAR"
    dx --dex --output=classes.dex out
    aapt package -f -M AndroidManifest.xml -S res -I "$ANDROID_JAR" -F "$OUTPUT_DIR/tmp.apk" .
    aapt add "$OUTPUT_DIR/tmp.apk" classes.dex
    apksigner sign --ks testkey.jks --ks-pass pass:android --key-pass pass:android --out "$OUTPUT_DIR/$OUTPUT_FILE" "$OUTPUT_DIR/tmp.apk"

    echo "✅ Build complete: $OUTPUT_DIR/$OUTPUT_FILE"

    echo "🌐 Uploading to WebDAV: $WEBDAV_URL"
    curl -u "$WEBDAV_USER:$WEBDAV_PASS" -T "$OUTPUT_DIR/$OUTPUT_FILE" "$WEBDAV_URL/$OUTPUT_FILE" && \
    echo "🚀 Upload successful!" || echo "❌ Upload failed"
}

# === Entry Point ===
do_build
