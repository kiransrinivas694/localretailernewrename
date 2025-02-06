import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/model/supplier_list_response/supplier_list_response_new.dart';
import 'package:store_app_b2b/screens/auth/app_pending_screen_new.dart';
import 'package:store_app_b2b/screens/auth/app_process_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:http/http.dart' as http;

class SupplierOnboardController extends GetxController {
  var supplierList = <SupplierDetail>[].obs;
  var isSupplierListLoading = false.obs;
  var isSupplierMoreListLoading = false.obs;
  RxInt supplierListPageSize = 10.obs;
  RxInt supplierListTotalPages = 0.obs;
  RxInt supplierListCurrentPage = 0.obs;

  var isSupplierSelected = false.obs;
  var selectedSupplierId = "".obs;

  TextEditingController supplierSearchController = TextEditingController();
  var showSuffixForSeachServiceProductController = false.obs;

  var isOnboarSupplierLoading = false.obs;

  Future<dynamic> getSupplierList({
    bool loadMore = false,
    String searchText = "",
  }) async {
    if (loadMore) {
      if (supplierListCurrentPage.value >= supplierListTotalPages.value) {
        return;
      }
    }
    try {
      if (loadMore) {
        isSupplierMoreListLoading.value = true;
      } else {
        isSupplierListLoading.value = true;
      }

      // String storeId =
      //     await SharPreferences.getString(SharPreferences.loginId) ??
      //         "ACIN100066";
      String categoryId = await SharPreferences.getString(
              SharPreferences.storeCategoryMainId) ??
          '';
      // String url =
      //     '${API.getSupplierList}?page=${supplierListCurrentPage}&size=${supplierListPageSize}&businessType=Supplier&categoryId=3d1592c3-60fa-4f5e-9229-2ba36bcca886&storeName=${searchText}';
      String url =
          '${API.baseUrl}api-auth/store/storeUsers/admin/2??page=${supplierListCurrentPage}&size=${supplierListPageSize}&businessType=Supplier&categoryId=$categoryId&storeName=${searchText}';
      logs('getSupplierList Url --> $url');

      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        print('getSupplierList Response ---> ${response.body} ');

        SupplierListResponse res = supplierListResponseFromJson(response.body);

        if (res.content != null &&
            res.page != null &&
            res.content!.isNotEmpty) {
          if (loadMore) {
            supplierList.addAll(res.content!);
            isSupplierMoreListLoading.value = false;
          } else {
            supplierList.value = res.content!;
            isSupplierListLoading.value = false;
          }

          List<SupplierDetail> tempList = [];
          for (SupplierDetail i in supplierList) {
            print('every supplier status ${i.displayOnboard}');
            if (i.displayOnboard == "Y") {
              tempList.add(i);
            }
          }

          supplierList.value = tempList;

          supplierListCurrentPage.value = res.page!.number!.toInt() + 1;
          supplierListTotalPages.value = res.page!.totalPages!.toInt();

          return;
        } else {
          supplierList.value = [];
          supplierListCurrentPage.value = 0;
          supplierListTotalPages.value = 0;
        }

        if (loadMore) {
          isSupplierMoreListLoading.value = false;
        } else {
          isSupplierListLoading.value = false;
        }
      } else {
        supplierList.value = [];
        if (loadMore) {
          isSupplierMoreListLoading.value = false;
        } else {
          isSupplierListLoading.value = false;
        }
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
    if (loadMore) {
      isSupplierMoreListLoading.value = false;
    } else {
      isSupplierListLoading.value = false;
    }
    update();
  }

  Future<void> onboardSupplierPost({required String retailerId}) async {
    try {
      isOnboarSupplierLoading.value = true;
      String url =
          "${API.onboardSupplierPost}/${retailerId}/${selectedSupplierId}";
      // String url =
      //     "http://45.127.101.45:8090/b2b/api-auth/store/linkSupplier/${retailerId}/${selectedSupplierId}";
      print('onboardSupplierPost url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print("onboardSupplierPost response ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        if (map.containsKey('response') && map['response']) {
          isOnboarSupplierLoading.value = false;
          print("successfully attached");
          "Supplier selection process completed".showError();
          Get.offAll(() => AppProcessScreen(), transition: Transition.size);
        } else {
          CommonSnackBar.showError('Something went wrong.');
          isOnboarSupplierLoading.value = false;
        }
      } else {
        CommonSnackBar.showError('Something went wrong.');
        isOnboarSupplierLoading.value = false;
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }

    isOnboarSupplierLoading.value = false;
  }
}
