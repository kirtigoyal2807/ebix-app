#!/bin/bash
# Production release build for App Store + Play Store
# API: https://admin.thepilates.sa/api/v1/
set -euo pipefail
cd "$(dirname "$0")"

echo "=== Production release: The Pilates ==="
echo "API: https://admin.thepilates.sa/api/v1/"
echo "Version: $(grep '^version:' pubspec.yaml | awk '{print $2}')"
echo ""

echo ">>> flutter pub get"
flutter pub get

echo ""
echo ">>> Android: release App Bundle (Play Store)"
flutter build appbundle --release
AAB="build/app/outputs/bundle/release/app-release.aab"
echo "Android AAB: $AAB"
ls -lh "$AAB"

echo ""
echo ">>> iOS: release IPA (App Store)"
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
IPA="build/ios/ipa/*.ipa"
echo "iOS IPA:"
ls -lh build/ios/ipa/*.ipa 2>/dev/null || ls -lh build/ios/ipa/

echo ""
echo "=== Build complete ==="
echo ""
echo "PLAY STORE:"
echo "  1. Open https://play.google.com/console"
echo "  2. The Pilates -> Production -> Create new release"
echo "  3. Upload: $AAB"
echo "  4. Version code must be higher than last upload (current: 24)"
echo ""
echo "APP STORE (direct — not TestFlight-only):"
echo "  1. Open Transporter app (or Xcode -> Organizer)"
echo "  2. Upload IPA from build/ios/ipa/"
echo "  3. App Store Connect -> My Apps -> The Pilates"
echo "  4. + Version -> select build 24 -> Submit for Review"
echo "     (Skip TestFlight; go straight to App Store submission)"
echo ""
