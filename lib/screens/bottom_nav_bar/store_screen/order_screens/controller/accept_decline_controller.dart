import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class AcceptDeclineController extends GetxController {
  static AcceptDeclineController get to => Get.put(AcceptDeclineController());

  ///accept order
  RxMap<String, dynamic> acceptOrDeclineResponse = <String, dynamic>{}.obs;

  Future<bool?> acceptOrderApi(
      {required String type,
      required Map data,
      Function? success,
      Function? error,
      String? page}) async {
    log(ApiConfig.acceptDeclineApi + type, name: 'TYPE');
    log(data.toString(), name: 'data');
    try {
      dio.Response response =
          await dio.Dio().put(ApiConfig.acceptDeclineApi + type,
              data: data,
              options: dio.Options(
                // contentType: dio.Headers.formUrlEncodedContentType,
                headers: {
                  "Authorization": "Bearer ${GetHelperController.token.value}"
                },
              ));

      if (response.statusCode == 200) {
        acceptOrDeclineResponse.value = response.data;

        log(acceptOrDeclineResponse.toString(),
            name: 'acceptOrDeclineResponse');

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

  ///cash reward
  RxMap<String, dynamic> cashRewardPointsRes = <String, dynamic>{}.obs;

  // Future<bool?> cashRewardPointsApi(
  //     {required Map data,
  //     Function? success,
  //     Function? error,
  //     String? page}) async {
  //   log(ApiConfig.cashRewardPoints, name: 'cashRewardPointsResURL');
  //   log(data.toString(), name: 'data');
  //   try {
  //     dio.Response response = await dio.Dio().post(ApiConfig.cashRewardPoints,
  //         data: data,
  //         options: dio.Options(
  //           // contentType: dio.Headers.formUrlEncodedContentType,
  //           headers: {
  //             "Authorization": "Bearer ${GetHelperController.token.value}"
  //           },
  //         ));

  //     if (response.statusCode == 200) {
  //       cashRewardPointsRes.value = response.data;

  //       log(cashRewardPointsRes.toString(), name: 'cashRewardPointsRes');

  //       if (response.data != null) {
  //         if (success != null) {
  //           success();
  //         }
  //         return true;
  //       } else {
  //         if (error != null) {
  //           error();
  //         }
  //         return false;
  //       }
  //     } else {
  //       print(response.data);
  //       if (error != null) {
  //         error();
  //       }
  //     }
  //   } on dio.DioError catch (e) {
  //     log(e.message.toString(), name: 'cashRewardPointsRes');
  //     if (error != null) {
  //       error("Something went wrong");
  //     }
  //   }
  //   return null;
  // }

  Future<bool?> cashRewardPointsApi(
      {required Map data,
      Function? success,
      Function? error,
      String? page}) async {
    log(ApiConfig.cashRewardAmount,
        name: 'cashRewardAPI cashRewardPointsResURL');
    log(data.toString(), name: 'data');
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.cashRewardAmount,
          data: data,
          options: dio.Options(
            // contentType: dio.Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          ));

      if (response.statusCode == 200) {
        cashRewardPointsRes.value = response.data;

        log(cashRewardPointsRes.toString(),
            name: 'cashRewardAPI cashRewardPointsResponse');

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
      log(e.message.toString(), name: 'cashRewardAPI cashRewardPointsRes');
      if (error != null) {
        error("Something went wrong");
      }
    }
    return null;
  }

  RxMap<String, dynamic> addCashRewardPointsRes = <String, dynamic>{}.obs;

  Future<bool?> addCashRewardPointsApi(
      {required Map data,
      Function? success,
      Function? error,
      String? page}) async {
    log(ApiConfig.addCashRewards,
        name: 'cashRewardAPI addCashRewardPointsApiURL');
    log(data.toString(), name: 'data');
    try {
      dio.Response response = await dio.Dio().put(ApiConfig.addCashRewards,
          data: data,
          options: dio.Options(
            // contentType: dio.Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          ));

      if (response.statusCode == 200) {
        addCashRewardPointsRes.value = response.data;

        log(addCashRewardPointsRes.toString(),
            name: 'cashRewardAPI addCashRewardPointsRes');

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
      log(e.message.toString(),
          name: 'cashRewardAPI addCashRewardPointsApiURL');
      if (error != null) {
        error("Something went wrong");
      }
    }
    return null;
  }

  ///get delivery Boy
  RxMap<String, dynamic> getStoreProductRes = <String, dynamic>{}.obs;

  Future<bool?> getDeliveryBoyApi(
      {Function? success, Function? error, String? page}) async {
    log("URL ${ApiConfig.getDeliveryBoyList}");

    if (GetHelperController.storeID.value.isNotEmpty) {
      try {
        dio.Response response = await dio.Dio().get(
            ApiConfig.getDeliveryBoyList + GetHelperController.storeID.value,
            options: dio.Options(
              // contentType: dio.Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Bearer ${GetHelperController.token.value}"
              },
            ));

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
