import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class LucidSoonScreen extends StatelessWidget {
  const LucidSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF), // White
                Color(0xFFFBD961), // Yellowish
              ],
              stops: [0.0, 1.0], // Percentage of each color
            ),
          ),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/icons/lucid_logo.png",
                width: 147,
                package: 'store_app_b2b',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 30,
              ),
              CommonText(
                content: "Coming Soon",
                textColor: Color.fromRGBO(45, 45, 45, 1),
                textSize: 40,
                boldNess: FontWeight.w500,
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/icons/lucid_test_image.png",
                // height: height * 0.4,
                width: double.infinity,
                package: 'store_app_b2b',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
