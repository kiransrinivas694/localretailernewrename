import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/model/account_status_model.dart';
import 'package:store_app_b2b/model/latest_order_response_model.dart';
import 'package:store_app_b2b/model/network_retailer/store_profile_response_model/store_profile_response_model.dart';
import 'package:store_app_b2b/model/store_credit_rating_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_loading_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_placed_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:store_app_b2b/model/store_category_model.dart';

class StoreController extends GetxController {
  //for outstanding payment
  late Razorpay razorpay;
  //above is for outstanding payment

  // final controller = Get.find<HomeController>();
  final isLoading = false.obs;
  final isCreditLimitLoading = false.obs;
  List bannerTopList = [].obs;
  final bannerBottomImageList = [].obs;
  final videoControllerList = [].obs;
  final bannerVideoControllerList = [].obs;
  RxList<LatestOrderResponseModel> latestOrderResponseModel =
      <LatestOrderResponseModel>[].obs;

  final outstandingAmountEnterController = TextEditingController().obs;

  List<StoreCategoryModel> storeCategoryList = [];
  final isStoreCategoriesLoading = false.obs;
  final isMedicalCategoryPresent = false.obs;
  final storeCategoryReminder = 0.obs;

  String timeFormate(String time) {
    DateTime parsedTime = DateFormat('H:m').parse(time);
    String parse = DateFormat('h:mm a').format(parsedTime);
    return parse;
  }

  List<Map<String, dynamic>> secondStoreList = [
    // {"icon": "assets/icons/order_history.png", "title": "Invoice History"},

    {"icon": "assets/icons/product-expired.png", "title": "Expiry Products"},
    {"icon": "assets/icons/returngrb.png", "title": "GRB"},
    //  {"icon": "assets/icons/notification.png", "title": "Notification"},
    {"icon": "assets/icons/grb.png", "title": " GRB History"},
    {"icon": "assets/icons/order_history.png", "title": "Invoice History"},
    // {"icon": "assets/icons/credit_note.png", "title": "Credit Note"},

    // {"icon": "assets/icons/supplier.png", "title": "Suppliers"},
    // {"icon": "assets/icons/inventory.png", "title": "Inventory"},
  ];

  List<Map<String, dynamic>> thirdStoreList = [
    // {"icon": "assets/icons/order_history.png", "title": "Invoice History"},
    // {"icon": "assets/icons/returngrb.png", "title": "GRB"},
    // {"icon": "assets/icons/notification.png", "title": "Notification"},
    // {"icon": "assets/icons/grb.png", "title": " GRB History"},
    {"icon": "assets/icons/credit_note.png", "title": "Credit Note"},

    {"icon": "assets/icons/entry_amount.png", "title": "Clearing\n Status"},
    // {"icon": "assets/icons/inventory.png", "title": "Inventory"},
  ];
  List<Map<String, dynamic>> firstStoreList = [
    {"icon": "assets/icons/buy.png", "title": "Buy Products"},
    // {"icon": "assets/icons/unlisted.png", "title": "Unlisted"},
  ];

  List<Map<String, dynamic>> buyProductList = [
    // {"icon": "assets/icons/buy_medicines_col.png", "title": "Medicines"},
    // {
    //   "icon": "assets/icons/generic_medicines_col.png",
    //   "title": "Generic Medicines"
    // },
    // {
    //   "icon": "assets/icons/speciality_col.png",
    //   "title": "Speciality Medicines"
    // },
    {"icon": "assets/icons/lucid_logo.png", "title": "Diagnostic"},
    {"icon": "assets/icons/med_doc.png", "title": "Doctor\nAppointments"},
    {"icon": "assets/icons/order_status_icon.png", "title": "Later\nDelivery"},
    {
      "icon": "assets/icons/unlisted_products_col.png",
      "title": "Unlisted Products"
    },
    // {"icon": "assets/icons/company_wise.png", "title": "Entry Amount"},
    {"icon": "assets/icons/entry_amount.png", "title": "Payment Clearing"},

    {"icon": "assets/icons/quick_delivery.png", "title": "Quick Delivery"},
    {
      "icon": "assets/icons/network_retailer_inactive.png",
      "title": "Network Retailer"
    },
    {
      "icon": "assets/icons/hospital_sales.png",
      "title": "Institutional/Hospital Sales"
    },
  ];
  AccountStatusModel accountStatusModel = AccountStatusModel();
  StoreCreditRatingModel? storeCreditRating;

  @override
  Future<void> onInit() async {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // getVideoBannerTopDataApi();
    // getBannerBottomImageDataApi();
    // getAccountStatus();
    // getLatestOrderApi();
    // getStoreCategories();
    print("print check init in onit store controller");
    super.onInit();
  }

  //outstanding payments tasks starts hereFuture<dynamic> getRazorPayDataApi(num amount, String? orderId, Key) async {
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
      'description': 'outstanding',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      },
      "notes": {
        "order_id": "outstanding",
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
        "printing amount in controller ---> ${outstandingAmountEnterController.value.text.trim()}");
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    Map<String, dynamic> bodyParams = {
      "orderId": response.paymentId,
      "orderAmount":
          num.parse(outstandingAmountEnterController.value.text.trim()),
      "paymentId": response.paymentId.toString(),
      "paidDate":
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
      "paidAmount":
          num.parse(outstandingAmountEnterController.value.text.trim()),
      "billedAmount": outstandingAmountEnterController.value.text,
      "storeId": supplierId,
      "trasactionStatus": "$response",
      "payerId": userId,
      "paymentMode": "Online",
      "paymentType": "CR"
    };

    // Get.to(() => PaymentLoadingScreen(
    //       orderBody: bodyParams,
    //     ));

    print("printing custom payment checkout body -> $bodyParams");
    print("printing after route to loading screen is done");
    await getCustomPaymentSuccessDataApi(bodyParams).then((value) async {
      print("custom payment value>>>>>>$value");
      if (value != null && value['status'] != null && value['status'] == true) {
        // await getPaymentRequestDataApi();
        getAccountStatus();
        Get.to(() => PaymentPlacedScreen());
        // Future.delayed(
        //   Duration(seconds: 10),
        //   () {
        //     Get.to(() => PaymentPlacedScreen());
        //   },
        // );
      }
    });
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

  Future<dynamic> getCustomPaymentSuccessDataApi(
      Map<String, dynamic> bodyParse) async {
    print("object+++++");
    try {
      print(
          "printing response url in getCustomPaymentSuccessDataApi ${API.getPaymentSuccessCustom}");

      print(
          "printing response jsonencode in getCustomPaymentSuccessDataApi ${jsonEncode(bodyParse)}");
      isLoading.value = true;

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.post(Uri.parse(API.getPaymentSuccessCustom),
          headers: headers, body: jsonEncode(bodyParse));
      print(
          "printing response url in getCustomPaymentSuccessDataApi ${API.getPaymentSuccessCustom}");
      print(
          "printing response in getCustomPaymentSuccessDataApi - $response , ${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        print(">>>>>>>>${jsonDecode(response.body)}");
        isLoading.value = false;
        return jsonDecode(response.body);
      } else {
        isLoading.value = false;
        CommonSnackBar.showError('Something went wrong in custompayment.');
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      debugPrint(e.toString());
    }
  }
  //outstanding payment tasks ends here

  getStoreCategories() async {
    // print("printing -- printing planTure --> $planTenure");
    String userId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';

    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';

    print("print check init in getStreCategories -> $userId");
    if (userId.isNotEmpty) {
      try {
        storeCategoryList.clear();
        isStoreCategoriesLoading.value = true;
        update();

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        String url = "${API.storeCategory}/$supplierId";
        print(
            "printing -- getStoreCategories url in getStoreCategories---> $url");
        final response = await http.get(Uri.parse(url), headers: headers);
        var responseBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          // businessCategoryList = businessCategoryModelFromJson(response.body);
          print("getStoreCategories response ---> $responseBody");

          for (Map plan in responseBody) {
            print("printing each plan ---> $plan");
            if (plan["medicalCategory"] == "Y") {
              isMedicalCategoryPresent.value = true;
            }
            StoreCategoryModel storeCategoryModel =
                storeCategoryModelFromJson(jsonEncode(plan));

            storeCategoryList.add(storeCategoryModel);
          }

          // for (int i = 0; i < responseBody.length; i++) {
          //   Map<String, dynamic> plan = responseBody[i];

          //   print("printing each plan ---> $plan");

          //   if (plan["medicalCategory"] == "Y") {
          //     isMedicalCategoryPresent.value = true;
          //   }

          //   StoreCategoryModel storeCategoryModel =
          //       storeCategoryModelFromJson(jsonEncode(plan));
          //   // if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5) {
          //   //   storeCategoryList.add(storeCategoryModel);
          //   // }
          //   // if (i == 0
          //   // || i == 1
          //   // || i == 2
          //   // || i == 3 || i == 4 || i == 5
          //   //     ) {
          //   //   storeCategoryList.add(storeCategoryModel);
          //   // }

          //   // if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5) {
          //   storeCategoryList.add(storeCategoryModel);
          //   // }
          // }

          storeCategoryReminder.value = (storeCategoryList.length) % 4;

          print(
              "printing reminder of storeCategoryList ---> ${storeCategoryReminder.value} -> length ${storeCategoryList.length}");
        } else {
          CommonSnackBar.showError(responseBody['error'].toString());
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
        // e.message.toString().showError();
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
        // e.message.toString().showError();
      } on Error catch (e) {
        debugPrint(e.toString());
      }

      isStoreCategoriesLoading.value = false;
      update();
    }
  }

  //Activate network retailer

  var isUpdateNrLoading = false.obs;

  Future<void> updateNetworkRetailerStatus(
      {required String updateStatus}) async {
    try {
      isUpdateNrLoading.value = true;

      await Future.delayed(Duration(seconds: 1), () {});

      final token = await SharPreferences.getToken();

      String userId =
          await SharPreferences.getString(SharPreferences.loginId) ?? '';

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      String url = "${API.updateNetworkRetailerStatus}/$userId/$updateStatus";

      print('updateNetworkRetailerStatus url --> ${url}');

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> resMap = jsonDecode(response.body);

        if (resMap.containsKey("status") && resMap["status"] == true) {
          if (resMap.containsKey("retailerResponse") &&
              resMap["retailerResponse"] != null) {
            CommonSnackBar.showError(resMap["retailerResponse"]);

            mainProfileStatus();
          } else {
            CommonSnackBar.showError("Retailer network status updated");
          }

          networkStatus.value = updateStatus == "Y" ? true : false;

          Get.back();
        } else {
          CommonSnackBar.showError("Something went wrong");
        }
        isUpdateNrLoading.value = false;
      } else {
        CommonSnackBar.showError('Something went wrong.');
        isUpdateNrLoading.value = false;
      }
    } on TimeoutException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on SocketException catch (e) {
      CommonSnackBar.showError(e.message.toString());
    } on Error catch (e) {
      print('error check from  on Error-> ${e.toString()}');
      debugPrint(e.toString());
    }
    isUpdateNrLoading.value = false;
  }

  var isProfileLoading = false.obs;
  var storeProfileDetails = Rx<StoreProfileResponseModel?>(null);
  var isNetworkChecked = false.obs;

  final networkStatus = ValueNotifier<bool>(false);

  Future<void> mainProfileStatus() async {
    try {
      String userId =
          await SharPreferences.getString(SharPreferences.loginId) ?? '';

      if (userId.isEmpty) {
        return;
      }
      isProfileLoading.value = true;
      storeProfileDetails.value = null;
      update();

      print(
          "printing main store profile status ---> ${"${API.profile}/$userId"}");
      final response = await http.get(
        Uri.parse("${API.profile}/$userId"),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('nr store profileStatus ${response.statusCode} --> $responseBody');

      if (response.statusCode == 200) {
        storeProfileDetails.value =
            storeProfileResponseModelFromJson(response.body);
        if (storeProfileDetails.value != null) {
          networkStatus.value = storeProfileDetails.value!.networkStatus == "Y";
        } else {
          networkStatus.value = false;
        }

        print('printing network status -> ${networkStatus.value}');

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

  Future<dynamic> getVideoBannerTopDataApi() async {
    try {
      bannerTopList.clear();
      videoControllerList.clear();
      isLoading.value = true;
      print("videoBannerTopData -> ${Uri.parse("${API.bannerTopApi}/1")}");
      final response = await http
          .get(Uri.parse("${API.bannerTopApi}/1"), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization':
        //     await SharPreferences.getString(SharPreferences.accessToken) ??
        //         ""
      });
      isLoading.value = false;

      if (response.statusCode == 200) {
        bannerTopList = jsonDecode(response.body);
        print("bannerTopList>>>>>>>>>>$bannerTopList");
        for (int i = 0; i < jsonDecode(response.body).length; i++) {
          // videoControllerList.add(await VideoPlayerController.network(
          //     jsonDecode(response.body)[i]['imageId'])
          //   ..initialize().then((play) {
          //     bannerVideoControllerList.value = jsonDecode(response.body);
          //     print(
          //         ">>>>>>>>>>>>>>Yes${videoControllerList[0].value.duration.inSeconds}");
          //     videoControllerList[0].play();
          //     Future.delayed(
          //         Duration(
          //             seconds: bannerVideoControllerList[0]['mediaDuratoin']),
          //         () {
          //       print(">>>>>>>>>>>>>>Yes>>>>>>>Change");
          //       controller.value.animateToPage(1,
          //           duration: Duration(milliseconds: 300),
          //           curve: Curves.easeIn);
          //     });
          //   }));
          videoControllerList.add(jsonDecode(response.body)[i]['imageId']);
          // videoControllerList.add(jsonDecode(response.body)[i]['imageId']);
          // videoControllerList.add(jsonDecode(response.body)[i]['imageId']);
        }
        isLoading.value = false;
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

  getAccountStatus() async {
    String storeId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    String supplierId =
        await SharPreferences.getString(SharPreferences.supplierId) ?? '';
    if (storeId.isNotEmpty) {
      isCreditLimitLoading.value = true;
      print("calling inside getAccountStatus");
      try {
        String url =
            '${API.getAccountStatus}/${storeId}?supplierId=$supplierId';
        print('account status url ---> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(Uri.parse(url), headers: headers);
        print('account status response ---> ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          accountStatusModel = accountStatusModelFromJson(response.body);
          GlobalMainController gmc = Get.put(GlobalMainController());
          gmc.popup2ndOptionNeededB2B =
              accountStatusModel.laterDeliveryIsEnable == "Y" ? true : false;

          logs('later delivery needed -> ${gmc.popup2ndOptionNeededB2B}');
          update();
        } else {
          CommonSnackBar.showError(
              'We are experiencing a temporary setback , please bear with us.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      isCreditLimitLoading.value = false;
      update();
    } else if (!Get.isDialogOpen!) {
      // Get.dialog(const LoginDialog(
      //   message: "getAccountStatus",
      // ));
    }
  }

  Map<String, dynamic> storeCreditBarChart = {
    "maxY": 0, // has to be int or double
    "minY": 10000, // has to be int or double
    "width":
        10, //has to be double or int or can be null. if null 10 width will be taken for bars.
    "data": [
      {
        "xAxisName": "Order Amount", // has to be string,
        "data": 0 // has to be int or double,
      },
      {
        "xAxisName": "Paid Amount", // has to be string
        "data": 0 // has to be int or double,
      },
      {
        "xAxisName": "Balance Amount", // has to be string
        "data": 0 // has to be int or double,
      },
    ]
  };

  getStoreCreditRating() async {
    String storeId =
        await SharPreferences.getString(SharPreferences.loginId) ?? '';
    if (storeId.isNotEmpty) {
      isCreditLimitLoading.value = true;
      storeCreditRating = null;
      update();
      print("calling inside getStoreCreditRating");
      try {
        String url = '${API.getStoreCreditRating}/${storeId}';
        print('getStoreCreditRating url ---> $url');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.get(Uri.parse(url), headers: headers);
        print(
            'getStoreCreditRating response ---> ${response.body} ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          storeCreditRating = storeCreditRatingModelFromJson(response.body);

          // Map<String, dynamic> demoChartData = {
          //   "maxY": 0, // has to be int or double
          //   "minY":
          //       storeCreditRating!.totalOrderAmount, // has to be int or double
          //   "width":
          //       10, //has to be double or int or can be null. if null 10 width will be taken for bars.
          //   "data": [
          //     {
          //       "xAxisName": "Order Amount", // has to be string,
          //       "data": storeCreditRating!.totalOrderAmount
          //     },
          //     {
          //       "xAxisName": "Paid Amount", // has to be string
          //       "data": storeCreditRating!
          //           .totalPaidAmount // has to be int or double,
          //     },
          //     {
          //       "xAxisName": "Balance Amount", // has to be string
          //       "data":
          //           storeCreditRating!.totalBalance // has to be int or double,
          //     },
          //   ]
          // };
          update();
        } else {
          CommonSnackBar.showError(
              'We are experiencing a temporary setback , please bear with us.');
        }
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      }
      isCreditLimitLoading.value = false;
      update();
    } else if (!Get.isDialogOpen!) {
      // Get.dialog(const LoginDialog(
      //   message: "getAccountStatus",
      // ));
    }
  }

  Future<dynamic> getLatestOrderApi() async {
    String storeId =
        await SharPreferences.getString(SharPreferences.loginId) ?? "";

    if (storeId.isNotEmpty) {
      try {
        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        String url = "${API.getLatestOrder}/$storeId/latestOrders";
        logs('url ---> ${url}');
        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          latestOrderResponseModel.value =
              latestOrderResponseModelFromJson(response.body);
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
    } else if (!Get.isDialogOpen!) {
      // Get.dialog(const LoginDialog(
      //   message: "getLatestOrderApi",
      // ));
    }
  }

  Future<dynamic> getBannerBottomImageDataApi() async {
    try {
      bannerTopList.clear();
      isLoading.value = true;
      print("getBannerBottomImageDataApi ${API.bannerTopApi + "/2"}");
      final response = await http
          .get(Uri.parse(API.bannerTopApi + "/2"), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization':
        //     await SharPreferences.getString(SharPreferences.accessToken) ??
        //         ""
      });
      isLoading.value = false;
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        bannerBottomImageList.value = jsonDecode(response.body);
        isLoading.value = false;
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
}
