import 'package:intl/intl.dart';

class DateFormatter {
  static bool isSameDate(String value1, String value2) {
    DateTime date1 = DateTime.parse(value1);
    DateTime date2 = DateTime.parse(value2);

    if (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute) {
      return true;
    } else {
      return false;
    }
  }

  static String formatToAppStandard(String date) {
    return DateFormat('EEE, dd MMM').format(DateTime.parse(date));
  }

  static String formatToAppStandardWithYear(String date) {
    return DateFormat('EEE, dd MMM yyy').format(DateTime.parse(date));
  }

  static String getJournalCreatedDateWithTime(String date) {
    DateTime journalDateParsed = DateTime.parse(date);

    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    DateTime journalDate = DateTime(
        journalDateParsed.year, journalDateParsed.month, journalDateParsed.day);

    if (now.difference(journalDate).inDays == 1) {
      return DateFormat('\'Yesterday at\' hh:mm aa')
          .format(DateTime.parse(date));
    } else if (now.difference(journalDate).inDays == 0) {
      return DateFormat('\'Today at\' hh:mm aa').format(DateTime.parse(date));
    } else {
      return DateFormat('dd MMM yyy \'at\' hh:mm aa')
          .format(DateTime.parse(date));
    }
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
