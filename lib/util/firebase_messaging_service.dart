import 'dart:convert';

import 'package:darkpanda_flutter/enums/firebase_message_type.dart';
import 'package:darkpanda_flutter/models/fcm_agree_to_chat.dart';
import 'package:darkpanda_flutter/models/fcm_male_send_direct_inquiry.dart';
import 'package:darkpanda_flutter/models/fcm_pickup_inquiry.dart';
import 'package:darkpanda_flutter/models/fcm_service_cancelled.dart';
import 'package:darkpanda_flutter/models/fcm_service_paid.dart';
import 'package:darkpanda_flutter/models/fcm_service_refunded.dart';
import 'package:darkpanda_flutter/models/fcm_unpaid_service_expired.dart';
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

      final message = json.decode(notification.body);
      var msg;

      final isPcikupInquiryFcm =
          (String type) => type == FirebaseMessageType.pickup_inquiry.name;
      final isServicePaidFcm =
          (String type) => type == FirebaseMessageType.service_paid.name;
      final isUnpaidServiceExpiredFcm = (String type) =>
          type == FirebaseMessageType.unpaid_service_expired.name;
      final isAgreeToChatFcm =
          (String type) => type == FirebaseMessageType.agree_to_chat.name;
      final isServiceCancelledFcm =
          (String type) => type == FirebaseMessageType.service_cancelled.name;
      final isRefundedFcm =
          (String type) => type == FirebaseMessageType.refunded.name;
      final isMaleSendDirectInquiryFcm = (String type) =>
          type == FirebaseMessageType.male_send_direct_inquiry.name;

      if (isPcikupInquiryFcm(message['fcm_type'])) {
        FcmPickupInquiry msg = FcmPickupInquiry.fromMap(message);

        body = msg.fcmContent.pickerName + ' 已回覆您的詢問，開始聊聊';
      } else if (isServicePaidFcm(message['fcm_type'])) {
        FcmServicePaid msg = FcmServicePaid.fromMap(message);

        body = msg.fcmContent.payerName + ' 已完成付款';
      } else if (isUnpaidServiceExpiredFcm(message['fcm_type'])) {
        FcmUnpaidServiceExpired msg = FcmUnpaidServiceExpired.fromMap(message);

        body = msg.fcmContent.customerName + ' 在30分鐘內沒完成付款，服務過期';
      } else if (isAgreeToChatFcm(message['fcm_type'])) {
        FcmAgreeToChat msg = FcmAgreeToChat.fromMap(message);

        body = msg.fcmContent.maleUsername + ' 已接受聊天，開始聊聊';
      } else if (isServiceCancelledFcm(message['fcm_type'])) {
        FcmServiceCancelled msg = FcmServiceCancelled.fromMap(message);

        body = msg.fcmContent.cancellerUsername + ' 已取消服務';
      } else if (isRefundedFcm(message['fcm_type'])) {
        FcmServiceRefunded msg = FcmServiceRefunded.fromMap(message);

        body = '服務已退款';
      } else if (isMaleSendDirectInquiryFcm(message['fcm_type'])) {
        FcmMaleSendDirectInquiry msg =
            FcmMaleSendDirectInquiry.fromMap(message);

        body = msg.fcmContent.maleUsername + ' 已發詢問，馬上聊聊';
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
