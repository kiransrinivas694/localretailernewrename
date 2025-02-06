import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class InventoryListController extends GetxController {
  static InventoryListController get to => Get.put(InventoryListController());

  RxMap<String, dynamic> inventoryRes = <String, dynamic>{}.obs;
  RxList inventoryList = [].obs;

  Future<bool?> inventoryListApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      log(ApiConfig.inventoryList + "${GetHelperController.storeID.value}",
          name: 'URL');
      log(queryParameters.toString(), name: 'PARAMS');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.inventoryList + "${GetHelperController.storeID.value}",
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
          inventoryRes.value = response.data;
          inventoryRes['content'].forEach((element) {
            inventoryList.add(element);
          });

          log(inventoryRes.toString(), name: 'inventoryRes length');

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

  Future<bool?> categoryItemListApi(
      {Map<String, dynamic>? queryParameters,
      required String subCategoryID,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      log(GetHelperController.categoryID.value, name: 'storeID');
      log(
          ApiConfig.getItemsbySubCategory +
              "${GetHelperController.storeID.value}" +
              "/category/" +
              /*PROFILE CATEGORY ID*/ GetHelperController.categoryID.value +
              "/subcategory/" +
              '${subCategoryID}',
          name: 'URL');

      try {
        dio.Response response = await dio.Dio().get(
            ApiConfig.getItemsbySubCategory +
                "${GetHelperController.storeID.value}" +
                "/category/" +
                /*PROFILE CATEGORY ID*/ '${GetHelperController.categoryID.value}' +
                "/subcategory/" +
                '${subCategoryID}',
            queryParameters: queryParameters,
            options: dio.Options(
              // contentType: dio.Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Bearer ${GetHelperController.token.value}"
              },
            ));

        if (response.statusCode == 200) {
          inventoryRes.value = response.data;
          inventoryRes['content'].forEach((element) {
            inventoryList.add(element);
          });

          log(inventoryRes.toString(), name: 'inventoryRes length');

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

  RxMap<String, dynamic> todaysDealRes = <String, dynamic>{}.obs;
  RxList todaysDealList = [].obs;

  Future<bool?> todaysDealListApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.todaysList + "${GetHelperController.storeID.value}",
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
          todaysDealRes.value = response.data;
          todaysDealRes['content'].forEach((element) {
            todaysDealList.add(element);
          });

          log(todaysDealRes.toString(), name: 'todaysDealRes length');

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

  RxList getCategoriesRes = [].obs;
  RxString categoryID = ''.obs;

  Future<bool?> getCategoriesApi(
      {Map<String, dynamic>? queryParameters,
      Function? success,
      Function? error,
      String? page}) async {
    try {
      dio.Response response = await dio.Dio().get(
        ApiConfig.getProductCategory + GetHelperController.categoryID.value,
        queryParameters: queryParameters,
        /* options: dio.Options(
            // contentType: dio.Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          )*/
      );

      if (response.statusCode == 200) {
        getCategoriesRes.value = response.data;
        /* getCategoriesRes['content'].forEach((element) {
          todaysDealList.add(element);
        });*/
// categoryID.value=getCategoriesRes[0]['subCategoryId'];
        log(getCategoriesRes.toString(), name: 'getCategoriesRes length');
        log(categoryID.value, name: 'categoryID');

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

  RxMap<String, dynamic> getInvoiceRes = <String, dynamic>{}.obs;

  Future<bool?> productListApi(
      {Map<String, dynamic>? queryParameters,
      required String productId,
      Function? success,
      Function? error,
      String? page}) async {
    if (GetHelperController.storeID.value.isNotEmpty) {
      log(GetHelperController.storeID.value, name: 'storeID');
      try {
        dio.Response response = await dio.Dio().get(
          ApiConfig.productStore +
              "${GetHelperController.storeID.value}/product/$productId?page=0&size=100",
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
          getInvoiceRes.value = response.data;
          log(getInvoiceRes.toString(), name: 'getInvoiceRes');

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

  RxMap<String, dynamic> updateInvoiceRes = <String, dynamic>{}.obs;

  Future<bool?> updateInvoiceApi({
    required Map data,
    Function? success,
    Function? error,
  }) async {
    log(data.toString(), name: 'PARAMS');
    try {
      dio.Response response = await dio.Dio().put(ApiConfig.priceUpdate,
          data: data,
          options: dio.Options(
            /* contentType: dio.Headers.formUrlEncodedContentType,*/
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          ));

      if (response.statusCode == 200) {
        updateInvoiceRes.value = response.data;
        log(updateInvoiceRes.toString(), name: 'updateInvoiceRes');

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

  RxMap<String, dynamic> addInvoiceRes = <String, dynamic>{}.obs;

  Future<bool?> addInvoiceApi({
    required Map data,
    Function? success,
    Function? error,
  }) async {
    log(data.toString(), name: 'PARAMS');
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.addInventory,
          data: data,
          options: dio.Options(
            /* contentType: dio.Headers.formUrlEncodedContentType,*/
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          ));

      if (response.statusCode == 200) {
        addInvoiceRes.value = response.data;
        log(addInvoiceRes.toString(), name: 'addInvoiceRes');

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

  RxMap<String, dynamic> updateInventoryRes = <String, dynamic>{}.obs;

  Future<bool?> updateInventoryApi({
    required Map data,
    Function? success,
    Function? error,
  }) async {
    log(data.toString(), name: 'PARAMS');
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.addInventory,
          data: data,
          options: dio.Options(
            /* contentType: dio.Headers.formUrlEncodedContentType,*/
            headers: {
              "Authorization": "Bearer ${GetHelperController.token.value}"
            },
          ));

      if (response.statusCode == 200) {
        updateInventoryRes.value = response.data;
        log(updateInventoryRes.toString(), name: 'updateInventoryRes');

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
}
