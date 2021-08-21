import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_service.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _firebaseMessagingService =
      FirebaseMessagingService._internal();

  FirebaseMessaging messaging;

  factory FirebaseMessagingService() {
    return _firebaseMessagingService;
  }

  FirebaseMessagingService._internal();

  void init() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification?.body);

      RemoteNotification notification = event.notification;

      if (notification != null) {
        NotificationService().showNotification(notification);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  void fcmSubscribe(String topic) {
    messaging.subscribeToTopic(topic);
  }

  void fcmUnSubscribe(String topic) {
    messaging.unsubscribeFromTopic(topic);
  }
}
