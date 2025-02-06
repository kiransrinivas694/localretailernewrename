import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller_new.dart';
import 'package:store_app_b2b/model/get_internal_popup_response_model_new.dart';
import 'package:store_app_b2b/model/subscription_popup_response_model_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/order_placed_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/store_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  Widget currentWidget = StoreScreen();

  //initialization

  bool initialisationInProgress = true;

  void updateInitialisationInProgress(bool value) {
    initialisationInProgress = value;
    update();
  }

  late Razorpay razorpay;

  String appBarTitle = "";

  bool isFromBuyTab = false;

  int currentIndex = 0;
  int selectedSubscriptionIndex = 0;

  bool isShowPopup = false;
  bool isShowSubscriptionPopup = false;
  bool isLoading = false;

  //Buy Hoem Banners
  int currentBanner = 0;
  int previousCurrentBanner = 0;

  setHomeBuyBanner() {
    currentBanner = currentBanner + 1;
    previousCurrentBanner = currentBanner - 1;
    update();
  }

  @override
  void onInit() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.onInit();
  }

  clearBottomBarValues() {
    isFromBuyTab = false;
    update();
  }

  GetInternalPopUpResponseModel internalPopUpResponseModel =
      GetInternalPopUpResponseModel();
  SubscriptionPopupResponseModel subscriptionPopupResponseModel =
      SubscriptionPopupResponseModel();

  Future<void> getInternalPopup() async {
    print("internal popup is called");
    String? loginId = await SharPreferences.getString(SharPreferences.loginId);
    print("internal popup is called -> $loginId");
    if (loginId != null && loginId.isNotEmpty) {
      // try {
      //   String url = '${API.getInternalPopUp}$loginId';
      //   logs('internal popup url ---> $url');
      //   final response = await http.get(Uri.parse(url));
      //   logs('internal popup response ---> ${response.body}');
      //   if (response.statusCode == 200 || response.statusCode == 201) {
      //     if (response.body.isNotEmpty) {
      //       internalPopUpResponseModel =
      //           getInternalPopUpResponseModelFromJson(response.body);
      //       isShowPopup = internalPopUpResponseModel.messageType == 'od';
      //     }
      //   } else {
      //     CommonSnackBar.showError('Something went wrong.');
      //   }
      // } on SocketException catch (e) {
      //   logs('Catch exception in getInternalPopupApi --> ${e.message}');
      //   CommonSnackBar.showError(e.message.toString());
      // }
      // } else if (!Get.isDialogOpen!) {
    } else {
      print("internal popup else is called");
      Get.dialog(const LoginDialog(
        message: "getInternalPopup",
      ));
    }
  }

  Future<void> getSubscriptionPopup() async {
    try {
      isShowSubscriptionPopup =
          await SharPreferences.getBoolean(SharPreferences.isNotSubscribe) ??
              false;
      logs('isShowSubscriptionPopup --> $isShowSubscriptionPopup');
      if (isShowSubscriptionPopup) {
        String url = API.getSubscriptionPopup;
        logs('get subscription url --> $url');
        final response = await http.get(Uri.parse(url));
        logs('get subscription response --> ${response.body}');
        if (response.statusCode == 200) {
          subscriptionPopupResponseModel =
              subscriptionPopupResponseModelFromJson(response.body);
        } else {
          CommonSnackBar.showError('Something went wrong');
        }
      }
    } on SocketException catch (e) {
      logs('Catch exception in getSubscriptionPopup --> ${e.message}');
      CommonSnackBar.showError(e.message.toString());
    }
    update();
  }

  Future<void> updateInternalPopup(
      {required String orderId,
      required String id,
      required String value}) async {
    try {
      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      String url = '${API.updatePopupValue}/$id/userViwed/$value';
      logs('Update internal popup url ---> $url');
      final response = await http.put(Uri.parse(url), headers: headers);
      logs('Update internal popup response ---> ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        isShowPopup = false;
        Get.back();
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
        isShowPopup = false;
        Get.back();
      } else {
        CommonSnackBar.showError('Something went wrong.');
      }
    } on SocketException catch (e) {
      logs('Catch exception in getInternalPopupApi --> ${e.message}');
      CommonSnackBar.showError(e.message.toString());
    }
    // isShowPopup = false;
    // appBarTitle = "Payment";
    // currentIndex = 3;
    // currentWidget = PaymentScreen();
    // update();
    // Get.back();
  }

  Future<dynamic> getSubscriptionSubscribe(
      {required String transactionId}) async {
    final String? subscriberId =
        await SharPreferences.getString(SharPreferences.loginId);
    if (subscriberId != null && subscriberId.isNotEmpty) {
      try {
        isLoading = true;
        update();
        final url = API.getSubscriptionSubscribe;
        final bodyParse = {
          "subscriberId": subscriberId,
          "planId": subscriptionPopupResponseModel
              .content[selectedSubscriptionIndex].id,
          "transactionId": transactionId
        };
        logs('Subscription Subscribe url --> $url');
        logs('Subscription Subscribe bodyParse  --> $bodyParse');

        final token = await SharPreferences.getToken();

        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        if (API.enableToken) headers['Authorization'] = '$token';

        final response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(bodyParse));
        print(
            "getSubscriptionSubscribe response --> ${jsonDecode(response.body)}");
        if (response.statusCode == 200) {
          isLoading = false;

          await SharPreferences.setBoolean(
              SharPreferences.isNotSubscribe, false);
          Get.to(() => const OrderPlacedScreen(
                // message: 'You have been subscribed successfully',
                message:
                    "Your subscription is confirmed. Thank you for your payment",
              ));

          update();
          return jsonDecode(response.body);
        } else {
          CommonSnackBar.showError('Something went wrong.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      isLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      print("else in subscription is called");
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> getRazorPayDataApi(int amount, String? orderId) async {
    return openCheckout(amount, orderId);
    // Get.to(() => const PaymentPlacedScreen());
  }

  void openCheckout(int price, String? orderId) async {
    var options = {
      'key': ApiConfig.razorpayKey,
      'amount': price,
      "id": orderId,

      // 'order_id': selectItem['orderId'],
      'name': 'Acintyo Retailer Buy',
      // 'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      },
    };

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
    await getSubscriptionSubscribe(transactionId: response.paymentId!);
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

  void selectSubscriptionPlan(int index) {
    selectedSubscriptionIndex = index;
    update();
  }
}
