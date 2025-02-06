import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/expiry_products_info_model.dart';
import 'package:store_app_b2b/model/grb_return_orders_pageable_model.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/utils/shar_preferences.dart';

class GrbReturnController extends GetxController {
  ScrollController scrollController = ScrollController();
  int grbOrderListCurrentPage = 0;
  int grbOrderListTotalPage = 1;
  int gerbOrderListSize = 14;
  bool isGrbOrderListLoadMore = false;
  bool isGrbOrderListLoadInitial = false;

  final grbReturnOrdersList = <GrbReturnOrderModel>[].obs;

  // RxList<TextEditingController> qtyTextControllerList =
  //     <TextEditingController>[].obs;
  // List<RxInt> qtyList = [];

  TextEditingController buyQuantityDialogController = TextEditingController();
  TextEditingController freeQuantityDialogController = TextEditingController();

  final grbOrderSearchController = TextEditingController().obs;
  final grbOrderSearchControllerText = "".obs;

  final grbUpdateLoading = false.obs;

  // // grb scheme product screen variables
  // bool isMainReturnQuantityEditable = true;

  // TextEditingController returnBuyQtyMainController = TextEditingController();

  // List<TextEditingController> batchWiseControllers = [
  //   TextEditingController(),
  //   TextEditingController(),
  //   TextEditingController()
  // ];

  // List<num> batchWiseTotals = [8, 10, 20];
  // List<String> batchWiseErrors = ["", "", ""];

  // void toggleMainReturnQty() {
  //   isMainReturnQuantityEditable = !isMainReturnQuantityEditable;

  //   // if (!isMainReturnQuantityEditable) {}
  //   update();
  // }

  @override
  void onInit() {
    scrollController.addListener(() async {
      print(
          "print scroll pixels -> ${scrollController.position.pixels} - maxExtent - ${scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("at bottom position reached");
        grbOrderListCurrentPage += 1;
        update();
        await getGrbProdutsList(searchText: grbOrderSearchControllerText.value);
        print("NEW DATA ADDED");
      } else {
        print("not reached");
      }
    });

    super.onInit();
  }

  Future<void> getGrbProdutsList(
      {initial = false, fromSearch = false, searchText = ""}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    log('logging grb -> $userId');

    if (userId.isEmpty) {
      if (!Get.isDialogOpen!) {
        Get.dialog(const LoginDialog());
      }
      return;
    }

    try {
      if (fromSearch) {
        grbOrderListCurrentPage = 0;
        update();
      }

      if (initial) {
        grbReturnOrdersList.clear();
        isGrbOrderListLoadInitial = true;
        update();
      } else {
        isGrbOrderListLoadMore = true;
        update();
      }
      String userId =
          await SharPreferences.getString(SharPreferences.loginId) ?? '';
      String url =
          '${API.getGrbReturnOrderList}/$userId/aggrigtation?page=${grbOrderListCurrentPage}&size=${gerbOrderListSize}&productName=$searchText';

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("getGrbProdutsList url -> $url");
      print("getGrbProdutsList response -> ${response.body}");

      if (response.statusCode == 200 &&
          searchText == grbOrderSearchController.value.text) {
        GrbReturnOrdersPageableModel grbReturnOrdersModel =
            grbReturnOrdersPageableModelFromJson(response.body);

        print("getGrbProdutsList is intital - $initial");

        if (initial) {
          List<GrbReturnOrderModel> grbContentList = [];
          print(
              'getGrbProdutsList condition -> ${grbReturnOrdersModel.content != null && grbReturnOrdersModel.content!.isNotEmpty}');
          if (grbReturnOrdersModel.content != null &&
              grbReturnOrdersModel.content!.isNotEmpty) {
            for (GrbReturnOrderModel i in grbReturnOrdersModel.content!) {
              if (i.confirmQuantity != null && i.confirmQuantity != 0) {
                grbContentList.add(i);
              }
            }
          }
          grbReturnOrdersList.value = grbContentList;
          // qtyTextControllerList = RxList.generate(
          //     grbReturnOrdersList.length, (index) => TextEditingController());

          // qtyList = List.generate(grbReturnOrdersList.length, (index) => 0.obs);
        } else {
          List<GrbReturnOrderModel> grbContentList = [];

          if (grbReturnOrdersModel.content != null &&
              grbReturnOrdersModel.content!.isNotEmpty) {
            for (GrbReturnOrderModel i in grbReturnOrdersModel.content!) {
              if (i.confirmQuantity != null && i.confirmQuantity != 0) {
                grbContentList.add(i);
              }
            }
          }
          grbReturnOrdersList.value = [
            ...grbReturnOrdersList,
            ...grbContentList
          ];

          // for (GrbReturnOrderModel i in grbReturnOrdersModel.content!) {
          //   qtyTextControllerList.add(TextEditingController());
          //   qtyList.add(0.obs);
          // }
        }

        update();
      }

      print(
          "getGrbProdutsList orders list count  -> ${grbReturnOrdersList.length}");
    } catch (e) {
      print("ERRO===>>>>>>>$e");
    }

    if (!initial) {
      isGrbOrderListLoadMore = false;
      update();
    } else {
      isGrbOrderListLoadInitial = false;
      update();
    }
  }

  var isCheckGrbItemInCart = false.obs;

  Future<dynamic> checkGrbItemAvailableInCart(
      {required String itemId, required String storeId}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    if (userId.isNotEmpty) {
      try {
        isCheckGrbItemInCart.value = true;

        String url =
            "${API.checkGrbItemAvaialbleInCart}/${userId}/store/${storeId}/itemId/${itemId}";
        logs('checkGrbItemAvailableInCart Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        print(response.body);

        if (response.statusCode == 200) {
          print(
              ">>>>>checkGrbItemAvailableInCart response>>>${jsonDecode(response.body)}");
          // isAddCartLoading.value = false;
          // return response.body;
          isCheckGrbItemInCart.value = false;
          return jsonDecode(response.body);
        } else {
          // isAddCartLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }

      isCheckGrbItemInCart.value = false;
    }
  }

  bool _isDetailsLoading = false;

  bool get isDetailsLoading => _isDetailsLoading;

  set isDetailsLoading(bool value) {
    _isDetailsLoading = value;
    update();
  }

  Future<dynamic> addGrbOrderToCart(var bodyMap) async {
    print("printing grb order body map -> $bodyMap");

    // if (userId.value.isNotEmpty) {
    try {
      // isAddCartLoading.value = true;
      grbUpdateLoading.value = true;
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
      print(response.body);

      if (response.statusCode == 200) {
        print(">>>>>add to cart>>>${jsonDecode(response.body)}");
        grbUpdateLoading.value = false;
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap["status"]) {
          return responseMap["status"];
        }

        CommonSnackBar.showError(responseMap["message"]);
        return responseMap["status"];
      } else {
        grbUpdateLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }

    grbUpdateLoading.value = false;
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog());
    // }
  }

  /// Expiry Product Requirables

  final expiryProductsList = <ExpiryProductInfo>[].obs;
  final expirySearchController = TextEditingController().obs;
  final expirySearchControllerText = "".obs;

  Future<void> getExpiryProdutsList({search = ""}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    if (userId.isEmpty) {
      if (!Get.isDialogOpen!) {
        Get.dialog(const LoginDialog());
      }
      return;
    }

    try {
      expiryProductsList.clear();
      isGrbOrderListLoadInitial = true;
      update();

      String userId =
          await SharPreferences.getString(SharPreferences.loginId) ?? '';

      String storeId =
          await SharPreferences.getString(SharPreferences.supplierId) ?? "";
      String url =
          '${API.getExpiryProdutsList}/$storeId/userId/$userId?productName=$search';

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("getExpiryProdutsList url -> $url");
      print("getExpiryProdutsList response -> ${response.body}");

      if (response.statusCode == 200 &&
          search == expirySearchControllerText.value) {
        ExpiryProductsInfoModel expriyProductsModel =
            expiryProductsInfoModelFromJson(response.body);

        List<ExpiryProductInfo> expiryContentList = [];
        print(
            'getGrbProdutsList condition -> ${expriyProductsModel.data != null && expriyProductsModel.data!.isNotEmpty}');
        if (expriyProductsModel.data != null &&
            expriyProductsModel.data!.isNotEmpty) {
          for (ExpiryProductInfo i in expriyProductsModel.data!) {
            if (i.confirmQuantity != null && i.confirmQuantity != 0) {
              expiryContentList.add(i);
            }
          }
        }
        expiryProductsList.value = expiryContentList;
        // qtyTextControllerList = RxList.generate(
        //     grbReturnOrdersList.length, (index) => TextEditingController());

        // qtyList = List.generate(grbReturnOrdersList.length, (index) => 0.obs);

        update();
      } else {
        CommonSnackBar.showError('Something went wrong');
      }

      print(
          "getGrbProdutsList orders list count  -> ${grbReturnOrdersList.length}");
    } catch (e) {
      print("ERRO===>>>>>>>$e");
    }

    // if (!initial) {
    //   isGrbOrderListLoadMore = false;
    //   update();
    // } else {
    isGrbOrderListLoadInitial = false;
    update();
    //   update();
    // }
  }
}
