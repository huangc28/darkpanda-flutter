import 'package:intl/intl.dart';

class DateTimeUtil {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ").parse(dateString);

    final dateNow = DateTime.now();
    final difference = notificationDate.difference(dateNow);

    // if (difference.inDays > 8) {
    //   return formatter.format(notificationDate);
    // } else
    if ((difference.inDays / 7).floor() >= 1) {
      final week = (difference.inDays / 7).floor();
      return '$week 个星期前';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} 天前';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 天前' : '昨天';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} 个小时前';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 个小时前' : '1 个小时前';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} 分钟前';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '一分钟前' : '一分钟前';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} 几秒前';
    } else {
      return '刚刚';
    }
  }
}
