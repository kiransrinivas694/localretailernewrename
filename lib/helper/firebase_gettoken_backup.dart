import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getFirebaseToken() async {
  String fcmToken = "";

  try {
    fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
  } catch (e) {
    fcmToken = "";
  }

  return fcmToken;
}
