import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/common_snackbar_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/controllers/auth_controller/login_controller_new.dart';
import 'package:b2c/helper/firebase_gettoken_backup_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OTPController extends GetxController {
  final isLoading = false.obs;

  TextEditingController phoneController = TextEditingController();

  Timer? timer;
  RxInt timerValue = 59.obs;
  String otp = "";

  bool? isVerified;

  void manageTimer() {
    timerValue = 59.obs;
    // !storeVerified ? sendOtp() : sendOwnerOtp();
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      timerValue--;
      update();
      if (timerValue <= 0) timer!.cancel();
    });
  }

  Future<dynamic> getOtp(flag) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiConfig.sendOtp}/$flag?phoneNumber=${phoneController.text}"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        // otpValue.value = responseBody['data']['otp'];
        // responseBody['message'].showError();
        // Get.offAll(() => const HomeScreen(), transition: Transition.size);
        return responseBody;
      } else {
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

  Future<dynamic> verifyOtp() async {
    if (otp == "") {
      CommonSnackBar.showError("Please enter otp");
    } else {
      isLoading(true);

      try {
        // log('Url --> ${ApiConfig.storeLogin}?otp=$otp&phoneNumber=${phoneController.text}&fcmToken=${await FirebaseMessaging.instance.getToken()}&role=Retailer');
        // final response = await http.post(
        //   Uri.parse(
        //       "${ApiConfig.storeLogin}?otp=$otp&phoneNumber=${phoneController.text}&fcmToken=${await FirebaseMessaging.instance.getToken()}&role=Retailer"),
        //   headers: <String, String>{'Content-Type': 'application/json'},
        // );
        log('Url --> ${ApiConfig.storeLogin}?otp=$otp&phoneNumber=${phoneController.text}&fcmToken=${await getFirebaseToken()}&role=Retailer');
        final response = await http.post(
          Uri.parse(
              "${ApiConfig.storeLogin}?otp=$otp&phoneNumber=${phoneController.text}&fcmToken=${await getFirebaseToken()}&role=Retailer"),
          headers: <String, String>{'Content-Type': 'application/json'},
        );
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        log(
          responseBody.toString(),
        );

        if (response.statusCode == 200) {
          if (responseBody["type"] == "success") {
            isVerified = true;
            update();
            isLoading(false);

            return responseBody;
          } else {
            isVerified = false;
            update();
          }
          // otpValue.value = responseBody['data']['otp'];
          // responseBody['message'].showError();
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
  }

  Future<dynamic> mobileVerify() async {
    isLoading(true);
    try {
      // String url =
      //     "${ApiConfig.storeLogin}?otp=$otp&phoneNumber=${phoneController.text}&fcmToken=${await FirebaseMessaging.instance.getToken()}&role=Retailer";
      // log(url, name: "URL --> ");
      String url =
          "${ApiConfig.storeLogin}?otp=$otp&phoneNumber=${phoneController.text}&fcmToken=${await getFirebaseToken()}&role=Retailer";
      log(url, name: "URL --> ");
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString(), name: "MOBILE VERIFY");

      if (response.statusCode == 200) {
        // otpValue.value = responseBody['data']['otp'];
        // responseBody['message'].showError();
        // Get.offAll(() => const HomeScreen(), transition: Transition.size);
        GetHelperController.storeID.value = responseBody['logInId'];
        GetHelperController.token.value = responseBody['token'];
        await PreferencesHelper().setPreferencesStringData(
            PreferencesHelper.token, GetHelperController.token.value);
        await PreferencesHelper().setPreferencesStringData(
            PreferencesHelper.storeID, GetHelperController.storeID.value);
        log(GetHelperController.storeID.value, name: 'storeID');
        log(GetHelperController.token.value, name: 'TOKEN');
        log(responseBody.keys.toString(),
            name: 'responseBody '); // ----------- vaishnav ---------------
        // onUserLogout();
        // Future.delayed(
        //   const Duration(milliseconds: 500),
        //   () {
        //     onUserLogin();
        //   },
        // );
        // ----------- vaishnav ---------------
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

  Future<dynamic> profileStatus(id) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse("${ApiConfig.profile}/$id"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

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
}
