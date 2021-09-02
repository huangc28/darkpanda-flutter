import 'dart:convert';

import 'package:darkpanda_flutter/enums/firebase_message_type.dart';
import 'package:darkpanda_flutter/models/firebase_message.dart';
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
      String body = "";

      RemoteNotification notification = event.notification;

      FirebaseMessage firebaseMessage =
          FirebaseMessage.fromMap(json.decode(notification.body));

      if (firebaseMessage.fcmType == FirebaseMessageType.pickup_inquiry.name) {
        body = firebaseMessage.fcmContent.pickerName + ' 已回覆您的詢問，開始聊聊';
      } else if (firebaseMessage.fcmType ==
          FirebaseMessageType.service_paid.name) {
        body = firebaseMessage.fcmContent.pickerName + ' 已完成付款';
      } else if (firebaseMessage.fcmType ==
          FirebaseMessageType.unpaid_service_expired.name) {
        body = firebaseMessage.fcmContent.pickerName + ' 在30分鐘內沒完成付款，服務過期';
      }

      if (notification != null) {
        NotificationService().showNotification(notification, body: body);
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
