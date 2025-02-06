import 'dart:developer';
import 'dart:io';

import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen_new.dart';
import 'package:b2c/service/sse_service_controller_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:store_app_b2b/components/common_primary_button_new.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/auth_controller/login_controller_new.dart';
import 'package:store_app_b2b/screens/auth/app_pending_screen_new.dart';
import 'package:store_app_b2b/screens/auth/app_rejected_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_screen_new.dart';
import 'package:store_app_b2b/screens/auth/supplier_onboard_screen_new.dart';
import 'package:store_app_b2b/service/location_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );

    logs("logs rescode -> ${res.code}");
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => true;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final SmsRetriever smsRetriever;

  @override
  void initState() {
    if (Platform.isAndroid) {
      smsRetriever = SmsRetrieverImpl(
        SmartAuth(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetBuilder<LoginController>(
        init: LoginController(),
        dispose: (state) {
          // state.controller!.resendOtpTimer!.cancel();
          // state.controller!.otpSeconds = 30;
        },
        builder: (LoginController loginController) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: ColorsConst.textColor,
              body: Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/image/bg.png'),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.02),
                        Center(
                          child: SizedBox(
                            height: 300,
                            child: Image.asset('assets/image/login.png',
                                package: 'store_app_b2b', fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: loginController.phoneController,
                          hintText: 'Enter store mobile number',
                          content: 'Store contact number',
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        if (loginController.showOtpBox) ...[
                          const CommonText(
                            content: 'Confirmation code',
                            textColor: Colors.white,
                            boldNess: FontWeight.w500,
                          ),
                          SizedBox(height: height * 0.01),
                          Platform.isAndroid
                              ? Pinput(
                                  controller: loginController.otpController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  length: 6,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  // androidSmsAutofillMethod:
                                  //     AndroidSmsAutofillMethod.smsUserConsentApi,
                                  // listenForMultipleSmsOnAndroid: true,
                                  smsRetriever: smsRetriever,
                                  defaultPinTheme: PinTheme(
                                    height: 56,
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    textStyle: const TextStyle(
                                        color: ColorsConst.appWhite),
                                    decoration: BoxDecoration(
                                      color: ColorsConst.textColor,
                                      border: Border.all(
                                          color: ColorsConst.semiGreyColor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10.5),
                                    ),
                                  ),
                                  focusedPinTheme: PinTheme(
                                    height: 56,
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    textStyle: const TextStyle(
                                        color: ColorsConst.appWhite),
                                    decoration: BoxDecoration(
                                      color: ColorsConst.textColor,
                                      border: Border.all(
                                          color: ColorsConst.semiGreyColor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10.5),
                                    ),
                                  ),
                                )
                              : Pinput(
                                  controller: loginController.otpController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  length: 6,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  // androidSmsAutofillMethod:
                                  //     AndroidSmsAutofillMethod.smsUserConsentApi,
                                  // listenForMultipleSmsOnAndroid: true,

                                  defaultPinTheme: PinTheme(
                                    height: 56,
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    textStyle: const TextStyle(
                                        color: ColorsConst.appWhite),
                                    decoration: BoxDecoration(
                                      color: ColorsConst.textColor,
                                      border: Border.all(
                                          color: ColorsConst.semiGreyColor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10.5),
                                    ),
                                  ),
                                  focusedPinTheme: PinTheme(
                                    height: 56,
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    textStyle: const TextStyle(
                                        color: ColorsConst.appWhite),
                                    decoration: BoxDecoration(
                                      color: ColorsConst.textColor,
                                      border: Border.all(
                                          color: ColorsConst.semiGreyColor,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10.5),
                                    ),
                                  ),
                                ),
                        ],
                        SizedBox(height: height * 0.01),
                        if (loginController.showOtpBox)
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  if (loginController.otpSeconds == 30) {
                                    loginController.getOtp('resend', context);
                                    loginController.otpController.clear();
                                  }
                                },
                                child: (loginController.otpSeconds == 30)
                                    ? const AppText('Resend otp')
                                    : AppText(
                                        '${loginController.otpSeconds} seconds'),
                              )),
                        SizedBox(height: height * 0.08),
                        CommonPrimaryButton(
                          text: loginController.showOtpBox
                              ? 'Verify otp'
                              : 'Continue',
                          isLoading: loginController.isLoading,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (loginController.phoneController.text.isEmpty) {
                              CommonSnackBar.showError(
                                  'Please enter store mobile number');
                            } else {
                              if (!loginController.showOtpBox) {
                                loginController
                                    .signInPhoneNumber()
                                    .then((value) {
                                  if (value['response'] == true) {
                                    print("this is called");
                                    loginController.getOtp('send', context);
                                    loginController.showOtpBox = true;
                                    loginController.update();
                                  } else {
                                    value["message"] == null
                                        ? CommonSnackBar.showError(
                                            'Phone Number is not registered.!')
                                        : CommonSnackBar.showError(
                                            value["message"]);
                                  }
                                });
                              } else {
                                loginController
                                    .mobileVerify()
                                    .then((mobileVerify) async {
                                  logs('login check Mobile --> $mobileVerify');
                                  await LocationService.instance
                                      .checkLocationPermission();
                                  if (mobileVerify != null) {
                                    loginController
                                        .profileStatus(mobileVerify['logInId'])
                                        .then((profileStatus) async {
                                      logs(
                                          'login check profileStatus --> $profileStatus');
                                      if (profileStatus != null) {
                                        log('subscribe --> ${mobileVerify['subscribed'] == 'N'}');
                                        log('storeNumberis --> ${profileStatus['storeNumber']}');
                                        log('storeNumberis --> ${mobileVerify['logInId']}');
                                        log('storeNumberis --> ${mobileVerify['categoryId']}');
                                        log('jwttoken is --> ${mobileVerify['token']}');
                                        await SharPreferences.setString(
                                            SharPreferences.accessToken,
                                            'Bearer ${mobileVerify['token']}');
                                        await SharPreferences.setString(
                                            SharPreferences.token,
                                            mobileVerify['token'] ?? '');
                                        await SharPreferences.setString(
                                            SharPreferences.storeCategoryMainId,
                                            profileStatus['storeCategoryId'] ??
                                                "");

                                        print(
                                            "printing supplier id -> ${await SharPreferences.getString(SharPreferences.storeCategoryMainId)}");
                                        if (profileStatus[
                                                'applicationStatus'] ==
                                            "Onboarded") {
                                          loginController.getLinkedSuppliersApi(
                                            mobileVerify['logInId'],
                                          );
                                          log('profileStatus msg --> $profileStatus');
                                          await SharPreferences.setString(
                                            SharPreferences.drugLicenseExpiry,
                                            profileStatus['drugLicense']
                                                    ["expiryDate"] ??
                                                "",
                                            // "2025-01-20",
                                          );
                                          await SharPreferences.setString(
                                              SharPreferences.loginId,
                                              mobileVerify['logInId'] ?? '');
                                          await SharPreferences.setString(
                                              SharPreferences.storeNumber,
                                              profileStatus['storeNumber'] ??
                                                  "");
                                          await SharPreferences.setString(
                                              SharPreferences.ownerNameNew,
                                              profileStatus['ownerName'] ?? "");
                                          GetHelperController.storeID.value =
                                              mobileVerify['logInId'];
                                          GetHelperController.token.value =
                                              mobileVerify['token'];
                                          await SharPreferences.setString(
                                              SharPreferences.storeCategoryId,
                                              mobileVerify['categoryId'] ?? "");
                                          await SharPreferences.setString(
                                              SharPreferences.storeName,
                                              mobileVerify['userName'] ?? "");
                                          await SharPreferences.setBoolean(
                                              SharPreferences.isLogin, true);
                                          await SharPreferences.setBoolean(
                                              SharPreferences.isNotSubscribe,
                                              // mobileVerify['subscribed'] == 'N');
                                              false);

                                          //setting static and checking if working or not
                                          await SharPreferences.setString(
                                              SharPreferences.supplierId,
                                              mobileVerify["linkSupplierId"] ??
                                                  '');

                                          // await SharPreferences.setString(
                                          //     SharPreferences
                                          //         .storeCategoryMainId,
                                          //     profileStatus[
                                          //             'storeCategoryId'] ??
                                          //         "");

                                          print(
                                              "print check init  after setting variables");
                                          loginController.showOtpBox = false;
                                          loginController.otpController.clear();
                                          loginController.phoneController
                                              .clear();
                                          loginController.resendOtpTimer!
                                              .cancel();
                                          loginController.otpSeconds = 30;
                                          SSEService sseController =
                                              Get.put(SSEService());
                                          sseController.connectSSE();
                                          Get.offAll(
                                              () => const home.HomeScreen());
                                          // Get.offAll(
                                          //     () => const DashboardScreen(
                                          //           isNeedToPlayVideo: true,
                                          //         ),
                                          //     transition: Transition.size);
                                        } else if (profileStatus[
                                                    'applicationStatus'] ==
                                                "Pending" &&
                                            profileStatus['linkSupplierId'] ==
                                                null) {
                                          loginController.showOtpBox = false;
                                          loginController.otpController.clear();
                                          loginController.phoneController
                                              .clear();

                                          if (loginController.resendOtpTimer !=
                                              null)
                                            loginController.resendOtpTimer!
                                                .cancel();
                                          loginController.otpSeconds = 30;
                                          Get.offAll(
                                              () => SupplierOnboardScreen(
                                                    retailerId: mobileVerify[
                                                            "logInId"] ??
                                                        '',
                                                  ),
                                              transition: Transition.size);
                                        } else if (profileStatus[
                                                'applicationStatus'] ==
                                            "Pending") {
                                          loginController.showOtpBox = false;
                                          loginController.otpController.clear();
                                          loginController.phoneController
                                              .clear();
                                          loginController.resendOtpTimer!
                                              .cancel();
                                          loginController.otpSeconds = 30;
                                          Get.to(() => AppPendingScreen(),
                                              transition: Transition.size);
                                        } else if (profileStatus[
                                                'applicationStatus'] ==
                                            "Rejected") {
                                          loginController.showOtpBox = false;
                                          loginController.otpController.clear();
                                          loginController.phoneController
                                              .clear();
                                          loginController.resendOtpTimer!
                                              .cancel();
                                          loginController.otpSeconds = 30;
                                          List<String> reasons = [];

                                          if (profileStatus["reason"] != null &&
                                              (profileStatus["reason"] as List)
                                                  .isNotEmpty) {
                                            Map<String, dynamic> reasonMap = {};

                                            reasonMap = profileStatus["reason"]
                                                        [0] !=
                                                    null
                                                ? profileStatus["reason"][0]
                                                    as Map<String, dynamic>
                                                : {};

                                            if (reasonMap
                                                    .containsKey('reason') &&
                                                reasonMap['reason'] != null) {
                                              reasons = (reasonMap['reason']
                                                      as List)
                                                  .map(
                                                      (item) => item.toString())
                                                  .toList();
                                            }
                                          }
                                          Get.to(
                                            transition:
                                                Transition.cupertinoDialog,
                                            () => AppRejectedScreen(
                                              email: profileStatus['email'],
                                              password:
                                                  profileStatus['password'],
                                              reasonReject: reasons,
                                              profileDetails:
                                                  profileStatus ?? {},
                                              userId: profileStatus["id"] ?? "",
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  }
                                });
                              }
                            }

                            // loginController.signInEmail().then((login) async {
                            //   print('bodyMap <<<<<<<==>>$login');
                            //
                            //   if (login != null) {
                            //     await loginController
                            //         .profileStatus(login['logInId'])
                            //         .then((value) async {
                            //       if (value != null) {
                            //         print('bodyMap <<<<<<<==>>$value');
                            //         await SharPreferences.setString(
                            //             SharPreferences.loginId,
                            //             login['logInId'] ?? '');
                            //
                            //         print(
                            //             '>>>>>>>>>>>>>>>>${login['storeCategoryId']}');
                            //         await SharPreferences.setString(
                            //             SharPreferences.accessToken,
                            //             '${login['fcmToken']}' ?? '');
                            //         print(value['applicationStatus']);
                            //         if (value['applicationStatus'] == 'Onboarded') {
                            //           await SharPreferences.setString(
                            //               SharPreferences.storeCategoryId,
                            //               value['storeCategoryId'] ?? '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.storeName,
                            //               value['storeName'] ?? '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.mobileNumber,
                            //               value['phoneNumber'] ?? '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.ownerName,
                            //               value['ownerName'] ?? '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.addressLine1,
                            //               value['storeAddressDetailRequest'][0]
                            //                       ['addressLine1'] ??
                            //                   '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.latitude,
                            //               value['storeAddressDetailRequest'][0]
                            //                       ['latitude'] ??
                            //                   '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.longitude,
                            //               value['storeAddressDetailRequest'][0]
                            //                       ['longitude'] ??
                            //                   '');
                            //           await SharPreferences.setString(
                            //               SharPreferences.storeNumber,
                            //               value['storeNumber'] ?? '');
                            //           await SharPreferences.setBoolean(
                            //               SharPreferences.isLogin, true);
                            //           Get.offAll(() => const HomeScreen(),
                            //               transition: Transition.size);
                            //         } else if (value['applicationStatus'] ==
                            //             'Pending') {
                            //           Get.to(() => AppPendingScreen(),
                            //               transition: Transition.size);
                            //         } else if (value['applicationStatus'] ==
                            //             'Rejected') {
                            //           Get.to(
                            //               () => AppRejectedScreen(
                            //                   email: value['email'],
                            //                   password: value['password'],
                            //                   reasonReject: value['reason'] ?? {}),
                            //               transition: Transition.size);
                            //         }
                            //       }
                            //     });
                            //   }
                            // });
                            // Get.offAll(() => HomeScreen(), transition: Transition.size);
                          },
                        ),
                        // SizedBox(height: height * 0.01),
                        // const Center(child: CommonText(content: 'Or')),
                        // SizedBox(height: height * 0.01),
                        // CommonBorderButton(
                        //   text: 'Continue with OTP',
                        //   onTap: () {
                        //     Get.to(() => MobileNoScreen());
                        //   },
                        // ),
                        SizedBox(height: height * 0.09),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'New to LOCAL ? ',
                              style: GoogleFonts.poppins(
                                  color: ColorsConst.hintColor),
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(() => SignupScreen());
                                    },
                                  style: GoogleFonts.poppins(
                                    color: ColorsConst.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: CommonText(
                            content:
                                'Terms and Conditions applied. Privacy policy',
                            textSize: width * 0.032,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
