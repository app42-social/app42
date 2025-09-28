#!/usr/bin/env bash
set -ex

# Install dependencies
apt-get update
apt-get install -y clang cmake ninja-build pkg-config curl unzip zip xz-utils libglu1-mesa libgtk-3-dev mesa-utils

export FLUTTER_HOME="/home/vscode/.local/flutter"

# Install Flutter
if [ ! -d $FLUTTER_HOME ]; then
    echo "Installing Flutter..."
    mkdir -p /home/vscode/.local/bin/
    git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
    ln -sf $FLUTTER_HOME/bin/flutter /home/vscode/.local/bin/
    ln -sf $FLUTTER_HOME/bin/flutter-dev /home/vscode/.local/bin/
    ln -sf $FLUTTER_HOME/bin/dart /home/vscode/.local/bin/
    sudo chown -R vscode:vscode /home/vscode/.local
fi

export ANDROID_SDK_ROOT="/home/vscode/.local/android-sdk"
export ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip"

# Android SDK (command line tools only)
if [ ! -d $ANDROID_SDK_ROOT ]; then
    echo "Installing Android SDK..."
    mkdir -p $ANDROID_SDK_ROOT
    cd $ANDROID_SDK_ROOT
    curl -fLo tools.zip $ANDROID_TOOLS_URL
    unzip -o tools.zip
    mv cmdline-tools tools
    rm tools.zip
    $FLUTTER_HOME/bin/flutter config --android-sdk $ANDROID_SDK_ROOT
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

export PATH="$ANDROID_SDK_ROOT/tools/bin":"$PATH"
export JAVA_HOME="/usr/local/sdkman/candidates/java/current/"

# Install SDK packages
yes | sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT
sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-34"

# Move ownership to vscode user
sudo chown -R vscode:vscode /home/vscode/.local

# Run Flutter doctor
sudo -u vscode /home/vscode/.local/bin/flutter doctor || true
