import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/model/grb_scheme_batch_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class GrbSchemeReturnController extends GetxController {
  // grb scheme product screen variables
  bool isMainReturnQuantityEditable = true;

  TextEditingController returnBuyQtyMainController = TextEditingController();

  num freeQTYNum = 0;
  num buyQTYNum = 0;
  num finalQTYNum = 0;

  List<TextEditingController> batchWiseControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<String?> batchWiseReasons = [];

  List<num> batchWiseTotals = [];
  List<String> batchWiseErrors = [];

  void toggleMainReturnQty() {
    isMainReturnQuantityEditable = !isMainReturnQuantityEditable;

    // if (!isMainReturnQuantityEditable) {}
    update();
  }

  List<GrbSchemeBatchModel> grbSchemeBatchesData = [];
  bool isGetSchemeProductLoading = false;

  bool isAddTOGrbCartApisLoading = false;
  List<Future> addToGrbCartApiCalls = [];

  List<GrbSchemeBatchItem> mainSchemeBatchItems = [];

  Future<dynamic> getGRBSchemeBatches({
    required String orderId,
    required String productId,
    bool isEdit = false,
    String? batchNo,
    String? itemId,
    String? returnReason,
    num? returnQuantity,
  }) async {
    try {
      batchWiseErrors = [];
      batchWiseControllers = [];
      batchWiseTotals = [];
      batchWiseReasons = [];
      isGetSchemeProductLoading = true;
      update();

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
        Uri.parse("${API.getGRBSchemeBatches}/$orderId/productId/$productId"),
        headers: headers,
      );

      logs(
          'getGRBSchemeBatches url ---> ${API.getGRBSchemeBatches}/$orderId/productId/$productId');

      logs('getGRBSchemeBatches response ---> ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = jsonDecode(response.body);

        if (responseMap.containsKey('status') &&
            responseMap["status"] == false) {
          isGetSchemeProductLoading = false;
          update();
          return;
        }

        grbSchemeBatchesData =
            grbSchemeBatchModelFromJson(jsonEncode(responseMap["data"]));

        mainSchemeBatchItems = grbSchemeBatchesData[0].items!;

        // if (isEdit) {
        List<GrbSchemeBatchItem> tempSchemeBatchItems = [];

        for (var i in mainSchemeBatchItems) {
          if (i.batchNumber == batchNo && i.itemId == itemId) {
            tempSchemeBatchItems.add(i);
          }
        }

        mainSchemeBatchItems = tempSchemeBatchItems;
        // }

        for (int index = 0; index < mainSchemeBatchItems.length; index++) {
          // var i = grbSchemeBatchesData[0].items![index];

          batchWiseErrors.add("");
          if (isEdit) {
            batchWiseControllers.add(TextEditingController(
                text: returnQuantity!.toStringAsFixed(0)));
          } else {
            batchWiseControllers.add(TextEditingController());
          }

          batchWiseReasons.add(isEdit ? returnReason : null);

          batchWiseTotals.add(mainSchemeBatchItems[index].finalQuantity!);

          // Now you can use the 'index' variable as needed.
        }
        isGetSchemeProductLoading = false;
        update();
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    }

    isGetSchemeProductLoading = false;
    update();
  }

  Future<dynamic> getSchemeQty({
    required String schemeId,
    required String schemeName,
    required num addBuyQty,
    required num addFreeQty,
    required num addFinalQty,
    required num quantity,
  }) async {
    try {
      print(API.getSchemeQty);
      Map<String, dynamic> jsonMap = {
        "schemeId": schemeId,
        "schemeName": schemeName,
        "buyQuantity": addBuyQty,
        "freeQuantity": addFreeQty,
        "finalQuantity": addFinalQty,
        "quantity": quantity,
      };
      logs('getSchemeQty map ---> $jsonMap');
      final response = await http.post(Uri.parse(API.getSchemeQty),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            //Authorization':
            //    '  await SharPreferences.getString(SharPreferences.accessToken) ??
            //         ""
          },
          body: jsonEncode(jsonMap));
      logs('Get scheme url --> ${API.getSchemeQty}');
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        freeQTYNum = data['freeQuantity'];
        finalQTYNum = data['finalQuantity'];
        buyQTYNum = data['buyQuantity'];
        update();
        // return response.body;
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

  bool grbItemUpdateLoading = false;

  Future<void> addToCartGrb(List<Map<String, dynamic>> bodyMap) async {
    // print("printing grb order body map -> $bodyMap");

    // if (userId.value.isNotEmpty) {
    log('GRB ITEM UPDATE 1_> ${grbItemUpdateLoading}');
    grbItemUpdateLoading = true;
    update();

    log('GRB ITEM UPDATE 2_> ${grbItemUpdateLoading}');
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    String storeId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? "";
    ;
    try {
      // isAddCartLoading.value = true;
      // grbUpdateLoading.value = true;
      print('addToCartGrb body -> $bodyMap');
      String url = "${API.addToCartGrb}/$userId/store/$storeId";
      logs('addToCartGrb Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      print('addToCartGrb response -> ${response.body}');

      if (response.statusCode == 200) {
        // print(
        //     ">>>>>add to cart>>> ${bodyMap["returnBuyQty"]}  , ${jsonDecode(response.body)}");
        // grbUpdateLoading.value = false;
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap["status"] == true) {
          grbItemUpdateLoading = false;
          update();
          CartController cartController = Get.put(CartController());
          cartController.getGRBCart();
          log('GRB ITEM UPDATE 3_> ${grbItemUpdateLoading}');
          CommonSnackBar.showError("Added to cart");
          Get.back();

          return;
        }

        CommonSnackBar.showError(responseMap["message"]);
        grbItemUpdateLoading = false;
        update();
        log('GRB ITEM UPDATE 4_> ${grbItemUpdateLoading}');
        return;
      } else {
        // grbUpdateLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }

    log('GRB ITEM UPDATE 5_> ${grbItemUpdateLoading}');
    grbItemUpdateLoading = false;
    update();

    // grbUpdateLoading.value = false;
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }
  }

  Future<void> editGrbItem(Map<String, dynamic> bodyMap) async {
    // print("printing grb order body map -> $bodyMap");

    grbItemUpdateLoading = true;
    update();

    // if (userId.value.isNotEmpty) {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    // String storeId =
    //     await SharPreferences.getString(SharPreferences.supplierId) ?? "";
    // ;
    try {
      // isAddCartLoading.value = true;
      // grbUpdateLoading.value = true;
      print('editGrbItem body -> $bodyMap');
      String url = "${API.editGrb}";
      logs('editGrbItem Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      print('editGrb response -> ${response.body}');

      if (response.statusCode == 200) {
        print(">>>>>editGrb response>>> ${jsonDecode(response.body)}");
        // grbUpdateLoading.value = false;
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap["status"]) {
          CartController cartController = Get.put(CartController());
          cartController.getGRBCart();
          CommonSnackBar.showError("Item Updated Successfully");
          Get.back();
          grbItemUpdateLoading = false;
          update();
          return;
        }

        CommonSnackBar.showError(responseMap["message"]);
        grbItemUpdateLoading = false;
        update();
        return;
      } else {
        // grbUpdateLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }

    // grbUpdateLoading.value = false;
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }

    grbItemUpdateLoading = false;
    update();
  }

  Future<void> addGrbOrderToCart(var bodyMap) async {
    // print("printing grb order body map -> $bodyMap");

    // if (userId.value.isNotEmpty) {
    try {
      // isAddCartLoading.value = true;
      // grbUpdateLoading.value = true;
      print('addGrbOrderToCart body -> $bodyMap');
      String url = "${API.addGrbOrderToCart}";
      logs('addGrbOrderToCart Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(bodyMap),
      );
      print('addGrbOrderToCart response -> ${response.body}');

      if (response.statusCode == 200) {
        print(
            ">>>>>add to cart>>> ${bodyMap["returnBuyQty"]}  , ${jsonDecode(response.body)}");
        // grbUpdateLoading.value = false;
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap["status"]) {
          CommonSnackBar.showError('Added to cart');
        } else {
          CommonSnackBar.showError(responseMap["message"]);
        }
      } else {
        // grbUpdateLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }

    // grbUpdateLoading.value = false;
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }
  }
}
