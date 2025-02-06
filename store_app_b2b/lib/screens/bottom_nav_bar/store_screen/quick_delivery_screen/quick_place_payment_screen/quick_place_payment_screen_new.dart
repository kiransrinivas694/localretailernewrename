import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_delivery_screen_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart';

class QuickPlaceOrderScreen extends StatelessWidget {
  const QuickPlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CommonText(
          content: 'Order Placed',
          boldNess: FontWeight.w600,
          textSize: 14,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff2F394B),
                Color(0xff090F1A),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/image/confirm_order_bg.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            package: 'store_app_b2b',
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                  'https://lottie.host/04ddc89f-abab-4a52-9787-42bd08c06f20/YHDXAMa6SL.json'),
              CommonText(
                content: 'Order Placed Successfully',
                textAlign: TextAlign.center,
                textSize: 24,
                textColor: ColorsConst.primaryColor,
                boldNess: FontWeight.w600,
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: checkStatusButton(),
    );
  }

  Widget checkStatusButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConst.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: const CommonText(
            content: 'Check status', boldNess: FontWeight.w500, textSize: 16),
      ),
    );
  }
}

class QuickPaymentPlacedScreen extends StatefulWidget {
  final bool showStatusButton;
  final String message;

  const QuickPaymentPlacedScreen(
      {super.key, this.showStatusButton = true, required this.message});

  @override
  State<QuickPaymentPlacedScreen> createState() =>
      _QuickPaymentPlacedScreenState();
}

class _QuickPaymentPlacedScreenState extends State<QuickPaymentPlacedScreen> {
  @override
  void initState() {
    if (!widget.showStatusButton) {
      Future.delayed(Duration(seconds: 3), () {
        // Get.offAll(() => const DashboardScreen(
        //       gotoHomeScreen: true,
        //       gotoQuickDeliveryScreen: true,
        //     ));
        Get.offAll(() => HomeScreen());
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //   fit: BoxFit.cover,
                //   image: AssetImage('assets/image/verify_bg.png'),
                // )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/image/thank_you_payment.png',
                          scale: 5),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    CommonText(
                      content: widget.message,
                      textSize: 24,
                      boldNess: FontWeight.w600,
                      textAlign: TextAlign.center,
                      textColor: Color.fromRGBO(255, 139, 3, 1),
                    ),
                    if (widget.showStatusButton)
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                    if (widget.showStatusButton)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonText(
                          content:
                              'Assigning a Delivery boy to serve your order',
                          textSize: 20,
                          boldNess: FontWeight.w500,
                          textAlign: TextAlign.center,
                          textColor: Color.fromRGBO(45, 54, 72, 1),
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (widget.showStatusButton)
              GestureDetector(
                onTap: () {
                  // Get.offAll(() => const DashboardScreen(
                  //     gotoHomeScreen: true, gotoQuickDeliveryScreen: true));
                  Get.offAll(() => HomeScreen());
                },
                child: Container(
                  height: 48,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorsConst.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: const CommonText(
                      content: 'Check status',
                      boldNess: FontWeight.w500,
                      textSize: 16),
                ),
              )
          ],
        ),
      ),
    );
  }
}
