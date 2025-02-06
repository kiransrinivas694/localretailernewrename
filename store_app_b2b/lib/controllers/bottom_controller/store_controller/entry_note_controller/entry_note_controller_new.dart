import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/credit_note_history_model_new.dart';
import 'package:store_app_b2b/model/entry_note_history_model/entry_note_history_model_new.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service_new.dart';
import 'package:store_app_b2b/new_module/services/payloads_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/entry_note_screen/entry_note_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class EntryNoteController extends GetxController {
  List<BasicEntryNoteHistoryModel> entryNoteHistoryList = [];
  bool isEntryNoteHistoryLoading = false;
  // num creditNoteBalance = 0;
  // bool isEntryNoteBalanceLoading = false;
  num entryHistoryTotalPages = 0;
  num entryHistoryCurrentPage = 0;
  int entryHistoryPaginationSize = 10;

  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String formattedDate = '';
  String displayDate = "";
  bool isNumeric(String str) {
    if (str.isEmpty) {
      return false;
    }
    final number = num.tryParse(str);
    return number != null;
  }

  int amount = 0;
  bool validation() {
    num amount = num.parse(amountController.text);
    if (amountController.text.isEmpty && dateController.text.isEmpty) {
      customFailureToast(content: 'Please enter details');
      return false;
    } else if (amountController.text.isEmpty) {
      customFailureToast(content: 'Enter Amount');
      return false;
    } else if (amount <= 0 || amount == null) {
      customFailureToast(content: 'Please enter valid amount');
      return false;
    } else if (dateController.text.isEmpty) {
      customFailureToast(content: 'Enter your Date');
      return false;
    }
    return true;
  }

  Future<void> getEntryNoteHistory({num pageNumber = 0}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    // String supplierId =
    //     await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (userId.isNotEmpty) {
      try {
        isEntryNoteHistoryLoading = true;
        update();
        String requestUrl =
            '${API.getEntryNoteHistory}$userId?page=$pageNumber&size=$entryHistoryPaginationSize&sort=desc';
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';
        logs('getClearingStatus Url --> $requestUrl');
        final response = await http.get(
          Uri.parse(requestUrl),
          headers: headers,
        );
        logs('getClearingStatus response ---> ${response.body}');
        if (response.statusCode == 200) {
          entryNoteHistoryList.clear();
          EntryNoteHistoryModel entryNoteHistory =
              entryNoteHistoryModelFromJson(response.body);
          entryNoteHistoryList.addAll(entryNoteHistory.data!.content!);
          // creditNoteHistoryList.addAll(creditNoteHistory.content);

          entryHistoryTotalPages = entryNoteHistory.data!.totalPages ?? 1;
          entryHistoryCurrentPage = entryNoteHistory.data!.number ?? 0;
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }

      isEntryNoteHistoryLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      // if (!callingFromDashboard) {
      Get.dialog(const LoginDialog());
      // }
    }
  }

  bool isPaymetDataLoading = false;

  Future<void> paymetData() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    String retailerPhoneNumber =
        await SharPreferences.getString(SharPreferences.storeNumber) ?? "";
    logs("phone number$retailerPhoneNumber");
    if (userId.isNotEmpty) {
      String userName =
          await SharPreferences.getString(SharPreferences.storeName) ?? "";
      String parseDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      try {
        Map<String, dynamic> referMap = {
          "retailerId": userId,
          "retailerName": userName,
          "paidAmount": num.parse(amountController.text),
          "approvedBy": "",
          "approvedDate": "",
          "status": "N",
          "requestDate": parseDate,
          "retailerPhoneNumber": retailerPhoneNumber,
          "paidDate": formattedDate,
        };

        print("printing bodymap of add supplier ---> ${jsonEncode(referMap)}");
        String url = '${API.postPaymentData}';
        print("payment Data$url");

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': "*/*",
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';
        final response = await http.post(Uri.parse(url),
            body: jsonEncode(referMap), headers: headers);
        print("response ---> $response");
        if (response.statusCode == 200) {
          print("response body ---> ${jsonDecode(response.body)}");
          // customSuccessToast(content: "Data enter succesfully");
          Map<String, dynamic> resMap = jsonDecode(response.body);
          if (resMap.containsKey("status") && resMap["status"] == true) {
            CommonSnackBar.showError(' Successful.');
            Get.back();
            Get.to(() => EntryNoteScreen());
          } else {
            CommonSnackBar.showError('Something went wrong.');
          }
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError("${e.message.toString()}");
      } on Error catch (e) {
        debugPrint(e.toString());
        CommonSnackBar.showError('Something went wrong.');
      }
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }
    update();
  }

  String entryNoteid = '';
  Future<void> updateAmountAndDate() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    String retailerPhoneNumber =
        await SharPreferences.getString(SharPreferences.storeNumber) ?? "";

    if (userId.isNotEmpty) {
      String userName =
          await SharPreferences.getString(SharPreferences.storeName) ?? "";
      String parseDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      try {
        Map<String, dynamic> referMap = {
          "retailerId": userId,
          "retailerName": userName,
          "paidAmount": num.parse(amountController.text),
          "approvedBy": "",
          "approvedDate": "",
          "status": "N",
          "requestDate": parseDate,
          "retailerPhoneNumber": retailerPhoneNumber,
          "paidDate": formattedDate,
        };

        print("printing bodymap of add supplier ---> $referMap");
        String url = '${API.putPaymentData}/id/$entryNoteid';

        final token = await SharPreferences.getToken();

        final headers = {
          'accept': "*/*",
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        print("printing bodymap of add supplier ---> $url");
        final response = await http.put(Uri.parse(url),
            body: jsonEncode(referMap), headers: headers);
        print("response ---> $response");
        if (response.statusCode == 200) {
          // customSuccessToast(content: "Data enter succesfully");

          CommonSnackBar.showError(' Successful.');
          getEntryNoteHistory();
          Get.back();
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError("data is jsdas${e.message.toString()}");
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
