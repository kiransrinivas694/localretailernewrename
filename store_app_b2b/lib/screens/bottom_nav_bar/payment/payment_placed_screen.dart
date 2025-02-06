import 'package:b2c/screens/dashboard_screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';

class PaymentPlacedScreen extends StatefulWidget {
  const PaymentPlacedScreen({Key? key}) : super(key: key);

  @override
  State<PaymentPlacedScreen> createState() => _PaymentPlacedScreenState();
}

class _PaymentPlacedScreenState extends State<PaymentPlacedScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      // Get.offAll(() => const DashboardScreen(
      //       gotoHomeScreen: true,
      //     ));
      Get.back();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/image/verify_bg.png"),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child:
                      Image.asset("assets/image/order_success.png", scale: 5),
                ),
                SizedBox(height: height * 0.05),
                CommonText(
                  content: "Your Payment has been Placed",
                  textSize: width * 0.045,
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
