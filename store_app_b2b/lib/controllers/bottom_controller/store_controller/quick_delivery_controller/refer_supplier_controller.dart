import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:store_app_b2b/utils/string_extensions.dart';
import 'package:store_app_b2b/utils/validation_utils.dart';

class ReferSupplierController extends GetxController {
  List businessCategoryList = [];
  String selectCategory = "";
  String selectCategoryId = "";
  RxString selectCategoryStatus = "".obs;
  List supplierTypeList = ["Quick", "Normal"];
  String supplierType = "";
  final supplierNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emailIdController = TextEditingController();
  final addressController = TextEditingController();
  final additionalRequestsController = TextEditingController();

  getCategory() async {
    try {
      print("getCategory url ---> ${API.getCategory} ");
      final response = await http.get(Uri.parse(API.getCategory),
          headers: <String, String>{'Content-Type': 'application/json'});
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        print("getCategory response ---> $responseBody");
        businessCategoryList = responseBody;
      } else {
        CommonSnackBar.showError(responseBody['error'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    update();
  }

  clearReferFields() {
    selectCategory = "";
    selectCategoryId = "";
    selectCategoryStatus.value = "";
    supplierType = "";
    supplierNameController.text = "";
    companyNameController.text = "";
    contactNumberController.text = "";
    emailIdController.text = "";
    addressController.text = "";
    additionalRequestsController.text = "";

    update();
  }

  verifyAddRefer() {
    if (supplierNameController.value.text == "") {
      CommonSnackBar.showError('Enter supplier name');
      return;
    }

    if (companyNameController.value.text == "") {
      CommonSnackBar.showError('Enter company name');
      return;
    }

    if (ValidationUtils.instance.lengthValidator(contactNumberController, 10)) {
      'Contact number can\'t be empty'.showError();
      return;
    }
    if (ValidationUtils.instance.validateEmptyController(emailIdController)) {
      'Email can\'t be empty'.showError();
      return;
    }
    if (!ValidationUtils.instance
        .regexValidator(emailIdController, ValidationUtils.emailRegExp)) {
      'Enter valid email '.showError();
      return;
    }

    if (contactNumberController.value.text == "") {
      CommonSnackBar.showError('Enter contact number');
      return;
    }

    if (contactNumberController.value.text.length != 10) {
      CommonSnackBar.showError('Enter valid contact number');
      return;
    }

    if (contactNumberController.value.text.length != 10) {
      CommonSnackBar.showError('Enter valid contact number');
      return;
    }

    if (supplierNameController.value.text == "") {
      CommonSnackBar.showError('select category');
      return;
    }

    if (selectCategoryStatus == "") {
      CommonSnackBar.showError('Select category');
      return;
    }

    if (supplierType == "") {
      CommonSnackBar.showError('Select supplier type');
      return;
    }

    if (addressController.text == "") {
      CommonSnackBar.showError('Enter address');
      return;
    }

    addReferSupplier();
  }

  addReferSupplier() async {
    print("add refer function called");
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    String storeName =
        await SharPreferences.getString(SharPreferences.storeName) ?? "";
    String loginId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    if (userId.isNotEmpty) {
      String userName =
          await SharPreferences.getString(SharPreferences.storeName) ?? "";
      try {
        Map<String, dynamic> referMap = {
          "supplierName": supplierNameController.text,
          "refferId": loginId,
          "companyName": companyNameController.text,
          "contactNumber": contactNumberController.text,
          "emailId": emailIdController.text,
          "categoryId": selectCategoryId,
          "categoryName": selectCategoryStatus.value,
          "refferName": storeName,
          "address": addressController.text,
          "supplierType": supplierType,
          "description": additionalRequestsController.text,
        };

        print("printing bodymap of add supplier ---> $referMap");
        String url = '${API.addReferSupplier}';
        log('addReferSupplier url ---> $url');
        log('productMap ---> $referMap');

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': '*/*',
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.post(Uri.parse(url),
            body: jsonEncode(referMap), headers: headers);
        print("response ---> $response");
        if (response.statusCode == 200) {
          clearReferFields();
          CommonSnackBar.showError('Refer Successful.');
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
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }
    update();
  }
}
