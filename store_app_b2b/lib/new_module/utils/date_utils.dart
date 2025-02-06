import 'package:intl/intl.dart';

String formatDateIn2ndJun2002Format(DateTime dateTime, {bool showDay = false}) {
  int day = dateTime.day;
  String month = getMonthString(dateTime.month);
  String year = dateTime.year.toString();

  String daySuffix = getDaySuffix(day);

  String dayOfWeek = showDay ? "${getDayOfWeek(dateTime.weekday)}, " : "";

  return "$dayOfWeek$day$daySuffix $month $year";
}

String formatDateInOct192021Format(DateTime dateTime, {bool showDay = false}) {
  int day = dateTime.day;
  String month = getMonthString(dateTime.month);
  String year = dateTime.year.toString();

  String dayOfWeek = showDay ? "${getDayOfWeek(dateTime.weekday)}, " : "";

  return "$dayOfWeek$month $day $year";
}

String formatStringDateIntoMay222024(String input) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(input);

  // Define the desired format
  DateFormat formatter = DateFormat('MMM dd, yyyy');

  // Format the DateTime object into the desired string format
  return formatter.format(dateTime);
}

String getMonthString(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      return "";
  }
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

String getDayOfWeek(int weekday) {
  switch (weekday) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "";
  }
}
