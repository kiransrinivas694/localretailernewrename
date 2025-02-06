import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:b2c/components/login_dialog_new.dart';
import 'package:http/http.dart' as http;
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/order_details_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class OrderDetailsController extends GetxController {
  bool isLoading = true;
  OrderDetailsModel? orderDetailsModel;
  List<OrderItem> availableList = [];
  List<OrderItem> notAvailableList = [];
  int currentActive = 0;

  bool isCSVSendLoading = false;

  Future<void> getOrderDetails({required String orderId}) async {
    isLoading = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
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
          log('Response --> ${response.body}');
          orderDetailsModel = orderDetailsModelFromJson(response.body);

          if (orderDetailsModel!.orderStatus == "0") {
            for (OrderItem item in orderDetailsModel!.items) {
              availableList.add(item);
            }
          } else {
            for (OrderItem item in orderDetailsModel!.items) {
              // if (item.status == "3") {
              //   if (!(item.modified == "Y" && item.rejectedFlag != "Y")) {
              //     notAvailableList.add(item);
              //   }
              // } else {
              //   availableList.add(item);
              // }
              if (item.showTabRecord == "C") {
                availableList.add(item);
              }

              if (item.showTabRecord == "U") {
                notAvailableList.add(item);
              }
            }

            if (availableList.length == 0 && notAvailableList.length != 0) {
              currentActive = 1;
            }
          }
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

  Future<void> sendCSV({required String orderId}) async {
    isCSVSendLoading = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
      try {
        logs('UserID --> $userId');
        String url = '${API.sendCSVForOrder}/userId/$userId/orderId/$orderId';
        logs('sendCSV Url --> $url');

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
          print("printing csv response -> ${response.body}");
          CommonSnackBar.showError(jsonDecode(response.body)["message"]);
        }
      } on SocketException catch (e) {
        logs('Catch exception in getOrderDetails --> ${e.message}');
        CommonSnackBar.showError(e.message);
      }
      // isLoading = false;
      // update();
      isCSVSendLoading = false;
      update();
    }
  }
}
