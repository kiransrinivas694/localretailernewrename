import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/common_snackbar.dart';
import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class NewOrderScreenController extends GetxController {
  static NewOrderScreenController get to => Get.put(NewOrderScreenController());

  RxMap<String, dynamic> newOrdersRes = <String, dynamic>{}.obs;
  RxList newOrdersList = [].obs;

  bool isOrderLoading = false;

  Map<String, dynamic> singleOrderDetail = {};

  getOrderDetails(String orderId) async {
    String userId = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        '';
    if (userId.isNotEmpty) {
      try {
        isOrderLoading = true;
        singleOrderDetail.clear();
        // isLoading = true;
        update();

        String url = '${ApiConfig.getOrderDEtails}/$orderId/store/$userId';
        logs('getOrderDetails Url --> $url');
        final response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        logs('getOrderDetails Response body --> $responseBody');

        if (response.statusCode == 200) {
          if (responseBody.isNotEmpty && responseBody["id"] != null) {
            // bankDetailsMap = responseBody;
            singleOrderDetail = responseBody;
          }
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      // log('bankDetailsMap --> $bankDetailsMap');
      // isLoading = false;
      // update();
      // } else if (!Get.isDialogOpen!) {
      //   Get.dialog(const LoginDialog());
      isOrderLoading = false;
      update();
    }
  }

  verifyPresc(String orderId) async {
    String userId = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        '';
    if (userId.isNotEmpty) {
      isOrderLoading = true;
      singleOrderDetail.clear();
      // isLoading = true;
      update();

      String url = ApiConfig.verifyPresc;
      logs('verifyPresc Url --> $url');

      Map<String, dynamic> bodyMap = {
        "orderId": orderId,
        "prescVerified": true,
        "storeId": userId
      };

      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(bodyMap),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      logs('verifyPresc Response body --> $responseBody');

      if (response.statusCode == 200) {
        // if (responseBody.isNotEmpty && responseBody["id"] != null) {
        //   // bankDetailsMap = responseBody;
        //   // singleOrderDetail = responseBody;
        // }
        "Prescription Verified".showError();
      } else {
        "Prescription Not Verified...Please try again".showError();
      }
      // log('bankDetailsMap --> $bankDetailsMap');
      // isLoading = false;
      isOrderLoading = false;
      update();
      // } else if (!Get.isDialogOpen!) {
      //   Get.dialog(const LoginDialog());
    }
  }

  Future<bool?> newOrdersApi(
      {Map<String, dynamic>? queryParameters,
      required String storeID,
      Function? success,
      Function? error,
      String? page}) async {
    if (storeID.isNotEmpty) {
      log(storeID, name: 'storeID');
      log(ApiConfig.newOrders + "$storeID/status/0", name: 'newOrdersApiURL');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.newOrders + "$storeID/status/0",
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
          newOrdersRes.value = response.data;
          newOrdersRes['content'].forEach((element) {
            newOrdersList.add(element);
          });

          log(newOrdersList.length.toString(), name: 'newOrdersList length');

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

  RxMap<String, dynamic> acceptedOrdersRes = <String, dynamic>{}.obs;
  RxList acceptedOrdersList = [].obs;

  Future<bool?> acceptedOrdersApi(
      {Map<String, dynamic>? queryParameters,
      required String storeID,
      Function? success,
      Function? error,
      String? page}) async {
    log(storeID, name: 'storeID');
    if (storeID.isNotEmpty) {
      try {
        log(ApiConfig.newOrders + "$storeID/status/1",
            name: "acceptedOrdersListUrl");
        dio.Response response =
            await dio.Dio().get(ApiConfig.newOrders + "$storeID/status/1",
                queryParameters: queryParameters,
                options: dio.Options(
                  contentType: dio.Headers.formUrlEncodedContentType,
                  /*  headers: {
                    "Authorization":
                        "Bearer ${GetHelperController.to.token.value}"
                  },*/
                ));

        if (response.statusCode == 200) {
          acceptedOrdersRes.value = response.data;
          acceptedOrdersRes['content'].forEach((element) {
            acceptedOrdersList.add(element);
          });

          log(acceptedOrdersList.length.toString(),
              name: 'acceptedOrdersList length');
          log(acceptedOrdersRes.toString(), name: 'acceptedOrdersRes');

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

  RxMap<String, dynamic> getStoreProductRes = <String, dynamic>{}.obs;

  Future<bool?> getStoreProduct(
      {required Map<String, dynamic> data,
      Function? success,
      Function? error,
      String? page}) async {
    log("getStoreProduct API ${data}");
    log("getStoreProduct URL ${ApiConfig.productStoreAvq}");
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.productStoreAvq,
          data: data,
          options: dio.Options(
            // contentType: dio.Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          ));

      print("printing getstoreProduct response ---> $response");
      if (response.statusCode == 200) {
        getStoreProductRes.value = response.data;

        log(response.data.toString(), name: 'response getStoreProductRes');

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
        print("printing response.data ${response.data}");
        if (error != null) {
          error();
        }
      }
    } on dio.DioError catch (e) {
      log("printing e.message.toString() ${e.message.toString()}");
      if (error != null) {
        error("Something went wrong");
      }
    }
    return null;
  }
}
