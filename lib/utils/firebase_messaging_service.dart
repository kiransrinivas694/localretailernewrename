import 'dart:convert';

import 'package:b2c/helper/firebase_gettoken_backup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// ----------- vaishnav ---------------
//import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// ----------- vaishnav ---------------
import '../controllers/auth_controller/login_controller.dart';
import '../main.dart';
import '../screens/bottom_nav_bar/store_screen/user_screen/missed_call_screen.dart';

class FirebaseNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static initializeService() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("msg arrived :::: ${message.toString()}");

      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      print(
          "senderId ===> ${jsonDecode(message.notification?.body ?? "")["senderId"]}");
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin?.initialize(initializationSettings);
      // showLog("IOS NOTIFICATION DATA $message");
      if (message.notification != null) {
        PushNotificationModel model = PushNotificationModel();
        model.title = message.notification!.title;
        model.body = message.notification!.body;
        showNotification(model);
      } else {
        PushNotificationModel model = PushNotificationModel();
        model.title = message.data["title"];
        model.body = message.data["body"];
        showNotification(model);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // {title: Calling you, body: {message: You received call..., type: missedCall, callID: , senderId: AL-R202304-001, isVideoCall: false}}false
      print("message ===> ${message.toString()}");
      // sendCallInvitation(
      //   callID: jsonDecode(message.notification?.body ?? "")["callID"],
      //   invitees: [ZegoCallUser(jsonDecode(message.notification?.body ?? "")["senderId"], jsonDecode(message.notification?.body ?? "")["senderId"])].toList(),
      //   calleeId: jsonDecode(message.notification?.body ?? "")["senderId"],
      //   isVideoCall: jsonDecode(message.notification?.body ?? "")["isVideoCall"],
      // );
      Future.delayed(const Duration(milliseconds: 1500)).then((value) {
        Get.to(() => const MissedCallScreen());
      });

      ///Handle tap here event.data["id"]
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);
    if (!isNotEmptyString(getFcmToken())) {
      // firebaseMessaging.getToken().then((String? token) {
      //   assert(token != null);
      //   showLog("FCM-TOKEN $token");
      //   setFcmToken(token!);
      // });
      getFirebaseToken().then((String? token) {
        assert(token != null);
        showLog("FCM-TOKEN $token");
        setFcmToken(token!);
      });
    }
  }

  static showNotification(PushNotificationModel data) async {
    showLog(data);
    return;
    var android = const AndroidNotificationDetails(
        'giving_channel_id', 'giving_channel_name',
        priority: Priority.high,
        importance: Importance.max,
        icon: "@mipmap/ic_launcher");
    var iOS = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    var jsonData = jsonEncode(data);
    await flutterLocalNotificationsPlugin!
        .show(123, data.title, data.body, platform, payload: jsonData)
        .onError((error, stackTrace) {
      print(error);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    showLog('Handling a background message ${message.messageId}');

    // showSnackBar(title: "Notification", message: "Notification message");
  }
}

showLog(data) {
  print(data.toString());
}

class PushNotificationModel {
  PushNotificationModel({this.title, this.body, this.data});

  String? title;
  String? body;
  PushNotificationData? data;

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    data = json['data'] != null
        ? PushNotificationData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class PushNotificationData {
  PushNotificationData(
      {this.id,
      this.title,
      this.createdat,
      this.description,
      this.image,
      this.url});

  int? id;
  String? title;
  String? description;
  String? url;
  String? image;
  String? createdat;

  PushNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    image = json['image'];
    createdat = json['createdat'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['image'] = image;
    map['createdat'] = createdat;
    return map;
  }
}

getFcmToken() {
  print("fcm token get ${getPreference.read("fcmTokenPref")}");
  return getPreference.read("fcmTokenPref") ?? "";
}

setFcmToken(String value) {
  getPreference.write("fcmTokenPref", value);
}

isNotEmptyString(String? data) {
  return data != null && data.isNotEmpty;
}

sendCallInvitation(
    {required String callID,
    //required List<ZegoCallUser> invitees,
    required String calleeId,
    required bool isVideoCall}) async {
  // onUserLogin(callBack: () async {
  //   await callController?.sendCallInvitation(
  //     callID: "",
  //     // callID: callID,
  //     // invitees: [ZegoCallUser(senderId, 'user_$senderId')].toList(),
  //     invitees: invitees.map((callee) => ZegoCallUser(callee.id, 'user_${callee.id}')).toList(),
  //     isVideoCall: isVideoCall,
  //   );
  // });
  ///
  // ZegoInvitationPageManager?  pageManager =
  // ZegoCallInvitationInternalInstance.instance.pageManager;
  // pageManager.onLocalSendInvitation("", invitees.map((callee) => invitees.map((callee) => ZegoCallUser(callee.id, 'user_${callee.id}')).toList(), invitationType, code, message, invitationID, errorInvitees)
  Future.delayed(const Duration(seconds: 10)).then((value) async {
    // await callController?.sendCallInvitation(
    //   callID: "",
    //   resourceID: 'zego_data',
    //   // callID: callID,
    //   // invitees: [ZegoCallUser(senderId, 'user_$senderId')].toList(),
    //   invitees: invitees.map((callee) => ZegoCallUser(callee.id, 'user_${callee.id}')).toList(),
    //   isVideoCall: isVideoCall,
    // );
    // onUserLogin(callBack: () async {
    //   await callController?.sendCallInvitation(
    //     callID: "",
    //     resourceID: 'zego_data',
    //     // callID: callID,
    //     // invitees: [ZegoCallUser(senderId, 'user_$senderId')].toList(),
    //     invitees: invitees
    //         .map((callee) => ZegoCallUser(callee.id, 'user_${callee.id}'))
    //         .toList(),
    //     isVideoCall: isVideoCall,
    //   );
    // });
  });
}
