import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;
import 'package:store_app_b2b/components/common_text_new.dart';

class OrderPlacedScreen extends StatefulWidget {
  final String? message;
  final bool needPop;
  const OrderPlacedScreen({Key? key, this.message, this.needPop = false})
      : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => OrderPlacedScreenState();
}

class OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (widget.needPop) {
          Get.back();
          return;
        }
        Get.offAll(() => const home.HomeScreen());
        // Get.to(() => const home.HomeScreen());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (widget.needPop) {
          Get.back();
          return false;
        }
        Get.offAll(() => const DashboardScreen());
        //Get.to(() => const home.HomeScreen());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(10),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/image/verify_bg.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child:
                      Image.asset('assets/image/order_success.png', scale: 5),
                ),
                SizedBox(height: height * 0.05),
                CommonText(
                  content: 'Yayy!',
                  textSize: width * 0.045,
                  boldNess: FontWeight.w600,
                ),
                SizedBox(height: height * 0.01),
                CommonText(
                  textAlign: TextAlign.center,
                  content: widget.message ?? 'Order has been Placed',
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
