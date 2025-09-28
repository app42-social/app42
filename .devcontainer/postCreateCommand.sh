#!/usr/bin/env bash
set -ex

# Install dependencies
apt-get update
apt-get install -y curl unzip zip xz-utils libglu1-mesa

# Install Flutter
if [ ! -d /home/vscode/.local/flutter ]; then
    echo "Installing Flutter..."
    mkdir -p /home/vscode/.local/bin/
    git clone https://github.com/flutter/flutter.git -b stable /home/vscode/.local/flutter
    ln -sf /home/vscode/.local/flutter/bin/flutter /home/vscode/.local/bin/   
    chown -R vscode:vscode /home/vscode/.local
fi

# Android SDK (command line tools only)
if [ ! -d /usr/local/android-sdk ]; then
    echo "Installing Android SDK..."
    mkdir -p /usr/local/android-sdk/cmdline-tools
    cd /usr/local/android-sdk/
    curl -fLo tools.zip https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
    unzip -o tools.zip -d .
    rm tools.zip
fi

echo 'export ANDROID_SDK_ROOT=/usr/local/android-sdk' >> /home/vscode/.bashrc
echo 'export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH' >> /home/vscode/.bashrc

export ANDROID_SDK_ROOT="/usr/local/android-sdk/"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/bin":"$ANDROID_SDK_ROOT/platform-tools":"$PATH"
export JAVA_HOME="/usr/local/sdkman/candidates/java/current/"

# Install SDK packages
yes | sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT
sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-34"

# Run Flutter doctor
sudo -u vscode /home/vscode/.local/bin/flutter doctor
