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
 

- Implement app bottom bar --- [ok]
- Login / Logout function
- Handle error when API request failed
- Initialize pubnub SDK at the start of the app