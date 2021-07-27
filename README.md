# darkpanda_flutter
## Build android APK 

Prompt the following command: `flutter build apk --release`

## Release

We will be using `appCenter` to release darkpanda app. The approach used is referencing  [this article]([Deploy Flutter Apps using AppCenter](https://medium.com/@maite.daluz11/deploy-flutter-apps-using-appcenter-ec28e8d940bf)).

### Environment variables

The app will retrieve it's environment variables from `.env` on local file system. For production build, the app retrieve environment variables from appcenter. Appcenter provides customed env configurations that are retrievable when building. Please refer to this [official reference](https://docs.microsoft.com/en-us/appcenter/build/custom/variables/).


After custom environment variables are properly set in appcenter build configuration, we can then retrieve variables in `appcenter-post-clone.sh` script.
`appcenter-post-clone.sh` gets executes during building process in appcenter so we can feed env variables to comments  `flutter build --dart-define=ENV=$ENV` when building APK.

```sh
flutter build \
    --dart-define=SERVER_HOST=$SERVER_HOST \
    --dart-define=PUBNUB_PUBLISH_KEY=$PUBNUB_PUBLISH_KEY \
    --dart-define=PUBNUB_SUBSCRIBE_KEY=$PUBNUB_SUBSCRIBE_KEY \
    --dart-define=PUBNUB_SECRET_KEY=$PUBNUB_SECRET_KEY \
    --dart-define=GEOCODING_APIS=$GEOCODING_APIS \
    --dart-define=APPCENTER_ANDROID_APP_SECRET=$APPCENTER_ANDROID_APP_SECRET \
    --dart-define=ENV=$ENV \
    apk --release
```

## TODOs 

- Catch system exception like `json.decode(...)` --- [ok]
 
 ```
 class SomeModel {

     static fromJson(Map<String, dynamic>, data) {
         if (!data.Contains('err_code') && data.Contains('err_msg')) {
            return ... 
         }

     }
 }
 ```
 

- Implement app bottom bar. --- [ok]
- Remove pubnub from the application
- Login / Logout function.
- Handle error when API request failed.
- Initialize firestore instance at the start of the application. --- [ok]
- Female app should add inquiry chats tap.
- All API classes should rethrow errors so that blocs can catch and display API errors.

## Reference

- [Deploy Flutter Apps Using AppCenter](https://medium.com/@maite.daluz11/deploy-flutter-apps-using-appcenter-ec28e8d940bf)
- [Great navigator article ](https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31)
- [How to fix form overflow problem](https://www.google.com/search?q=flutter+from+keyboard+overflow&rlz=1C5CHFA_enTW891TW891&oq=flutter+keyboard+form+o&aqs=chrome.1.69i57j0i10i22i30j69i60.11468j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_6Gd0YMewBrXLmAXXtJe4DA12)
- [Slideup panel animation](https://nhancv.medium.com/simple-slide-up-widget-animation-56b14e0189c5)
- [Enable android map SDK on GCP before using the sdk in flutter](https://console.developers.google.com/google/maps-apis/overview?project=studious-optics-233010)
- [How to distribute IOS app outside of app store?](https://medium.com/globant/ios-in-house-app-distribution-on-own-server-ca23e793670a)