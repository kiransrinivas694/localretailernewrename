String customDateSubstringFormat(String value) {
  String inputString = value;

  // Extract day, month, and year substrings
  String day = inputString.substring(0, 2);
  String month = inputString.substring(2, 4);
  String year = inputString.substring(4);

  // Concatenate substrings with the desired format
  String formattedDate = "$day-$month-$year";

  return formattedDate;
}
