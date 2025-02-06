import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/order_details_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class PrintInvoiceController extends GetxController {
  bool isLoading = true;
  OrderDetailsModel? ordersContent;

  Future<void> getOrderDetails({required String orderId}) async {
    isLoading = true;
    update();
    String? userId = await SharPreferences.getString(SharPreferences.loginId);
    if (userId != null && userId.isNotEmpty) {
      try {
        logs('UserID --> $userId');
        String url = '${API.getOrderDetails}/$userId/order/$orderId';
        logs('Url --> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          logs('Response --> ${response.body}');
          ordersContent = orderDetailsModelFromJson(response.body);
        }
      } on SocketException catch (e) {
        logs('Catch exception in getOrderDetails --> ${e.message}');
        CommonSnackBar.showError(e.message);
      }
      isLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }
}
