#!/data/data/com.termux/files/usr/bin/bash

# Auto builder for DevVaults APK with aapt+
echo "🚀 Starting APK Build Process with aapt+..."

APP_NAME="DevVaultsModded"
PACKAGE_NAME="com.devvaults.pro"
VERSION_CODE="3"
VERSION_NAME="3.0"

OUT_DIR=output
mkdir -p $OUT_DIR

# Define paths
AAPT_PATH="$HOME/aapt+/aapt"
ANDROID_JAR="$HOME/Android/SDK/platforms/android-33/android.jar"
DEX_FILES="classes.dex classes2.dex"

echo "📦 Creating APK structure..."
mkdir -p $OUT_DIR/$APP_NAME
cp -r res $OUT_DIR/$APP_NAME/
cp AndroidManifest.xml $OUT_DIR/$APP_NAME/

echo "⚙️ Building APK..."
$AAPT_PATH package -f -m -F $OUT_DIR/$APP_NAME.apk \
  -M AndroidManifest.xml -S res -I $ANDROID_JAR

echo "📥 Adding dex files..."
cd $OUT_DIR
zip -u $APP_NAME.apk ../$DEX_FILES

echo "✅ Build Complete: $OUT_DIR/$APP_NAME.apk"
