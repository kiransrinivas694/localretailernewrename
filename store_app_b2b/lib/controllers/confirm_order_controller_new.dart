import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/get_internal_popup_response_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class ConfirmOrderController extends GetxController {
  List<GetInternalPopUpResponseModel> internalPopUpResponseModel = [];
  List<GetInternalPopUpResponseModel> internalPopUpResponseModel1 = [];

  bool isDashboardBuyClickLoading = false;
  bool isConfirmationScreenLoading = false;
  bool isYesOrNoLoading = false;

  //this and below one are same apis...but this is added to check if length is zero..it will go back to home.homescreen
  Future<void> getInternalPopupInside() async {
    String? loginId = await SharPreferences.getString(SharPreferences.loginId);
    if (loginId != null && loginId.isNotEmpty) {
      isConfirmationScreenLoading = true;
      internalPopUpResponseModel.clear();
      update();
      try {
        String url = '${API.getInternalPopUp}$loginId';
        logs('internal popup url ---> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(Uri.parse(url), headers: headers);
        logs('internal popup response ---> ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          List res1 = jsonDecode(response.body);
          print("printing length of res1 ----> ${res1.length}");
          if (res1.length != 0) {
            print("printing confirm order response ---> ${response.body}");
            List res = jsonDecode(response.body);
            print(
                "printing length of confirm orders in api call ---> ${res.length}");

            internalPopUpResponseModel.clear();
            update();
            for (Map<String, dynamic> i in res) {
              internalPopUpResponseModel
                  .add(getInternalPopUpResponseModelFromJson(jsonEncode(i)));
            }
          } else {
            Get.back();
          }
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        logs('Catch exception in getInternalPopupApi --> ${e.message}');
        CommonSnackBar.showError(e.message.toString());
      }

      isConfirmationScreenLoading = false;

      update();
    }
    // } else if (!Get.isDialogOpen!) {
    //   Get.dialog(const LoginDialog(
    //     message: "getInternalPopup",
    //   ));
    // }
  }

  //this call is used in dashboard screen when buy products is clicked
  Future<void> getInternalPopup() async {
    logs(
        'internal popup url length of items ---> ${internalPopUpResponseModel1.length}');

    internalPopUpResponseModel1.clear();
    isDashboardBuyClickLoading = true;
    update();

    print(
        "printing isbuyclick loading in pi call --> $isDashboardBuyClickLoading");

    String? loginId = await SharPreferences.getString(SharPreferences.loginId);
    if (loginId != null && loginId.isNotEmpty) {
      try {
        String url = '${API.getInternalPopUp}$loginId';
        logs('internal popup url ---> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(Uri.parse(url), headers: headers);
        logs('internal popup response ---> ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.body.isNotEmpty) {
            print("printing confirm order response ---> ${response.body}");
            List res = jsonDecode(response.body);
            print(
                "printing length of confirm orders in api call ---> ${res.length}");

            for (Map<String, dynamic> i in res) {
              internalPopUpResponseModel1
                  .add(getInternalPopUpResponseModelFromJson(jsonEncode(i)));
            }
          }
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        logs('Catch exception in getInternalPopupApi --> ${e.message}');
        CommonSnackBar.showError(e.message.toString());
      }

      update();
    } else if (!Get.isDialogOpen!) {
      // print("else in get internal popup is called");
      // Get.dialog(const LoginDialog(
      //   message: "getInternalPopup",
      // ));
    }

    isDashboardBuyClickLoading = false;
    update();
  }

  Future<void> updateInternalPopup(
      {required String orderId,
      required String id,
      required String value}) async {
    try {
      isYesOrNoLoading = true;
      update();
      String url = '${API.updatePopupValue}/$id/userViwed/Y';
      logs('Update internal popup url ---> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.put(Uri.parse(url), headers: headers);
      logs('Update internal popup response ---> ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // isShowPopup = false;
        // Get.back();
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      logs('Catch exception in getInternalPopupApi --> ${e.message}');
      CommonSnackBar.showError(e.message.toString());
    }

    try {
      String url =
          '${API.updatePopupConfirmation}/order/$orderId/status/$value';

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      logs('Update internal popup confirmation url ---> $url');
      final response = await http.put(Uri.parse(url), headers: headers);
      logs('Update internal popup confirmation response ---> ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // isShowPopup = false;
        // Get.back();

        getInternalPopupInside();
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      logs('Catch exception in getInternalPopupApi --> ${e.message}');
      CommonSnackBar.showError(e.message.toString());
    }

    isYesOrNoLoading = false;
    update();
  }
}
