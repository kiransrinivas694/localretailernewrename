import 'dart:developer';
import 'dart:io';

import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/dashboard_controller.dart';
import 'package:b2c/screens/auth/login_screen.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/profile_overview_screen.dart';
import 'package:b2c/screens/dashboard_screen/dashboard_screen.dart';
import 'package:b2c/service/remote_config_service.dart';
import 'package:b2c/service/shared_prefrence/prefrence_helper.dart';
import 'package:b2c/service/sse_service_controller.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/categories_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/grb_return_controller/grb_return_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/subscription_controller/subscription_controller_new.dart';
import 'package:store_app_b2b/controllers/confirm_order_controller_new.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/model/subscription_tenure_model_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/buy_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/cart_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/store_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/subscription_screens/subscription_details_screen_new.dart';
import 'package:store_app_b2b/screens/confirm_orders/confirm_orders_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/categories_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';
import '../../model/subscription_popup_response_model_new.dart';
import 'package:b2c/utils/shar_preferences.dart' as b2c_ref;

import 'package:store_app_b2b/utils/shar_preferences_new.dart' as store_app_b2b;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    int this.moveToBottomIndex = 0,
    this.inititalScreen = const SizedBox(),
    this.isRedirectNeed = false,
  }) : super(key: key);

  final int moveToBottomIndex;
  final Widget inititalScreen;
  final bool isRedirectNeed;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogin = false;

  Future<dynamic> getLogin() async {
    await RemoteConfigService.getUpdateConfigValue(mounted, context);

    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    API.campaignImg.forEach((url) => precacheImage(
          NetworkImage(url),
          context,
          onError: (error, stackTrace) {
            print('Image failed to load: $error');
          },
        ));
  }

  void initState() {
    getLogin();
    super.initState();
  }

  final controller = Get.put(HomeController());
  final cartB2bController = Get.put(CartController());
  final nrCartController = Get.put(NrCartController());
  final cartLabTestController = Get.put(CartLabtestController());
  final ConfirmOrderController confirmOrderController =
      Get.put(ConfirmOrderController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
        // init: HomeController(),
        initState: (state) {
      Future.delayed(
        const Duration(microseconds: 0),
        () async {
          final homeController = Get.put(HomeController());
          Future.delayed(
            Duration(seconds: 3),
            () {
              homeController.updateInitialisationInProgress(false);
            },
          );
          final cartController = Get.put(CartController());
          final nrCartController = Get.put(NrCartController());
          PaymentController paymentController = Get.put(PaymentController());
          paymentController.getPaymentRequestDataApi(
              callingFromDashboard: true);
          paymentController.update();
          StoreController controller = Get.put(StoreController());
          // controller.getStoreCategories();
          controller.getVideoBannerTopDataApi();
          controller.getBannerBottomImageDataApi();
          controller.getAccountStatus();

          cartLabTestController.getDiagnosticCartData(homeCollection: "0");
          cartLabTestController.getDiagnosticCartData(homeCollection: "1");

          controller.getLatestOrderApi();
          controller.getStoreCategories();

          final DashboardController dashboardController =
              Get.put(DashboardController());
          dashboardController.getTopBuyingProducts();
          dashboardController.getLtdSalesInfo();
          // final categoriesController = Get.put(CategoriesController());
          // categoriesController.getStoreCategories();
          // await homeController.getInternalPopup();
          await cartController.getUserId();
          await nrCartController.getUserId();
          await cartController.getVerifiedProductDataApi();
          await nrCartController.getVerifiedProductDataApi();
          // cartController.getGRBCart();
          await homeController.getSubscriptionPopup();
          // if (homeController.isShowSubscriptionPopup &&
          //     mounted &&
          //     homeController
          //         .subscriptionPopupResponseModel.content.isNotEmpty) {
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) {
          //       return subscriptionDialog(context);
          //     },
          //   );
          // }
          bool isUserLoggedIn =
              await SharPreferences.getBoolean(SharPreferences.isLogin) ??
                  false;

          if (API.emergencyStop) {
            showDialog(
              context: context,
              barrierDismissible: true,
              useRootNavigator: false,
              builder: (context) {
                return campaignEmergencyDialog(context);
              },
            );
          } else {
            if (API.campaignsShowing && isUserLoggedIn) {
              showDialog(
                context: context,
                // barrierDismissible: false,
                useRootNavigator: false,
                builder: (context) {
                  return campaignDialog(context);
                },
              );
            }
          }

          String expiryDateString = "";

          await controller.mainProfileStatus().then((value) {
            if (controller.storeProfileDetails.value != null &&
                controller.storeProfileDetails.value!.drugLicense != null &&
                controller.storeProfileDetails.value!.drugLicense!.expiryDate !=
                    null) {
              expiryDateString = controller
                  .storeProfileDetails.value!.drugLicense!.expiryDate!;
            }
          });

          // String expiryDateString =
          //     await store_app_b2b.SharPreferences.getString(
          //             store_app_b2b.SharPreferences.drugLicenseExpiry) ??
          //         "";

          print("printing expiryDateString $expiryDateString");

          DateTime? expiryDate;

          if (expiryDateString.isNotEmpty) {
            try {
              expiryDate = DateTime.parse(expiryDateString);
              print("Converted DateTime: $expiryDate");
            } catch (e) {
              print("Error parsing expiryDateString: $e");
            }
          } else {
            print("expiryDateString is empty.");
          }

          if (expiryDate != null) {
            DateTime currentDate = DateTime.now();
            DateTime currentDateWithoutTime =
                DateTime(currentDate.year, currentDate.month, currentDate.day);

            DateTime expiryDateWithoutTime =
                DateTime(expiryDate.year, expiryDate.month, expiryDate.day);

            int differenceInDays =
                expiryDateWithoutTime.difference(currentDateWithoutTime).inDays;

            print(
                "Warning difference in days -> ${currentDate} , ${expiryDate} ${expiryDate!.day}-${expiryDate.month}-${expiryDate.year} ,  ${differenceInDays}");

            if (differenceInDays > 0 && differenceInDays <= 30) {
              print("Warning: Drug license is expiring soon!");

              showDialog(
                context: context,
                // barrierDismissible: ,
                useRootNavigator: false,
                builder: (context) {
                  return expiryLicenseDialog(context,
                      expiringOn: expiryDateString,
                      heading: "Expiry Alert",
                      popupType: "W",
                      content: [
                        "Drug License Expiring On ${expiryDate!.day.toString().padLeft(2, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.year}",
                        "Please contact admin to update the details",
                        "Failure to do so will prevent you from using the app after ${expiryDate.day.toString().padLeft(2, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.year}."
                      ]);
                },
              );
            } else if (differenceInDays <= 0) {
              print("Warning: Drug license has already expired!");

              showDialog(
                context: context,
                // barrierDismissible: ,
                useRootNavigator: false,
                builder: (context) {
                  return expiryLicenseDialog(context,
                      expiringOn: expiryDateString,
                      heading: "Expired",
                      popupType: "D",
                      needGetBack: false,
                      content: [
                        "Drug License Expired On $expiryDateString",
                        "Please contact admin to update the details"
                      ]);
                },
              );
            } else {
              print("Drug license is valid.");
            }
          }

          // if (API.campaignsShowing && isUserLoggedIn) {
          //   showDialog(
          //     context: context,
          //     // barrierDismissible: false,
          //     useRootNavigator: false,
          //     builder: (context) {
          //       return campaignDialog(context);
          //     },
          //   );
          // }

          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) {
          //     return subscriptionMainDialog(context);
          //   },
          // );

          if (homeController.isShowPopup && mounted) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => orderUpdateDialog(homeController));
          }

          if (widget.moveToBottomIndex == 3) {
            homeController.appBarTitle = "Payment";
            homeController.currentIndex = 3;
            homeController.currentWidget = PaymentScreen();
            homeController.update();
          } else {
            homeController.appBarTitle =
                await SharPreferences.getString(SharPreferences.storeName);
            homeController.currentIndex = 0;

            homeController.currentWidget = StoreScreen();
            homeController.update();
          }

          if (widget.isRedirectNeed) {
            Get.to(() => widget.inititalScreen);
          }

          // homeController.appBarTitle =
          //     await SharPreferences.getString(SharPreferences.storeName);
          // homeController.currentIndex = 0;

          // homeController.currentWidget = StoreScreen();
          // homeController.update();
        },
      );
    }, builder: (_) {
      log("logged inside home screen - checking whether index and widget is updated or not");
      log('current index is ${controller.currentIndex}');
      log('current widget is ${controller.currentWidget}');
      return WillPopScope(
        onWillPop: () async {
          // if (controller.currentIndex == 0) {
          //   return true;
          // } else {
          //   controller.appBarTitle =
          //       await SharPreferences.getString(SharPreferences.storeName);
          //   controller.currentIndex = 0;
          //   controller.currentWidget = StoreScreen();
          //   controller.update();

          //   return false;
          // }
          if (controller.currentIndex == 0) {
            // Get.offAll(() => const DashboardScreen());
            return true;
          } else {
            // if (controller.isFromBuyTab) {
            //   controller.isFromBuyTab = false;
            //   controller.appBarTitle = "Buy";
            //   controller.currentIndex = 2;
            //   controller.currentWidget = CategoriesScreen();
            //   controller.update();

            //   return false;
            // }

            controller.appBarTitle =
                await SharPreferences.getString(SharPreferences.storeName);
            controller.currentIndex = 0;
            controller.currentWidget = StoreScreen();
            controller.update();

            return false;
          }
        },
        child: GestureDetector(
          onHorizontalDragEnd: (details) async {
            if (details.velocity.pixelsPerSecond.dx > 50 && Platform.isIOS) {
              if (controller.currentIndex == 0) {
                // Get.offAll(() => const DashboardScreen());
                Get.back();
              } else {
                // if (controller.isFromBuyTab) {
                //   controller.isFromBuyTab = false;
                //   controller.appBarTitle = "Buy";
                //   controller.currentIndex = 2;
                //   controller.currentWidget = CategoriesScreen();
                //   controller.update();

                //   // return false;
                //   return;
                // }

                controller.appBarTitle =
                    await SharPreferences.getString(SharPreferences.storeName);
                controller.currentIndex = 0;
                controller.currentWidget = StoreScreen();
                controller.update();

                // return false;
              }
            }
          },
          child: SafeArea(
              child: Stack(
            children: [
              Scaffold(
                // key: controller.key,
                backgroundColor: ColorsConst.bgColor,
                appBar: AppBar(
                  centerTitle: (controller.currentIndex != 0) ? true : false,
                  title: FutureBuilder<String>(
                    future:
                        SharPreferences.getString(SharPreferences.storeName),
                    builder: (_, data) {
                      return CommonText(
                        content: controller.appBarTitle,
                        boldNess: FontWeight.w600,
                        textSize: 14,
                      );
                    },
                  ),
                  automaticallyImplyLeading: false,
                  leading: controller.currentIndex == 0 ||
                          controller.currentIndex == 4
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () async {
                            // if (controller.isFromBuyTab) {
                            //   controller.isFromBuyTab = false;
                            //   controller.appBarTitle = await "Buy";
                            //   controller.currentIndex = 2;
                            //   controller.currentWidget = CategoriesScreen();
                            //   controller.update();
                            //   return;
                            // }

                            controller.appBarTitle =
                                await SharPreferences.getString(
                                    SharPreferences.storeName);
                            controller.currentIndex = 0;
                            controller.currentWidget = StoreScreen();
                            controller.update();
                          },
                        ),
                  elevation: 0,
                  actions: [
                    if (controller.currentIndex == 0)
                      !isLogin
                          ? const SizedBox()
                          : InkWell(
                              onTap: () async {
                                // showDialog(
                                //   context: context,
                                //   // barrierDismissible: ,
                                //   useRootNavigator: false,
                                //   builder: (context) {
                                //     return expiryLicenseDialog(context,
                                //         expiringOn: "2025-01-29",
                                //         heading: "Expired",
                                //         popupType: "D",
                                //         needGetBack: false,
                                //         content: [
                                //           "Drug License Expiring On 2025-01-29",
                                //           "Please update details in profile section before the expiry date to continue using local retailer app"
                                //         ]);
                                //   },
                                // );

                                // return;
                                Get.dialog(
                                  Dialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: AppColors.primaryColor,
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: width / 2,
                                            child: CommonText(
                                              content:
                                                  "Are you sure you want to logout?",
                                              textSize: width * 0.04,
                                              textColor: Colors.white,
                                              boldNess: FontWeight.w500,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          side: const BorderSide(
                                                              color: AppColors
                                                                  .appWhite)),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 0),
                                                    child: CommonText(
                                                      content: "Back",
                                                      textSize: width * 0.035,
                                                      textColor:
                                                          AppColors.appWhite,
                                                      boldNess: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    // Get.back();
                                                    String storedUserVersion =
                                                        await store_app_b2b
                                                                    .SharPreferences
                                                                .getString(store_app_b2b
                                                                    .SharPreferences
                                                                    .versionNumber) ??
                                                            "";

                                                    // String videoWatchedDate =
                                                    //     await SharPreferences.getString(
                                                    //             SharPreferences.videoWatchedDate) ??
                                                    //         "";
                                                    // int videoWatchedCount = await SharPreferences.getInt(
                                                    // SharPreferences.videoWatchedCount) ??
                                                    // 0;

                                                    await SharPreferences
                                                        .clearSharPreference();
                                                    await b2c_ref
                                                            .SharPreferences
                                                        .clearSharPreference();
                                                    await PreferencesHelper()
                                                        .clearPreferenceData();

                                                    // await SharPreferences.setString(
                                                    //     SharPreferences.videoWatchedDate,
                                                    //     videoWatchedDate);
                                                    // await SharPreferences.setInt(
                                                    //     SharPreferences.videoWatchedCount,
                                                    //     videoWatchedCount);

                                                    await store_app_b2b
                                                            .SharPreferences
                                                        .setString(
                                                            store_app_b2b
                                                                .SharPreferences
                                                                .versionNumber,
                                                            storedUserVersion);
                                                    Get.delete<
                                                        StoreController>();
                                                    SSEService sseController =
                                                        Get.put(SSEService());
                                                    sseController
                                                        .disconnectSSE();
                                                    Get.offAll(() =>
                                                        const LoginScreen());
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 0),
                                                    child: CommonText(
                                                      content: "Yes",
                                                      textSize: width * 0.035,
                                                      textColor: AppColors
                                                          .primaryColor,
                                                      boldNess: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                return;
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 7),
                                    SvgPicture.asset('assets/icons/logout.svg',
                                        fit: BoxFit.cover),
                                    const AppText(
                                      'Logout',
                                      fontSize: 12,
                                    )
                                  ],
                                ),
                              ),
                            ),
                    // Switch(
                    //   value: true,
                    //   onChanged: (value) =>
                    //       Get.offAll(() => const DashboardScreen()),
                    //   activeColor: ColorsConst.primaryColor,
                    //   inactiveThumbColor: ColorsConst.textColor,
                    // ),
                    // if(controller.currentIndex == 0 || controller.currentIndex == 3)
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10),
                    //   child: InkWell(
                    //     onTap: () async {
                    //       // if (controller.currentIndex == 4) {
                    //       //   await SharPreferences.clearSharPreference();
                    //       //   await PreferencesHelper().clearPreferenceData();
                    //       // }
                    //       /*controller.currentIndex == 4
                    //                 ? Get.to(() => LoginScreen())
                    //                 : */
                    //       Get.to(() => const NotificationScreen());
                    //     },
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         /*controller.currentIndex == 4
                    //                   ? const Icon(Icons.logout)
                    //                   : */
                    //         Image.asset(
                    //           "assets/icons/notification.png",
                    //           scale: 5,
                    //           package: 'store_app_b2b',
                    //         ),
                    //         CommonText(
                    //           content: /*controller.currentIndex == 4
                    //                     ? "Logout"
                    //                     : */
                    //           "Notification",
                    //           textSize: width * 0.03,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff2F394B),
                          Color(0xff090F1A),
                        ],
                      ),
                    ),
                  ),
                ),
                body: controller.currentWidget,
                bottomNavigationBar: Stack(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: ColorsConst.semiGreyColor.withOpacity(0.2),
                            offset: const Offset(0, -5),
                            blurRadius: 5,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final StoreController storeController =
                                      Get.put(StoreController());
                                  storeController.getAccountStatus();
                                  controller.clearBottomBarValues();
                                  controller.appBarTitle =
                                      await SharPreferences.getString(
                                          SharPreferences.storeName);
                                  controller.currentIndex = 0;
                                  controller.currentWidget = StoreScreen();
                                  controller.update();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      controller.currentIndex == 0
                                          ? "assets/icons/bottom_icons/home_select_icon.png"
                                          : "assets/icons/bottom_icons/home_unselect_icon.png",
                                      scale: 4,
                                    ),
                                    CommonText(
                                      content: "Home",
                                      textSize: width * 0.032,
                                      textColor: controller.currentIndex == 0
                                          ? ColorsConst.primaryColor
                                          : ColorsConst.semiGreyColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final StoreController storeController =
                                      Get.put(StoreController());
                                  storeController.getAccountStatus();
                                  controller.clearBottomBarValues();
                                  controller.appBarTitle = "Cart";
                                  controller.currentIndex = 1;
                                  controller.currentWidget = CartScreen();
                                  controller.update();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Badge(
                                      backgroundColor: Colors.transparent,
                                      padding: const EdgeInsets.only(right: 5),
                                      label: GetX<CartController>(
                                        // init: CartController(),
                                        builder: (controller) {
                                          print(
                                              'bottom check 1 -> ${cartLabTestController.diagnosticCartTests.isEmpty && controller.cartListModel != null && controller.cartListModel!.storeVo.isNotEmpty && controller.cartListModel!.storeVo[0].items.isEmpty}');

                                          print(
                                              'bottom check 2 -> ${cartLabTestController.diagnosticCartTests.isEmpty && (controller.cartListModel == null || controller.cartListModel!.storeVo.isEmpty || controller.cartListModel!.storeVo[0].items.isEmpty)}');
                                          int grbLength = 0;

                                          if (controller.grbCartDetails !=
                                                  null &&
                                              controller.grbCartDetails!
                                                      .storeVo !=
                                                  null &&
                                              controller.grbCartDetails!
                                                  .storeVo!.isNotEmpty &&
                                              controller.grbCartDetails!
                                                      .storeVo![0].items !=
                                                  null) {
                                            grbLength = controller
                                                .grbCartDetails!
                                                .storeVo![0]
                                                .items!
                                                .length;
                                          }

                                          if (cartLabTestController.diagnosticCartTests.isEmpty &&
                                              cartLabTestController
                                                  .diagnosticHomeTests
                                                  .isEmpty &&
                                              controller.productTotal.value ==
                                                  0 &&
                                              nrCartController
                                                      .productTotal.value ==
                                                  0 &&
                                              controller.grbTotalLength.value ==
                                                  0) {
                                            return const SizedBox();
                                          }
                                          return Container(
                                            height: 15,
                                            width: 20,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: ColorsConst.primaryColor,
                                                shape: BoxShape.circle),
                                            child: Obx(
                                              () => CommonText(
                                                content:
                                                    '${cartLabTestController.diagnosticCartTests.length + (cartLabTestController.diagnosticHomeTests.length) + (controller.productTotal.value) + (nrCartController.productTotal.value) + controller.grbTotalLength.value}',
                                                textSize: 8,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      child: Image.asset(
                                        controller.currentIndex == 1
                                            ? "assets/icons/bottom_icons/cart_select_icon.png"
                                            : "assets/icons/bottom_icons/cart_unselect_icon.png",
                                        scale: 4,
                                        package: 'store_app_b2b',
                                      ),
                                    ),
                                    CommonText(
                                      content: "Cart",
                                      textSize: width * 0.032,
                                      textColor: controller.currentIndex == 1
                                          ? ColorsConst.primaryColor
                                          : ColorsConst.semiGreyColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const SizedBox(
                                    height: 60,
                                    width: 60,
                                  ),
                                  Positioned(
                                    top: -20,
                                    right: 0,
                                    left: 0,
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.clearBottomBarValues();
                                          controller.appBarTitle = "Buy";
                                          controller.currentIndex = 2;
                                          final StoreController
                                              storeController =
                                              Get.put(StoreController());

                                          controller.currentWidget =
                                              BuyScreen(categoryId: "all");

                                          HomeController hController =
                                              Get.put(HomeController());

                                          hController.appBarTitle = "Buy";

                                          // controller.currentWidget = BuyScreen(
                                          //     categoryId: API
                                          //         .generalMedicineCategoryId);
                                          // controller.currentWidget =
                                          //     CategoriesScreen();
                                          // controller.update();
                                        },
                                        child: Center(
                                          child: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorsConst
                                                      .semiGreyColor
                                                      .withOpacity(
                                                          0.3), // darker color
                                                ),
                                                const BoxShadow(
                                                  color: Colors.white,
                                                  // background color
                                                  spreadRadius: -3.0,
                                                  offset: Offset(2, 1),
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  controller.currentIndex == 2
                                                      ? "assets/icons/bottom_icons/buy_select_icon.png"
                                                      : "assets/icons/bottom_icons/buy_unselect_icon.png",
                                                  scale: 4.5,
                                                  package: 'store_app_b2b',
                                                ),
                                                CommonText(
                                                  content: "Buy",
                                                  textSize: width * 0.026,
                                                  textColor: controller
                                                              .currentIndex ==
                                                          2
                                                      ? ColorsConst.primaryColor
                                                      : ColorsConst
                                                          .semiGreyColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  PaymentController paymentController =
                                      Get.put(PaymentController());
                                  paymentController.storeCreditRating = null;
                                  paymentController.update();
                                  controller.clearBottomBarValues();
                                  controller.appBarTitle = "Payment";
                                  controller.currentIndex = 3;
                                  controller.currentWidget = PaymentScreen();
                                  controller.update();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      controller.currentIndex == 3
                                          ? "assets/icons/bottom_icons/payment_select_icon.png"
                                          : "assets/icons/bottom_icons/payment_unselect_icon.png",
                                      scale: 4,
                                      package: 'store_app_b2b',
                                    ),
                                    CommonText(
                                      content: "Payment",
                                      textSize: width * 0.032,
                                      textColor: controller.currentIndex == 3
                                          ? ColorsConst.primaryColor
                                          : ColorsConst.semiGreyColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  controller.clearBottomBarValues();
                                  controller.appBarTitle =
                                      await SharPreferences.getString(
                                          SharPreferences.storeName);
                                  controller.currentIndex = 4;
                                  controller.currentWidget =
                                      const ProfileOverViewScreen();
                                  controller.update();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      controller.currentIndex == 4
                                          ? "assets/icons/bottom_icons/profile_select_icon.png"
                                          : "assets/icons/bottom_icons/profile_unselect_icon.png",
                                      scale: 4,
                                      package: 'store_app_b2b',
                                    ),
                                    CommonText(
                                      content: "Profile",
                                      textSize: width * 0.032,
                                      textColor: controller.currentIndex == 4
                                          ? ColorsConst.primaryColor
                                          : ColorsConst.semiGreyColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.initialisationInProgress)
                Positioned(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
            ],
          )),
        ),
      );
    });
  }

  Widget expiryLicenseDialog(BuildContext,
      {required String expiringOn,
      String popupType = "W",
      required String heading,
      bool needGetBack = true,
      required List<String> content}) {
    // W - Warning , D - Danger

    print("checking campaignsShowing in dialog --> ${API.campaignImg}");
    Color sideContColor = Color.fromRGBO(253, 205, 15, 1);

    if (popupType == "D") {
      sideContColor = Color.fromRGBO(240, 67, 73, 1);
    }
    return WillPopScope(
      onWillPop: () async {
        return needGetBack;
      },
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),

            width: MediaQuery.of(context).size.width * 0.9,
            // height: 200,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    // height: double.infinity,
                    width: 10,
                    decoration: BoxDecoration(
                      color: sideContColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10),
                            Icon(
                              Icons.info,
                              size: 30,
                              color: sideContColor,
                            ),
                            Gap(10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      content: heading,
                                      textColor: AppColors.textBlackColor,
                                      boldNess: FontWeight.bold,
                                      textSize: 18,
                                    ),
                                    Gap(10),
                                    ...content.map((content) {
                                      return CommonText(
                                        content: content,
                                        textColor: Color(0xff6C7D7D),
                                        textSize: 14,
                                      );
                                    }).toList(),
                                    Gap(10),
                                    //   Row(
                                    //     children: [
                                    //       // GestureDetector(
                                    //       //   onTap: () {
                                    //       //     Get.to(() =>
                                    //       //         const ProfileOverViewScreen());
                                    //       //   },
                                    //       //   child: CommonText(
                                    //       //     content: "Update",
                                    //       //     boldNess: FontWeight.w900,
                                    //       //     textColor: sideContColor,
                                    //       //   ),
                                    //       // ),
                                    //       // Gap(20),
                                    //       if (popupType == "D")
                                    //         GestureDetector(
                                    //           onTap: () async {
                                    //             String storedUserVersion =
                                    //                 await store_app_b2b
                                    //                             .SharPreferences
                                    //                         .getString(store_app_b2b
                                    //                             .SharPreferences
                                    //                             .versionNumber) ??
                                    //                     "";

                                    //             // String videoWatchedDate =
                                    //             //     await SharPreferences.getString(
                                    //             //             SharPreferences.videoWatchedDate) ??
                                    //             //         "";
                                    //             // int videoWatchedCount = await SharPreferences.getInt(
                                    //             // SharPreferences.videoWatchedCount) ??
                                    //             // 0;

                                    //             await SharPreferences
                                    //                 .clearSharPreference();
                                    //             await b2c_ref.SharPreferences
                                    //                 .clearSharPreference();
                                    //             await PreferencesHelper()
                                    //                 .clearPreferenceData();

                                    //             // await SharPreferences.setString(
                                    //             //     SharPreferences.videoWatchedDate,
                                    //             //     videoWatchedDate);
                                    //             // await SharPreferences.setInt(
                                    //             //     SharPreferences.videoWatchedCount,
                                    //             //     videoWatchedCount);

                                    //             await store_app_b2b
                                    //                     .SharPreferences
                                    //                 .setString(
                                    //                     store_app_b2b
                                    //                         .SharPreferences
                                    //                         .versionNumber,
                                    //                     storedUserVersion);
                                    //             Get.delete<StoreController>();
                                    //             Get.offAll(
                                    //                 () => const LoginScreen());
                                    //           },
                                    //           child: CommonText(
                                    //             content: "Logout",
                                    //             boldNess: FontWeight.w900,
                                    //             textColor: Color(0xff6C7D7D),
                                    //           ),
                                    //         ),
                                    //     ],
                                    //   )
                                  ],
                                ),
                              ),
                            ),
                            Gap(10),
                            if (needGetBack)
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                              ),
                            Gap(10),
                          ],
                        ),
                        Gap(20),

                        // Icon(
                        //   Icons.error,
                        //   size: 70,
                        //   color: AppColors.primaryColor,
                        // ),
                        // Gap(10),
                        // CommonText(
                        //   content: "Drug License Expiring On $expiringOn",
                        //   textColor: AppColors.primaryColor,
                        // ),
                        // Gap(20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget campaignEmergencyDialog(BuildContext) {
    print("checking campaignsShowing in dialog --> ${API.campaignImg}");
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.network(
            API.emergencyStopImg, // Image loaded from a network URL
            width: MediaQuery.of(context).size.width *
                0.9, // Image width is 90% of screen width
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Image is fully loaded
                return child;
              } else {
                // Image is still loading, show CircularProgressIndicator
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget campaignDialog(BuildContext) {
    print("checking campaignsShowing in dialog --> ${API.campaignImg}");
    HomeController homeCc = Get.put(HomeController());
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GetBuilder<HomeController>(builder: (controller) {
        // API.campaignImg
        //     .forEach((url) => precacheImage(NetworkImage(url), context));
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: API.campaignImg[controller.currentBanner],
                            placeholder: (context, url) {
                              return Container(
                                // height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            placeholderFadeInDuration: Duration.zero,
                          )),
                      Positioned(
                          top: -10,
                          right: -10,
                          child: GestureDetector(
                            onTap: () {
                              // Get.back();
                              if (controller.currentBanner ==
                                  API.campaignImg.length - 1) {
                                Get.back();
                                return;
                              }

                              controller.setHomeBuyBanner();
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: AppColors.appWhite,
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 25,
                                  weight: 2.0,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  SizedBox()
                ],
              ),
            ),
            // child: ListView.separated(
            //   itemCount: API.campaignImg.length,
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       child: Image.network(
            //         API.campaignImg[index],
            //         width: MediaQuery.of(context).size.width * 0.9,
            //         loadingBuilder: (context, child, loadingProgress) {
            //           if (loadingProgress == null) {
            //             return child;
            //           } else {
            //             return Center(
            //               child: CircularProgressIndicator(),
            //             );
            //           }
            //         },
            //       ),
            //     );
            //   },
            //   separatorBuilder: (context, index) {
            //     return SizedBox(
            //       height: 10,
            //     );
            //   },
            // ),
          ),
        );
      }),
    );
  }

  Widget subscriptionDialog(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: AlertDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 3),
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.keyboard_arrow_left_outlined,
                        size: 40, color: ColorsConst.primaryColor),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(top: 10),
                  //     child: CommonText(
                  //       content: subscriptionDetail.planType,
                  //       textSize: 20,
                  //       textColor: ColorsConst.primaryColor,
                  //       boldNess: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.62,
              width: MediaQuery.of(context).size.width,
              child: (controller.subscriptionPopupResponseModel.content.isEmpty)
                  ? Center(
                      child: CommonText(
                        content: 'No plans are available',
                        textColor: ColorsConst.primaryColor,
                        boldNess: FontWeight.w500,
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Image.asset(
                          'assets/image/subscription.png',
                          fit: BoxFit.contain,
                          height: 190.08,
                          width: 228.04,
                          package: 'store_app_b2b',
                        ),
                        const SizedBox(height: 10),
                        CommonText(
                            content: 'Subscription',
                            textSize: 18,
                            textColor: ColorsConst.primaryColor,
                            boldNess: FontWeight.w600,
                            textAlign: TextAlign.center),
                        CommonText(
                            content:
                                'Please purchase a subscription to use the app',
                            textSize: 12,
                            textColor: ColorsConst.greyTextColor,
                            boldNess: FontWeight.w500,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 145,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller
                                .subscriptionPopupResponseModel.content.length,
                            itemBuilder: (context, index) {
                              Content subscription = controller
                                  .subscriptionPopupResponseModel
                                  .content[index];
                              return GestureDetector(
                                onTap: () =>
                                    controller.selectSubscriptionPlan(index),
                                child: Container(
                                  width: 120,
                                  height: 140,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          width: 152,
                                          height: 136,
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: (controller
                                                              .selectedSubscriptionIndex ==
                                                          index)
                                                      ? ColorsConst.primaryColor
                                                      : const Color(
                                                          0xffD1D1D1))),
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CommonText(
                                                content:
                                                    '₹${subscription.planRate}/-',
                                                textSize: 20,
                                                boldNess: FontWeight.w600,
                                                textColor: (controller
                                                            .selectedSubscriptionIndex ==
                                                        index)
                                                    ? ColorsConst.primaryColor
                                                    : Colors.black,
                                              ),
                                              CommonText(
                                                content:
                                                    '${subscription.planType}',
                                                textSize: 14,
                                                boldNess: FontWeight.w600,
                                                textColor: (controller
                                                            .selectedSubscriptionIndex ==
                                                        index)
                                                    ? ColorsConst.primaryColor
                                                    : Colors.black,
                                              ),
                                              CommonText(
                                                content: subscription.features
                                                    .join(','),
                                                textSize: 10,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                boldNess: FontWeight.w500,
                                                textColor: (controller
                                                            .selectedSubscriptionIndex ==
                                                        index)
                                                    ? ColorsConst.primaryColor
                                                    : const Color(0xff8F8F8F),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (controller
                                              .selectedSubscriptionIndex ==
                                          index)
                                        Positioned(
                                            child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            height: 20,
                                            width: 54,
                                            decoration: BoxDecoration(
                                              color: ColorsConst.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(44),
                                            ),
                                            alignment: Alignment.center,
                                            child: const CommonText(
                                                content: 'Preferred ',
                                                textSize: 8,
                                                textColor: Colors.white,
                                                boldNess: FontWeight.w500),
                                          ),
                                        )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            controller.getRazorPayDataApi(
                              int.parse(
                                  '${controller.subscriptionPopupResponseModel.content[controller.selectedSubscriptionIndex].planRate}00'),
                              controller
                                      .subscriptionPopupResponseModel
                                      .content[
                                          controller.selectedSubscriptionIndex]
                                      .id ??
                                  '',
                            );
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(44),
                                color: ColorsConst.primaryColor),
                            child: CommonText(
                                content:
                                    'Get Subscription / ₹${controller.subscriptionPopupResponseModel.content[controller.selectedSubscriptionIndex].planRate}',
                                textSize: 12,
                                boldNess: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget subscriptionMainDialog(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      init: SubscriptionController(),
      initState: (state) {
        Future.delayed(
          Duration(microseconds: 150),
          () {
            SubscriptionController controller =
                Get.find<SubscriptionController>();
            controller.getPlanTenures();
          },
        );
      },
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: AlertDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 3),
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            // title: Align(
            //   alignment: Alignment.centerLeft,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Get.back();
            //           Get.back();
            //         },
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         icon: Icon(Icons.keyboard_arrow_left_outlined,
            //             size: 40, color: ColorsConst.primaryColor),
            //       ),
            //       // Expanded(
            //       //   child: Padding(
            //       //     padding: EdgeInsets.only(top: 10),
            //       //     child: CommonText(
            //       //       content: subscriptionDetail.planType,
            //       //       textSize: 20,
            //       //       textColor: ColorsConst.primaryColor,
            //       //       boldNess: FontWeight.w700,
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.83,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CommonText(
                    content: 'Subscriptions',
                    textColor: ColorsConst.primaryColor,
                    boldNess: FontWeight.w600,
                    textSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: ColorsConst.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonText(
                    content: 'Please purchase a subscription to use the app',
                    textColor: ColorsConst.appblack54,
                    boldNess: FontWeight.w500,
                    textSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 50,
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.plansPhases.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              controller.changePlanPhase(index);
                              controller.getPlansByTenure(
                                  controller.plansPhases[index]);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: index ==
                                            controller.selectedPlanPhaseIndex
                                        ? Colors.transparent
                                        : Color.fromRGBO(255, 122, 0, 1)),
                                color:
                                    index == controller.selectedPlanPhaseIndex
                                        ? Color.fromRGBO(255, 122, 0, 1)
                                        : Colors.transparent,
                              ),
                              child: Center(
                                child: CommonText(
                                  content: controller.plansPhases[index],
                                  textColor:
                                      index == controller.selectedPlanPhaseIndex
                                          ? Colors.white
                                          : Color.fromRGBO(255, 122, 0, 1),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 375,
                    width: double.infinity,
                    child: ListView.separated(
                      itemCount: controller.subscriptionPlansList.length,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.only(
                                // top: index == 0 ? 10 : 0,
                                // bottom: index == 3 ? 20 : 0,
                                ),
                            child: SubscriptionDetailCard(context,
                                planIndex: index,
                                controller: controller,
                                planCollection:
                                    controller.subscriptionPlansList[index],
                                colorCollection: index >= 4
                                    ? controller.planCardColorsCollection[0]
                                    : controller
                                        .planCardColorsCollection[index]));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border:
                            Border.all(color: Color.fromRGBO(255, 122, 0, 1))),
                    child: Center(
                      child: CommonText(
                        content: "Free Trial for 7-day",
                        textColor: Color.fromRGBO(255, 122, 0, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SubscriptionDetailsScreen());
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorsConst.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CommonText(
                          content: 'Go for Subscription',
                          textColor: ColorsConst.appWhite,
                          boldNess: FontWeight.w600,
                          textSize: 16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget SubscriptionDetailCard(BuildContext context,
      {required colorCollection,
      required int? planIndex,
      required SubscriptionTenureModel? planCollection,
      required SubscriptionController? controller}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17),
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: colorCollection["backgroundGradient"],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planCollection?.planType ?? "",
                      style: GoogleFonts.poppins(
                        color: colorCollection["planHeadingColor"],
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Benefits Include",
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(113, 113, 113, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '₹${planCollection?.planRate}',
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(38, 38, 38, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '/${planCollection?.planTenure}',
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(38, 38, 38, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            itemCount: planCollection?.features.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? colorCollection["firstBenefitColor"]
                          : Color.fromRGBO(75, 75, 75, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CommonText(
                      content: planCollection?.features[index],
                      textColor: index == 0
                          ? colorCollection["firstBenefitColor"]
                          : Color.fromRGBO(75, 75, 75, 1),
                      boldNess: FontWeight.w500,
                      textSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              controller?.selectedSubscriptionIndex = planIndex!;
              controller?.update();
              print(
                  "printing -- parse int planrate --> ${int.parse('${controller?.subscriptionPlansList[controller.selectedSubscriptionIndex].planRate}')}");
              print(
                  "printing -- parse int id ---> ${controller!.subscriptionPlansList[controller.selectedSubscriptionIndex].id ?? ''}");

              if (controller
                          .subscriptionPlansList[
                              controller.selectedSubscriptionIndex]
                          .paymentFlg ==
                      "Y" ||
                  controller
                          .subscriptionPlansList[
                              controller.selectedSubscriptionIndex]
                          .paymentFlg ==
                      null) {
                controller.getRazorPayDataApi(
                  int.parse(
                      '${controller.subscriptionPlansList[controller.selectedSubscriptionIndex].planRate}00'),
                  controller
                          .subscriptionPlansList[
                              controller.selectedSubscriptionIndex]
                          .id ??
                      '',
                );
              } else {
                controller.getSubscriptionSubscribe(
                    transactionId: "nopaymentid_NIUaoI4cdZZjGE");
              }
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                // height: 40,
                width: 100,
                padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                decoration: BoxDecoration(
                  color: ColorsConst.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CommonText(
                    content: 'Subscribe',
                    textColor: ColorsConst.appWhite,
                    boldNess: FontWeight.w600,
                    textSize: 14,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget subscriptionFreeTrialExpiredDialog(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: AlertDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 3),
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            // title: Align(
            //   alignment: Alignment.centerLeft,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Get.back();
            //           Get.back();
            //         },
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         icon: Icon(Icons.keyboard_arrow_left_outlined,
            //             size: 40, color: ColorsConst.primaryColor),
            //       ),
            //       // Expanded(
            //       //   child: Padding(
            //       //     padding: EdgeInsets.only(top: 10),
            //       //     child: CommonText(
            //       //       content: subscriptionDetail.planType,
            //       //       textSize: 20,
            //       //       textColor: ColorsConst.primaryColor,
            //       //       boldNess: FontWeight.w700,
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.79,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CommonText(
                    content: 'Subscriptions',
                    textColor: ColorsConst.primaryColor,
                    boldNess: FontWeight.w600,
                    textSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: ColorsConst.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonText(
                    content: 'Please purchase a subscription to use the app',
                    textColor: ColorsConst.appblack54,
                    boldNess: FontWeight.w500,
                    textSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Image.asset(
                    'assets/image/subscription_completed.png',
                    fit: BoxFit.contain,
                    height: 210,
                    width: 249,
                    package: 'store_app_b2b',
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                  CommonText(
                    content: 'Your 10-Days Free Trial is Completed',
                    textColor: ColorsConst.primaryColor,
                    boldNess: FontWeight.w500,
                    textSize: 20,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  CommonText(
                    content:
                        'Please Explore Our Tailormade Subscriptions Plans.',
                    textColor: ColorsConst.appblack54,
                    boldNess: FontWeight.w500,
                    textSize: 18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorsConst.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CommonText(
                        content: 'Go for Subscription',
                        textColor: ColorsConst.appWhite,
                        boldNess: FontWeight.w600,
                        textSize: 16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget subscriptionExpiredDialog(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: AlertDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 3),
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            // title: Align(
            //   alignment: Alignment.centerLeft,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Get.back();
            //           Get.back();
            //         },
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         icon: Icon(Icons.keyboard_arrow_left_outlined,
            //             size: 40, color: ColorsConst.primaryColor),
            //       ),
            //       // Expanded(
            //       //   child: Padding(
            //       //     padding: EdgeInsets.only(top: 10),
            //       //     child: CommonText(
            //       //       content: subscriptionDetail.planType,
            //       //       textSize: 20,
            //       //       textColor: ColorsConst.primaryColor,
            //       //       boldNess: FontWeight.w700,
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.79,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CommonText(
                    content: 'Subscriptions',
                    textColor: ColorsConst.primaryColor,
                    boldNess: FontWeight.w600,
                    textSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: ColorsConst.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonText(
                    content: 'Please purchase a subscription to use the app',
                    textColor: ColorsConst.appblack54,
                    boldNess: FontWeight.w500,
                    textSize: 12,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Image.asset(
                    'assets/image/subscription_expired.png',
                    fit: BoxFit.contain,
                    height: 210,
                    width: 249,
                    package: 'store_app_b2b',
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                  CommonText(
                    content: 'Your Subscription \n has Expired',
                    textColor: Color.fromRGBO(248, 44, 44, 1),
                    boldNess: FontWeight.w500,
                    textSize: 20,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  CommonText(
                    content:
                        'Please Explore Our Tailormade Subscriptions Plans.',
                    textColor: ColorsConst.appblack54,
                    boldNess: FontWeight.w500,
                    textSize: 18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorsConst.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CommonText(
                        content: 'Go for Subscription',
                        textColor: ColorsConst.appWhite,
                        boldNess: FontWeight.w600,
                        textSize: 16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget orderUpdateDialog(HomeController homeController) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        Get.back();
        return false;
      },
      child: Dialog(
        backgroundColor: const Color(0xffFBFBFB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            children: [
              const SizedBox(height: 15),
              Image.asset('assets/image/dialog_image.png',
                  package: 'store_app_b2b', scale: 4.5, fit: BoxFit.cover),
              const SizedBox(height: 10),
              CommonText(
                content:
                    homeController.internalPopUpResponseModel.message ?? '',
                textColor: Colors.black,
                textAlign: TextAlign.center,
                boldNess: FontWeight.w700,
                textSize: 14,
              ),
              const SizedBox(height: 5),
              CommonText(
                content:
                    '${DateFormat('E MMM d HH:mm:ss y').format(DateTime.now())}',
                textColor: const Color(0xffBAA89C),
                textAlign: TextAlign.center,
                boldNess: FontWeight.w500,
                textSize: 12,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => homeController.updateInternalPopup(
                    orderId:
                        homeController.internalPopUpResponseModel.orderId ?? '',
                    id: homeController.internalPopUpResponseModel.id ?? '',
                    value: 'Y'),
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorsConst.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: const CommonText(
                    content: 'Yes',
                    boldNess: FontWeight.w600,
                    textSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  homeController.updateInternalPopup(
                      orderId:
                          homeController.internalPopUpResponseModel.orderId ??
                              "",
                      id: homeController.internalPopUpResponseModel.id ?? '',
                      value: 'N');
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffFF5449),
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: const CommonText(
                    content: 'No',
                    boldNess: FontWeight.w600,
                    textSize: 16,
                    textColor: Color(0xffFF5449),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomCampaignDialog extends StatefulWidget {
//   const CustomCampaignDialog({super.key});

//   @override
//   State<CustomCampaignDialog> createState() => _CustomCampaignDialogState();
// }

// class _CustomCampaignDialogState extends State<CustomCampaignDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: AlertDialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.symmetric(horizontal: 0),
//         contentPadding: EdgeInsets.zero,
//         content: Container(
//           decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(10)),
//           height: 400,
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: Image.network(
//             API.campaignImg,
//             fit: BoxFit.contain,
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) {
//                 // Image is fully loaded
//                 return child;
//               } else {
//                 // Image is still loading, show CircularProgressIndicator
//                 return Center(
//                   child: CircularProgressIndicator(
//                       // value: loadingProgress.expectedTotalBytes != null
//                       //     ? loadingProgress.cumulativeBytesLoaded /
//                       //         (loadingProgress.expectedTotalBytes ?? 1)
//                       //     : null,
//                       ),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
