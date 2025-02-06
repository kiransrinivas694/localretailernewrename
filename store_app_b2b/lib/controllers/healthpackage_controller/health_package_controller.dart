//import 'package:flutter/widgets.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/constant/app_api_type_constants.dart';
import 'package:store_app_b2b/new_module/model/lucid/health_package/health_package_model.dart';
import 'package:store_app_b2b/new_module/model/lucid/health_package/health_packagedetails_model.dart';
import 'package:store_app_b2b/new_module/model/lucid/health_package/view_healthpackage_model.dart';
import 'package:store_app_b2b/new_module/services/new_apiresponse.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service.dart';
import 'package:store_app_b2b/new_module/services/payloads.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';

class HealthPackageController extends GetxController
    implements APiResponseFlow {
  var packageDetails = <BasicHealthPackageModel>[].obs;
  var isHealthPackageLoading = false.obs;
  var isHealthMorePackageLoading = false.obs;
  RxInt healthPackagePageSize = 8.obs;
  RxInt healthPackageTotalPages = 0.obs;
  RxInt healthPackageCurrentPage = 0.obs;
  TextEditingController packageSearchController = TextEditingController();
  var showSuffixForSearchPackageController = false.obs;
  void clearHealthPackagestDetails() {
    packageDetails.clear();
    isHealthPackageLoading.value = false;
    isHealthMorePackageLoading.value = false;
    healthPackageCurrentPage.value = 0;
    healthPackageTotalPages.value = 0;
  }

  Future<void> getAllHealthPackagesData({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
    String searchText = "",
  }) async {
    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    if (!loadMore) clearHealthPackagestDetails();
    try {
      if (finalLoadMore) {
        if (healthPackageCurrentPage.value >= healthPackageTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        isHealthMorePackageLoading.value = true;
        logs("said load more");
      } else {
        isHealthPackageLoading.value = true;
      }

      await RestServices.instance.getRestCall<HealthPackageModel>(
        fromJson: (json) {
          return healthPackageModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getAllHealthPackages(
                packageName: searchText,
                page: healthPackageCurrentPage.value,
                size: healthPackagePageSize.value,
              ),
        flow: this,
        info: {
          "loadMore": finalLoadMore,
        },
        apiType: ApiTypes.getAllHealthPackages,
      );
    } catch (e) {
      logs("logs error-->${e.toString()}");
      if (finalLoadMore) {
        isHealthMorePackageLoading.value = false;
      } else {
        isHealthPackageLoading.value = false;
      }
      // toastification.dismissAll();
      // customFailureToast(content: e.toString());
    }
  }

  void getAllHealthPackagesOnSuccess<T>(
      T? data, String apiType, Map<String, dynamic> info) {
    HealthPackageModel modelData = data as HealthPackageModel;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        packageDetails.addAll(modelData.data!.content!);
        isHealthMorePackageLoading.value = false;
      } else {
        packageDetails.value = modelData.data!.content!;
        isHealthPackageLoading.value = false;
      }

      healthPackageCurrentPage.value = modelData.data!.number! + 1;
      healthPackageTotalPages.value = modelData.data!.totalPages ?? 0;

      return;
    }

    if (info["loadMore"]) {
      isHealthMorePackageLoading.value = false;
    } else {
      isHealthPackageLoading.value = false;
    }
  }

  void getAllHealthPackagesOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    // toastification.dismissAll(delayForAnimation: false);
    customFailureToast(content: message);
    if (info["loadMore"]) {
      isHealthMorePackageLoading.value = false;
    } else {
      isHealthPackageLoading.value = false;
    }
  }

  var healthPackageList = Rx<BasicPackageDetails?>(null);
  var totalTests = 0.obs;

  RxBool ishealthPackageListLoading = false.obs;
  Future<void> getHealthPackagesDetailsID({
    required String packageId,
    String endpoint = "",
  }) async {
    try {
      ishealthPackageListLoading.value = true;
      logs("Flow is here");
      await RestServices.instance.getRestCall<HealthPackageDetails>(
        fromJson: (json) {
          return healthPackageDetailsFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getHealthPackagesDetails(packageId: packageId),
        flow: this,
        apiType: ApiTypes.getHealthPackageDetails,
      );
    } catch (e) {
      logs("logs error-->${e.toString()}");
      ishealthPackageListLoading.value = false;
      ////toastification.dismissAll();
      //customFailureToast(content: e.toString());
    }
  }

  var healthPackageCartList = Rx<BasicPackageCartDetails?>(null);

  RxBool ishealthPackageCartListLoading = false.obs;
  Future<void> getPackageViewCart({
    required String serviceCd,
    String endpoint = "",
  }) async {
    healthPackageCartList.value = null;
    try {
      ishealthPackageCartListLoading.value = true;

      await RestServices.instance.getRestCall<ViewAllPackageCartModel>(
        fromJson: (json) {
          return viewAllPackageCartModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getViewPackages(serviceCd: serviceCd),
        flow: this,
        apiType: ApiTypes.getviewPackageCart,
      );
    } catch (e) {
      logs("logs error-->${e.toString()}");
      ishealthPackageCartListLoading.value = false;
      //toastification.dismissAll();
      //customFailureToast(content: e.toString());
    }
  }

  @override
  void onFailure(String message, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllHealthPackages) {
      logs("packages success");
      getAllHealthPackagesOnFailure(message, apiType, info);
    }
    if (apiType == ApiTypes.getHealthPackageDetails) {
      // toastification.dismissAll();
      logs("packages success");
      customFailureToast(content: message);
      ishealthPackageListLoading.value = false;
    }
    if (apiType == ApiTypes.getviewPackageCart) {
      // toastification.dismissAll();
      // customFailureToast(content: message);
      ishealthPackageCartListLoading.value = false;
    }
  }

  @override
  void onSuccess<T>(T? data, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllHealthPackages) {
      getAllHealthPackagesOnSuccess(data, apiType, info);
    }
    if (apiType == ApiTypes.getHealthPackageDetails) {
      HealthPackageDetails modelData = data as HealthPackageDetails;
      totalTests.value = 0;
      if (modelData.data != null) {
        logs("data is running");
        healthPackageList.value = modelData.data!;
        for (var tests in modelData.data!.healthPackageTypes!) {
          totalTests.value += tests.testNames!.length;
        }

        logs("total tests $totalTests");
        ishealthPackageListLoading.value = false;
        //toastification.dismissAll();
      } else {
        logs("running");
        ishealthPackageListLoading.value = false;
      }
    }
    if (apiType == ApiTypes.getviewPackageCart) {
      ViewAllPackageCartModel modelData = data as ViewAllPackageCartModel;
      if (modelData.data != null) {
        healthPackageCartList.value = modelData.data;
      }
      ishealthPackageCartListLoading.value = false;
      //  toastification.dismissAll();
    }
  }

  @override
  void onTokenExpired(
      String apiType, String endPoint, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllHealthPackages) {
      getAllHealthPackagesData(
        endpoint: endPoint,
        retryInfo: info,
      );
    }
    if (apiType == ApiTypes.getHealthPackageDetails) {
      getHealthPackagesDetailsID(
        endpoint: endPoint,
        packageId: '',
      );
    }
    if (apiType == ApiTypes.getviewPackageCart) {
      getPackageViewCart(
        endpoint: endPoint,
        serviceCd: '',
      );
    }
  }
}
