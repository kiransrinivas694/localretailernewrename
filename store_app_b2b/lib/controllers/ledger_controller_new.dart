import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:b2c/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/supplier_controller/supplier_controller_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class LedgerController extends GetxController {
  DateTime? fromDate;
  DateTime? toDate;

  RxString selectFrom = ''.obs;
  RxString selectTo = ''.obs;

  checkVadilation() {
    if (fromDate == null && toDate == null) {
      CommonSnackBar.showError('Please select From and To date');
    } else if (fromDate == null) {
      CommonSnackBar.showError('Please select From date');
    } else if (toDate == null) {
      CommonSnackBar.showError('Please select To date');
    } else if (fromDate != null &&
        toDate != null &&
        toDate!.isBefore(fromDate!)) {
      CommonSnackBar.showError("'To date' can't be less than 'From date'");
    } else {
      postRestCall();
    }
  }

  Future<void> postRestCall() async {
    String? responseData;
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    try {
      String requestUrl =
          '${ApiConfig.baseUrl}b2b/api-ledger2/v2/ledger/retailerId/$userId/byDate?fromDate=${selectFrom.value}&toDate=${selectTo.value}';
      Uri? requestedUri = Uri.tryParse(requestUrl);
      print(
          'printing url ${ApiConfig.baseUrl}b2b/api-ledger2/v2/ledger/retailerId/$userId/byDate?fromDate=${selectFrom.value}&toDate=${selectTo.value}');
      // log('Body map --> $body');
      var headers = {
        'Accept': 'application/json',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
      };

      final token = await SharPreferences.getToken();

      if (API.enableToken) headers['Authorization'] = '$token';
      http.Response response = await http.get(
        requestedUri!,
        headers: headers,
      );

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          log('ResponseData --> $responseData');
          // Get.offAll(() => const HomeScreen(), transition: Transition.size);
          if (jsonDecode(responseData)['status'] == true) {
            fromDate = null;
            toDate = null;
            selectFrom.value = '';
            selectTo.value = '';
            CommonSnackBar.showInfo("Legder sent successfully");
          } else {
            fromDate = null;
            toDate = null;
            selectFrom.value = '';
            selectTo.value = '';
            CommonSnackBar.showError('${jsonDecode(responseData)['message']}');
          }

          break;
        case 400:
        case 410:
        case 500:
          responseData = response.body;
          log('ResponseData --> $responseData');
          // Get.offAll(() => const HomeScreen(), transition: Transition.size);
          CommonSnackBar.showError("Something went wrong");
          Get.snackbar('${jsonDecode(responseData)['message']}', '');
          break;
        case 502:
        case 404:
          log('${response.statusCode}');
          CommonSnackBar.showError("Something went wrong");
          Get.snackbar('${jsonDecode(response.body)['error']}', '');
          break;
        case 401:
          log('401 : ${response.body}');
          break;
        default:
          log('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      log('PlatformException in postRestCall --> ${e.message}');
    }
  }
}
