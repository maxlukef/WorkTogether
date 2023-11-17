import 'package:intl/intl.dart';

DateTime convertTime(String timeString) {
  DateTime returnDate;
  List<String> separatedDateTime = timeString.split("-");
  returnDate = DateTime(int.parse(separatedDateTime[0]),
      int.parse(separatedDateTime[1]), int.parse(separatedDateTime[2]));
  return returnDate;
}

String formatDatePretty(String timestring) {
  return DateFormat.MMMd().format(convertTime(timestring));
}
