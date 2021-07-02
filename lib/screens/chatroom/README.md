## Flutter date / time picker coding reference

https://medium.com/flutterdevs/date-and-time-picker-in-flutter-72141e7531c

## TODOs

- [ok] Scroll list view to bottom when new message is appended to list.
- [ok] Clear text field after new message is emitted successfully.
- [ok] Load more historical messages.
- [ok] Display error when fetching historical message / send message failed.
- [] Display loading icon when fetching historical messages.
- [ok] [ServiceSettingsSheet]. Service provider should be able to tailor the service detail.
- [ok] There should be a default value passing into [ServiceSettingsSheet].
- [ok] Remove historical messages and current messages when leaving the chatroom.
- [x] Display an error message when failed to load service settings.
- [x] Display an error message when failed to load historical messages. 
- [] When male user approves the agreement by pressing OK, chatroom should be disabled due to that the service has been created.
- [] Create a countdown timer to notify female user that she will quit the chatroom after timer countdown.
- [] Female user should be able to see the profile of the inquirer.


## service_chatroom back button routes
1. From service_list:
 - female use navigator.pop
 - male use navigator.pop
2. From topup back button - navigator.pushNamed
 - male
  - if topup is from service_chatroom, use navigator.pop
  - if topup is from settings, use navigator.pop
  - if topup is from inquiry, use navigator.pushNamed
3. From complete_buy_service use navigator.pushNamed
4. From buy_service back button 
 - if route is from service_chatroom, use navigator.pop
