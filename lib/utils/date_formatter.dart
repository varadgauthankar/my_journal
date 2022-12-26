import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToAppStandard(String date) {
    return DateFormat('EEE, dd MMM').format(DateTime.parse(date));
  }

  static String formatToAppStandardWithYear(String date) {
    return DateFormat('EEE, dd MMM yyy').format(DateTime.parse(date));
  }

  static String getJournalCreatedDateWithTime(String date) {
    return DateFormat('dd MMM yyy \'at\' hh:mm aa')
        .format(DateTime.parse(date));
  }

  static String getAppropriateLastEditedTime(String date) {
    DateTime dateEdited = DateTime.parse(date);
    DateTime now = DateTime.now();

    if (dateEdited.day == now.day) {
      return DateFormat('hh:mm aa').format(dateEdited);
    } else if (dateEdited.month == now.month) {
      return DateFormat('dd MMM \'at\' hh:mm aa').format(dateEdited);
    } else {
      return DateFormat('dd MMM yyy \'at\' hh:mm aa').format(dateEdited);
    }
  }
}
