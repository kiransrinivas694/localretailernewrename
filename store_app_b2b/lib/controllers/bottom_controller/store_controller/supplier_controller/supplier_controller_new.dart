import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class SupplierController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isLoading = false.obs;
  var userId = "".obs;

  late TabController controller;
  final connectIdAllList = [].obs;
  final connectIdLinkList = [].obs;

  final searchController = TextEditingController().obs;
  final linkedSuppliersList = [].obs;
  final allSuppliersList = [].obs;

  @override
  void onInit() {
    controller = TabController(vsync: this, length: 2);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  Future<dynamic> getUserId() async {
    userId.value =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";
    print(userId.value);
  }

  Future<dynamic> getLinkedSuppliersApi() async {
    if (userId.value.isNotEmpty) {
      try {
        isLoading.value = true;

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse('${API.linkedSuppliers}/${userId.value}'),
          headers: headers,
        );
        print(response.body);
        isLoading.value = false;
        if (response.statusCode == 200) {
          linkedSuppliersList.value = jsonDecode(response.body);
          print(">>>>>>>>${jsonDecode(response.body).length}");

          isLoading.value = false;
        } else {
          isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> getAllSuppliersApi() async {
    try {
      isLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response =
          await http.get(Uri.parse(API.allSuppliers), headers: headers);
      print(response.body);
      isLoading.value = false;
      if (response.statusCode == 200) {
        allSuppliersList.value = jsonDecode(response.body);
        print(">>>>>>>>${jsonDecode(response.body).length}");

        isLoading.value = false;
      } else {
        isLoading.value = false;
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

  Future<dynamic> getConnectApi(Map<String, dynamic> bodyMap) async {
    try {
      isLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(Uri.parse(API.connectAPIPost),
          headers: headers, body: jsonEncode(bodyMap));
      print(response.body);
      isLoading.value = false;
      if (response.statusCode == 200) {
        isLoading.value = false;
        return jsonDecode(response.body);
      } else {
        isLoading.value = false;
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
}
