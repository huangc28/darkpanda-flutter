# darkpanda_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Reference

- [Great navigator article ](https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31)
- [How to fix form overflow problem](https://www.google.com/search?q=flutter+from+keyboard+overflow&rlz=1C5CHFA_enTW891TW891&oq=flutter+keyboard+form+o&aqs=chrome.1.69i57j0i10i22i30j69i60.11468j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_6Gd0YMewBrXLmAXXtJe4DA12)
- [Slideup panel animation](https://nhancv.medium.com/simple-slide-up-widget-animation-56b14e0189c5)
- [Enable android map SDK on GCP before using the sdk in flutter](https://console.developers.google.com/google/maps-apis/overview?project=studious-optics-233010)

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
