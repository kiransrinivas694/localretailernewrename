import 'dart:convert';

import 'package:b2c/components/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

import 'package:b2c/utils/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller.dart';
import 'package:store_app_b2b/model/by_date_order_history.dart';
import 'package:store_app_b2b/model/unlisted_order_model.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:http/http.dart' as http;

class OrderHistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  final isLoading = false.obs;

  DateTime? selectFrom;
  DateTime? selectTo;
  RxList<ByDateOfHistoryContent> byProductList = <ByDateOfHistoryContent>[].obs;
  GetUnlistedProductResponseModel unlistedProductResponseModel =
      GetUnlistedProductResponseModel();

  @override
  void onInit() {
    // TODO: implement onInit
    controller = TabController(vsync: this, length: 3);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  Future<dynamic> getBuyByDate() async {
    if (selectFrom == null) {
      'Please select start date'.showError();
      return;
    }
    if (selectTo == null) {
      'Please select end date'.showError();
      return;
    }
    isLoading.value = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (userId.isNotEmpty) {
      try {
        String url =
            '${API.getByDate}/$userId/orders/store/$supplierId?startDate=${DateFormat("yyyy-MM-dd").format(selectFrom ?? DateTime.now())}&endDate=${DateFormat("yyyy-MM-dd").format(selectTo ?? DateTime.now())}&page=0&size=10';
        logs('Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        http.Response response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          logs('Response --> ${response.body}');
          ByDateOrderHistory byDateOrderHistory =
              byDateOrderHistoryFromJson(response.body);

          byProductList.value = byDateOrderHistory.content;
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  var isTodayOrderLoading = false.obs;

  Future<bool?> getTodayOrderCount() async {
    isTodayOrderLoading.value = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (userId.isNotEmpty) {
      try {
        String url = '${API.getTOdayOrderCount}/$userId';
        logs('getTodayOrderCount Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        http.Response response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          logs('Response --> ${response.body}');
          Map<String, dynamic> responseMap = jsonDecode(response.body);
          // ByDateOrderHistory byDateOrderHistory =
          //     byDateOrderHistoryFromJson(response.body);

          // byProductList.value = byDateOrderHistory.content;

          if (responseMap.containsKey("status") && responseMap['status']) {
            if (responseMap.containsKey("data") &&
                responseMap["data"] != null &&
                (responseMap["data"] as Map<String, dynamic>)
                    .containsKey("totalOrderCount") &&
                (responseMap["data"]
                        as Map<String, dynamic>)["totalOrderCount"] !=
                    null &&
                (responseMap["data"]
                        as Map<String, dynamic>)["totalOrderCount"] >
                    0) {
              isTodayOrderLoading.value = false;

              return true;
            } else {
              isTodayOrderLoading.value = false;
              return false;
            }
          } else {
            isTodayOrderLoading.value = false;
            CommonSnackBar.showError("Something went wrong");
            return null;
          }
        } else {
          isTodayOrderLoading.value = false;
          CommonSnackBar.showError("Something went wrong");
          return null;
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
        isTodayOrderLoading.value = false;
        update();
        return null;
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
        isTodayOrderLoading.value = false;
        update();
        return null;
      } on Error catch (e) {
        debugPrint(e.toString());
        isTodayOrderLoading.value = false;
        update();
        return null;
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
      return null;
    }

    isTodayOrderLoading.value = false;
    return null;
  }

  Future<dynamic> getBuyBySupplier() async {
    isLoading.value = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
      try {
        String url =
            '${API.getByDate}/$userId/ordersBySupplier?supplierId=${Get.find<BuyController>().suppliersId.value}&startDate=${DateFormat("yyyy-MM-dd").format(selectFrom ?? DateTime.now())}&endDate=${DateFormat("yyyy-MM-dd").format(selectTo ?? DateTime.now())}&page=0&size=10';
        logs('Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        http.Response response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          logs('Response --> ${response.body}');
          ByDateOrderHistory byDateOrderHistory =
              byDateOrderHistoryFromJson(response.body);

          byProductList.value = byDateOrderHistory.content;
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> getUnlistedProduct() async {
    isLoading.value = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
      try {
        String url =
            '${API.getUnlistedProduct}/$userId/unlistedOrders?page=0&size=10';
        logs('getUnlistedProduct Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        http.Response response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          logs('getUnlistedProduct Response --> ${response.body}');
          unlistedProductResponseModel =
              getUnlistedProductResponseModelFromJson(response.body);
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading.value = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }
}
