import 'dart:developer';
import 'dart:ui';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class AnalyticsApiController extends GetxController {
  static AnalyticsApiController get to => Get.put(AnalyticsApiController());

  RxMap<String, dynamic> analyticsRes = <String, dynamic>{}.obs;
  // RxList waitingList = [].obs;

  RxList<double> subCategorySalesPre = <double>[].obs;
  RxList<Color> subCategorySalesColor = <Color>[].obs;
  RxList<double> dashboardStoreSalesAgg = <double>[].obs;

  Future<bool?> analyticsApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log("${ApiConfig.callNotificatoin}${GetHelperController.storeID.value}",
          name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          "${ApiConfig.dashboard}${GetHelperController.storeID.value}",
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
          analyticsRes.value = response.data;

          log(analyticsRes.keys.toString(), name: 'analyticsRes ');
          // waitingList.value = response.data;
          subCategorySalesPre.clear();
          analyticsRes['subCategorySales'].forEach((element) {
            subCategorySalesPre.add(
                (double.parse((element['totalPercent'] ?? '0').toString()) /
                        100) *
                    2);
            subCategorySalesColor.add(Color(int.parse(
                    (element['colorCode'] ?? "#000000").substring(1, 7),
                    radix: 16) +
                0xFF000000));
          });
          subCategorySalesPre.refresh();

          /*dashboardStoreSalesAgg
              .addAll((analyticsRes['dashboardStoreSalesAgg'].values / 100) * 2);*/

          subCategorySalesPre.refresh();
          log(subCategorySalesPre.toString(), name: 'subCategorySalesPre');

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
