import 'dart:developer';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class GetCustomersController extends GetxController {
  static GetCustomersController get to => Get.put(GetCustomersController());

  RxMap<String, dynamic> getCustomerRes = <String, dynamic>{}.obs;
  RxList getCustomerList = [].obs;

  Future<bool?> getCustomerApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          "${ApiConfig.customerList}${GetHelperController.storeID.value}/customerList",
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
          getCustomerRes.value = response.data;
          getCustomerRes['content'].forEach((element) {
            getCustomerList.add(element);
          });

          log(getCustomerList.length.toString(),
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

  RxMap<String, dynamic> getCustomerOrderRes = <String, dynamic>{}.obs;
  RxList getCustomerOrdersList = [].obs;

  Future<bool?> getCustomerOrdersApi(
      {Map<String, dynamic>? queryParameters,
      required String userID,
      Function? success,
      Function? error,
      String? page}) async {
    log(GetHelperController.storeID.value, name: 'storeID');
    log("${ApiConfig.userOrders}${GetHelperController.storeID.value}/user/$userID",
        name: 'url');
    try {
      dio.Response response = await dio.Dio().get(
        "${ApiConfig.userOrders}${GetHelperController.storeID.value}/user/$userID",
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
        getCustomerOrderRes.value = response.data;
        getCustomerOrderRes['content'].forEach((element) {
          getCustomerOrdersList.add(element);
        });

        log(getCustomerOrderRes.toString(), name: 'getCustomerOrderRes');

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
    return null;
  }

  RxMap<String, dynamic> getOrderRes = <String, dynamic>{}.obs;
  RxList getOrderList = [].obs;

  Future<bool?> getOrderDetailApi(
      {Map<String, dynamic>? queryParameters,
      required String userID,
      required String orderID,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      log("${ApiConfig.orderDetail}$userID/order/$orderID", name: 'url');
      try {
        dio.Response response = await dio.Dio().get(
          "${ApiConfig.orderDetail}$userID/order/$orderID",
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
          getOrderRes.value = response.data;
          /*getCustomerOrderRes['content'].forEach((element) {
            getCustomerOrdersList.add(element);
          });*/

          log(getOrderRes.toString(), name: 'getCustomerOrderRes');
          log(getOrderRes.keys.toString(), name: 'getCustomerOrderRes');

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
