import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/helper/firebase_token_storeb2b_helper.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOtpBox = false;
  bool isVerified = false;
  bool isLoading = false;

  Timer? resendOtpTimer;
  int otpSeconds = 30;

  Future<dynamic> signInPhoneNumber() async {
    try {
      isLoading = true;
      update();
      String baseUrl = API.logInWithPhone +
          "?phoneNumber=${phoneController.value.text.trim()}&role=Retailer";
      log('urs --> $baseUrl');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      log('response data ---> $response');
      log('response statusCode --> ${response.statusCode}');
      log('response data body --> ${response.body}');
      log('response data body --> ${jsonDecode(response.body)}');
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString(), name: "MOBILE RES");

      if (response.statusCode == 200) {
        isLoading = false;
        update();

        return responseBody;
      } else {
        isLoading = false;
        update();
        CommonSnackBar.showError(responseBody['message'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  void starTimer() {
    resendOtpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      otpSeconds--;
      if (otpSeconds == 0) {
        otpSeconds = 30;
        resendOtpTimer!.cancel();
      }
      update();
    });
  }

  Future<void> getOtp(flag, BuildContext context) async {
    try {
      print("printing flag getOtp --> $flag");
      print(
          "printing getOtp url getOtp ---> ${API.sendOtp}/$flag/otp?phoneNumber=${phoneController.text}");
      print(
          "printing getOtp url getOtp ${API.sendOtp}/$flag/otp?phoneNumber=${phoneController.text}");
      final response = await http.post(
        Uri.parse(
            API.sendOtp + '/$flag/otp?phoneNumber=${phoneController.text}'),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        starTimer();
        showOtpBox = true;
        update();
        CommonSnackBar.showToast(
          responseBody["message"] == null
              ? responseBody['type'].toString()
              : responseBody['message'].toString(),
          context,
          showTickMark: false,
        );
      } else {
        CommonSnackBar.showError(responseBody['message'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  // in this get otp ..we are passing role also..abve commented function is without passing role
  // Future<void> getOtp(flag, BuildContext context) async {
  //   try {
  //     print("printing flag getOtp --> $flag");
  //     print(
  //         "printing getOtp url getOtp ---> ${API.sendOtp}/$flag/otp?phoneNumber=${phoneController.text}");
  //     print(
  //         "printing getOtp url getOtp ${API.sendOtp}/$flag/otp?phoneNumber=${phoneController.text}");
  //     final response = await http.post(
  //       Uri.parse(API.sendOtp +
  //           '/$flag/otp?phoneNumber=${phoneController.text}&role=Retailer'),
  //       headers: <String, String>{'Content-Type': 'application/json'},
  //     );
  //     Map<String, dynamic> responseBody = jsonDecode(response.body);
  //     print(responseBody);

  //     if (response.statusCode == 200) {
  //       starTimer();
  //       showOtpBox = true;
  //       update();
  //       CommonSnackBar.showToast(
  //         responseBody["message"] == null
  //             ? responseBody['type'].toString()
  //             : responseBody['message'].toString(),
  //         context,
  //         showTickMark: false,
  //       );
  //     } else {
  //       CommonSnackBar.showError(responseBody['message'].toString());
  //     }
  //   } on TimeoutException catch (e) {
  //     CommonSnackBar.showError(e.message.toString());
  //   } on SocketException catch (e) {
  //     CommonSnackBar.showError(e.message.toString());
  //   } on Error catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future<dynamic> verifyOtp() async {
    if (otpController.text.isEmpty) {
      CommonSnackBar.showError("Please enter otp");
    } else {
      try {
        // final String url =
        //     '${API.verifyOtp}?otp=${otpController.text}&phoneNumber=${phoneController.text}&fcmToken=${await FirebaseMessaging.instance.getToken()}&role=Retailer';
        // log('Url --> $url');
        final String url =
            '${API.verifyOtp}?otp=${otpController.text}&phoneNumber=${phoneController.text}&fcmToken=${await getFirebaseTokenStoreb2b()}&role=Retailer';
        log('Url --> $url');
        final response = await http.get(
          Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
        );
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody);

        if (response.statusCode == 200) {
          if (responseBody["type"] == "success") {
            isVerified = true;
            update();
            CommonSnackBar.showSuccess(responseBody['message'].toString());
          } else {
            isVerified = false;
            update();
            CommonSnackBar.showError(responseBody['message'].toString());
          }
          return responseBody;
        } else {
          CommonSnackBar.showError(responseBody['message'].toString());
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<dynamic> mobileVerify() async {
    isLoading = true;
    update();
    try {
      // String url =
      //     "${API.storeLogin}?otp=${otpController.text}&phoneNumber=${phoneController.text}&fcmToken=${await FirebaseMessaging.instance.getToken()}&role=Retailer";
      // log(url, name: "URL --> ");

      String url =
          "${API.storeLogin}?otp=${otpController.text}&phoneNumber=${phoneController.text}&fcmToken=${await getFirebaseTokenStoreb2b()}&role=Retailer";
      log(url, name: "URL --> ");

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString(), name: "MOBILE VERIFY");

      if (response.statusCode == 200) {
        // isLoading = false;
        // update();
        print("printing login responsebody --> $responseBody");
        return responseBody;
      } else {
        isLoading = false;
        update();
        CommonSnackBar.showError(responseBody['message'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      isLoading = false;
      update();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      isLoading = false;
      update();
    } on Error catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      update();
    }
  }

  Future<dynamic> profileStatus(id) async {
    try {
      isLoading = true;
      update();
      print("printing profile status ---> ${"${API.profile}/$id"}");
      final response = await http.get(
        Uri.parse("${API.profile}/$id"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log('profileStatus --> $responseBody');

      if (response.statusCode == 200) {
        isLoading = false;
        update();
        return responseBody;
      } else {
        isLoading = false;
        update();
        CommonSnackBar.showError(responseBody['message'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getLinkedSuppliersApi(userId) async {
    // String userId =
    // await SharPreferences.getString(SharPreferences.loginId) ?? "";
    print("printing getLinkedSuppliersList userId  -> $userId");
    if (userId.isNotEmpty) {
      try {
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        print(
            "printing getLinkdeSuppliersList url -> ${API.linkedSuppliers}/${userId}");
        // isLoading.value = true;
        final response = await http.get(
          Uri.parse('${API.linkedSuppliers}/${userId}'),
          headers: headers,
        );
        print(response.body);

        if (response.statusCode == 200) {
          final suppliersListResponse = jsonDecode(response.body);
          await SharPreferences.setString(SharPreferences.supplierId,
              suppliersListResponse[0]["supplierId"] ?? '');
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    } else if (!Get.isDialogOpen!) {
      // Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> signInEmail() async {
    try {
      var deviceToken =
          await SharPreferences.getString(SharPreferences.deviceToken) ?? '';
      print(deviceToken);
      Map<String, dynamic> bodyParams = {
        'email': phoneController.text.trim(),
        'password': otpController.text.trim(),
        'fcmToken': deviceToken.toString()
      };
      final response = await http.post(Uri.parse(API.logIn),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
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
