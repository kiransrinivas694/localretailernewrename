import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/helper/firebase_token_storeb2b_helper.dart';
import 'package:store_app_b2b/screens/auth/login_screen.dart';
import 'package:store_app_b2b/screens/home/home_screen.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLogin = false;
  @override
  void initState() {
    getDeviceToken();
    getLogin();
    Future.delayed(
      const Duration(seconds: 4),
      () => Get.offAll(() => isLogin ? HomeScreen() : HomeScreen()),
    );
    super.initState();
  }

  Future<dynamic> getLogin() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    print(isLogin);
  }

  getDeviceToken() async {
    // await FirebaseMessaging.instance.getToken().then((token) {
    //   SharPreferences.setString(SharPreferences.deviceToken, token ?? "");
    //   print("device-token $token");
    // });
    await getFirebaseTokenStoreb2b().then((token) {
      SharPreferences.setString(SharPreferences.deviceToken, token ?? "");
      print("device-token $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsConst.textColor,
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/image/splash_image.png"),
            ),
          ),
        ),
      ),
    );
  }
}
