import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class EnableDisableProductController extends GetxController {
  static EnableDisableProductController get to =>
      Get.put(EnableDisableProductController());

  RxMap<String, dynamic> inventoryEnableRes = <String, dynamic>{}.obs;

  Future<bool?> inventoryEnableApi(
      {Map<String, dynamic>? queryParameters,
      required String productID,
      Function? success,
      Function? error}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().put(
          ApiConfig.activeInventory +
              "${GetHelperController.storeID.value}/" +
              '${productID}',
          data: queryParameters ?? {},
          /*options: dio.Options(
                  contentType: dio.Headers.formUrlEncodedContentType,
                     headers: {
                    "Authorization":
                        "Bearer ${GetHelperController.token.value}"
                  },
                )*/
        );

        if (response.statusCode == 200) {
          inventoryEnableRes.value = response.data;
          // inventoryRes['content'].forEach((element) {
          //   inventoryList.add(element);
          // });

          log(inventoryEnableRes.toString(), name: 'inventoryEnableRes length');

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

  RxMap<String, dynamic> todaysDealEnableRes = <String, dynamic>{}.obs;

  Future<bool?> todaysDealEnableApi(
      {Map<String, dynamic>? queryParameters,
      required String productId,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      log(
          ApiConfig.activeTodaysInventory +
              '${productId}/store/' +
              "${GetHelperController.storeID.value}",
          name: 'URL');
      try {
        dio.Response response = await dio.Dio().put(
          ApiConfig.activeTodaysInventory +
              '${productId}/store/' +
              "${GetHelperController.storeID.value}",
          data: queryParameters,
          /*options: dio.Options(
                  contentType: dio.Headers.formUrlEncodedContentType,
                     headers: {
                    "Authorization":
                        "Bearer ${GetHelperController.token.value}"
                  },
                )*/
        );

        if (response.statusCode == 200) {
          todaysDealEnableRes.value = response.data;

          log(todaysDealEnableRes.toString(),
              name: 'todaysDealEnableRes length');

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
