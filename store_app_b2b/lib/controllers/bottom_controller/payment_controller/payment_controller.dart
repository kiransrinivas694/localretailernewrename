import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/account_status_model.dart';
import 'package:store_app_b2b/model/order_details_model.dart';
import 'package:store_app_b2b/model/payment_history_by_order_model.dart';
import 'package:store_app_b2b/model/payment_overview_model.dart';
import 'package:store_app_b2b/model/payment_request_model.dart';
import 'package:store_app_b2b/model/store_credit_rating_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_loading_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_placed_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PaymentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isLoading = false.obs;
  late TabController controller;
  late Razorpay razorpay;

  OrderDetailsModel? ordersContent;

  final searchAllController = TextEditingController().obs;

  /// Payment Request
  final searchRequestController = TextEditingController().obs;
  final amountEnterController = TextEditingController().obs;
  final List<PaymentRequestOrderContent> paymentRequestList =
      <PaymentRequestOrderContent>[].obs;
  final paymentRequestCurrentPage = 0.obs;
  final paymentRequestTotalPage = 0.obs;
  PaymentRequestOrderContent? selectItem;

  ///Payment history by order
  PaymentHistoryByOrderModel paymentHistoryByOrderModel =
      PaymentHistoryByOrderModel();

  /// Fully Paid
  final List<PaymentRequestOrderContent> fullyPaidList =
      <PaymentRequestOrderContent>[].obs;
  final fullyPaidCurrentPage = 0.obs;
  final fullyPaidTotalPage = 0.obs;

  List<PaymentOverviewModel> paymentOverview = [];
  bool isOverviewLoading = false;

  AccountStatusModel? storeCreditRating;
  // StoreCreditRatingModel? storeCreditRating;
  var storeCreditLoading = false.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    controller = TabController(vsync: this, length: 3);
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  getStoreCreditRatingPresent() async {
    String storeId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (storeId.isNotEmpty) {
      storeCreditLoading.value = true;
      storeCreditRating = null;
      update();
      print("calling inside getAccountStatus");
      try {
        String url =
            '${API.getAccountStatus}/${storeId}?supplierId=$supplierId';

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        print('account status url ---> $url');
        final response = await http.get(Uri.parse(url), headers: headers);
        print('account status response ---> ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          storeCreditRating = accountStatusModelFromJson(response.body);

          update();
        } else {
          CommonSnackBar.showError(
              'We are experiencing a temporary setback , please bear with us.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }

      storeCreditLoading.value = false;

      update();
    } else if (!Get.isDialogOpen!) {
      // Get.dialog(const LoginDialog(
      //   message: "getAccountStatus",
      // ));
    }
  }

  // getStoreCreditRating() async {
  //   String storeId =
  //       await SharPreferences.getString(SharPreferences.loginId) ?? '';
  //   if (storeId.isNotEmpty) {
  //     // storeCreditLoading.value = true;
  //     storeCreditLoading.value = true;
  //     storeCreditRating = null;
  //     update();
  //     print("calling inside getStoreCreditRating");
  //     try {
  //       String url = '${API.getStoreCreditRating}/${storeId}';
  //       print('getStoreCreditRating url ---> $url');
  //       final response = await http.get(Uri.parse(url));
  //       print(
  //           'getStoreCreditRating response ---> ${response.body} ${response.statusCode}');
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         Map<String, dynamic> responseMap = jsonDecode(response.body);

  //         print(
  //             'response map - ${responseMap} ${responseMap['retailerResponse']} ${responseMap.containsKey("retailerResponse") && responseMap['retailerResponse'] == null}');

  //         if (responseMap.containsKey("retailerResponse") &&
  //             responseMap['retailerResponse'] == "null") {
  //           print('entered null');
  //           storeCreditRating = null;
  //         } else {
  //           storeCreditRating = storeCreditRatingModelFromJson(response.body);
  //           print('entered non null');
  //         }

  //         print('successsssssss');

  //         // Map<String, dynamic> demoChartData = {
  //         //   "maxY": 0, // has to be int or double
  //         //   "minY":
  //         //       storeCreditRating!.totalOrderAmount, // has to be int or double
  //         //   "width":
  //         //       10, //has to be double or int or can be null. if null 10 width will be taken for bars.
  //         //   "data": [
  //         //     {
  //         //       "xAxisName": "Order Amount", // has to be string,
  //         //       "data": storeCreditRating!.totalOrderAmount
  //         //     },
  //         //     {
  //         //       "xAxisName": "Paid Amount", // has to be string
  //         //       "data": storeCreditRating!
  //         //           .totalPaidAmount // has to be int or double,
  //         //     },
  //         //     {
  //         //       "xAxisName": "Balance Amount", // has to be string
  //         //       "data":
  //         //           storeCreditRating!.totalBalance // has to be int or double,
  //         //     },
  //         //   ]
  //         // };
  //         update();
  //       } else {
  //         CommonSnackBar.showError(
  //             'We are experiencing a temporary setback , please bear with us.');
  //       }
  //     } on SocketException catch (e) {
  //       CommonSnackBar.showError(e.message.toString());
  //     }

  //     storeCreditLoading.value = false;

  //     // storeCreditLoading.value = false;
  //     update();
  //   } else if (!Get.isDialogOpen!) {
  //     // Get.dialog(const LoginDialog(
  //     //   message: "getAccountStatus",
  //     // ));
  //   }
  // }

  /// ToDo : Payment request
  Future<void> getPaymentRequestDataApi(
      {String? searchQuery, bool callingFromDashboard = false}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
      try {
        isLoading.value = true;
        String requestUrl =
            '${API.getPaymentRequest}/$userId?page=$paymentRequestCurrentPage&size=100';
        if (searchQuery != null) {
          requestUrl =
              '${API.getPaymentRequest}/$userId?invoiceId=${searchQuery}&page=$paymentRequestCurrentPage&size=100';
          ;
        }
        logs('get payment Request Url --> $requestUrl');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(requestUrl),
          headers: headers,
        );
        log('payment request response ---> ${response.body}');
        if (response.statusCode == 200) {
          paymentRequestList.clear();
          PaymentRequestModel paymentRequestModel =
              paymentRequestModelFromJson(response.body);
          paymentRequestList.addAll(paymentRequestModel.content);
          isLoading.value = false;
          if (paymentRequestCurrentPage.value == 0) {
            paymentRequestTotalPage.value =
                (paymentRequestModel.totalPages ?? 0).toInt();
          }
        } else {
          isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
    } else if (!Get.isDialogOpen!) {
      if (!callingFromDashboard) {
        Get.dialog(const LoginDialog());
      }
    }
  }

  //Total payment overview
  Future<void> getPaymentOverview() async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (userId.isNotEmpty) {
      try {
        paymentOverview.clear();
        isOverviewLoading = true;
        update();
        String requestUrl =
            '${API.getPaymentOverview}$supplierId&payerId=$userId';

        requestUrl = '$requestUrl';

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        logs('getPaymentOverview Url --> $requestUrl');
        final response = await http.get(
          Uri.parse(requestUrl),
          headers: headers,
        );
        log('getPaymentOverview response ---> ${response.body}');
        if (response.statusCode == 200) {
          paymentOverview.add(paymentOverviewModelFromJson(response.body));
        } else {
          // isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
    } else if (!Get.isDialogOpen!) {}
    isOverviewLoading = false;
    update();
  }

  /// ToDo : Fully Paid
  Future<void> getFullyPaidDataApi({String? searchQuery}) async {
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
      try {
        isLoading.value = true;
        update();
        String requestUrl =
            '${API.getFullyPaid}/$userId?page=$fullyPaidCurrentPage&size=100';
        if (searchQuery != null && searchQuery != "") {
          requestUrl =
              '${API.getFullyPaid}/$userId?invoiceId=${searchQuery}&page=$fullyPaidCurrentPage&size=100';
        }
        logs('getFullyPaidDataApi Request Url --> $requestUrl');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(
          Uri.parse(requestUrl),
          headers: headers,
        );

        if (response.statusCode == 200) {
          fullyPaidList.clear();
          PaymentRequestModel paymentRequestModel =
              paymentRequestModelFromJson(response.body);
          fullyPaidList.addAll(paymentRequestModel.content);
          if (fullyPaidCurrentPage.value == 0) {
            fullyPaidTotalPage.value =
                (paymentRequestModel.totalPages ?? 0).toInt();
          }
          isLoading.value = false;
        } else {
          isLoading.value = false;
          CommonSnackBar.showError('Something went wrong.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> getPaymentHistoryByOrder(
      {required String orderId,
      required String storeId,
      required String payerId}) async {
    isLoading.value = true;
    try {
      String url =
          "${API.getPaymentHistoryByOrder}/$payerId/storeId/$storeId/order/$orderId/details";
      logs('getPaymentHistoryByOrder url ---> $url');

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(Uri.parse(url), headers: headers);
      logs('getPaymentHistoryByOrder response ---> ${response.body}');
      if (response.statusCode == 200) {
        paymentHistoryByOrderModel =
            paymentHistoryByOrderModelFromJson(response.body);
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    }
    isLoading.value = false;
  }

  Future<dynamic> getPaymentSuccessDataApi(
      Map<String, dynamic> bodyParse) async {
    print("object+++++");
    try {
      isLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(Uri.parse(API.getPaymentSuccess),
          headers: headers, body: jsonEncode(bodyParse));

      print(
          "printing response url in getPaymentSuccessDataApi ${API.getPaymentSuccess}");

      if (response.statusCode == 200) {
        print(">>>>>>>>${jsonDecode(response.body)}");
        isLoading.value = false;
        return jsonDecode(response.body);
      } else {
        isLoading.value = false;
        CommonSnackBar.showError('Something went wrong.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getOrderDetails({required String orderId}) async {
    // isLoading = true;
    update();
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (userId.isNotEmpty) {
      try {
        logs('UserID --> $userId');
        String url = '${API.getOrderDetails}/$userId/order/$orderId';

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        logs('Url --> $url');
        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          logs('getOrderDetails Response --> ${response.body}');
          ordersContent = orderDetailsModelFromJson(response.body);
        } else {
          ordersContent = null;
        }
      } on SocketException catch (e) {
        logs('Catch exception in getOrderDetails --> ${e.message}');
        CommonSnackBar.showError(e.message);
      }
      // isLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> getRazorPayDataApi(num amount, String? orderId, Key) async {
    return openCheckout(amount, orderId, Key);
    // Get.to(() => const PaymentPlacedScreen());
  }

  void openCheckout(num price, String? orderId, Key) async {
    // var options = {
    //   'key': Key,
    //   'amount': price,
    //   // 'name': 'Acme Corp.',
    //   // 'description': 'Fine T-Shirt',
    //   'name': 'Acintyo Retailer Buy',
    //   'order_id': orderId,
    //   'external': {
    //     'wallets': ['paytm']
    //   },
    //   // 'retry': {'enabled': true, 'max_count': 1},
    //   'send_sms_hash': true,
    //   // "image": "https://www.belliza.in/public/assets/images/favicon.ico",
    //   'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
    //   'theme': {'color': "#F54567"}
    // };

    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String storeName =
        await SharPreferences.getString(SharPreferences.storeName) ?? '';

    final PackageInfo info = await PackageInfo.fromPlatform();

    var options = {
      'key': Key,
      'amount': price * 100,
      "id": orderId,

      // 'order_id': selectItem['orderId'],
      'name': 'Acintyo Retailer Buy',
      'description': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      // 'prefill': {'contact': '$orderId', 'email': '$orderId'},
      'external': {
        'wallets': ['paytm']
      },
      "notes": {
        "order_id": orderId,
        "store_name": storeName,
        "store_id": userId,
        "app_name": info.appName,
        "app_id": info.packageName,
      }
    };

    print("printing opencheckout pay now options ---> $options");

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Success Response orderId:- ${response.orderId}');
    print('Success Response paymentId:- ${response.paymentId}');
    print('Success Response signature:- ${response.signature}');
    print('Success Response subject:- ${response.obs.subject.stream}');

    print("====razor pay response $response");

    print(
        "printing amount in controller ---> ${amountEnterController.value.text.trim()}");

    Map<String, dynamic> bodyParams = {
      "orderId": selectItem?.orderId ?? "",
      "orderAmount": num.parse(amountEnterController.value.text.trim()),
      "paymentId": response.paymentId.toString(),
      "paidDate":
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
      "paidAmount": num.parse(amountEnterController.value.text.trim()),
      "billedAmount": selectItem?.billedAmount ?? "",
      "storeId": selectItem?.storeId ?? "",
      "trasactionStatus": "$response",
      "payerId": selectItem?.payerId ?? "",
      "paymentMode": "Online",
      "paymentType": "CR"
    };

    print("printing payment checkout body -> ${jsonEncode(bodyParams)}");

    Get.to(() => PaymentLoadingScreen(
          orderBody: bodyParams,
        ));

    print("printing payment checkout body -> $bodyParams");
    print("printing after route to loading screen is done");
    // await getPaymentSuccessDataApi(bodyParams).then((value) async {
    //   print("value>>>>>>$value");
    //   if (value['status'] == true) {
    //     // await getPaymentRequestDataApi();
    //     Get.to(() => PaymentPlacedScreen());
    //     // Future.delayed(
    //     //   Duration(seconds: 10),
    //     //   () {
    //     //     Get.to(() => PaymentPlacedScreen());
    //     //   },
    //     // );
    //   }
    // });
    // paymentController.verifyOrderDataApi(bodyParamsVerify, response.signature.toString()).then((verify) async {
    //   if (verify['success'] == "true") {
    //     final dbOrder = await DBOrderHelper.database();
    //     await dbOrder.rawQuery('DELETE FROM OrderCart');
    //     showAlertDialog(response.orderId);
    //   }
    // });
    //   //   }
    //   // });
    // });

    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }
}
