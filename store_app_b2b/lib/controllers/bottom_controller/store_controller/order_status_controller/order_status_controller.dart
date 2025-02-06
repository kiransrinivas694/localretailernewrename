import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/cart_model.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class OrderStatusController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  var userId = "".obs;

  List<CartListModel> laterDeliveryData = [];
  List<CartListModel> todayDeliveryData = [];
  bool isLaterDeliveryLoading = false;
  bool isTodayDeliveryLoading = false;

  @override
  Future<void> onInit() async {
    tabController = TabController(vsync: this, length: 2);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onDispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<dynamic> getUserId() async {
    userId.value =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
  }

  Future<dynamic> getLaterDeliveryDataApi() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    print("printing user id inside getLater - $userId");
    if (userId.isNotEmpty) {
      try {
        // isLoading.value = true;
        isLaterDeliveryLoading = true;
        laterDeliveryData.clear();
        update();
        logs(
            'getLaterDeliveryDataApi message --> ${"${API.getLaterDeliveryData}/${userId}"}');
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
            Uri.parse("${API.getLaterDeliveryData}/${userId}"),
            headers: headers);
        logs('getLaterDeliveryDataApi response ---> ${response.body}');
        if (response.statusCode == 200) {
          // paymentRequestList.value = jsonDecode(response.body);
          print("Verify product >>>>>>>>${jsonDecode(response.body)}");
          dynamic responseData = jsonDecode(response.body);

          print("prinitng laterDeliveryData responseData -> ${responseData}");

          final List<dynamic> jsonList = json.decode(response.body);

          // Convert each item in the JSON list into a CartListModel object
          laterDeliveryData = fullCartListModelFromJson(response.body);

          // responseData.map((e) {
          //   // laterDeliveryData.add(cartListModelFromJson(responseData[e]));
          //   print("printing in loop --> ${responseData[e]["userId"]} $e");
          // });

          print(
              "printing length in laterDeliveryData call -> ${laterDeliveryData.length}");

          // log('cartListModel ---> ${laterDeliveryData!.toJson()}');
          // productTotal.value = 0;
          // verifyProductLength.value = cartListModel!.storeVo.length;

          // cartListModel?.storeVo.forEach((element) {
          // productTotal.value += element.items.length;
          // });
          update();

          // logs('Product total --> $productTotal');

          // var data = jsonDecode(response.body);
          // if (data['storeVo'].length != 0) {}
          // for (int i = 0; i < data.length; i++) {
          //   print("product length>>>>>>>>>>${data["storeVo"][i]['items'].length}");
          //   productTotal.value = data["storeVo"][i]['items'].length + productTotal.value;
          // }
          // isLoading.value = false;
        } else {
          // isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      isLaterDeliveryLoading = false;
      update();
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog(
    //     message: "getVerifiedProductDataApi()",
    //   ));
    // }
  }

  Future<dynamic> getTodayDeliveryDataApi() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    print("printing user id inside getLater - $userId");
    if (userId.isNotEmpty) {
      try {
        isTodayDeliveryLoading = true;
        todayDeliveryData.clear();
        update();
        logs(
            'getTodayDeliveryDataApi message --> ${"${API.getTodayDeliveryData}/${userId}"}');
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
            Uri.parse("${API.getTodayDeliveryData}/${userId}"),
            headers: headers);
        logs('getTodayDeliveryDataApi response ---> ${response.body}');
        if (response.statusCode == 200) {
          print("Verify product >>>>>>>>${jsonDecode(response.body)}");
          dynamic responseData = jsonDecode(response.body);

          print(
              "prinitng getTodayDeliveryDataApi responseData -> ${responseData}");

          final List<dynamic> jsonList = json.decode(response.body);

          todayDeliveryData = fullCartListModelFromJson(response.body);

          print(
              "printing length in getTodayDeliveryDataApi call -> ${laterDeliveryData.length}");

          update();
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      isTodayDeliveryLoading = false;
      update();
    }
  }
}
