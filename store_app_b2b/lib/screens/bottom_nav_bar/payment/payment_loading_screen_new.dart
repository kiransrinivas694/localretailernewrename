import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_placed_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_update_error_screen_new.dart';

class PaymentLoadingScreen extends StatefulWidget {
  const PaymentLoadingScreen({super.key, required this.orderBody});

  final Map<String, dynamic> orderBody;

  @override
  State<PaymentLoadingScreen> createState() => _PaymentLoadingScreenState();
}

class _PaymentLoadingScreenState extends State<PaymentLoadingScreen> {
  PaymentController paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    // callSuccessApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callSuccessApi();
    });
  }

  callSuccessApi() async {
    await paymentController
        .getPaymentSuccessDataApi(widget.orderBody)
        .then((value) async {
      print("value>>>>>>$value");
      if (value != null && value['status'] == true) {
        // await getPaymentRequestDataApi();
        // paymentController.getPaymentRequestDataApi();
        // Get.off(() => PaymentPlacedScreen());
        Future.delayed(
          Duration(seconds: 3),
          () {
            paymentController.getPaymentRequestDataApi();
            paymentController.getPaymentOverview();
            Get.off(() => PaymentPlacedScreen());
            // Get.to(() => PaymentPlacedScreen());
          },
        );
      } else {
        Future.delayed(
          Duration(seconds: 3),
          () {
            Get.off(() => PaymentUpdateErrorScreen());
          },
        );
        // Get.off(() => PaymentUpdateErrorScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/icons/payment_loading.json',
                    width: screenWidth / 1.2, package: 'store_app_b2b'),
                SizedBox(height: 10),
                CommonText(
                  content: "Please wait while we verify your payment",
                  textColor: AppColors.appblack,
                  textSize: 20,
                  textAlign: TextAlign.center,
                  boldNess: FontWeight.w600,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
