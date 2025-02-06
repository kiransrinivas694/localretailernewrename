import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/controllers/auth_controller/login_controller.dart';
import 'package:b2c/helper/firebase_gettoken_backup.dart';
import 'package:b2c/screens/auth/login_screen.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/controllers/home_controller.dart';
import 'package:store_app_b2b/screens/home/home_screen.dart' as home;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLogin = false;
  @override
  void initState() {
    getLogin();
    super.initState();
  }

  Future<dynamic> getLogin() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    print(isLogin);

    GetHelperController.token.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.token) ??
        '';
    GetHelperController.storeID.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.storeID) ??
        '';
    // await FirebaseMessaging.instance.getToken().then((token) {
    //   PreferencesHelper()
    //       .setPreferencesStringData(PreferencesHelper.deviceToken, token ?? "");
    //   print("device-token $token");
    // });

    await getFirebaseToken().then((token) {
      PreferencesHelper()
          .setPreferencesStringData(PreferencesHelper.deviceToken, token ?? "");
      print("device-token $token");
    });

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (GetHelperController.token.value.isNotEmpty) {
          // ----------- vaishnav ---------------
          // Future.delayed(const Duration(milliseconds: 500)).then((value) => onUserLogin());
          // ----------- vaishnav ---------------
        }
        print(">>>>>>>>>>>>>>>>>>>>$isLogin");
        // Get.offAll(() => const DashboardScreen());
        Get.offAll(() => const home.HomeScreen());
        // Get.offAll(
        //   () => isLogin
        //       ? const DashboardScreen()
        //       : /*kDebugMode
        //           ? LoginScreen()
        //           : */
        //       LoginScreen(),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.textColor,
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
