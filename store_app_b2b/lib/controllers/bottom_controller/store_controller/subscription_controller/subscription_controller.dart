import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/model/subscription_popup_response_model.dart';
import 'package:store_app_b2b/model/subscription_tenure_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/order_placed_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:store_app_b2b/utils/string_extensions.dart';

import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController {
  late Razorpay razorpay;

  List<String> plansPhases = [];
  List<SubscriptionTenureModel> subscriptionPlansList = [];
  List<dynamic> subscriptionsHistory = [];

  int selectedPlanPhaseIndex = 0;
  late int selectedSubscriptionIndex;

  List<dynamic> planCardColorsCollection = [
    {
      "firstBenefitColor": Color.fromRGBO(75, 75, 75, 1),
      "planHeadingColor": Color.fromRGBO(67, 73, 213, 1),
      "backgroundGradient": [
        Color.fromRGBO(30, 151, 170, 0.3),
        Color.fromRGBO(142, 219, 213, 0.3),
        Color.fromRGBO(255, 204, 172, 0.3),
      ],
    },
    {
      "firstBenefitColor": Color.fromRGBO(67, 73, 213, 1),
      "planHeadingColor": Color.fromRGBO(146, 40, 173, 1),
      "backgroundGradient": [
        Color.fromRGBO(251, 209, 171, 0.3),
        Color.fromRGBO(249, 147, 182, 0.3),
        Color.fromRGBO(182, 71, 196, 0.3),
      ],
    },
    {
      "firstBenefitColor": Color.fromRGBO(146, 40, 173, 1),
      "planHeadingColor": Color.fromRGBO(226, 157, 25, 1),
      "backgroundGradient": [
        Color.fromRGBO(229, 200, 98, 0.3),
        Color.fromRGBO(238, 213, 142, 0.3),
        Color.fromRGBO(222, 190, 90, 0.3),
        Color.fromRGBO(246, 211, 135, 0.3),
      ],
    },
    {
      "firstBenefitColor": Color.fromRGBO(255, 176, 22, 1),
      "planHeadingColor": Color.fromRGBO(38, 38, 38, 1),
      "backgroundGradient": [
        Color.fromRGBO(158, 158, 158, 0.3),
        Color.fromRGBO(196, 196, 196, 0.3),
        Color.fromRGBO(137, 137, 137, 0.3),
      ]
    }
  ];

  @override
  void onInit() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.onInit();
  }

  getPlanTenures() async {
    try {
      plansPhases = [];
      update();
      print(
          "getSubscriptionPlanLabels url ---> ${API.getSubscriptionPlanLabels} ");
      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(Uri.parse(API.getSubscriptionPlanLabels),
          headers: headers);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        print("getSubscriptionPlanLabels response ---> $responseBody");

        print("printing length of response body ---> ${responseBody.length}");
        for (String plan in responseBody) {
          print("printing plan $plan");
          plansPhases.add(plan);
        }

        print("printing -- responsebody index 1 ---> ${responseBody[0]}");
        print("printing -- plansPhases index 1 ---> ${plansPhases[0]}");
        getPlansByTenure(plansPhases[0]);
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
    print("printing plan phases ---> ${plansPhases}");
    update();
  }

  getPlansByTenure(String planTenure) async {
    subscriptionPlansList.clear();
    update();

    print("printing -- printing planTure --> $planTenure");
    try {
      String url = "${API.getSubscriptionPlanByTenure}$planTenure";
      print("printing -- getPlansByTenure url ---> $url");
      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(Uri.parse(url), headers: headers);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        print("getPlansByTenure response ---> $responseBody");

        for (Map plan in responseBody) {
          print("printing each plan ---> $plan");
          SubscriptionTenureModel subscriptionTenureModel =
              subscriptionTenureModelFromJson(jsonEncode(plan));

          subscriptionPlansList.add(subscriptionTenureModel);
        }

        // print("printing length of response body ---> ${responseBody.length}");
        // for (String plan in responseBody) {
        //   print("printing plan $plan");
        //   plansPhases.add(plan);
        // }
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
    // print("printing plan phases ---> ${plansPhases}");
    update();
  }

  getAllSubscriptionsHistory() async {
    // subscriptionPlansList.clear();
    // update();

    // print("printing -- printing planTure --> $planTenure");
    final String? loginId =
        await SharPreferences.getString(SharPreferences.loginId);
    try {
      subscriptionsHistory = [];
      update();

      String url = "${API.getAllSubscriptionsHistory}$loginId?page=0&size=100";
      print("printing -- getAllSubscriptionsHistory url ---> $url");

      final token = await SharPreferences.getToken();

      final headers = {
        'Content-Type': 'application/json',
      };

      if (API.enableToken) headers['Authorization'] = '$token';

      final response = await http.get(Uri.parse(url), headers: headers);
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // businessCategoryList = businessCategoryModelFromJson(response.body);
        print("getAllSubscriptionsHistory response ---> $responseBody");

        subscriptionsHistory = responseBody["content"];

        // for (Map plan in responseBody) {
        //   print("printing each plan ---> $plan");
        //   SubscriptionTenureModel subscriptionTenureModel =
        //       subscriptionTenureModelFromJson(jsonEncode(plan));

        //   subscriptionPlansList.add(subscriptionTenureModel);
        // }

        // print("printing length of response body ---> ${responseBody.length}");
        // for (String plan in responseBody) {
        //   print("printing plan $plan");
        //   plansPhases.add(plan);
        // }
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
    // print("printing plan phases ---> ${plansPhases}");
    update();
  }

  void changePlanPhase(int index) {
    selectedPlanPhaseIndex = index;
    update();
  }

  Future<dynamic> getSubscriptionSubscribe(
      {required String transactionId}) async {
    final String? subscriberId =
        await SharPreferences.getString(SharPreferences.loginId);
    print(
        "printing -- getSubscirptionSubscribe subscriber id ---> $subscriberId");
    if (subscriberId != null && subscriberId.isNotEmpty) {
      try {
        // isLoading = true;
        update();
        final url = API.getSubscriptionSubscribe;
        final bodyParse = {
          "subscriberId": subscriberId,
          "planId": subscriptionPlansList[selectedSubscriptionIndex].id,
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
          // isLoading = false;

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
          CommonSnackBar.showError(
              'Something went wrong in post subscription call.');
        }
      } on TimeoutException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on SocketException catch (e) {
        CommonSnackBar.showError(e.message.toString());
      } on Error catch (e) {
        debugPrint(e.toString());
      }
      // isLoading = false;
      update();
    } else if (!Get.isDialogOpen!) {
      Get.dialog(const LoginDialog());
    }
  }

  Future<dynamic> getRazorPayDataApi(int amount, String? orderId) async {
    print(
        "printing -- getRazorpaydataapi amount - ${amount} order id - ${orderId}");
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
      }
    };

    print("printing -- opencheckout options map --> $options");

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error in razorpay catch: $e');
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
}
