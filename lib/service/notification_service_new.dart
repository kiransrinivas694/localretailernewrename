import 'dart:convert';
import 'dart:developer';

import 'package:b2c/helper/firebase_gettoken_backup_new.dart';
import 'package:b2c/utils/notification_navigation_utils_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();
  String? fcmToken;
  FirebaseMessaging? firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log('Background message Id : ${message.messageId}');
    log('Background message Time : ${message.sentTime}');
  }

  Future<void> initializeNotification() async {
    await Firebase.initializeApp();
    await initializeLocalNotification();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(announcement: true);

    log('Notification permission status : ${notificationSettings.authorizationStatus.name}');

    // fcmToken = await firebaseMessaging.getToken();
    fcmToken = await getFirebaseToken();
    log('FCM Token --> $fcmToken');
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
        // logs('Message title: ${remoteMessage.notification!.title}, body: ${remoteMessage.notification!.body}');
        Map<String, dynamic> payload = remoteMessage.data;

        AndroidNotificationDetails androidNotificationDetails =
            const AndroidNotificationDetails(
          'CHANNEL ID',
          'CHANNEL NAME',
          channelDescription: 'CHANNEL DESCRIPTION',
          importance: Importance.max,
          priority: Priority.max,
        );
        DarwinNotificationDetails iosNotificationDetails =
            const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails, iOS: iosNotificationDetails);

        await flutterLocalNotificationsPlugin.show(
            0,
            remoteMessage.notification!.title ?? '',
            remoteMessage.notification!.body ?? '',
            notificationDetails,
            payload: jsonEncode(payload));
      });

      FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
        // {title: Calling you, body: {message: You received call..., type: missedCall, callID: , senderId: AL-R202304-005, isVideoCall: false}}false
        logs(
            "msg arrived in background category :::: ${remoteMessage.category}");
        logs(
            "msg arrived in background collapseKey :::: ${remoteMessage.collapseKey}");
        logs(
            "msg arrived in background contentAvailable :::: ${remoteMessage.contentAvailable}");
        logs("msg arrived in background data :::: ${remoteMessage.data}");
        logs("msg arrived in background from :::: ${remoteMessage.from}");
        logs(
            "msg arrived in background messageId :::: ${remoteMessage.messageId}");
        logs(
            "msg arrived in background messageType :::: ${remoteMessage.messageType}");
        logs(
            "msg arrived in background mutableContent :::: ${remoteMessage.mutableContent}");
        logs(
            "msg arrived in background notification :::: ${remoteMessage.notification}");
        logs(
            "msg arrived in background notificationBody :::: ${remoteMessage.notification != null ? remoteMessage.notification!.body : "null"}");
        logs(
            "msg arrived in background notificationbodyLocKey :::: ${remoteMessage.notification != null ? remoteMessage.notification!.bodyLocKey : "null"}");
        logs(
            "msg arrived in background notificationtitle :::: ${remoteMessage.notification != null ? remoteMessage.notification!.title : "null"}");
        logs(
            "msg arrived in background notificationtitleLocKey :::: ${remoteMessage.notification != null ? remoteMessage.notification!.titleLocKey : "null"}");

        //// Navigation During Background.

        Map<String, dynamic> payloadMap = remoteMessage.data;
        logs("ready to navigate from backgroound");
        notificationNavigationUtil(payloadMap);

        ///Handle tap here event.data["id"]
      });
    }
  }

  initializeLocalNotification() {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    DarwinInitializationSettings ios = const DarwinInitializationSettings();
    InitializationSettings platform =
        InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(
      platform,
      onDidReceiveNotificationResponse: (details) async {
        Map<String, dynamic> notificationMap =
            jsonDecode(details.payload ?? '');
        print('Notfication --> $notificationMap');

        print(
            'On Notfication received --> ${details.toString()} ${details.payload} ${details.input} ${details.notificationResponseType.toString()}');
        print(
            'On notfication received condition check -> ${details.payload != null && details.payload!.isNotEmpty}');
        if (details.payload != null && details.payload!.isNotEmpty) {
          Map<String, dynamic> payloadMap = jsonDecode(details.payload!);

          notificationNavigationUtil(payloadMap);
          log('notification util click launched after');
        }

        // if (notificationMap['notification']['body']
        //     .toString()
        //     .toLowerCase()
        //     .contains('delivered')) {
        //   print('Notfication --> ${notificationMap['notification']['title']}');
        //   print('Notfication --> ${notificationMap['notification']['body']}');
        //   // Get.to(() => RatePurchases(orderId: notificationMap['notification']['title'].toString().split('#').last, riderName: notificationMap['notification']['body'].toString().toLowerCase().split('by').last));
        // } else {
        //   // Get.to(() => OrderScreen());
        // }
      },
    );
  }

  void showNotification(String message) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'sse_channel_id', // Unique channel ID
      'SSE Notifications', // Channel name
      channelDescription: 'Notifications from SSE stream',
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      "New Alert! 📢 Check it Now", // Title (header)
      message, // Body (message content)
      notificationDetails,
    );
  }
}
