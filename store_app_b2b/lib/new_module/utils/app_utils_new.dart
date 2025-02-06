import 'package:b2c/utils/string_extensions.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/cart/cart_lab_test_model.dart';

class AppFont {
  static const String montserrat = 'Montserrat';
  static const String oswald = 'Oswald';
  static const String roboto = 'Roboto';
  static const String openSans = 'Open Sans';
  static const String poppins = 'Poppins';
  static const String proximaNova = 'ProximaNova';
}

void customFailureToast({String header = "", required String content}) {
  BotToast.cleanAll();
  BotToast.showCustomText(
    toastBuilder: (context) {
      return Container(
        margin: EdgeInsets.all(16.px).copyWith(bottom: 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        constraints: BoxConstraints(maxWidth: 85.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                  color: Color.fromRGBO(0, 0, 0, 0.1))
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImageAsset(
              image: "assets/images/toast_failure.png",
              width: 30,
            ),
            const SizedBox(width: 10),
            Flexible(
              // child: AppText(
              //   message,
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   fontWeight: FontWeight.w400,
              //   color: Color.fromRGBO(0, 0, 0, 1),
              // ),
              child: Text(
                content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ],
        ),
      );
    },
    duration: const Duration(seconds: 2),
    align: Alignment.bottomCenter,
  );
}

void customSuccessToast({String header = "", String content = ""}) {
  BotToast.cleanAll();
  BotToast.showCustomText(
    toastBuilder: (context) {
      return Container(
        margin: EdgeInsets.all(16.px).copyWith(bottom: 100),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        constraints: BoxConstraints(maxWidth: 85.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                  color: Color.fromRGBO(0, 0, 0, 0.1))
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImageAsset(
              image: "assets/images/toast_success.png",
              width: 30,
            ),
            const SizedBox(width: 10),
            Flexible(
              // child: AppText(
              //   message,
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   fontWeight: FontWeight.w400,
              //   color: Color.fromRGBO(0, 0, 0, 1),
              // ),
              child: Text(
                content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ],
        ),
      );
    },
    duration: const Duration(seconds: 2),
    align: Alignment.bottomCenter,
  );
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  try {
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      logs('Could not launch $launchUri');
      throw 'Could not launch $launchUri';
    }
  } catch (e) {
    logs('Error launching URL: $e');
  }
}

void launchHttpUrl(String url) async {
  // const url = 'https://www.capedindia.org/';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    // throw 'Could not launch $url';
    customFailureToast(
        content:
            "We're having some trouble processing your request. Please try again shortly.");
  }
}

Future<bool> isUserLogged() async {
  // mysaa commented
  // String user = await SharedPrefService.instance
  //         .getPrefStringValue(SharedPrefService.instance.logInId) ??
  //     "";

  String user = "skdfksd";

  if (user.isEmpty) {
    return false;
  } else {
    return true;
  }
}

bool checkForHvEqualOne(RxList<BasicLucidTestModel> lucidTest) {
  for (var item in lucidTest) {
    if (item.hv == "1") {
      return true;
    }
  }
  return false;
}

Future<String> getUserId() async {
  String user = await SharPreferences.getString(SharPreferences.loginId) ?? '';
  //mysaa commewnted - hardcoded belwo , commented above
  // String user = "MYSAA-UP202408-452";

  return user;
}

Future<String> getMobileNumber() async {
  // String user = await SharedPrefService.instance
  //         .getPrefStringValue(SharedPrefService.instance.logInId) ??
  //     "";

  //mysaa commewnted - hardcoded belwo , commented above
  String mobileNumber = "6301458089";

  return mobileNumber;
}

bool fieldLengthCheck({
  required String value,
  int length = 2,
  required String fieldName,
}) {
  if (value.length <= length) {
    customFailureToast(
        content: '$fieldName must be more than $length characters');

    return true;
  }
  return false;
}
