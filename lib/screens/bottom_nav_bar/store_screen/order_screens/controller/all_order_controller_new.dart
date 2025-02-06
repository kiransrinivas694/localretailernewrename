import 'dart:developer';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class AllItemController extends GetxController {
  static AllItemController get to => Get.put(AllItemController());

  RxMap<String, dynamic> allOrdersRes = <String, dynamic>{}.obs;
  RxList allOrdersList = [].obs;

  Future<bool?> allOrdersApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.newOrders +
              "${GetHelperController.storeID.value}/status/all",
          queryParameters: queryParameters,
          /*options: dio.Options(
                  contentType: dio.Headers.formUrlEncodedContentType,
                     headers: {
                    "Authorization":
                        "Bearer ${GetHelperController.token.value}"
                  },
                )*/
        );

        if (response.statusCode == 200) {
          allOrdersRes.value = response.data;
          allOrdersRes['content'].forEach((element) {
            allOrdersList.add(element);
          });

          log(allOrdersList.length.toString(),
              name: 'cancelledOrdersRes length');

          if (response.data != null) {
            if (success != null) {
              success();
            }
            return true;
          } else {
            if (error != null) {
              error();
            }
            return false;
          }
        } else {
          print(response.data);
          if (error != null) {
            error();
          }
        }
      } on dio.DioError catch (e) {
        log(e.message.toString());
        if (error != null) {
          error("Something went wrong");
        }
      }
    }
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (!Get.isDialogOpen!) {
          Get.dialog(const LoginDialog());
        }
      },
    );
    return null;
  }
}
