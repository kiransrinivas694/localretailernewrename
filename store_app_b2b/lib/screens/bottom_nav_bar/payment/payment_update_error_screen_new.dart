import 'package:b2c/screens/dashboard_screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text_new.dart';

class PaymentUpdateErrorScreen extends StatelessWidget {
  const PaymentUpdateErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();

        return false;
      },
      child: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset('assets/image/high_demand_two.png',
                      package: 'store_app_b2b', fit: BoxFit.cover),
                  SizedBox(
                    height: 45,
                  ),
                  CommonText(
                    content:
                        "Thank you for your payment! We've received it successfully. However, we encountered a technical issue while updating our records. Please contact our support team for assistance. We apologize for any inconvenience.",
                    textColor: Colors.black,
                    decoration: TextDecoration.none,
                    textAlign: TextAlign.center,
                    boldNess: FontWeight.w500,
                    textSize: 16,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                // height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8)),
                // color: Colors.orange,
                child: Center(
                  child: CommonText(
                    content: "Go to Payments",
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            )
            // SizedBox(
            //   height: 45,
            // ),
            // CommonText(
            //   content:
            //       "Please bear with us as we manage the surge. Your patience is highly appreciated.",
            //   textColor: Color.fromRGBO(255, 139, 3, 1),
            //   decoration: TextDecoration.none,
            //   textAlign: TextAlign.center,
            //   boldNess: FontWeight.w500,
            //   textSize: 14,
            // ),
          ],
        ),
      ),
    );
  }
}
