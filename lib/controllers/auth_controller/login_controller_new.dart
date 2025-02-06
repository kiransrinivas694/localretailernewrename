import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/common_snackbar_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/helper/firebase_gettoken_backup_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/controller/user_controller_new.dart';
import 'package:b2c/screens/bottom_tap_bar_screen_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:b2c/utils/firebase_messaging_service_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ----------- vaishnav ---------------
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// ----------- vaishnav ---------------
class LoginController extends GetxController {
  final isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  RxBool showPassword = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    // if (kDebugMode) {
    //   emailController.text = 'store5814@gmail.com';
    //   passwordController.text = '123456';
    // }
    super.onInit();
  }

  Future<dynamic> signInEmail() async {
    isLoading(true);
    try {
      // var deviceToken = await FirebaseMessaging.instance.getToken();
      var deviceToken = await getFirebaseToken();
      log(deviceToken!, name: 'deviceToken');
      Map<String, dynamic> bodyParams = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'fcmToken': deviceToken.toString()
      };
      log(bodyParams.toString(), name: 'bodyParams');
      final response = await http.post(Uri.parse(ApiConfig.logIn),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        // otpValue.value = responseBody['data']['otp'];
        // responseBody['message'].showError();
        GetHelperController.storeID.value = responseBody['logInId'];
        GetHelperController.token.value = responseBody['token'];
        await PreferencesHelper().setPreferencesStringData(
            PreferencesHelper.token, GetHelperController.token.value);
        await PreferencesHelper().setPreferencesStringData(
            PreferencesHelper.storeID, GetHelperController.storeID.value);
        log(GetHelperController.storeID.value, name: 'storeID');
        log(GetHelperController.token.value, name: 'TOKEN');
        log(responseBody.keys.toString(), name: 'responseBody ');
        // ----------- vaishnav ---------------
        //  onUserLogout();

        // await Future.delayed(
        //   const Duration(microseconds: 2),
        //   () {
        //     onUserLogin();
        //   },
        // );
        // ----------- vaishnav ---------------
        // isLoading(false);
        // Get.offAll(() => const HomeScreen(), transition: Transition.size);
        return responseBody;
      } else {
        // isLoading(false);

        CommonSnackBar.showError(responseBody['message'].toString());
        // responseBody['message'].toString().showError();
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> profileStatus(id) async {
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.profile + "/$id"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString(), name: 'profileStatus');

      if (response.statusCode == 200) {
        isLoading(false);
        return responseBody;
      } else {
        isLoading(false);
        CommonSnackBar.showError(responseBody['message'].toString());
        // responseBody['message'].toString().showError();
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

//TODO: change here...
// String currentUserId = getPreference.read("currentUserId");
// String currentUserId = "AL-R202304-005";

//TODO: change here...
// const fcmToken = "fJahMJv8QQy9Uim2SmzLIM:APA91bG4Ep9MFVBYc0tPyudWCeHIzKdOIalAAMX8huHisDIUDXeEh-nu0-5sG7LXXxcvhi-ukp3CqWyVr_kcdEMo8jEpq4kLNX0Q0lFbpJc8146ocNtWgjE4k65dJXAb5lpcLwGte61g";
}
// ----------- vaishnav ---------------
// ZegoUIKitPrebuiltCallController? callController;
// const maxRetryCount = 2;
// final Map<String, int> calleesRetryCount = {};

// /// on user login
// void onUserLogin({Function? callBack}) {
//   callController ??= ZegoUIKitPrebuiltCallController();
//   const appId = 767810516;
//   const appSign =
//       "14612378b28ec24d107fa9f65428242e2764f2b78240675bcfe0c566160c5043";

//   /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
//   ZegoUIKitPrebuiltCallInvitationService()
//       .init(
//     appID: appId /*input your AppID*/,
//     appSign: appSign /*input your AppSign*/,
//     // userID: GetHelperController.storeID.value,
//     userID: GetHelperController.storeID.value,
//     userName: GetHelperController.storeName.value,
//     androidNotificationConfig: ZegoAndroidNotificationConfig(
//       channelID: "ZegoUIKit",
//       channelName: "Call Notifications",
//       // sound: "zego_incoming",
//     ),
//     events: ZegoUIKitPrebuiltCallInvitationEvents(
//       onOutgoingCallCancelButtonPressed: () {
//         print("onOutgoingCallCancelButtonPressed");
//         final params = {
//           // "id": DateTime.now().hashCode.toString(),
//           "senderId": GetHelperController.storeID.value,
//           "receiverId": userController.currentCallee.value,
//           "createdDt": DateTime.now().toIso8601String(),
//           "fcmToken": getFcmToken(),
//           "message": "You've received missed call",
//         };
//         userController.missedCallApi(params);
//         sendNotification(userController.currentCalleeFcm.value);
//       },
//       onOutgoingCallAccepted: (callID, callee) {
//         print("onOutgoingCallCancelButtonPressed");
//         final params = {
//           // "id": DateTime.now().hashCode.toString(),
//           "senderId": GetHelperController.storeID.value,
//           "receiverId": userController.currentCallee.value,
//           "createdDt": DateTime.now().toIso8601String(),
//           "fcmToken": getFcmToken(),
//           "message": "Ongoing",
//         };
//         userController.missedCallApi(params);
//         sendNotification(userController.currentCalleeFcm.value);
//       },
//       onIncomingCallReceived: (callID, caller, callType, callees, customData) {
//         print("onOutgoingCallCancelButtonPressed");
//         final params = {
//           // "id": DateTime.now().hashCode.toString(),
//           "senderId": GetHelperController.storeID.value,
//           "receiverId": userController.currentCallee.value,
//           "createdDt": DateTime.now().toIso8601String(),
//           "fcmToken": getFcmToken(),
//           "message": "Incoming",
//         };
//         userController.missedCallApi(params);
//         sendNotification(userController.currentCalleeFcm.value);
//       },
//       onOutgoingCallDeclined: (String callID, ZegoCallUser callees) async {
//         print("onOutgoingCallDeclined");
//         // sendNotification();
//         ///To send notification to other user
//       },
//       onIncomingCallTimeout: (String callID, ZegoCallUser caller) async {
//         print("onIncomingCallTimeout");
//         // sendNotification();
//         ///To send notification to current user
//       },
//       onIncomingCallCanceled: (callID, caller) {
//         print("onIncomingCallCanceled");
//         print("callID ===> $callID");
//         print("caller ===> ${caller.id}");
//         // final params = {
//         //   "id": DateTime.now().toIso8601String(),
//         //   "senderId": currentUserId,
//         //   "receiverId": userController.currentCallee.value,
//         //   // "receiverId": caller.id,
//         //   "createdDt": DateTime.now(),
//         //   "message": "You've received missed call",
//         // };
//         // userController.missedCallApi(params);
//       },
//       onOutgoingCallTimeout:
//           (String callID, List<ZegoCallUser> callees, bool isVideoCall) async {
//         print("onOutgoingCallTimeout");

//         final params = {
//           // "id": DateTime.now().hashCode.toString(),
//           "senderId": GetHelperController.storeID.value,
//           "receiverId": userController.currentCallee.value,
//           "createdDt": DateTime.now().toIso8601String(),
//           "fcmToken": getFcmToken(),
//           "message": "You've received missed call",
//         };
//         userController.missedCallApi(params);
//         sendNotification(userController.currentCalleeFcm.value,
//             callID: callID, isVideoCall: isVideoCall);
//       },
//     ),
//     notifyWhenAppRunningInBackgroundOrQuit: true,
//     plugins: [ZegoUIKitSignalingPlugin()],
//     controller: callController,
//     requireConfig: (ZegoCallInvitationData data) {
//       final config = (data.invitees.length > 1)
//           ? ZegoCallType.videoCall == data.type
//               ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//               : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//           : ZegoCallType.videoCall == data.type
//               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

//       /// support minimizing, show minimizing button
//       config.topMenuBarConfig.isVisible = true;
//       config.topMenuBarConfig.buttons
//           .insert(0, ZegoMenuBarButtonName.minimizingButton);

//       return config;
//     },
//   )
//       .then((value) {
//     if (callBack != null) {
//       callBack();
//     }
//   });
// }

// /// on user logout
// void onUserLogout() {
//   callController = null;

//   /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
//   ZegoUIKitPrebuiltCallInvitationService().uninit();
// }
// ----------- vaishnav ---------------
Future<dynamic> sendNotification(String fcmToken,
    {String? callID, bool? isVideoCall}) async {
  try {
    Map<String, dynamic> bodyParams = {
      "to": fcmToken,
      // "to": "c-CTeg8lnnAOy6dbqLKzpu:APA91bH4JvAb3Mhn7GO71Bi4EX0jsTva92mzmPE0eCD6_-MDELn4Nb0e3fAfFlHENZT0tVngyK663OBiyx31ihYYOQUUTxWnqQQ5HAAuLcaxrT4O-D9vkdXVafzxph_jTpOSsKbB1KMt",
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "notification": {
        "title": "Calling you",
        "body": "You received call...",
        "content_available": true
      },
      "data": {
        "type": "missedCall",
        "callID": callID ?? "",
        "senderId": GetHelperController.storeID.value,
        "isVideoCall": false
      },
    };
    final response = await http.post(Uri.parse(ApiConfig.sendNotification),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAxLEsphE:APA91bEIDqG86BFwqeVFu5Kv9nm7OCebcwkj3Vqm4IawcYhK-ADeKKrjZz6BexRUAW15hmt1-raiReiGkTrJzTsv7lY0UAXitcflKxs3oZobwmKYzBnsBdLM-1L6qCy22tWXlR9u8B6J",
        },
        body: jsonEncode(bodyParams));
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    log(bodyParams.toString(), name: 'bodyParams');

    if (response.statusCode == 200) {
      log(responseBody.toString(), name: 'sendNotification RES');
    } else {
      responseBody['message'].toString().showError();
    }
  } on TimeoutException catch (e) {
    e.message.toString().showError();
  } on SocketException catch (e) {
    e.message.toString().showError();
  } on Error catch (e) {
    debugPrint(e.toString());
  }
}
