import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/model/top_buying_products_model/top_buying_products_model.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/service/api_service.dart';

class DashboardController extends GetxController {
  List<TopBuyingProductModel> topBuyingProductsList = [];
  bool isTopBuyingProductsLoading = false;

  Map<String, dynamic> ltdSalesInfo = {};
  bool isLtdSalesInfoLoading = false;

  Future<dynamic> getTopBuyingProducts() async {
    final String userId =
        await SharPreferences.getString(SharPreferences.loginId);
    if (userId.isNotEmpty) {
      try {
        isTopBuyingProductsLoading = true;
        update();

        // String url = '${API.topBuyingProducts}/AL-R202312-047'; - testing purpose
        String url = '${API.topBuyingProducts}/$userId';
        logs('getTopBuyingProducts Url --> $url');
        final response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );
        List<dynamic> responseBody = jsonDecode(response.body);

        print("getTopBuyingProducts response --> ${responseBody}");
        if (response.statusCode == 200) {
          for (var index = 0; index < responseBody.length; index++) {
            TopBuyingProductModel content =
                topBuyingProductModelFromJson(jsonEncode(responseBody[index]));
            topBuyingProductsList.add(content);
          }
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

      isTopBuyingProductsLoading = false;
      update();
      print(
          "printing false update after complete -> value is $isTopBuyingProductsLoading");
    } else if (!Get.isDialogOpen!) {
      print("else in getTopBuyingProducts is called");
    }
  }

  Future<dynamic> getLtdSalesInfo() async {
    final String userId =
        await SharPreferences.getString(SharPreferences.loginId);
    if (userId.isNotEmpty) {
      try {
        isLtdSalesInfoLoading = true;
        update();

        // String url = '${API.topBuyingProducts}/AL-R202312-047'; - testing purpose
        String url = '${API.purchasesAndProfits}/$userId';
        logs('getLtdSalesInfo Url --> $url');
        final response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        Map<String, dynamic> responseBody = jsonDecode(response.body);

        print("getLtdSalesInfo response --> ${responseBody}");
        if (response.statusCode == 200) {
          ltdSalesInfo = responseBody;
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

      isLtdSalesInfoLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      print("else in getTopBuyingProducts is called");
    }
  }
}
