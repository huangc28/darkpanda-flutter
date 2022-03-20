# darkpanda_flutter
## Build android APK 

Prompt the following command: `flutter build apk --release`

## Release

We will be using `appCenter` to release darkpanda app. The approach used is referencing [Deploy Flutter Apps using AppCenter](https://medium.com/@maite.daluz11/deploy-flutter-apps-using-appcenter-ec28e8d940bf).

## Folder structure

Please follow this [advance project structure](https://medium.com/@alexmngn/how-to-better-organize-your-react-applications-2fd3ea1920f1) when creating widget for better organization.
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

## Dashbook

Dashbook is like storybookjs in react community. It provides isolated dev environment for flutter widget. it works as a development enviroment for the project widgets and also a showcase for common widgets on the app. 

### Android

First open android emulator from android studio AVD manager. Then prompt the following command:

```
 flutter run -d "[YOUR_EMULATOR_ID]" lib/main_dashbook.dart
```

You should see dashboard installed on you emulator.

## TODOs 

- Catch system exception like `json.decode(...)` --- [ok]
 
 ```dart
 class SomeModel {

     static fromJson(Map<String, dynamic>, data) {
         if (!data.Contains('err_code') && data.Contains('err_msg')) {
            return ... 
         }

     }
 }
 ```

- []Female cancel service now display `對方已取消交易` should be `你已取消交易` 
- []When participant cancels service chatroom, popup a notification telling the other particiant to rate the service.
- []When make user emit a direct inqiury, he can still emit another direct inquiry to the same girl in the girl list.
- [x]When male left the inquiry chatroom and post another inquiry, the same girl can not see the inquiry.
- [x]When either party left the chatoom, we should change  the inquiry status to cancel 
- [x]In inquiry chatroom When female sends service update message, chatroom should have a `ServiceUpdateMessageBubble`.  `ServiceUpdateMessageBubble` is clickable 
    When user clicks on it, service detail popup will show. 
- []Create a singleton class contains a hash map of error code and corresponding error message. The error message is resolved via i18n function. 
- [x]Emit service inquiry not showing on female app.
- []Girls emit service confirm, male is not able to recieve it via historical message.
- []Click on edit address, there should be an default address showing on address input box.
- []`inquiry_chatroom` need to fix `InquiryDetailDialog` 
- []Cancel service in chatroom, all functions in the chatroom should be locked on both party.
- []In service chatroom, click on `UpdatedInqiuryBubble` should display service detail popup.
- [x]Service 過期 chatroom 不會有通知.
- [x]Direct match still has duplicated girl.
- [x] In historical records, Expired service should display `已過期` instead of `已完成`
- [] Histoical records should state whether the service can be commented.
- [] If user has uncommented service, notify user user to comment on the service when the app is launched.

### FCM integration on picking up inquiry 

When female user picks up inquiry, sends FCM message to male user. We will use google pub/sub service to integrate FCM message.
When male starts an inquiry, backend creates a pub/sub topic that the device can subscribe to. FCM message is send via the topic.

1. Retrieve topic name from active inquiry if there is any.
2. `FirebaseMessaging` subscribes to the topic. 

### Commenting Timing

girl_cancel_before_appointment_time ---> man can comment or bypass 
girl_cancel_after_appointment_time ---> man can comment or bypass
guy_cancel_before_appointment_time ---> girl can comment or bypass
guy_cancel_after_appointment_time --->  girl can comment or bypass
## Reference
- [Postgres how to shuffle records with pagination so it looks random](https://nathanmlong.com/2017/11/a-shuffled-order-that-works-with-pagination/)
- [Methods to connect to server on emulator or devices](https://medium.com/@podcoder/connecting-flutter-application-to-localhost-a1022df63130)
- [Deploy Flutter Apps Using AppCenter](https://medium.com/@maite.daluz11/deploy-flutter-apps-using-appcenter-ec28e8d940bf)
- [Great navigator article ](https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31)
- [How to fix form overflow problem](https://www.google.com/search?q=flutter+from+keyboard+overflow&rlz=1C5CHFA_enTW891TW891&oq=flutter+keyboard+form+o&aqs=chrome.1.69i57j0i10i22i30j69i60.11468j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_6Gd0YMewBrXLmAXXtJe4DA12)
- [Slideup panel animation](https://nhancv.medium.com/simple-slide-up-widget-animation-56b14e0189c5)
- [Enable android map SDK on GCP before using the sdk in flutter](https://console.developers.google.com/google/maps-apis/overview?project=studious-optics-233010)
- [How to distribute IOS app outside of app store?](https://medium.com/globant/ios-in-house-app-distribution-on-own-server-ca23e793670a)