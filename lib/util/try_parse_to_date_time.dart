import 'package:darkpanda_flutter/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Try parse chatroom [Message] field data to [DateTime] object. Chatroom message container datetime data such as
/// `created_at`, `appointment_time`. Message data can possibly come from backend or from firestore thus, the data type
/// can be of type [String] or [Timestamp]. This function determines the runtime type and convert it to [DateTime] with
/// the appropriate method.
DateTime tryParseToDateTime(dynamic field) {
  if (field == null) {
    return DateTime.now();
  }

  DateTime dt;

  if (field.runtimeType == Timestamp) {
    dt = field.toDate();
  } else if (field.runtimeType == String) {
    dt = DateTime.tryParse(field);
  }

  if (dt == null) {
    return DateTime.now();
  }

  return dt;
}
