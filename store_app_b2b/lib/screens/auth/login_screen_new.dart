// import 'dart:developer';

// import 'package:b2c/controllers/GetHelperController.dart';
// import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:store_app_b2b/components/common_primary_button.dart';
// import 'package:store_app_b2b/components/common_snackbar_new.dart';
// import 'package:store_app_b2b/components/common_text_new.dart';
// import 'package:store_app_b2b/components/common_text_field.dart';
// import 'package:store_app_b2b/constants/colors_const_new.dart';
// import 'package:store_app_b2b/controllers/auth_controller/login_controller.dart';
// import 'package:store_app_b2b/screens/auth/app_pending_screen.dart';
// import 'package:store_app_b2b/screens/auth/app_rejected_screen.dart';
// import 'package:store_app_b2b/screens/auth/sign_up_screen.dart';
// import 'package:store_app_b2b/service/location_service.dart';
// import 'package:store_app_b2b/utils/shar_preferences.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return GetBuilder<LoginController>(
//       init: LoginController(),
//       builder: (LoginController loginController) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: ColorsConst.textColor,
//             body: Container(
//               width: width,
//               height: height,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage('assets/image/bg.png'),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 20, left: 20),
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: height * 0.02),
//                       Center(
//                         child: Container(
//                           child: Image.asset(
//                             'assets/image/login.png',
//                             scale: 5,
//                             package: 'store_app_b2b',
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: height * 0.02),
//                       CommonTextField(
//                         controller: loginController.phoneController,
//                         hintText: 'Enter store mobile number',
//                         content: 'Store contact number',
//                         keyboardType: TextInputType.numberWithOptions(),
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                       ),
//                       SizedBox(height: height * 0.02),
//                       if (loginController.showOtpBox) ...[
//                         CommonText(
//                           content: 'Confirmation code',
//                           textColor: Colors.white,
//                           boldNess: FontWeight.w500,
//                         ),
//                         SizedBox(height: height * 0.01),
//                         // Pinput(
//                         //   controller: loginController.otpController,
//                         //   keyboardType: TextInputType.numberWithOptions(),
//                         //   length: 6,
//                         //   inputFormatters: [
//                         //     FilteringTextInputFormatter.digitsOnly,
//                         //     LengthLimitingTextInputFormatter(6),
//                         //   ],
//                         //   // androidSmsAutofillMethod:
//                         //   //     AndroidSmsAutofillMethod.smsUserConsentApi,
//                         //   // listenForMultipleSmsOnAndroid: true,
//                         //   defaultPinTheme: PinTheme(
//                         //     height: 56,
//                         //     width: MediaQuery.of(context).size.width / 6,
//                         //     textStyle: TextStyle(color: ColorsConst.appWhite),
//                         //     decoration: BoxDecoration(
//                         //       color: ColorsConst.textColor,
//                         //       border: Border.all(
//                         //           color: ColorsConst.semiGreyColor, width: 1),
//                         //       borderRadius: BorderRadius.circular(10.5),
//                         //     ),
//                         //   ),
//                         //   focusedPinTheme: PinTheme(
//                         //     height: 56,
//                         //     width: MediaQuery.of(context).size.width / 6,
//                         //     textStyle: TextStyle(color: ColorsConst.appWhite),
//                         //     decoration: BoxDecoration(
//                         //       color: ColorsConst.textColor,
//                         //       border: Border.all(
//                         //           color: ColorsConst.semiGreyColor, width: 1),
//                         //       borderRadius: BorderRadius.circular(10.5),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                       SizedBox(height: height * 0.08),
//                       CommonPrimaryButton(
//                         text: loginController.showOtpBox
//                             ? 'Verify otp'
//                             : 'Continue',
//                         isLoading: loginController.isLoading,
//                         onTap: () async {
//                           if (loginController.phoneController.text
//                               .trim()
//                               .isEmpty) {
//                             CommonSnackBar.showError(
//                                 'Please enter store mobile number');
//                           } else {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             if (!loginController.showOtpBox) {
//                               loginController.signInPhoneNumber().then((value) {
//                                 if (value != null &&
//                                     value['response'] == true) {
//                                   loginController.getOtp('send', context);
//                                   loginController.showOtpBox = true;
//                                   loginController.update();
//                                 } else {
//                                   CommonSnackBar.showError(
//                                       'Phone Number is not registered.!');
//                                 }
//                               });
//                             } else {
//                               loginController
//                                   .mobileVerify()
//                                   .then((mobileVerify) async {
//                                 await LocationService.instance
//                                     .checkLocationPermission();
//                                 if (mobileVerify != null) {
//                                   loginController
//                                       .profileStatus(mobileVerify['logInId'])
//                                       .then((profileStatus) async {
//                                     if (profileStatus != null) {
//                                       await SharPreferences.setString(
//                                           SharPreferences.accessToken,
//                                           'Bearer ${mobileVerify['token']}' ??
//                                               '');
//                                       if (profileStatus['applicationStatus'] ==
//                                           "Onboarded") {
//                                         log('profileStatus msg --> $profileStatus');
//                                         GetHelperController.storeID.value =
//                                             mobileVerify['logInId'];
//                                         GetHelperController.token.value =
//                                             mobileVerify['token'];
//                                         await SharPreferences.setString(
//                                             SharPreferences.loginId,
//                                             mobileVerify['logInId'] ?? '');
//                                         await SharPreferences.setString(
//                                             SharPreferences.storeCategoryId,
//                                             mobileVerify['categoryId'] ?? "");
//                                         await SharPreferences.setString(
//                                             SharPreferences.storeName,
//                                             mobileVerify['userName'] ?? "");
//                                         await SharPreferences.setBoolean(
//                                             SharPreferences.isLogin, true);
//                                         Get.offAll(
//                                             () => const DashboardScreen(),
//                                             transition: Transition.size);
//                                       } else if (profileStatus[
//                                               'applicationStatus'] ==
//                                           "Pending") {
//                                         Get.to(() => AppPendingScreen(),
//                                             transition: Transition.size);
//                                       } else if (profileStatus[
//                                               'applicationStatus'] ==
//                                           "Rejected") {
//                                         Get.to(
//                                           transition:
//                                               Transition.cupertinoDialog,
//                                           () => AppRejectedScreen(
//                                             email: profileStatus['email'],
//                                             password: profileStatus['password'],
//                                             reasonReject:
//                                                 profileStatus["reason"] ?? {},
//                                           ),
//                                         );
//                                       }
//                                     }
//                                   });
//                                   loginController.isLoading = false;
//                                   loginController.update();
//                                 }
//                               });
//                             }
//                           }
//                           // loginController.signInEmail().then((login) async {
//                           //   print('bodyMap <<<<<<<==>>$login');
//                           //
//                           //   if (login != null) {
//                           //     await loginController
//                           //         .profileStatus(login['logInId'])
//                           //         .then((value) async {
//                           //       if (value != null) {
//                           //         print('bodyMap <<<<<<<==>>$value');
//                           //         await SharPreferences.setString(
//                           //             SharPreferences.loginId,
//                           //             login['logInId'] ?? '');
//                           //
//                           //         print(
//                           //             '>>>>>>>>>>>>>>>>${login['storeCategoryId']}');
//                           //         await SharPreferences.setString(
//                           //             SharPreferences.accessToken,
//                           //             '${login['fcmToken']}' ?? '');
//                           //         print(value['applicationStatus']);
//                           //         if (value['applicationStatus'] == 'Onboarded') {
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.storeCategoryId,
//                           //               value['storeCategoryId'] ?? '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.storeName,
//                           //               value['storeName'] ?? '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.mobileNumber,
//                           //               value['phoneNumber'] ?? '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.ownerName,
//                           //               value['ownerName'] ?? '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.addressLine1,
//                           //               value['storeAddressDetailRequest'][0]
//                           //                       ['addressLine1'] ??
//                           //                   '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.latitude,
//                           //               value['storeAddressDetailRequest'][0]
//                           //                       ['latitude'] ??
//                           //                   '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.longitude,
//                           //               value['storeAddressDetailRequest'][0]
//                           //                       ['longitude'] ??
//                           //                   '');
//                           //           await SharPreferences.setString(
//                           //               SharPreferences.storeNumber,
//                           //               value['storeNumber'] ?? '');
//                           //           await SharPreferences.setBoolean(
//                           //               SharPreferences.isLogin, true);
//                           //           Get.offAll(() => const HomeScreen(),
//                           //               transition: Transition.size);
//                           //         } else if (value['applicationStatus'] ==
//                           //             'Pending') {
//                           //           Get.to(() => AppPendingScreen(),
//                           //               transition: Transition.size);
//                           //         } else if (value['applicationStatus'] ==
//                           //             'Rejected') {
//                           //           Get.to(
//                           //               () => AppRejectedScreen(
//                           //                   email: value['email'],
//                           //                   password: value['password'],
//                           //                   reasonReject: value['reason'] ?? {}),
//                           //               transition: Transition.size);
//                           //         }
//                           //       }
//                           //     });
//                           //   }
//                           // });
//                           // Get.offAll(() => HomeScreen(), transition: Transition.size);
//                         },
//                       ),
//                       // SizedBox(height: height * 0.01),
//                       // const Center(child: CommonText(content: 'Or')),
//                       // SizedBox(height: height * 0.01),
//                       // CommonBorderButton(
//                       //   text: 'Continue with OTP',
//                       //   onTap: () {
//                       //     Get.to(() => MobileNoScreen());
//                       //   },
//                       // ),
//                       SizedBox(height: height * 0.09),
//                       Center(
//                         child: RichText(
//                           text: TextSpan(
//                             text: 'New to LOCAL ? ',
//                             style: GoogleFonts.poppins(
//                                 color: ColorsConst.hintColor),
//                             children: [
//                               TextSpan(
//                                 text: 'Register',
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Get.to(() => SignupScreen());
//                                   },
//                                 style: GoogleFonts.poppins(
//                                   color: ColorsConst.primaryColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: CommonText(
//                           content:
//                               'Terms and Conditions applied. Privacy policy',
//                           textSize: width * 0.032,
//                         ),
//                       ),
//                       SizedBox(height: height * 0.015),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
