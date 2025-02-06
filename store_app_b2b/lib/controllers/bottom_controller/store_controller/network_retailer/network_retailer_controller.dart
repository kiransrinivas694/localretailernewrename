import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/network_retailer/network_retailer_response.dart';
import 'package:store_app_b2b/model/network_retailer/store_profile_response_model/store_profile_response_model.dart';
import 'package:store_app_b2b/model/supplier_list_response/supplier_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class NetworkRetailerController extends GetxController {
  var selectedRetailerListTab = 0.obs;

  var networkRetailerList = <NetworkRetailerSingleItem>[].obs;
  var isNetworkRetailerListLoading = false.obs;
  var isNetworkRetailerMoreListLoading = false.obs;
  RxInt networkRetailerListPageSize = 10.obs;
  RxInt networkRetailerListTotalPages = 0.obs;
  RxInt networkRetailerListCurrentPage = 0.obs;

  var networkRetailerLinkedList = <NetworkRetailerSingleItem>[].obs;
  var isNetworkRetailerLinkedListLoading = false.obs;
  var isNetworkRetailerMoreLinkedListLoading = false.obs;
  RxInt networkRetailerLinkedListPageSize = 10.obs;
  RxInt networkRetailerLinkedListTotalPages = 0.obs;
  RxInt networkRetailerLinkedListCurrentPage = 0.obs;

  var networkRetailerRequestList = <NetworkRetailerSingleItem>[].obs;
  var isNetworkRetailerRequestListLoading = false.obs;
  var isNetworkRetailerMoreRequestListLoading = false.obs;
  RxInt networkRetailerRequestListPageSize = 10.obs;
  RxInt networkRetailerRequestListTotalPages = 0.obs;
  RxInt networkRetailerRequestListCurrentPage = 0.obs;

  TextEditingController requestRetailerSearchController =
      TextEditingController();
  var showSuffixForRequestREtailerSearchController = false.obs;

  TextEditingController linkedRetailerSearchController =
      TextEditingController();
  var showSuffixForLinkedREtailerSearchController = false.obs;

  TextEditingController retailerSearchController = TextEditingController();
  var showSuffixForREtailerSearchController = false.obs;

  Future<dynamic> getNetworkRetailerList({
    bool loadMore = false,
    String searchText = "",
  }) async {
    if (loadMore) {
      if (networkRetailerListCurrentPage.value >=
          networkRetailerListTotalPages.value) {
        return;
      }
    }
    try {
      if (loadMore) {
        isNetworkRetailerMoreListLoading.value = true;
      } else {
        isNetworkRetailerListLoading.value = true;
      }

      String storeId =
          await SharPreferences.getString(SharPreferences.loginId) ?? "";

      String categoryId = await SharPreferences.getString(
              SharPreferences.storeCategoryMainId) ??
          '';

      String url =
          '${API.getAllRetailers}?page=${networkRetailerListCurrentPage}&size=${networkRetailerListPageSize}&businessType=Retailer&categoryId=${categoryId}&storeName=${searchText}&storeId=$storeId';
      logs('getNetworkRetailerList Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print('getNetworkRetailerList Response ---> ${response.body} ');

        NetworkRetailerResponse res =
            networkRetailerResponseFromJson(response.body);

        if (res.content != null &&
            res.page != null &&
            res.content!.isNotEmpty) {
          if (loadMore) {
            networkRetailerList.addAll(res.content!);

            networkRetailerList.removeWhere((item) => item.id == storeId);

            isNetworkRetailerMoreListLoading.value = false;
          } else {
            networkRetailerList.value = res.content!;

            networkRetailerList.removeWhere((item) => item.id == storeId);
            isNetworkRetailerListLoading.value = false;
          }

          networkRetailerListCurrentPage.value = res.page!.number!.toInt() + 1;
          networkRetailerListTotalPages.value = res.page!.totalPages!.toInt();

          return;
        } else {
          networkRetailerList.value = [];
          networkRetailerListCurrentPage.value = 0;
          networkRetailerListTotalPages.value = 0;
        }

        if (loadMore) {
          isNetworkRetailerMoreListLoading.value = false;
        } else {
          isNetworkRetailerListLoading.value = false;
        }
      } else {
        networkRetailerList.value = [];
        if (loadMore) {
          isNetworkRetailerMoreListLoading.value = false;
        } else {
          isNetworkRetailerListLoading.value = false;
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
      isNetworkRetailerMoreListLoading.value = false;
    } else {
      isNetworkRetailerListLoading.value = false;
    }
    update();
  }

  Future<dynamic> getLinkedNetworkRetailerList({
    bool loadMore = false,
    String searchText = "",
  }) async {
    if (loadMore) {
      if (networkRetailerLinkedListCurrentPage.value >=
          networkRetailerLinkedListTotalPages.value) {
        return;
      }
    }
    try {
      if (loadMore) {
        isNetworkRetailerMoreLinkedListLoading.value = true;
      } else {
        isNetworkRetailerLinkedListLoading.value = true;
      }

      String storeId =
          await SharPreferences.getString(SharPreferences.loginId) ?? "";

      // String url =
      //     '${API.getLinkedRetailers}?retailerId=${storeId}&page=${networkRetailerLinkedListCurrentPage}&size=${networkRetailerLinkedListPageSize}';
      String url =
          '${API.getRequestRetailers}?retailerId=${storeId}&status=Y&page=${networkRetailerLinkedListCurrentPage}&size=${networkRetailerLinkedListPageSize}';

      logs('getLinkedNetworkRetailerList Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print('getLinkedNetworkRetailerList Response ---> ${response.body} ');

        NetworkRetailerResponse res =
            networkRetailerResponseFromJson(response.body);

        if (res.content != null &&
            res.page != null &&
            res.content!.isNotEmpty) {
          if (loadMore) {
            networkRetailerLinkedList.addAll(res.content!);

            networkRetailerLinkedList.removeWhere((item) => item.id == storeId);

            isNetworkRetailerMoreLinkedListLoading.value = false;
          } else {
            networkRetailerLinkedList.value = res.content!;

            networkRetailerLinkedList.removeWhere((item) => item.id == storeId);

            isNetworkRetailerLinkedListLoading.value = false;
          }

          networkRetailerLinkedListCurrentPage.value =
              res.page!.number!.toInt() + 1;
          networkRetailerLinkedListTotalPages.value =
              res.page!.totalPages!.toInt();

          return;
        } else {
          networkRetailerLinkedList.value = [];
          networkRetailerLinkedListCurrentPage.value = 0;
          networkRetailerLinkedListTotalPages.value = 0;
        }

        if (loadMore) {
          isNetworkRetailerMoreLinkedListLoading.value = false;
        } else {
          isNetworkRetailerLinkedListLoading.value = false;
        }
      } else {
        networkRetailerLinkedList.value = [];
        if (loadMore) {
          isNetworkRetailerMoreLinkedListLoading.value = false;
        } else {
          isNetworkRetailerLinkedListLoading.value = false;
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
      isNetworkRetailerMoreLinkedListLoading.value = false;
    } else {
      isNetworkRetailerLinkedListLoading.value = false;
    }
    update();
  }

  Future<dynamic> getRequestNetworkRetailerList({
    bool loadMore = false,
    String searchText = "",
    String status = "P",
  }) async {
    if (loadMore) {
      if (networkRetailerRequestListCurrentPage.value >=
          networkRetailerRequestListTotalPages.value) {
        return;
      }
    }
    try {
      if (loadMore) {
        isNetworkRetailerMoreRequestListLoading.value = true;
      } else {
        isNetworkRetailerRequestListLoading.value = true;
      }

      String storeId =
          await SharPreferences.getString(SharPreferences.loginId) ?? "";

      String url =
          '${API.getRequestRetailers}?retailerId=${storeId}&status=${status}&page=${networkRetailerRequestListCurrentPage}&size=${networkRetailerRequestListPageSize}&storeName=$searchText';
      logs('getRequestNetworkRetailerList Url --> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print('getRequestNetworkRetailerList Response ---> ${response.body} ');

        NetworkRetailerResponse res =
            networkRetailerResponseFromJson(response.body);

        if (res.content != null &&
            res.page != null &&
            res.content!.isNotEmpty) {
          if (loadMore) {
            networkRetailerRequestList.addAll(res.content!);

            networkRetailerRequestList
                .removeWhere((item) => item.id == storeId);

            isNetworkRetailerMoreRequestListLoading.value = false;
          } else {
            networkRetailerRequestList.value = res.content!;

            networkRetailerRequestList
                .removeWhere((item) => item.id == storeId);

            isNetworkRetailerRequestListLoading.value = false;
          }

          networkRetailerRequestListCurrentPage.value =
              res.page!.number!.toInt() + 1;
          networkRetailerRequestListTotalPages.value =
              res.page!.totalPages!.toInt();

          return;
        } else {
          networkRetailerRequestList.value = [];
          networkRetailerRequestListCurrentPage.value = 0;
          networkRetailerRequestListTotalPages.value = 0;
        }

        if (loadMore) {
          isNetworkRetailerMoreRequestListLoading.value = false;
        } else {
          isNetworkRetailerRequestListLoading.value = false;
        }
      } else {
        networkRetailerRequestList.value = [];
        if (loadMore) {
          isNetworkRetailerMoreRequestListLoading.value = false;
        } else {
          isNetworkRetailerRequestListLoading.value = false;
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
      isNetworkRetailerMoreRequestListLoading.value = false;
    } else {
      isNetworkRetailerRequestListLoading.value = false;
    }
    update();
  }

  var isLinkRetailerLoading = false.obs;

  Future<void> linkNetworkRetailer(
      {required String linkRetailerId,
      bool isUnlink = false,
      bool isPostMethod = true,
      // bool isDisconnect = false,
      String? status}) async {
    try {
      print(
          "linkNetworkRetailer isUnliunk : $isUnlink , isPostMethod : $isPostMethod");
      String storeId =
          await SharPreferences.getString(SharPreferences.loginId) ?? "";
      isLinkRetailerLoading.value = true;
      String url = "${isUnlink ? API.unlinkRetailer : API.linkRetailer}";

      Map<String, dynamic> body = {
        "retailerId": storeId,
        "linkRetailerId": linkRetailerId,
        "status": status != null
            ? status
            : isUnlink
                ? "N"
                : "P"
      };

      if (!isPostMethod && status == "Y") {
        body = {
          "retailerId": linkRetailerId,
          "linkRetailerId": storeId,
          "status": "Y"
        };
      }
      // else if (isPostMethod && isUnlink && isDisconnect) {
      //   body = {
      //     "retailerId": storeId,
      //     "linkRetailerId": linkRetailerId,
      //     "status": "N"
      //   };
      // }
      else if (isPostMethod && isUnlink) {
        body = {
          "retailerId": linkRetailerId,
          "linkRetailerId": storeId,
          "status": "N"
        };
      }
      print('linkNetworkRetailer url , body --> $url $body');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      if (isPostMethod) {
        print("Calling POST method with URL: $url");
      } else {
        print("Calling PUT method with URL: $url");
      }

      final response = isPostMethod
          ? await http.post(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: headers,
            )
          : await http.put(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: headers,
            );
      print("linkNetworkRetailer response ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);

        print(
            "linkNetworkRetailer condition ${map.containsKey('status') && map['status']}");
        if (map.containsKey('status') && map['status']) {
          if (map.containsKey("retailerResponse") &&
              map["retailerResponse"] != null) {
            CommonSnackBar.showError(map["retailerResponse"]);

            if (selectedRetailerListTab.value == 1) {
              networkRetailerLinkedList.value = [];
              networkRetailerLinkedListCurrentPage.value = 0;
              networkRetailerLinkedListTotalPages.value = 0;

              getLinkedNetworkRetailerList();
              Get.back();
            } else if (selectedRetailerListTab.value == 0) {
              networkRetailerList.value = [];
              networkRetailerListCurrentPage.value = 0;
              networkRetailerListTotalPages.value = 0;

              getNetworkRetailerList(searchText: retailerSearchController.text);
            } else {
              networkRetailerRequestList.value = [];
              networkRetailerRequestListCurrentPage.value = 0;
              networkRetailerRequestListTotalPages.value = 0;

              getRequestNetworkRetailerList();
              if (status == "N") Get.back();
            }
          } else {
            CommonSnackBar.showError(
                '${isUnlink ? "Unlink" : "Link"} Retailer Successful.');
          }

          isLinkRetailerLoading.value = false;
          print("successfully attached");
        } else {
          CommonSnackBar.showError('Something went wrong.');
          isLinkRetailerLoading.value = false;
        }
      } else {
        CommonSnackBar.showError('Something went wrong.');
        isLinkRetailerLoading.value = false;
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      CommonSnackBar.showError('Something went wrong.');
      debugPrint(e.toString());
    }

    isLinkRetailerLoading.value = false;
  }

  var isProfileLoading = false.obs;
  var storeProfileDetails = Rx<StoreProfileResponseModel?>(null);
  Future<void> profileStatus(id) async {
    try {
      isProfileLoading.value = true;
      storeProfileDetails.value = null;
      update();

      await Future.delayed(Duration(seconds: 1), () {});
      print("printing nr store profile status ---> ${"${API.profile}/$id"}");
      final response = await http.get(
        Uri.parse("${API.profile}/$id"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('nr store profileStatus --> $responseBody');

      if (response.statusCode == 200) {
        storeProfileDetails.value =
            storeProfileResponseModelFromJson(response.body);
        isProfileLoading.value = false;
        update();
      } else {
        isProfileLoading.value = false;
        update();
        CommonSnackBar.showError(responseBody['message'].toString());
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }

    isProfileLoading.value = false;
  }
}
