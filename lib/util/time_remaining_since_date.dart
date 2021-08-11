import 'package:intl/intl.dart';

class DateTimeUtil {
  static String timeAgoSinceDate(DateTime dateTime) {
    DateTime notificationDate = dateTime;
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(notificationDate);

    final dateNow = DateTime.now();
    final difference = notificationDate.difference(dateNow);

    if ((difference.inDays / DateTime.daysPerWeek).floor() >= 1) {
      return formattedDate;
    }
    if (difference.inDays >= 1) {
      return '${difference.inMinutes}天後開始';
    }

    if (difference.inHours >= 1) {
      return '${difference.inMinutes}個小時後開始';
    }

    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}分鐘後開始';
    }

    return formattedDate;
  }
}
