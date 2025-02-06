import 'dart:developer';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class NotificationController extends GetxController {
  static NotificationController get to => Get.put(NotificationController());

  RxMap<String, dynamic> notificationRes = <String, dynamic>{}.obs;
  RxList notificationList = [].obs;

  Future<bool?> getNotificationListApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.getNotification + "${GetHelperController.storeID.value}",
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
          notificationRes.value = response.data;
          notificationRes['content'].forEach((element) {
            notificationList.add(element);
          });

          log(notificationList.toString(), name: 'NOTIFICATION length');

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
