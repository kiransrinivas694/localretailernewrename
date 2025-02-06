import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text.dart';

class HighDemandTypeThree extends StatelessWidget {
  const HighDemandTypeThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              content:
                  "We're thrilled about the overwhelming response to our app! Due to high demand, you might experience a brief wait.",
              textColor: Colors.black,
              decoration: TextDecoration.none,
              textAlign: TextAlign.center,
              boldNess: FontWeight.w500,
              textSize: 14,
            ),
            SizedBox(
              height: 45,
            ),
            Image.asset('assets/image/high_demand_three.png',
                package: 'store_app_b2b', fit: BoxFit.cover),
            SizedBox(
              height: 45,
            ),
            CommonText(
              content: "Your enthusiasm is truly appreciated. Thank you",
              textColor: Color.fromRGBO(255, 139, 3, 1),
              decoration: TextDecoration.none,
              textAlign: TextAlign.center,
              boldNess: FontWeight.w500,
              textSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
