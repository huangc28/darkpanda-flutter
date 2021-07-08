#!/usr/bin/env bash

cd ..

# retrieve environment variables

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

# build APK
# if you get "Execution failed for task ':app:lintVitalRelease'." error, uncomment next two lines
# flutter build apk --debug
# flutter build apk --profile
flutter build \
    --dart-define=SERVER_HOST=$SERVER_HOST \
    --dart-define=PUBNUB_PUBLISH_KEY=$PUBNUB_PUBLISH_KEY \
    --dart-define=PUBNUB_SUBSCRIBE_KEY=$PUBNUB_SUBSCRIBE_KEY \
    --dart-define=PUBNUB_SECRET_KEY=$PUBNUB_SECRET_KEY \
    --dart-define=GEOCODING_APIS=$GEOCODING_APIS \
    --dart-define=APPCENTER_ANDROID_APP_SECRET=$APPCENTER_ANDROID_APP_SECRET \
    --dart-define=ENV=$ENV \
    apk --release

# if you need build bundle (AAB) in addition to your APK, uncomment line below and last line of this script.
#flutter build appbundle --release --build-number $APPCENTER_BUILD_ID

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_

# copy the AAB where AppCenter will find it
#mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/release/app-release.aab $_