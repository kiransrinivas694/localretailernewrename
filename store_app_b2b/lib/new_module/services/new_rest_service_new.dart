import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/new_module/services/new_apiresponse_new.dart';
import 'package:store_app_b2b/new_module/services/new_encryption_service_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';

class MysaaApi {
  static String baseUrl = "https://devapi.mysaa.life"; // local
}

class RestConstants {
  RestConstants._privateConstructor();

  static final RestConstants instance = RestConstants._privateConstructor();

  //     ======================= API baseurl =======================     //
  // String baseUrl = 'https://devapi.mysaa.life';
  // String baseUrl = 'http://137.59.201.109:8100';
  String androidAppVersion = 'http://devapi.thelocal.co.in';
  String iosAppVersion = 'http://devapi.thelocal.co.in';

  //     ======================= API type =======================     //
  final String getLucidUserUpcomingStatus =
      "getUpcommingLucidPatientByUserIdAndStatus";
  final String api = "api/";
  final String apiAuthentication = 'api-auth/';
  final String apiProduct = 'api-product/';
  final String apiBanner = 'api-banner/';
  final String apiCart = 'api-cart/';
  final String apiCheckout = 'api-checkout/';
  final String apiOMS = 'api-oms/';
  final String apiOfm = 'api-ofm/';
  final String apiReview = 'api-review/';
  final String apiLucidService = 'api-lucidService/';
  final String apingo = 'api-ngo/';
  final String apiLucidCart = 'api-lucidCart/';
  final String apiAchivers = 'api-achivers/';

  //     ======================= API EndPoints =======================     //
  final String sendOtp = 'v1/send/otp';
  final String verifyOtp = "v1/verify/otp";
  final String signup = "v1/user/mobile/signUp";
  final String referralCheck = "v1/verifyReferralCode";
  final String sendLoginOtp = "v1/mobileLogin";
  final String verifyLoginOtp = "v1/verify/otp";
  final String getAllCategories = 'storeCategory/store/AL-S202309-756';
  final String getNewlyLaunchedProducts = 'v1/mobilehome/newproducts';
  final String getRecentViewedProducts = "v1/recent-view-product/userId";
  final String getMedOrdersList = "v1/user";
  final String getRequestList = "v1/doctor-requests/userId";
  final String getCategoryWiseProducts = 'v1/product/all';
  final String getReviewById = 'v1/review/type';
  final String getAllBranches = 'v1/getAllBranches/branchNameSearch';
  final String getTopSellingProducts = 'v1/mobilehome/topselling';
  final String getAllSpecialisation = 'v1/specializations/all';
  final String getAllDoctors = 'v1/doctor/profiles';
  final String getAllLucidData = 'v1/getAll/lucidData';
  final String cartAdditionNearProduct = "v1/cart/items/user";
  final String cartAdditionUpdateNearProduct = "v1/cart/quantity";
  final String getAppWideCart = "v1/cart/user";
  final String getUSerCart = "v1/cart/user";
  final String getMedOrderDetail = "v1/user";
  final String getRequestDetail = "v1/doctor-requests/byId";
  final String findBranch = 'v1/findBranch';
  final String getProductDetails = "v1/product";
  final String getAppointmentDetails = "v1/bookAppointment";
  final String getHomeBanners = "v1/banners/mobile/row";
  final String getLucidOrderById = "getLucidOrder";
  final String getAllNgoId = 'v1/all';
  final String appointmentHistory = 'v1/users/appointHistory/userId';
  final String getBeforeCheckout = "v1/before/checkout";
  final String uploadPrescription = "v1/cart/updPresc/cart";
  final String saveRecentView = "v1/save-recent-view";
  final String getTopAllDoctors = 'v1/doctorProfile/topDoctor';
  final String getDoctorDetailsById = 'v1/doctors/getDoctorProfile';
  final String continuewWithoutPrescription = 'v1/cart';
  final String deletePrescription = "v1/cart/deletePresc/cart";
  final String getAfterCheckout = "v1/checkout";
  final String getAllAddress = "v1/getAllAddress";
  final String getAddAddress = "v1/address";
  final String postDoctorAppointment = "v1/doctor/bookAppointment";
  final String addTest = 'addTest';
  final String getByNgoId = 'v1/byId';
  final String getAllHealthPackages = 'getAllHealthPackages';
  final String saveLucidPatient = 'saveLucidPatient';
  final String getAllTests = 'getAllTests';
  final String bookingOverview = 'v1/bookAppointment';
  final String deleteTest = 'deleteTest';
  final String postReview = "v1/review";
  final String deleteMedicineCart = "v1/cart";
  final String cancelOrReschedule = 'cancelOrReschedule';
  final String getAllAchievers = 'v1/getAll-achievers';
  final String getByAchieverId = "v1/get-acheiver-ById";
  final String getlucidByDepartment = "v1/get/lucidDataByDepartment";
  final String deleteCart = 'deleteCart';
  final String prescriptionUpload = 'v1/doctor-requests/save';
  final String getVideosList = 'video/v1/getAll';
  final String getByDiseaseId = 'v1/geAll-acheivers-ByDiseaseId';
  final String rebookTest = "reBookAppointment/id";
  final String getPackagedetails = 'getHealthPackage/id/';
  final String getHealthPackage = 'getHealthPackage/serviceCd/';
  final String getRelationList = 'v1/myrelations';
  final String getTestPatientDetails = "getLucidPatient/";
  final String lucidOrderCheckout = "lucidOrderCheckout";
}

class RestServices {
  RestServices._privateConstructor();

  static final RestServices instance = RestServices._privateConstructor();

  Map<String, String> headers = {};

  void showRequestAndResponseLogs(
      http.Response? response, Map<String, Object> requestData) {
    logs('•••••••••• Network logs ••••••••••');
    logs('Request code --> ${response!.statusCode} : ${response.request!.url}');
    logs('Request headers --> $requestData');
    logs('Response headers --> ${response.headers}');
    logs('Response body --> ${response.body}');
    logs('••••••••••••••••••••••••••••••••••');
  }

  // Future<String?> getUserId() async => await SharedPrefService.instance
  // .getPrefStringValue(SharedPrefService.instance.logInId);

  // need to try out how it works.
  Future<void> getRestCall<T>(
      {required String? endpoint,
      String? addOns,
      bool decryptionNeeded = false,
      bool tokenCheckNeed = true,
      String? apiType,
      Map<String, dynamic>? info,
      APiResponseFlow? flow,
      required T Function(String) fromJson}) async {
    info ??= {};
    // bool connected =
    //     await ConnectivityService.instance.isConnectNetworkWithMessage();
    // if (!connected) {
    //   flow!.onFailure("No Internet Connection", apiType!, info);
    // }
    try {
      String requestUrl = addOns != null
          ? '${MysaaApi.baseUrl}/$endpoint$addOns'
          : '${MysaaApi.baseUrl}/$endpoint';

      logs("log url - $requestUrl");
      Uri? requestedUri = Uri.tryParse(requestUrl);
      headers['Content-Type'] = 'application/json';

      http.Response response = await http.get(requestedUri!, headers: headers);

      showRequestAndResponseLogs(response, headers);

      logs("printing response status - ${response.statusCode}");

      switch (response.statusCode) {
        case 200:
        case 201:
        case 400:
        case 401:
        case 422:
          Map<String, dynamic> responseMap = jsonDecode(response.body);

          if (responseMap.containsKey("status") && responseMap["status"]) {
            dynamic data = responseMap["data"];

            T? responseData;

            if (decryptionNeeded) {
              String decryptedData =
                  EncryptionService.instance.decryptString(data);
              responseData = fromJson(decryptedData);
            } else {
              logs(response.body);

              responseData = fromJson(response.body);
            }
            logs("the resposeDAta is--->$responseData");
            flow!.onSuccess(responseData, apiType!, info);
          } else if (responseMap.containsKey('token') &&
              responseMap["token"] != null &&
              responseMap['token'].toString().isNotEmpty) {
            flow!.onTokenExpired(apiType!, endpoint!, info);
          } else {
            flow!.onFailure(responseMap['message'], apiType!, info);
          }
          break;
        case 404:
        case 502:
        case 503:
        case 500:
          logs('${response.statusCode}');
          flow!.onFailure(
              "We're having some trouble processing your request. Please try again shortly.",
              apiType!,
              info);
          break;

        default:
          logs('failure -> ${response.statusCode} : ${response.body}');

          // customFailureToast(content: "Something went wrong");
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in getRestCall --> ${e.message}');
    } on SocketException catch (e) {
      logs('Catch exception in getSubCategoriesList --> ${e.message}');
    }
  }

  Future<void> postRestCall({
    required String? endpoint,
    String? addOns,
    String? apiType,
    APiResponseFlow? flow,
    required dynamic body,
    Map<String, dynamic>? info,
  }) async {
    info ??= {};
    // bool connected =
    //     await ConnectivityService.instance.isConnectNetworkWithMessage();
    // if (!connected) {
    //   flow!.onFailure("No Internet Connection", apiType!, info);
    // }

    try {
      String requestUrl = addOns != null
          ? '${MysaaApi.baseUrl}/$endpoint$addOns'
          : '${MysaaApi.baseUrl}/$endpoint';
      Uri? requestedUri = Uri.tryParse(requestUrl);
      log('Body map --> ${jsonEncode(body)}');
      log(requestUrl);
      headers['content-type'] = 'application/json';
      log(jsonEncode(body));

      Response response = await http.post(requestedUri!,
          body: jsonEncode(body), headers: headers);

      showRequestAndResponseLogs(response, headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          flow!.onSuccess(jsonDecode(response.body), apiType ?? "", info);
          break;
        case 404:
        case 502:
        case 503:
        case 500:
          logs('${response.statusCode}');
          flow!.onFailure(
              "We're having some trouble processing your request. Please try again shortly.",
              apiType!,
              info);

          break;
        case 400:
        case 401:
          logs('${response.statusCode}');
          flow!.onFailure('${response.statusCode} error', apiType!, info);
          break;
        case 403:
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in postRestCall --> ${e.message}');
    }
  }

  Future<void> deleteRestCall({
    required String? endpoint,
    String? addOns,
    String? apiType,
    APiResponseFlow? flow,
    required dynamic body,
    Map<String, dynamic>? info,
  }) async {
    info ??= {};
    // bool connected =
    //     await ConnectivityService.instance.isConnectNetworkWithMessage();
    // if (!connected) {
    //   flow!.onFailure("No Internet Connection", apiType!, info);
    // }

    try {
      String requestUrl = addOns != null
          ? '${MysaaApi.baseUrl}/$endpoint$addOns'
          : '${MysaaApi.baseUrl}/$endpoint';
      Uri? requestedUri = Uri.tryParse(requestUrl);
      log('Body map --> ${jsonEncode(body)}');
      headers['content-type'] = 'application/json';

      Response response = await http.delete(requestedUri!,
          body: jsonEncode(body), headers: headers);

      showRequestAndResponseLogs(response, headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          flow!.onSuccess(jsonDecode(response.body), apiType ?? "", info);
          break;
        case 404:
        case 502:
        case 503:
        case 500:
          logs('${response.statusCode}');
          flow!.onFailure(
              "We're having some trouble processing your request. Please try again shortly.",
              apiType!,
              info);
          break;
        case 400:
        case 401:
          logs('${response.statusCode}');
          flow!.onFailure('${response.statusCode} error', apiType!, info);
          break;
        case 403:
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in postRestCall --> ${e.message}');
    }
  }

  Future<void> putRestCall({
    required String? endpoint,
    String? addOns,
    String? apiType,
    APiResponseFlow? flow,
    required dynamic body,
    Map<String, dynamic>? info,
  }) async {
    info ??= {};
    // bool connected =
    //     await ConnectivityService.instance.isConnectNetworkWithMessage();
    // if (!connected) {
    //   flow!.onFailure("No Internet Connection", apiType!, info);
    // }

    try {
      String requestUrl = addOns != null
          ? '${MysaaApi.baseUrl}/$endpoint$addOns'
          : '${MysaaApi.baseUrl}/$endpoint';
      Uri? requestedUri = Uri.tryParse(requestUrl);
      log('Body map --> ${jsonEncode(body)}');
      headers['content-type'] = 'application/json';

      Response response = await http.put(requestedUri!,
          body: jsonEncode(body), headers: headers);

      showRequestAndResponseLogs(response, headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          flow!.onSuccess(jsonDecode(response.body), apiType ?? "", info);
          break;
        case 404:
        case 502:
        case 503:
        case 500:
          logs('${response.statusCode}');
          flow!.onFailure(
              "We're having some trouble processing your request. Please try again shortly.",
              apiType!,
              info);
          break;
        case 400:
        case 401:
          logs('${response.statusCode}');
          flow!.onFailure('${response.statusCode} error', apiType!, info);
          break;
        case 403:
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in postRestCall --> ${e.message}');
    }
  }

  Future<String?>? multiPartRestCall(
      {required String? endpoint,
      required Map<String, String>? body,
      String? keyName,
      String? filePath}) async {
    String? responseData;
    // bool connected =
    //     await ConnectivityService.instance.isConnectNetworkWithMessage();
    // if (!connected) {
    //   return responseData;
    // }
    try {
      String requestUrl = '${MysaaApi.baseUrl}/$endpoint';
      Uri? requestedUri = Uri.tryParse(requestUrl);
      MultipartRequest request = http.MultipartRequest('POST', requestedUri!);
      headers['Content-Type'] = 'multipart/form-data';
      request.headers.addAll(headers);
      if (body!.isNotEmpty) {
        request.fields.addAll(body);
      }
      if (keyName != null && filePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            keyName,
            filePath,

            /// todo contentType: MediaType.parse('image/jpeg'),
          ),
        );
      }
      StreamedResponse responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      showRequestAndResponseLogs(response, request.headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 500:
          responseData = response.body;
          break;
        case 502:
        case 400:
        case 401:
        case 404:
          logs('${response.statusCode}');
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in multiPartRestCall --> ${e.message}');
    }
    return responseData;
  }
}
