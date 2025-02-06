import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text_new.dart';

class HighDemandTypeTwo extends StatelessWidget {
  const HighDemandTypeTwo({super.key});

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
            Image.asset('assets/image/high_demand_two.png',
                package: 'store_app_b2b', fit: BoxFit.cover),
            SizedBox(
              height: 45,
            ),
            CommonText(
              content:
                  "Dear users, our app is in high demand, and we're thrilled by your enthusiasm!",
              textColor: Colors.black,
              decoration: TextDecoration.none,
              textAlign: TextAlign.center,
              boldNess: FontWeight.w500,
              textSize: 16,
            ),
            SizedBox(
              height: 45,
            ),
            CommonText(
              content:
                  "Please bear with us as we manage the surge. Your patience is highly appreciated.",
              textColor: Color.fromRGBO(255, 139, 3, 1),
              decoration: TextDecoration.none,
              textAlign: TextAlign.center,
              boldNess: FontWeight.w500,
              textSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
