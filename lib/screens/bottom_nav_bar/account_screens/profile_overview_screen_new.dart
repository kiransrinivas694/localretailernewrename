import 'dart:convert';
import 'dart:developer';

import 'package:b2c/components/common_snackbar_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/components/login_dialog_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller_new.dart';
import 'package:b2c/screens/auth/login_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/account_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/ledger_screen_new.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/my_bookings_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_my_booking_screen.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/subscription_screens/subscription_history_screen.dart';
import 'package:store_app_b2b/screens/home/notification_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:b2c/utils/shar_preferences_new.dart' as b2c_ref;

import 'package:store_app_b2b/utils/shar_preferences.dart' as store_app_b2b;

class ProfileOverViewScreen extends StatelessWidget {
  const ProfileOverViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetX<EditProfileController>(
      init: EditProfileController(),
      initState: (state) async {
        await state.controller!.getUserId();
        state.controller!.getCategory();
        await state.controller!.getProfileDataApi();
      },
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            body: controller.isLoading.value
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: height * 0.015),
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerRight,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 188,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      if (controller.profileData['imageUrl']
                                                  ?['bannerImageId'] !=
                                              null &&
                                          controller
                                              .profileData['imageUrl']
                                                  ['bannerImageId']
                                              .isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: AppImageAsset(
                                              image: controller
                                                      .profileData['imageUrl']
                                                  ['bannerImageId'],
                                              height: 188,
                                              width: width,
                                              fit: BoxFit.fill),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                              Positioned(
                                bottom: -5,
                                child: Container(
                                  height: 103,
                                  width: 103,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Container(
                                    height: 103,
                                    width: 103,
                                    margin: const EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: (controller.profileData['imageUrl']
                                                    ?['profileImageId'] !=
                                                null &&
                                            controller
                                                .profileData['imageUrl']
                                                    ['profileImageId']
                                                .isNotEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(103),
                                            child: AppImageAsset(
                                                image: controller
                                                        .profileData['imageUrl']
                                                    ['profileImageId'],
                                                height: 103,
                                                width: 103,
                                                fit: BoxFit.fill),
                                          )
                                        : const AppImageAsset(
                                            image: "assets/icons/camera.svg",
                                            height: 24,
                                            width: 32),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.025),
                        ],
                      ),
                      SizedBox(height: height * 0.015),
                      GestureDetector(
                        onTap: () =>
                            Get.to(() => ProfileScreen(isShowAllBar: true)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: ColorsConst.appBorderLight),
                          ),
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: const AppImageAsset(
                                image: 'assets/icons/account.svg',
                                fit: BoxFit.cover),
                            title: CommonText(
                                content: "My Account",
                                textColor: AppColors.appDarkGrey,
                                boldNess: FontWeight.w600,
                                textSize: 14),
                            subtitle: const CommonText(
                                content: "Make changes to your account",
                                textColor: Color(0xffBDBDBD),
                                boldNess: FontWeight.w400,
                                textSize: 11.46),
                            trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.appGrey,
                                size: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ColorsConst.appBorderLight),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                bool isUserIn = await isUserLogged();

                                if (!isUserIn) {
                                  //mysaa commented
                                  // Get.to(() => const AskLoginScreen());
                                  return;
                                }
                                Get.to(() => const DiagnosisMyBookingScreen());
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/labtest_history.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Diagnostic Tests",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                BooikingAppointmentController
                                    booikingAppointmentController =
                                    Get.put(BooikingAppointmentController());
                                booikingAppointmentController.status = 'P';
                                booikingAppointmentController
                                    .getAppointmentHistory();
                                Get.to(() => MyBookingsScreen());
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/doc_history.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Doctor Appointments",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.to(() => LedgerScreen());
                            //   },
                            //   child: ListTile(
                            //     leading: const AppImageAsset(
                            //         image: 'assets/images/ledger_profile.png',
                            //         fit: BoxFit.cover),
                            //     title: CommonText(
                            //         content: "Ledger",
                            //         textColor: AppColors.appDarkGrey,
                            //         boldNess: FontWeight.w600,
                            //         textSize: 14),
                            //     trailing: const Icon(
                            //         Icons.arrow_forward_ios_rounded,
                            //         color: AppColors.appGrey,
                            //         size: 15),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const NotificationScreen());
                                // Get.to(() => const SubscriptionHistoryScreen());
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/contact_us.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Notifications",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // Get.to(() => const SubscriptionHistoryScreen());
                            //   },
                            //   child: ListTile(
                            //     leading: const AppImageAsset(
                            //         image: 'assets/icons/contact_us.svg',
                            //         fit: BoxFit.cover),
                            //     title: CommonText(
                            //         content: "Your Subscriptions",
                            //         textColor: AppColors.appDarkGrey,
                            //         boldNess: FontWeight.w600,
                            //         textSize: 14),
                            //     trailing: const Icon(
                            //         Icons.arrow_forward_ios_rounded,
                            //         color: AppColors.appGrey,
                            //         size: 15),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                _launchURLBrowser(
                                    "https://thelocal.co.in/terms.html");
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/terms_condition.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Terms And Conditions",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchURLBrowser(
                                    "https://thelocal.co.in/policy.html");
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/privacy_policy.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Privacy and Policy",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {},
                                      behavior: HitTestBehavior.opaque,
                                      child: contactUsModalSheet(context),
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/contact_us.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Contact Us",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            ListTile(
                              leading: const AppImageAsset(
                                  image: 'assets/icons/about_us.svg',
                                  fit: BoxFit.cover),
                              title: CommonText(
                                  content: "About App",
                                  textColor: AppColors.appDarkGrey,
                                  boldNess: FontWeight.w600,
                                  textSize: 14),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.appGrey,
                                  size: 15),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String userId = await SharPreferences.getString(
                                        SharPreferences.loginId) ??
                                    '';

                                if (userId.isEmpty) {
                                  Get.dialog(const LoginDialog());
                                  return;
                                }

                                Get.dialog(
                                  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    // title: CommonText(
                                    //   content:
                                    //       "Are you sure you want to delete your account ?",
                                    //   textColor: Colors.black,
                                    // ),
                                    alignment: Alignment.center,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CommonText(
                                          content:
                                              'Are you sure you want to delete account?\n It will delete all your records.',
                                          textAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 1.6.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  // String loginId =
                                                  //     VariableUtilities
                                                  //         .storage
                                                  //         .read(KeyUtilities
                                                  //             .loginId);
                                                  // await http.delete(Uri.parse(
                                                  //     '${AppConfig.instance.config.appAPIBaseUrl}/api-auth/user/userprofile/$loginId'));
                                                  // VariableUtilities.storage
                                                  //     .remove(
                                                  //         KeyUtilities.loginId);
                                                  // VariableUtilities.storage
                                                  //     .remove(KeyUtilities
                                                  //         .authToken);
                                                  // Get.offAllNamed(
                                                  //     Routes.dashboard);
                                                  try {
                                                    log('delete url : ${'${API.deleteAccount}/$userId'}');

                                                    final response = await http
                                                        .get(Uri.parse(
                                                            '${API.deleteAccount}/$userId'));

                                                    log('delete url : response ${response.body}');

                                                    if (response.statusCode ==
                                                        200) {
                                                      Map<String, dynamic> map =
                                                          jsonDecode(
                                                              response.body);
                                                      if (map.containsKey(
                                                              'status') &&
                                                          map['status']) {
                                                        String
                                                            storedUserVersion =
                                                            await store_app_b2b
                                                                        .SharPreferences
                                                                    .getString(store_app_b2b
                                                                        .SharPreferences
                                                                        .versionNumber) ??
                                                                "";
                                                        CommonSnackBar.showError(
                                                            'Account Deleted Sucessfully');
                                                        await SharPreferences
                                                            .clearSharPreference();
                                                        await b2c_ref
                                                                .SharPreferences
                                                            .clearSharPreference();
                                                        await PreferencesHelper()
                                                            .clearPreferenceData();

                                                        await store_app_b2b
                                                                .SharPreferences
                                                            .setString(
                                                                store_app_b2b
                                                                    .SharPreferences
                                                                    .versionNumber,
                                                                storedUserVersion);
                                                        Get.delete<
                                                            StoreController>();
                                                        Get.offAll(() =>
                                                            const LoginScreen());
                                                      } else {
                                                        CommonSnackBar.showError(
                                                            'Something went wrong');
                                                      }
                                                    } else {
                                                      CommonSnackBar.showError(
                                                          'Something went wrong');
                                                    }
                                                  } catch (e) {
                                                    CommonSnackBar.showError(
                                                        'Something went wrong');
                                                    print(e.toString());
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.7.h,
                                                      horizontal: 6.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                  child: CommonText(
                                                    content: "Yes",
                                                    textColor: Colors.orange,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => Get.back(),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 3.w),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.7.h,
                                                      horizontal: 6.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.orange,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                  child: CommonText(
                                                    content: "No",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: const AppImageAsset(
                                    image: 'assets/icons/account.svg',
                                    fit: BoxFit.cover),
                                title: CommonText(
                                    content: "Delete Account",
                                    textColor: AppColors.appDarkGrey,
                                    boldNess: FontWeight.w600,
                                    textSize: 14),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.appGrey,
                                    size: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CommonText(
                                textAlign: TextAlign.center,
                                content: "Version : ${API.appVersion}",
                                textSize: 8,
                                textColor: Colors.black,
                                boldNess: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

_launchURLBrowser(String url) async {
  var finalUrl = Uri.parse(url);
  if (await canLaunchUrl(finalUrl)) {
    await launchUrl(finalUrl);
  } else {
    throw 'Could not launch $url';
  }
}

Widget contactUsModalSheet(context) {
  return SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            content: "Acintyo Local Pvt. Ltd",
            textColor: AppColors.appblack,
            textSize: 14,
            boldNess: FontWeight.w600,
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                content: "Address",
                textColor: AppColors.appblack,
                textSize: 14,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                width: 29,
              ),
              Expanded(
                child: CommonText(
                  content:
                      "Acintyo Local Private Limited IDA, Gandhi Nagar, Hyderabad - PIN 500037",
                  textColor: AppColors.appblack,
                  textSize: 14,
                  boldNess: FontWeight.w400,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                content: "Contact",
                textColor: AppColors.appblack,
                textSize: 14,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                width: 29,
              ),
              Expanded(
                child: CommonText(
                  content: "6303558285",
                  textColor: AppColors.appblack,
                  textSize: 14,
                  boldNess: FontWeight.w400,
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                content: "Email",
                textColor: AppColors.appblack,
                textSize: 14,
                boldNess: FontWeight.w600,
              ),
              SizedBox(
                width: 46,
              ),
              Expanded(
                child: CommonText(
                  content: "care@thelocal.co.in",
                  textColor: AppColors.appblack,
                  textSize: 14,
                  boldNess: FontWeight.w400,
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          CommonText(
            content: "Acintyo Local Oriented Customer Applications PVT. LTD.",
            textColor: AppColors.appblack,
            textSize: 14,
            boldNess: FontWeight.w600,
          ),
        ],
      ),
    ),
  );
}
