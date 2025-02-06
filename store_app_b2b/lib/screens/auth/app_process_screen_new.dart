import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_primary_button_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/auth_controller/app_process_controller_new.dart';
import 'package:store_app_b2b/screens/auth/login_screen_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;

class AppProcessScreen extends StatelessWidget {
  AppProcessScreen({Key? key}) : super(key: key);
  final AppProcessController appProcessController =
      Get.put(AppProcessController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/image/bg.png"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //   onPressed: () {
              //     Get.back();
              //   },
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //   ),
              // ),
              // SizedBox(height: height * 0.05),
              // Center(
              //   child: SizedBox(
              //     height: height / 7,
              //     width: width / 1.3,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Center(
              //           child: CommonText(
              //             content:
              //                 "Use the below details to login and check your status",
              //             textSize: width * 0.04,
              //           ),
              //         ),
              //         // Row(
              //         //   children: [
              //         //     const CommonText(content: "Email : "),
              //         //     CommonText(content: "harsh@gmail.com", textColor: ColorsConst.primaryColor),
              //         //   ],
              //         // ),
              //         // Row(
              //         //   children: [
              //         //     const CommonText(content: "Password : "),
              //         //     CommonText(content: "123456", textColor: ColorsConst.primaryColor),
              //         //   ],
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: height * 0.25),
              Center(child: Image.asset("assets/image/timer.png", scale: 4)),
              SizedBox(height: height * 0.1),
              Center(
                child: CommonText(
                  content: "Your application is under verification",
                  textSize: width * 0.035,
                ),
              ),
              Center(
                child: CommonText(
                  content: "please try later",
                  textSize: width * 0.035,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CommonPrimaryButton(
                    text: "Home",
                    onTap: () {
                      Get.offAll(() => home.HomeScreen());
                    }),
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
