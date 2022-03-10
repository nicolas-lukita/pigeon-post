import 'package:intl/intl.dart';

class DateFormatter {
  String getVerboseDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime localDateTime = dateTime.toLocal();

    String roughTimeString = DateFormat('jm').format(dateTime.toLocal());

    if (now.difference(localDateTime).inMinutes <= 1) {
      return 'Just now';
    }
    if (now.difference(localDateTime).inDays <= 1) {
      return roughTimeString;
    }
    if (now.difference(localDateTime).inDays <= 2) {
      return 'Yesterday, ' + roughTimeString;
    }
    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime.toLocal());
      return '$weekday, $roughTimeString';
    }

    return DateFormat('yMd').format(dateTime);
  }
}
