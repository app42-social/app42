#!/usr/bin/env bash
set -ex

# Install dependencies
apt-get update
apt-get install -y clang cmake ninja-build pkg-config curl unzip zip xz-utils libglu1-mesa libgtk-3-dev mesa-utils

# Install Flutter
if [ ! -d /home/vscode/.local/flutter ]; then
    echo "Installing Flutter..."
    mkdir -p /home/vscode/.local/bin/
    git clone https://github.com/flutter/flutter.git -b stable /home/vscode/.local/flutter
    ln -sf /home/vscode/.local/flutter/bin/flutter /home/vscode/.local/bin/
    ln -sf /home/vscode/.local/flutter/bin/flutter-dev /home/vscode/.local/bin/
    ln -sf /home/vscode/.local/flutter/bin/dart /home/vscode/.local/bin/   
    sudo chown -R vscode:vscode /home/vscode/.local
fi

# Android SDK (command line tools only)
if [ ! -d /usr/local/android-sdk ]; then
    echo "Installing Android SDK..."
    mkdir -p /usr/local/android-sdk
    cd /usr/local/android-sdk/
    curl -fLo tools.zip https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
    unzip -o tools.zip
    mv cmdline-tools latest
    rm tools.zip
    /home/vscode/.local/flutter/bin/flutter config --android-sdk /usr/local/android-sdk
fi

# if no google-chrome, install it
if ! command -v google-chrome &> /dev/null; then
    echo "Installing Google Chrome..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub |
        gpg --dearmor -o /usr/share/keyrings/google-linux-signing-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" |
        tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
    apt-get update
    apt-get install -y google-chrome-stable
fi

export ANDROID_SDK_ROOT="/usr/local/android-sdk/"
export PATH="$ANDROID_SDK_ROOT/latest/bin":"$PATH"
export JAVA_HOME="/usr/local/sdkman/candidates/java/current/"

# Install SDK packages
yes | sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT
sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-34"

# Run Flutter doctor
sudo -u vscode /home/vscode/.local/bin/flutter doctor || true
