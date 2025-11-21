#!/bin/bash

# Install Flutter if not exists
if [ ! -d "$HOME/flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 $HOME/flutter
fi

# Add Flutter to PATH
export PATH="$PATH:$HOME/flutter/bin"

# Configure Flutter for web
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web
flutter build web --release
