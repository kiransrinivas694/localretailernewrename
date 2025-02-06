import 'dart:io';

import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/constant/app_api_type_constants_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/model/lucid/find_location_model_new.dart';
import 'package:store_app_b2b/new_module/model/lucid/location_id_model_new.dart';
import 'package:store_app_b2b/new_module/model/lucid/lucid_list_model_new.dart';
import 'package:store_app_b2b/new_module/services/new_apiresponse_new.dart';
import 'package:store_app_b2b/new_module/services/new_rest_service_new.dart';
import 'package:store_app_b2b/new_module/services/payloads_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';

import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class LucidController extends GetxController implements APiResponseFlow {
  final ThemeController themeController = Get.find();
  TextEditingController diagnosisSearchController = TextEditingController();
  var showSuffixFordiagnosisSearchController = false.obs;

  var lucidServices = <BasicLucidModel>[].obs;
  var islucidServicesLoading = false.obs;
  var islucidMoreServicesLoading = false.obs;
  RxInt lucidServicesPageSize = 10.obs;
  RxInt lucidServicesTotalPages = 0.obs;
  RxInt lucidServicesCurrentPage = 0.obs;

  TextEditingController scanSearchController = TextEditingController();
  var showSuffixForSearchScanController = false.obs;
  bool isTestAdded = false;

  var scanServices = <BasicLucidModel>[].obs;
  var isScanServicesLoading = false.obs;
  var isScanMoreServicesLoading = false.obs;
  RxInt scanServicesPageSize = 10.obs;
  RxInt scanServicesTotalPages = 0.obs;
  RxInt scanServicesCurrentPage = 0.obs;

  RxList<BasicLocationModel> locationList = <BasicLocationModel>[].obs;
  RxBool isLocationListLoading = false.obs;

  void clearScanDetails() {
    scanServices.clear();
    isScanServicesLoading.value = false;
    isScanMoreServicesLoading.value = false;
    scanServicesCurrentPage.value = 0;
    scanServicesTotalPages.value = 0;
  }

  void clearTestDetails() {
    lucidServices.clear();
    islucidServicesLoading.value = false;
    islucidMoreServicesLoading.value = false;
    lucidServicesCurrentPage.value = 0;
    lucidServicesTotalPages.value = 0;
  }

  Future<void> getAllLucidData({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
    String searchText = "",
    required String hc,
  }) async {
    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    if (!loadMore) clearTestDetails();
    try {
      if (finalLoadMore) {
        if (lucidServicesCurrentPage.value >= lucidServicesTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        islucidMoreServicesLoading.value = true;
        logs("said load more");
      } else {
        islucidServicesLoading.value = true;
      }

      await RestServices.instance.getRestCall<LucidListModel>(
        fromJson: (json) {
          return lucidListModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getAllLucidData(
                serviceName: searchText,
                page: lucidServicesCurrentPage.value,
                size: lucidServicesPageSize.value,
                hc: hc),
        flow: this,
        info: {
          "loadMore": finalLoadMore,
        },
        apiType: ApiTypes.getAllLucidData,
      );
    } catch (e) {
      if (finalLoadMore) {
        islucidMoreServicesLoading.value = false;
      } else {
        islucidServicesLoading.value = false;
      }
      //
      // customFailureToast(content: e.toString());
    }
  }

  void getAllLucidDataOnSuccess<T>(
      T? data, String apiType, Map<String, dynamic> info) {
    LucidListModel modelData = data as LucidListModel;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        lucidServices.addAll(modelData.data!.content!);
        islucidMoreServicesLoading.value = false;
      } else {
        lucidServices.value = modelData.data!.content!;
        islucidServicesLoading.value = false;
      }

      lucidServicesCurrentPage.value = modelData.data!.number! + 1;
      lucidServicesTotalPages.value = modelData.data!.totalPages ?? 0;

      return;
    }

    if (info["loadMore"]) {
      islucidMoreServicesLoading.value = false;
    } else {
      islucidServicesLoading.value = false;
    }
  }

  void getAllLucidDataOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    customFailureToast(content: message);
    if (info["loadMore"]) {
      islucidMoreServicesLoading.value = false;
    } else {
      islucidServicesLoading.value = false;
    }
  }

  Future<void> getlucidByDepartment({
    String endpoint = "",
    Map<String, dynamic>? retryInfo,
    bool loadMore = false,
    String searchText = "",
  }) async {
    bool finalLoadMore = endpoint.isEmpty ? loadMore : retryInfo!["loadMore"];
    if (!loadMore) clearScanDetails();
    try {
      if (finalLoadMore) {
        if (scanServicesCurrentPage.value >= scanServicesTotalPages.value) {
          return;
        }
      }

      if (finalLoadMore) {
        isScanMoreServicesLoading.value = true;
        logs("said load more");
      } else {
        isScanServicesLoading.value = true;
      }

      await RestServices.instance.getRestCall<LucidListModel>(
        fromJson: (json) {
          return lucidListModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getlucidDataByDepartment(
                serviceName: searchText,
                page: scanServicesCurrentPage.value,
                size: scanServicesPageSize.value),
        flow: this,
        info: {
          "loadMore": finalLoadMore,
        },
        apiType: ApiTypes.getLucidByDepartment,
      );
    } catch (e) {
      if (finalLoadMore) {
        isScanMoreServicesLoading.value = false;
      } else {
        isScanServicesLoading.value = false;
      }

      customFailureToast(content: e.toString());
    }
  }

  void getAllDataByDepartmentOnSuccess<T>(
      T? data, String apiType, Map<String, dynamic> info) {
    LucidListModel modelData = data as LucidListModel;

    if (modelData.data != null &&
        modelData.data!.content != null &&
        modelData.data!.content!.isNotEmpty) {
      if (info["loadMore"]) {
        scanServices.addAll(modelData.data!.content!);
        isScanMoreServicesLoading.value = false;
      } else {
        scanServices.value = modelData.data!.content!;
        isScanServicesLoading.value = false;
      }

      scanServicesCurrentPage.value = modelData.data!.number! + 1;
      scanServicesTotalPages.value = modelData.data!.totalPages ?? 0;

      return;
    }

    if (info["loadMore"]) {
      isScanMoreServicesLoading.value = false;
    } else {
      isScanServicesLoading.value = false;
    }
  }

  void getAllLucidByDepartmentOnFailure(
      String message, String apiType, Map<String, dynamic> info) {
    customFailureToast(content: message);
    if (info["loadMore"]) {
      isScanMoreServicesLoading.value = false;
    } else {
      isScanServicesLoading.value = false;
    }
  }

  RxBool isAddCartLoading = false.obs;
  Future<void> getAddTest(
      {required String serviceCd,
      required String serviceName,
      required String imageUrl,
      required num discount,
      required num finalMrp,
      required num mrpPrice,
      required String isAppointmentRequired,
      required String isHealthPackage,
      required String hv}) async {
    try {
      isAddCartLoading.value = true;
      Map<String, dynamic> map =
          Payloads().getAddTest(userId: await getUserId(), lucidTest: [
        {
          "serviceCd": serviceCd,
          "serviceName": serviceName,
          "image": imageUrl,
          "discount": discount,
          "finalMrp": finalMrp,
          "isAppointmentRequired": isAppointmentRequired,
          "hv": hv,
          'mrpPrice': mrpPrice,
          "isHealthPackage": isHealthPackage
        },
      ]);
      await RestServices.instance.postRestCall(
        body: map["body"],
        endpoint: map['url'],
        flow: this,
        apiType: ApiTypes.addTest,
      );
    } on SocketException catch (e) {
      isAddCartLoading.value = false;
      logs('Catch exception in submitLucidTest --> ${e.message}');
    }
  }

  Future<void> getAllBranches({
    String endpoint = "",
  }) async {
    try {
      isLocationListLoading.value = true;

      await RestServices.instance.getRestCall<FindLocationModel>(
        fromJson: (json) {
          return findLocationModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty ? endpoint : Payloads().getAllBranches(),
        flow: this,
        apiType: ApiTypes.getAllBranches,
      );
    } catch (e) {
      isLocationListLoading.value = false;

      customFailureToast(content: e.toString());
    }
    update();
  }

  // Future<double> requestLocationPermission(
  //     double storeLatitude, double storeLongitude) async {
  //   logs("Store lat and long-->$storeLatitude and $storeLongitude");
  //   var status = await Geolocator.checkPermission();
  //   if (status == LocationPermission.denied) {
  //     status = await Geolocator.requestPermission();
  //   }
  //   if (status == LocationPermission.deniedForever) {
  //     await Geolocator.openAppSettings();
  //     Get.snackbar('Permission Required',
  //         'Location permission is required. Please enable it in settings.');
  //     return Future.error('Location permission denied forever');
  //   }

  //   if (status == LocationPermission.whileInUse ||
  //       status == LocationPermission.always) {
  //     return getDistanceToStore(storeLatitude, storeLongitude);
  //   } else {
  //     Get.snackbar('Permission Denied',
  //         'Location permission is required to access the current location');
  //     return Future.error('Location permission denied');
  //   }
  // }

  // double _haversine(double lat1, double lon1, double lat2, double lon2) {
  //   const R = 6371;
  //   double dLat = _degToRad(lat2 - lat1);
  //   double dLon = _degToRad(lon2 - lon1);
  //   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
  //       math.cos(_degToRad(lat1)) *
  //           math.cos(_degToRad(lat2)) *
  //           math.sin(dLon / 2) *
  //           math.sin(dLon / 2);
  //   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //   return R * c;
  // }

  // double _degToRad(double deg) {
  //   return deg * (math.pi / 180);
  // }

  // Future<double> getDistanceToStore(
  //     double storeLatitude, double storeLongitude) async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     double userLatitude = position.latitude;
  //     double userLongitude = position.longitude;

  //     logs('User Latitude: $userLatitude, User Longitude: $userLongitude');

  //     return _haversine(
  //         userLatitude, userLongitude, storeLatitude, storeLongitude);
  //   } catch (e) {
  //     logs('Error getting distance: $e');
  //     return Future.error('Error getting distance: $e');
  //   }
  // }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        logs('Could not launch $launchUri');
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      logs('Error launching URL: $e');
    }
  }

  void openGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var locationListId = LocationIdModel().obs;
  RxBool isLocationListIdLoading = false.obs;
  Future<void> getFindBranchesId({
    required String branchId,
    String endpoint = "",
  }) async {
    try {
      isLocationListIdLoading.value = true;
      logs("Flow is here");
      await RestServices.instance.getRestCall<LocationIdModel>(
        fromJson: (json) {
          return locationIdModelFromJson(json);
        },
        endpoint: endpoint.isNotEmpty
            ? endpoint
            : Payloads().getfindBranch(branchId: branchId),
        flow: this,
        apiType: ApiTypes.findBranch,
      );
    } catch (e) {
      isLocationListIdLoading.value = false;

      customFailureToast(content: e.toString());
    }
    update();
  }

  @override
  void onFailure(String message, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllLucidData) {
      getAllLucidDataOnFailure(message, apiType, info);
    }

    if (apiType == ApiTypes.addTest) {
      isAddCartLoading.value = false;
      customFailureToast(content: message);
    }

    if (apiType == ApiTypes.getLucidByDepartment) {
      getAllLucidByDepartmentOnFailure(message, apiType, info);
    }
    if (apiType == ApiTypes.getAllBranches) {
      customFailureToast(content: message);
      isLocationListLoading.value = false;
    }
  }

  @override
  void onSuccess<T>(T? data, String apiType, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllLucidData) {
      getAllLucidDataOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.getLucidByDepartment) {
      getAllDataByDepartmentOnSuccess(data, apiType, info);
    }

    if (apiType == ApiTypes.addTest) {
      Map<String, dynamic> response = data as Map<String, dynamic>;
      if (response["status"] == true) {
        logs("response body -->${response["body"]}");

        isAddCartLoading.value = false;
      } else {
        isAddCartLoading.value = false;

        customFailureToast(content: "Test already exist");
      }
    }
    if (apiType == ApiTypes.findBranch) {
      LocationIdModel modelData = data as LocationIdModel;
      if (modelData.data != null) {
        locationListId.value = data as LocationIdModel;
        isLocationListIdLoading.value = false;
      }
    }

    if (apiType == ApiTypes.getAllBranches) {
      FindLocationModel modelData = data as FindLocationModel;

      if (modelData.data != null && modelData.data!.isNotEmpty) {
        locationList.value = modelData.data!;
        locationList.value = modelData.data!;
      }
      isLocationListLoading.value = false;
    }
  }

  @override
  void onTokenExpired(
      String apiType, String endPoint, Map<String, dynamic> info) {
    if (apiType == ApiTypes.getAllLucidData) {
      getAllLucidData(endpoint: endPoint, retryInfo: info, hc: "");
    }

    if (apiType == ApiTypes.getAllBranches) {
      getAllBranches(
        endpoint: endPoint,
      );
    }
  }
}
