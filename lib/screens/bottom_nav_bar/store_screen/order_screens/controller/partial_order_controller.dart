import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class PartialOrderController extends GetxController {
  static PartialOrderController get to => Get.put(PartialOrderController());

  RxMap<String, dynamic> partialOrderRes = <String, dynamic>{}.obs;
  RxList partialOrderList = [].obs;

  Future<bool?> partialOrderApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'partialOrderApistoreID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.newOrders + "${GetHelperController.storeID.value}/status/2",
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
          partialOrderRes.value = response.data;
          partialOrderRes['content'].forEach((element) {
            partialOrderList.add(element);
          });

          log(
              ApiConfig.newOrders +
                  "${GetHelperController.storeID.value}/status/2/",
              name: "deliveryProgressUrl");
          log(partialOrderList.length.toString(), name: 'partialOrder length');
          log(partialOrderRes.toString(), name: 'deliveryProgress');

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
