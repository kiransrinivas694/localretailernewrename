import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:b2c/components/login_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:b2c/utils/string_extensions.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/order_details_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class GrbOrderDetailsController extends GetxController {
  bool isLoading = true;
  OrderDetailsModel? orderDetailsModel;

  Future<void> getOrderDetails({required String orderId}) async {
    isLoading = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String accessToken =
        await SharPreferences.getString(SharPreferences.accessToken) ?? "";

    if (userId.isNotEmpty) {
      try {
        logs('UserID --> $userId');
        String url = '${API.getGrbOrderDetails}/$userId/order/$orderId';

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';
        logs('Url --> $url');
        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          log('Response --> ${response.body}');
          orderDetailsModel = orderDetailsModelFromJson(response.body);
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
