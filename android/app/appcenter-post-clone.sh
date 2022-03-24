#!/usr/bin/env bash

cd ..

# retrieve environment variables

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

# switch flutter channel to 'stable' and upgrade to latest build
flutter channel stable
flutter upgrade 2.5.1

# accepting all licenses
yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

flutter doctor

echo "Installed flutter to `pwd`/flutter"

# create .env file specified in pubspec.yaml for build to pass.
# write env vars to .env file.
ENV_FILE="$APPCENTER_SOURCE_DIRECTORY/.env"
touch $ENV_FILE
cat > $ENV_FILE <<- EOM  
ENV=$ENV
SERVER_HOST=$SERVER_HOST
PUBNUB_PUBLISH_KEY=$PUBNUB_PUBLISH_KEY
PUBNUB_SUBSCRIBE_KEY=$PUBNUB_SUBSCRIBE_KEY
PUBNUB_SECRET_KEY=$PUBNUB_SECRET_KEY
GEOCODING_APIS=$GEOCODING_APIS
APPCENTER_ANDROID_APP_SECRET=$APPCENTER_ANDROID_APP_SECRET
EOM

echo ".env content:"
cat $ENV_FILE

# create google-services.json for firestore to work.
GOOGLE_JSON_FILE="$APPCENTER_SOURCE_DIRECTORY/android/app/google-services.json"
touch $GOOGLE_JSON_FILE
echo "Updating Google Json"
echo "$GOOGLE_JSON" > $GOOGLE_JSON_FILE
sed -i -e 's/\\"/'\"'/g' $GOOGLE_JSON_FILE

echo "File content:"
cat $GOOGLE_JSON_FILE

# create `key.properties` at build time that stores credentials of keystore file.  
# keystore is essential to build sign apk on appstore:
#
#   - https://flutter.dev/docs/deployment/android#configure-signing-in-gradle
KEYPROPERTIES_FILE=android/key.properties
touch $KEYPROPERTIES_FILE
cat > $KEYPROPERTIES_FILE <<- EOM  
storePassword=$APPCENTER_KEYSTORE_PASSWORD
keyPassword=$APPCENTER_KEY_PASSWORD
keyAlias=$APPCENTER_KEY_ALIAS
storeFile=keystore.jks
EOM

# build APK
# if you get "Execution failed for task ':app:lintVitalRelease'." error, uncomment next two lines
# flutter build apk --debug
# flutter build apk --profile
flutter build apk --release

# if you need build bundle (AAB) in addition to your APK, uncomment line below and last line of this script.
# flutter build appbundle --release --build-number $APPCENTER_BUILD_ID

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_

# copy the AAB where AppCenter will find it
#mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/release/app-release.aab $_