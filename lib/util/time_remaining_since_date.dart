import 'package:intl/intl.dart';

class DateTimeUtil {
  static String timeAgoSinceDate(DateTime dateTime) {
    DateTime notificationDate = dateTime;
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(notificationDate);

    final dateNow = DateTime.now();
    final difference = notificationDate.difference(dateNow);

    if ((difference.inDays / 7).floor() >= 1) {
      return formattedDate;
    } else if (difference.inDays >= 1) {
      return '還有${difference.inDays}天';
    } else if (difference.inHours >= 1) {
      return '還有${difference.inHours}个小时';
    } else if (difference.inMinutes >= 1) {
      return '還有${difference.inMinutes}分鐘';
    } else {
      return formattedDate;
    }
  }
}
