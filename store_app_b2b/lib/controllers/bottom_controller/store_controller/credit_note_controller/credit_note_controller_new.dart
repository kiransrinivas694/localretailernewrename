import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/credit_note_history_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class CreditNoteController extends GetxController {
  List<CreditNoteOrderContent> creditNoteHistoryList = [];
  bool isCreditNoteHistoryLoading = false;
  num creditNoteBalance = 0;
  bool isCreditNoteBalanceLoading = false;
  num creditHistoryTotalPages = 0;
  num creditHistoryCurrentPage = 0;
  int creditHistoryPaginationSize = 10;

  Future<void> getCreditNoteHeader() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (userId.isNotEmpty) {
      try {
        isCreditNoteBalanceLoading = true;
        update();
        String requestUrl =
            '${API.getCreditNoteHeader}/$userId/store/$supplierId';

        logs('getCreditNoteHeader Url --> $requestUrl');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(requestUrl),
          headers: headers,
        );
        logs('getCreditNoteHeader response ---> ${response.body}');
        if (response.statusCode == 200) {
          dynamic normalRes = jsonDecode(response.body);
          creditNoteBalance = normalRes["creditNoteAmount"];
          // isLoading.value = false;
          // if (paymentRequestCurrentPage.value == 0) {
          // paymentRequestTotalPage.value =
          // (paymentRequestModel.totalPages ?? 0).toInt();
          // }
        } else {
          // isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }

      isCreditNoteBalanceLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      // if (!callingFromDashboard) {
      //   Get.dialog(const LoginDialog());
      // }
    }
  }

  Future<void> getCreditNoteHistory({num pageNumber = 0}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (userId.isNotEmpty) {
      try {
        isCreditNoteHistoryLoading = true;
        update();
        String requestUrl =
            '${API.getCreditNoteHistory}/$userId/store/$supplierId?page=$pageNumber&size=$creditHistoryPaginationSize';

        logs('getCreditNoteHistory Url --> $requestUrl');
        logs('getCreditNoteHistory Url --> $supplierId');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(requestUrl),
          headers: headers,
        );
        logs('getCreditNoteHistory response ---> ${response.body}');
        if (response.statusCode == 200) {
          creditNoteHistoryList.clear();
          CreditNoteHistoryModel creditNoteHistory =
              creditNoteHistoryModelFromJson(response.body);
          creditNoteHistoryList.addAll(creditNoteHistory.content);
          // creditNoteHistoryList.addAll(creditNoteHistory.content);

          creditHistoryTotalPages = creditNoteHistory.totalPages ?? 1;
          creditHistoryCurrentPage = creditNoteHistory.number ?? 0;
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }

      isCreditNoteHistoryLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      // if (!callingFromDashboard) {
      Get.dialog(const LoginDialog());
      // }
    }
  }
}
