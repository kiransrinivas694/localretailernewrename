import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class DeliveryProgressController extends GetxController {
  static DeliveryProgressController get to =>
      Get.put(DeliveryProgressController());

  RxMap<String, dynamic> deliveryProgressRes = <String, dynamic>{}.obs;
  RxList deliveryProgressList = [].obs;

  Future<bool?> deliveryProgressApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.newOrders +
              "${GetHelperController.storeID.value}/status/delivaryInprogress",
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
          deliveryProgressRes.value = response.data;
          deliveryProgressRes['content'].forEach((element) {
            deliveryProgressList.add(element);
          });

          log(
              ApiConfig.newOrders +
                  "${GetHelperController.storeID.value}/status/delivaryInprogress",
              name: "deliveryProgressUrl");
          log(deliveryProgressList.length.toString(),
              name: 'deliveryProgress length');
          log(deliveryProgressRes.toString(), name: 'deliveryProgress');

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
    } else {
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

    // Commented this because even if user logged in and api failed..this is asking login.
    // Future.delayed(
    //   const Duration(milliseconds: 300),
    //   () {
    //     if (!Get.isDialogOpen!) {
    //       Get.dialog(const LoginDialog());
    //     }
    //   },
    // );
    // return null;
  }
}
