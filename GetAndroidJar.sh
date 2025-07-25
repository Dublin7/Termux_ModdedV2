#!/data/data/com.termux/files/usr/bin/bash
mkdir -p libs
echo "Downloading android.jar..."
curl -s -o tmp.zip https://dl.google.com/android/repository/platform-30_r03.zip
unzip -j tmp.zip "platforms/android-30/android.jar" -d libs
rm tmp.zip
echo "Done—libs/android.jar ready!"
