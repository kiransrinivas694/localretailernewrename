import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class RejectedOrderController extends GetxController {
  static RejectedOrderController get to => Get.put(RejectedOrderController());

  RxMap<String, dynamic> rejectedOrdersRes = <String, dynamic>{}.obs;
  RxList rejectedOrdersList = [].obs;

  Future<bool?> rejectedOrdersApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.newOrders + "${GetHelperController.storeID.value}/status/3",
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
          rejectedOrdersRes.value = response.data;
          rejectedOrdersRes['content'].forEach((element) {
            rejectedOrdersList.add(element);
          });

          log(rejectedOrdersList.length.toString(),
              name: 'rejectedOrdersList length');

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
