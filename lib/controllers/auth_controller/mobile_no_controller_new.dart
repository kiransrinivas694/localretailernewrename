import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:b2c/service/api_service_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:b2c/utils/validation_utils_new.dart';
import 'package:http/http.dart' as http;

class MobileNoController extends GetxController {
  final isLoading = false.obs;
  TextEditingController phoneController = TextEditingController();
  RxString phoneError = ''.obs;

  void validateMobileForm() {
    if (ValidationUtils.instance.lengthValidator(phoneController, 10)) {
      'Enter mobile number'.showError();
    }
    update();
    // if (phoneError.isEmpty) signInPhoneNumber();
  }

  Future<dynamic> signInPhoneNumber() async {
    try {
      isLoading(true);
      log(
          ApiConfig.logInWithPhone +
              "?phoneNumber=${phoneController.value.text.trim()}&role=Retailer",
          name: 'URL');
      final response = await http.post(
        Uri.parse(ApiConfig.logInWithPhone +
            "?phoneNumber=${phoneController.value.text.trim()}&role=Retailer"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      log(responseBody.toString(), name: "MOBILE RES");

      if (response.statusCode == 200) {
        isLoading(false);

        return responseBody;
      } else {
        isLoading(false);
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
}
