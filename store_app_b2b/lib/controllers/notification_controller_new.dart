import 'dart:io';
import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/model/get_notification_response_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class NotificationController extends GetxController {
  bool isLoading = false;
  bool isLoadingMore = false;
  int page = 0;
  int size = 10;
  final ScrollController scrollController = ScrollController();
  GetNotificationResponseModel notificationResponseModel =
      GetNotificationResponseModel();

  Future<void> getNotificationListApi(
      {required int page, required int size, bool loadData = true}) async {
    String? loginId = await SharPreferences.getString(SharPreferences.loginId);
    if (loginId != null && loginId.isNotEmpty) {
      try {
        if (loadData) {
          isLoading = true;
          update();
        }
        String url = '${API.getNotification}$loginId?page=$page&size=$size';

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        logs('get notification url ---> $url');
        final response = await http.get(Uri.parse(url), headers: headers);
        logs('notification response ---> ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          notificationResponseModel =
              getNotificationResponseModelFromJson(response.body);
        } else {
          CommonSnackBar.showError('Something went wrong');
        }
      } on SocketException catch (e) {
        logs('Catch exception in getOrderDetails --> ${e.message}');
        CommonSnackBar.showError(e.message);
      }
      if (loadData) {
        isLoading = false;
      }
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<void> deleteNotificationApi(String id) async {
    try {
      String url = '${API.deleteNotification}$id';
      logs('delete notification url ---> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        getNotificationListApi(page: page, size: size, loadData: false);
      } else {
        CommonSnackBar.showError('Something went wrong');
      }
    } on SocketException catch (e) {
      logs('Catch exception in getOrderDetails --> ${e.message}');
      CommonSnackBar.showError(e.message);
    }
  }

  Future<void> scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        size <= notificationResponseModel.totalElements!) {
      isLoadingMore = true;
      update();
      size = size + 10;
      logs('size --> $size');
      await getNotificationListApi(page: page, size: size, loadData: false);
      isLoadingMore = false;
      update();
    }
  }
}
