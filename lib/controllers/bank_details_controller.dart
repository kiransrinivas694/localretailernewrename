import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/screens/bottom_nav_bar/subscription/social_otp_verification_screen.dart';
import 'package:b2c/screens/bottom_tap_bar_screen.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper.dart';
import 'package:b2c/utils/validation_utils.dart';
import 'package:http/http.dart' as http;
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/service/api_service.dart';

class BankDetailsController extends GetxController {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController bankBranchController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController upiPhoneNumberController =
      TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController googlePayController = TextEditingController();
  final TextEditingController phonePayController = TextEditingController();
  final TextEditingController paytmController = TextEditingController();
  bool isLoading = true;
  bool phonePayVerified = true;
  bool googlePayVerified = true;
  bool paytmVerified = true;
  String otp = '';
  Map<String, dynamic> bankDetailsMap = {};

  @override
  void onInit() {
    getBankDetails();
    super.onInit();
  }

  void validateBankDetailsForm() {
    if (accountNumberController.text.isEmpty) {
      'Please enter account number'.showError();
      return;
    }
    if (accountNameController.text.isEmpty) {
      'Please enter account holder name'.showError();
      return;
    }
    if (ifscController.text.isEmpty) {
      'Please enter IFSC code'.showError();
      return;
    }
    if (!ValidationUtils.instance
        .regexValidator(ifscController, ValidationUtils.ifscRegexp)) {
      'Please enter valid  IFSC code'.showError();
      return;
    }
    if (bankBranchController.text.isEmpty) {
      'Please enter branch name'.showError();
      return;
    }
    if (bankNameController.text.isEmpty) {
      'Please enter bank name'.showError();
      return;
    }

    if (upiPhoneNumberController.text.isEmpty) {
      'Please enter phone number'.showError();
      return;
    }

    if (upiPhoneNumberController.text.length < 10) {
      'Please enter valid Phone number'.showError();
      return;
    }

    if (upiIdController.text.isEmpty) {
      'Please enter upi id'.showError();
      return;
    }

    // if (googlePayController.text.isEmpty) {
    //   'Please enter Google Pay number'.showError();
    //   return;
    // }
    // if (googlePayController.text.length < 10) {
    //   'Please enter valid Google Pay number'.showError();
    //   return;
    // }
    // if (phonePayController.text.isEmpty) {
    //   'Please enter Phone Pay number'.showError();
    //   return;
    // }
    // if (phonePayController.text.length < 10) {
    //   'Please enter valid Phone Pay number'.showError();
    //   return;
    // }
    // if (paytmController.text.isEmpty) {
    //   'Please enter Paytm number'.showError();
    //   return;
    // }
    // if (paytmController.text.length < 10) {
    //   'Please enter valid Paytm number'.showError();
    //   return;
    // }
    updateBankDetails();
  }

  Future<void> updateBankDetails() async {
    isLoading = true;
    update();
    // if (googlePayController.text != (bankDetailsMap['googlepay'] ?? '')) {
    //   googlePayVerified = await signInPhoneNumber(googlePayController.text);
    //   if (googlePayVerified) {
    //     'Google pay number is verified'.showSuccess();
    //   } else {
    //     'Google pay number is not verified. Please verify it'.showError();
    //     isLoading = false;
    //     update();
    //     return;
    //   }
    // }
    // if (phonePayController.text != (bankDetailsMap['phonepay'] ?? '')) {
    //   phonePayVerified = await signInPhoneNumber(phonePayController.text);
    //   if (phonePayVerified) {
    //     'Phone pay number is verified'.showSuccess();
    //   } else {
    //     'Phone pay number is not verified. Please verify it'.showError();
    //     isLoading = false;
    //     update();
    //     return;
    //   }
    // }
    // if (paytmController.text != (bankDetailsMap['paytm'] ?? '')) {
    //   paytmVerified = await signInPhoneNumber(paytmController.text);
    //   if (paytmVerified) {
    //     'Paytm number is verified'.showSuccess();
    //   } else {
    //     'Paytm number is not verified. Please verify it'.showError();
    //     isLoading = false;
    //     update();
    //     return;
    //   }
    // }
    Map<String, dynamic> bodyMap = {
      'id': bankDetailsMap['id'],
      'accountNumber': accountNumberController.text,
      'accuntName': accountNameController.text,
      'ifsc': ifscController.text,
      'bankbranch': bankBranchController.text,
      'bank': bankNameController.text,
      'googlepay': "6301458089",
      'phonepay': "6301458089",
      'paytm': "6301458089",
      'upiId': upiIdController.text,
      'upiPhoneNumber': upiPhoneNumberController.text,
    };
    logs('logging BankDetailsSend Body map --> $bodyMap');
    logs("logging bankdetails update url ---> ${Uri.parse(API.editProfile)}");
    final response = await http.put(
      Uri.parse(API.editProfile),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(bodyMap),
    );
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    logs('BankDetailsregister Response body --> $responseBody');
    if (response.statusCode == 200) {
      if (responseBody.isNotEmpty) {
        Get.snackbar(
          'Profile.!',
          'Profile updated successfully.!',
          backgroundColor: AppColors.greenColor,
          colorText: AppColors.appWhite,
        );
        Get.offAll(() => const HomeScreen(), transition: Transition.fadeIn);
      }
    }
    isLoading = false;
    update();
  }

  Future<void> getBankDetails() async {
    String userId = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        '';
    if (userId.isNotEmpty) {
      isLoading = true;
      update();
      String url = '${API.editProfile}/$userId';
      logs('getBankDetails Url --> $url');
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      logs('getBankDetails Response body --> $responseBody');
      logs(
          'getBankDetails upiPhoneNumber Response body --> ${responseBody["upiPhoneNumber"]}');
      logs('getBankDetails upiId Response body --> ${responseBody["upiId"]}');
      logs('getBankDetails upiId Response body --> ${responseBody["email"]}');
      if (response.statusCode == 200) {
        if (responseBody.isNotEmpty) {
          bankDetailsMap = responseBody;
        }
        accountNumberController.text = bankDetailsMap['accountNumber'] ?? '';
        accountNameController.text = bankDetailsMap['accuntName'] ?? '';
        ifscController.text = bankDetailsMap['ifsc'] ?? '';
        bankBranchController.text = bankDetailsMap['bankbranch'] ?? '';
        bankNameController.text = bankDetailsMap['bank'] ?? '';
        // googlePayController.text = bankDetailsMap['googlepay'] ?? '';
        // phonePayController.text = bankDetailsMap['phonepay'] ?? '';
        // paytmController.text = bankDetailsMap['paytm'] ?? '';
        upiPhoneNumberController.text = bankDetailsMap["upiPhoneNumber"] ?? '';
        upiIdController.text = bankDetailsMap["upiId"] ?? "";
      }
      log('bankDetailsMap --> $bankDetailsMap');
      isLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<bool> signInPhoneNumber(String phoneController) async {
    try {
      String url = '${ApiConfig.sendOtp}/send?phoneNumber=$phoneController  ';
      logs('signInPhoneNumber Url --> $url');
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      logs("logging otp response ---> ${response.body}");

      if (response.statusCode == 200 &&
          responseBody['type'].toString().toLowerCase() == 'success') {
        otp = '';
        bool isValid = await Get.to(() =>
            SocialOtpVerificationScreen(phoneController: phoneController));
        log('IsValid --> $isValid');
        return bool.tryParse(isValid.toString()) ?? false;
      } else {
        responseBody['message'].toString().showError();
      }
    } on TimeoutException catch (e) {
      e.message.toString().showError();
    } on SocketException catch (e) {
      e.message.toString().showError();
    } on Error catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> verifyPhoneNumber(
      String phoneController, String otpNumber) async {
    try {
      String url =
          '${ApiConfig.verifyOtp}?phoneNumber=$phoneController&otp=$otpNumber';
      logs('verifyPhonenumber Url --> $url');
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      logs('verifyPhoneNumber Response body --> $responseBody');
      if (response.statusCode == 200 &&
          responseBody['type'].toString().toLowerCase() == 'success') {
        Get.back(result: true);
        otp = '';
        responseBody['message'].toString().showSuccess();
      } else {
        logs(":checking before update otp ---> ${otp}");
        otp = '';

        update();
        logs(":checking updated otp ---> ${otp}");
        responseBody['message'].toString().showError();
      }
    } on TimeoutException catch (e) {
      e.message.toString().showError();
    } on SocketException catch (e) {
      e.message.toString().showError();
    } on Error catch (e) {
      log(e.toString());
    }
    return false;
  }
}
