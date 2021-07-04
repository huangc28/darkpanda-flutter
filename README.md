# darkpanda_flutter
## Build android APK 

Prompt the following command: `flutter build apk --release`

## Reference

- [Great navigator article ](https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31)
- [How to fix form overflow problem](https://www.google.com/search?q=flutter+from+keyboard+overflow&rlz=1C5CHFA_enTW891TW891&oq=flutter+keyboard+form+o&aqs=chrome.1.69i57j0i10i22i30j69i60.11468j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_6Gd0YMewBrXLmAXXtJe4DA12)
- [Slideup panel animation](https://nhancv.medium.com/simple-slide-up-widget-animation-56b14e0189c5)
- [Enable android map SDK on GCP before using the sdk in flutter](https://console.developers.google.com/google/maps-apis/overview?project=studious-optics-233010)
- [How to distribute IOS app outside of app store?](https://medium.com/globant/ios-in-house-app-distribution-on-own-server-ca23e793670a)

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
- Login / Logout function.
- Handle error when API request failed.
- Initialize firestore instance at the start of the application. --- [ok]
- Female app should add inquiry chats tap.
- All API classes should rethrow errors so that blocs can catch and display API errors.
