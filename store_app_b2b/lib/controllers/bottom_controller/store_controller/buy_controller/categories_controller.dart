import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/store_category_model.dart';

import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

import 'package:http/http.dart' as http;

class CategoriesController extends GetxController {
  List<StoreCategoryModel> storeCategoryList = [];
  bool isCategoriesLoading = false;

  getStoreCategories() async {
    isCategoriesLoading = true;
    update();

    // print("printing -- printing planTure --> $planTenure");

    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';

    print("print check init  supplierid in getstoreCategories -> ${userId}");

    if (userId == "") {
      isCategoriesLoading = false;
      update();
      // Get.dialog(LoginDialog());
      return;
    }

    try {
      String url = "${API.storeCategory}/$supplierId";
      print(
          "printing -- getStoreCategories url in categories controller---> $url");

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(Uri.parse(url), headers: headers);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        storeCategoryList.clear();
        print("getStoreCategories response ---> $responseBody");

        print(
            "printing length of categories from response in buy tab --> ${responseBody.length}");

        for (Map plan in responseBody) {
          print("printing each plan ---> $plan");

          StoreCategoryModel storeCategoryModel =
              storeCategoryModelFromJson(jsonEncode(plan));

          storeCategoryList.add(storeCategoryModel);
        }

        // print("printing length of response body ---> ${responseBody.length}");
        // for (String plan in responseBody) {
        //   print("printing plan $plan");
        //   plansPhases.add(plan);
        // }
      } else {
        CommonSnackBar.showError(responseBody['error'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
      // e.message.toString().showError();
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    // print("printing plan phases ---> ${plansPhases}");
    print(
        "printing length of categories in buy tab --> ${storeCategoryList.length}");
    isCategoriesLoading = false;
    update();
  }
}
