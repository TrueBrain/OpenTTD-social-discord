#!/bin/bash
set -e

# This script attempts to notarize the OpenTTD DMG generated by CPack.
# If you are building an unofficial branch of OpenTTD, please change the bundle
# ID in Info.plist and below.
#
# This uses the Xcode notarytool to perform notarization. You must set up a keychain
# profile called "openttd" using the "store-credentials" notarytool command beforehand.
#
# Before executing this script, you must first configure CMake with at least the following
# parameters:
#
# -DCPACK_BUNDLE_APPLE_CERT_APP={certificate ID}
#
# then run "make package" or "cpack".
#
# This will sign the application with your signing certificate, and will enable
# the hardened runtime.
#
# Then, ensuring you're in your build directory and that the "bundles" directory
# exists with a .dmg in it (clear out any old DMGs first), run:
#
# ../os/macos/notarize.sh

dmg_filename=(bundles/*.dmg)

if [ "${dmg_filename}" = "bundles/*.dmg" ]; then
    echo "No .dmg found in the bundles directory, skipping notarization. Please read this"
    echo "script's source for execution instructions."
    exit 1
fi;

xcrun notarytool submit ${dmg_filename[0]} --keychain-profile "openttd" --wait

# Staple the ticket to the .dmg
xcrun stapler staple "${dmg_filename[0]}"

app_filename=(_CPack_Packages/*/Bundle/discord-social-*/OpenTTD-discord-social.app)

if [ "${app_filename}" = "_CPack_Packages/*/Bundle/discord-social-*/OpenTTD-discord-social.app" ]; then
    echo "No .app found in the _CPack_Packages directory, skipping app stapling."
    exit 0
fi;

# Now staple the ticket to the .app
xcrun stapler staple "${app_filename[0]}"
