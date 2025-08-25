#!/bin/bash

echo "🚀 Brother Print SDK Demo - Flutter"
echo "=================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
echo "📱 Flutter version:"
flutter --version
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get
echo ""

# Check for connected devices
echo "🔍 Checking for connected devices..."
flutter devices
echo ""

# Run the app
echo "🎯 Starting Brother Print SDK Demo..."
echo "Use 'r' for hot reload, 'R' for hot restart, 'q' to quit"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - try iOS simulator first, then Android
    if flutter devices | grep -q "iPhone"; then
        echo "📱 Starting on iOS Simulator..."
        flutter run -d ios
    elif flutter devices | grep -q "android"; then
        echo "🤖 Starting on Android device/emulator..."
        flutter run -d android
    else
        echo "❌ No iOS or Android devices found"
        echo "Please start an iOS Simulator or Android emulator first"
        exit 1
    fi
else
    # Linux/Windows - try Android
    if flutter devices | grep -q "android"; then
        echo "🤖 Starting on Android device/emulator..."
        flutter run -d android
    else
        echo "❌ No Android devices found"
        echo "Please start an Android emulator first"
        exit 1
    fi
fi
