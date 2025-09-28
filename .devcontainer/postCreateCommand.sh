#!/usr/bin/env bash
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
echo 'export PATH="/usr/local/flutter/bin:$PATH"' >> /home/vscode/.bashrc
chown -R vscode:vscode /usr/local/flutter

# Install dependencies
apt-get update
apt-get install -y curl unzip zip xz-utils libglu1-mesa

# Android SDK (command line tools only)
mkdir -p /usr/local/android-sdk/cmdline-tools
cd /usr/local/android-sdk/cmdline-tools
curl -Lo tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip tools.zip -d latest
rm tools.zip

echo 'export ANDROID_SDK_ROOT=/usr/local/android-sdk' >> /home/vscode/.bashrc
echo 'export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH' >> /home/vscode/.bashrc

# Install SDK packages
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34"

# Run Flutter doctor
sudo -u vscode /usr/local/flutter/bin/flutter doctor
