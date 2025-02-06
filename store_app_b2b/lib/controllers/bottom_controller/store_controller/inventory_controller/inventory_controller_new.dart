import 'dart:convert';
import 'dart:io';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class InventoryController extends GetxController {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxMap<String, dynamic> inventoryRes = <String, dynamic>{}.obs;
  RxList inventoryList = [].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxInt pageValue = 1.obs;
  RxString storeId = ''.obs;
  List<RxInt> quantityList = [];
  List<TextEditingController> quantityTextControllerList = [];

  Future getInventory({bool isLoad = true}) async {
    if (isLoad) {
      isLoading.value = true;
    }
    try {
      storeId.value = await SharPreferences.getString(SharPreferences.loginId);
      final String storeCategoryId =
          await SharPreferences.getString(SharPreferences.storeCategoryId);
      logs('storeId --> $storeCategoryId');
      String url =
          '${API.getInventory}/$storeId?categoryId=$storeCategoryId&page=${pageValue.value}&size=10';
      logs('getInventory url ---> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(Uri.parse(url), headers: headers);
      logs('getInventory response ---> ${response.body}');
      if (response.statusCode == 200) {
        inventoryRes.value = jsonDecode(response.body);
        inventoryRes['content'].forEach((element) {
          inventoryList.add(element);
          quantityList
              .add(RxInt(element['price'][storeId]['quantity'].toInt()));
          quantityTextControllerList.add(TextEditingController());
        });
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    }
    if (isLoad) {
      isLoading.value = false;
    }
    update();
  }

  Future<void> scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      pageValue.value++;
      isLoadMore.value = true;
      await getInventory(isLoad: false);
      isLoadMore.value = false;
    }
  }
}
