import 'dart:convert';
import 'dart:developer';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller_new.dart';
import 'package:b2c/model/product_search_model_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController {
  List<ProductSearchModel> productSearchModelList = [];
  ProductSearchModel? productSearchModel;
  ProductResult? productResult;
  final TextEditingController searchProductController = TextEditingController();

  Future<List<String>> searchOnChanged(String query) async {
    List<String> productSearchList = [];
    final String? response = await getRestCall(query);
    if (response != null && response.isNotEmpty) {
      productSearchModelList = productSearchModelFromJson(response);
      for (ProductSearchModel element in productSearchModelList) {
        productSearchList.add(element.productName ?? '');
      }
    }
    return productSearchList;
  }

  Future<String?>? getRestCall(String query) async {
    String? responseData;
    try {
      String categoryID = GetHelperController.categoryID.value.isEmpty
          ? '3d1592c3-60fa-4f5e-9229-2ba36bcca886'
          : GetHelperController.categoryID.value;
      String requestUrl =
          '${ApiConfig.baseUrl}api-product/product/text/search/$query/category/$categoryID?page=0&size=10';
      log('Request url --> $requestUrl');
      Uri? requestedUri = Uri.tryParse(requestUrl);
      var headers = {'Content-Type': 'application/json'};
      http.Response response = await http.get(requestedUri!, headers: headers);

      switch (response.statusCode) {
        case 200:
        case 201:
        case 400:
          responseData = response.body;
          break;
      }
    } on PlatformException catch (e) {
      log('PlatformException in getRestCall --> ${e.message}');
    }
    return responseData;
  }

  Future<String?>? getProductsRestCall() async {
    String? responseData;
    try {
      String requestUrl =
          '${ApiConfig.baseUrl}api-product/product/${productSearchModel!.id}';
      log('Request url --> $requestUrl');
      Uri? requestedUri = Uri.tryParse(requestUrl);
      var headers = {'Content-Type': 'application/json'};
      http.Response response = await http.get(requestedUri!, headers: headers);

      switch (response.statusCode) {
        case 200:
        case 201:
        case 400:
          responseData = response.body;
          break;
      }
    } on PlatformException catch (e) {
      log('PlatformException in getRestCall --> ${e.message}');
    }
    return responseData;
  }

  @override
  void onInit() {
    Get.put(EditProfileController()).getProfileDataApi();
    super.onInit();
  }

  Future<String?>? subscribeProduct() async {
    String? responseData;
    if (GetHelperController.storeID.value.isNotEmpty) {
      try {
        String storeID = GetHelperController.storeID.value;
        String requestUrl =
            '${ApiConfig.baseUrl}api-product/product/${productSearchModel!.id}/subscribe/$storeID';
        log('Request url --> $requestUrl');
        Uri? requestedUri = Uri.tryParse(requestUrl);
        var headers = {'Content-Type': 'application/json'};
        http.Response response =
            await http.put(requestedUri!, headers: headers);

        switch (response.statusCode) {
          case 200:
          case 201:
          case 400:
            responseData = response.body;
            log('Rsponse --> $responseData');
            Map<String, dynamic> responseMap = jsonDecode(responseData);
            if (!responseMap['status']) {
              Get.snackbar('Subscribe.!', responseMap['message'],
                  backgroundColor: AppColors.redColor,
                  colorText: AppColors.appWhite);
            } else {
              Get.snackbar('Subscribe.!', responseMap['message'],
                  backgroundColor: AppColors.greenColor,
                  colorText: AppColors.appWhite);
            }
            break;
        }
      } on PlatformException catch (e) {
        log('PlatformException in getRestCall --> ${e.message}');
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
    return responseData;
  }
}
