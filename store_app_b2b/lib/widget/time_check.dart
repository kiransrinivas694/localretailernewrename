import 'package:ntp/ntp.dart';
import 'package:store_app_b2b/service/api_service.dart';

Future<bool> isAfterDynamicTime() async {
  // return false;
  try {
    // Fetch current time from NTP server
    DateTime currentTime = await NTP.now();

    print("printing current time -> $currentTime");

    // Check if the hour is greater than 16 (4 PM)
    if (currentTime.hour >= API.maxTimeToStopOrder) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    // Handle errors if any
    print('Error fetching current time: $e');
    return false; // Return false in case of error
  }
}

bool isAfterDynamicTimeSystemCheck() {
  // return false;
  DateTime currentTime = DateTime.now();

  print("printing current time -> $currentTime");

  if (currentTime.hour >= API.maxTimeToStopOrder) {
    return true;
  } else {
    return false;
  }
}

String getAmPm() {
  num time = API.maxTimeToStopOrder;

  String initialText = "";
  String finalText = "";

  if (time < 12) {
    finalText = "AM";
    if (time == 0) {
      initialText = "12";
    } else {
      initialText = "$time";
    }
  } else if (time == 12) {
    finalText = "PM";
    initialText = "12";
  } else if (time == 24) {
    finalText = "AM";
    initialText = "12";
  } else {
    finalText = "PM";
    if (time == 13) {
      initialText = "1";
    }
    if (time == 14) {
      initialText = "2";
    }
    if (time == 15) {
      initialText = "3";
    }
    if (time == 16) {
      initialText = "4";
    }

    if (time == 17) {
      initialText = "5";
    }
    if (time == 18) {
      initialText = "6";
    }
    if (time == 19) {
      initialText = "7";
    }
    if (time == 20) {
      initialText = "8";
    }
    if (time == 21) {
      initialText = "9";
    }
    if (time == 22) {
      initialText = "10";
    }
    if (time == 23) {
      initialText = "11";
    }
  }

  return '$initialText $finalText';
}
