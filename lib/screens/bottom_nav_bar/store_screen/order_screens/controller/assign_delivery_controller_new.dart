// assignDelivery

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class AssignDeliveryController extends GetxController {
  static AssignDeliveryController get to => Get.put(AssignDeliveryController());

  ///accept order
  RxMap<String, dynamic> assignDeliveryResponse = <String, dynamic>{}.obs;

  Future<bool?> assignDeliveryApi(
      {required String riderId,
      required Map data,
      Function? success,
      Function? error,
      String? page}) async {
    log(ApiConfig.assignDelivery + riderId, name: 'URL');
    log(data.toString(), name: 'assignDeliveryApiDATA');
    log('Data --> $data');
    logs(
        'logging assignDeliveryApi + riderId is $riderId ---> ${ApiConfig.assignDelivery + riderId}');
    try {
      dio.Response response =
          await dio.Dio().put(ApiConfig.assignDelivery + riderId,
              data: data,
              options: dio.Options(
                // contentType: dio.Headers.formUrlEncodedContentType,
                headers: {
                  "Authorization": "Bearer ${GetHelperController.token.value}"
                },
              ));

      if (response.statusCode == 200) {
        assignDeliveryResponse.value = response.data;

        log(assignDeliveryResponse.toString(), name: 'acceptOrDeclineResponse');

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

  ///get RIDERS
  RxList/*<String, dynamic>*/ getRiderResponse = [].obs;

  Future<bool?> getRiderApi(
      {Function? success, Function? error, String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(ApiConfig.getRiders + GetHelperController.storeID.value, name: 'URL');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.getRiders + GetHelperController.storeID.value,
          /*options: dio.Options(
                  headers: {
                    "Authorization": "Bearer ${GetHelperController.token.value}"
                  },
                )*/
        );

        if (response.statusCode == 200) {
          log(response.data.toString(), name: 'getRiderResponse');
          getRiderResponse.value = response.data;

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
    // Future.delayed(
    //   const Duration(milliseconds: 300),
    //   () {
    //     if (!Get.isDialogOpen!) {
    //       Get.dialog(const LoginDialog());
    //     }
    //   },
    // );
    return null;
  }
}
