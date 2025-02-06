import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/controllers/auth_controller/mobile_no_controller.dart';
import 'package:store_app_b2b/controllers/auth_controller/signup_controller.dart';
import 'package:store_app_b2b/screens/auth/app_process_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';

class OTPController extends GetxController {
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
      log('printing timer value $timerValue');
      update();
      if (timerValue <= 0) {
        print("timer cancelled is called");
        timer!.cancel();
      }
    });
  }

  Future<dynamic> getOtp(flag) async {
    try {
      final response = await http.post(
        Uri.parse(
            API.sendOtp + "/$flag/otp?phoneNumber=${phoneController.text}"),
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
        CommonSnackBar.showError(
          responseBody["message"] == null
              ? responseBody['type'].toString()
              : responseBody['message'].toString(),
        );
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
      try {
        final response = await http.get(
          Uri.parse(
              API.verifyOtp + "?otp=$otp&phoneNumber=${phoneController.text}"),
          headers: <String, String>{'Content-Type': 'application/json'},
        );
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(
            'log current check verify otpo response - url ${API.verifyOtp + "?otp=$otp&phoneNumber=${phoneController.text}"} ${responseBody}');

        if (response.statusCode == 200) {
          if (responseBody["type"] == "success") {
            isVerified = true;
            update();
            return responseBody;
          } else {
            isVerified = false;
            update();
          }
          // otpValue.value = responseBody['data']['otp'];
          // responseBody['message'].showError();

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
  }
}
