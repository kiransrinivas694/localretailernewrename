import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getFirebaseTokenStoreb2b() async {
  String fcmToken = "";

  try {
    fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
  } catch (e) {
    fcmToken = "";
  }

  return fcmToken;
}
