import 'dart:developer';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class GetCallsController extends GetxController {
  static GetCallsController get to => Get.put(GetCallsController());

  RxMap<String, dynamic> getWaitingListRes = <String, dynamic>{}.obs;
  RxList waitingList = [].obs;

  Future<bool?> getWaitingCallApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log("${ApiConfig.callNotificatoin}${GetHelperController.storeID.value}",
          name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          "${ApiConfig.callNotificatoin}${GetHelperController.storeID.value}",
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
          log(response.data.toString(), name: 'response.data');
          getWaitingListRes.value = response.data;

          getWaitingListRes['content'].forEach((element) {
            waitingList.add(element);
          });

          log(getWaitingListRes.length.toString(),
              name: 'cancelledOrdersRes length');
          // waitingList.value = response.data;

          log(waitingList.length.toString(), name: 'waitingList length');

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
