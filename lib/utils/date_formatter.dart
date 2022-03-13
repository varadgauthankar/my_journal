import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToAppStandard(String date) {
    return DateFormat('EEE, dd MMM').format(DateTime.parse(date));
  }

  static String formatToAppStandardWithYear(String date) {
    return DateFormat('EEE, dd MMM yyy').format(DateTime.parse(date));
  }
}
