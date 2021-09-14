import 'package:intl/intl.dart';

class DateTimeUtil {
  static String timeAgoSinceDate(DateTime dateTime) {
    DateTime notificationDate = dateTime;
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(notificationDate);

    final dateNow = DateTime.now();
    final bufferMinute = 30;

    final difference = notificationDate.difference(dateNow);
    final bufferTime = notificationDate.add(Duration(minutes: bufferMinute));
    final differenceBufferTime = bufferTime.difference(dateNow);

    if ((difference.inDays / DateTime.daysPerWeek).floor() >= 1) {
      return formattedDate;
    }

    if (difference.inDays >= 1) {
      // return '${difference.inMinutes}天後開始';
      String date = DateFormat('yyyy-MM-dd').format(notificationDate);
      return date;
    }

    if (difference.inHours >= 1) {
      return '${difference.inHours}個小時後開始';
    }

    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}分鐘後開始';
    }

    if (difference.inSeconds >= 1) {
      return '${difference.inSeconds}秒後開始';
    }

    if (differenceBufferTime.inMinutes >= 1) {
      return '等待著${bufferMinute - differenceBufferTime.inMinutes}分鐘';
    }

    return '';
  }
}
