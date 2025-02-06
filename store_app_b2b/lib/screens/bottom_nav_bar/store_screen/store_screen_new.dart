import 'dart:math';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/dashboard_controller.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/service/api_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/entry_note_controller/entry_note_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller_new.dart';
import 'package:store_app_b2b/controllers/confirm_order_controller_new.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/delegate/height_delegate_new.dart';
import 'package:store_app_b2b/model/expiry_products_info_model_new.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/screens/appointments/appointments_screen.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/my_bookings_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_my_booking_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_screen.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/generic_medicine_screen/generic_medicine_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/spp_screen/spp_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/bar_graph_creditRating_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/brands/brands_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/buy_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/unlisted_prodcut/unlisted_products_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/coming_soon_screens/lucid_soon_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/credit_note_screens/credit_note_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/custom_bar_graph_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/entry_note_screen/entry_note_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/grb_module/expiry_products_info_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/grb_module/grb_products_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/grb_order_history_screens/grb_order_history_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/inventory_screen/inventory_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/network_retailer_list_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/order_history_screens/order_details_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/order_history_screens/order_history_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/order_status_screens/order_status_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_delivery_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_place_payment_screen/quick_place_payment_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/subscription_screens/subscription_details_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/subscription_screens/subscription_history_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/supplier_screen/suppliers_screen_new.dart';
import 'package:store_app_b2b/screens/coming_soon_screens/a_to_z_soon_screen_new.dart';
import 'package:store_app_b2b/screens/coming_soon_screens/unlisted_soon_screen_new.dart';
import 'package:store_app_b2b/screens/confirm_orders/confirm_orders_screen_new.dart';
import 'package:store_app_b2b/screens/home/notification_screen_new.dart';
import 'package:store_app_b2b/screens/home/home_screen_new.dart' as home;
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/widget/app_html_text_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';
import 'package:store_app_b2b/widget/video_player_widget.dart';
import 'package:ntp/ntp.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _checked = false;

  var isLogin = false;

  Future<dynamic> getLogin() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    setState(() {});
  }

  void initState() {
    getLogin();
    super.initState();

    // _controller.addListener(() {
    //   setState(() {
    //     if (_controller.value) {
    //       _checked = true;
    //     } else {
    //       _checked = false;
    //     }
    //   });
    // });
  }

  final StoreController storeController = Get.put(StoreController());

  final GlobalMainController gmController = Get.find<GlobalMainController>();

  final DashboardController dashboardController =
      Get.put(DashboardController());

  final PaymentController paymentController = Get.put(PaymentController());
  final ConfirmOrderController confirmOrderController =
      Get.put(ConfirmOrderController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<StoreController>(
        init: StoreController(),
        initState: (state) {
          Future.delayed(
            const Duration(milliseconds: 250),
            () async {
              storeController.mainProfileStatus();
              bool isUserLoggedIn =
                  await SharPreferences.getBoolean(SharPreferences.isLogin) ??
                      false;

              if (isUserLoggedIn) {
                await confirmOrderController.getInternalPopup();

                if (confirmOrderController
                    .internalPopUpResponseModel1.isNotEmpty) {
                  Get.to(() => const ConfirmOrdersScreen());
                  print("to the screen of confirm orders screen");
                }
              }
              // storeController.getStoreCreditRating();
            },
          );

          print(
              "print check init in onit store controller - storescreen initState");
        },
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(right: 6, left: 6),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Container(
                      height: height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: ColorsConst.yellowColor,
                      ),
                      child: storeController.videoControllerList.isEmpty
                          ? AppShimmerEffectView(
                              width: width,
                              borderRadius: 12,
                              baseColor: Colors.grey.withOpacity(0.9),
                              highlightColor: Colors.grey.withOpacity(0.3),
                            )
                          : VideoListWidget(
                              videoUrls: storeController.videoControllerList,
                            ),
                    ),
                  ),
                  // SizedBox(height: height * 0.03),
                  // Container(
                  //   width: double.infinity,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.all(Radius.circular(12)),
                  //   ),
                  //   padding: EdgeInsets.all(16),
                  //   child: Row(
                  //     children: [
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           CommonText(
                  //             maxLines: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //             content: 'Wow..! Discount',
                  //             textColor: ColorsConst.appblack54,
                  //             boldNess: FontWeight.w600,
                  //             textSize: 14,
                  //             textAlign: TextAlign.start,
                  //           ),
                  //           CommonText(
                  //             maxLines: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //             content: 'Benefits on Purchases',
                  //             textColor: ColorsConst.appblack54,
                  //             boldNess: FontWeight.w600,
                  //             textSize: 14,
                  //           ),
                  //         ],
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             CommonText(
                  //               maxLines: 1,
                  //               overflow: TextOverflow.ellipsis,
                  //               content: '₹25000.00',
                  //               textColor: Color.fromRGBO(30, 170, 36, 1),
                  //               boldNess: FontWeight.w600,
                  //               textSize: 14,
                  //               textAlign: TextAlign.start,
                  //             ),
                  //             CommonText(
                  //               maxLines: 1,
                  //               overflow: TextOverflow.ellipsis,
                  //               content: '(January)',
                  //               textColor: Color.fromRGBO(171, 171, 171, 1),
                  //               boldNess: FontWeight.w600,
                  //               textSize: 14,
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: height * 0.02),
                  // CommonText(
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   content: 'Buy Products',
                  //   textColor: ColorsConst.appblack54,
                  //   boldNess: FontWeight.w600,
                  //   textSize: 14,
                  // ),
                  // SizedBox(height: height * 0.02),
                  // GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: storeController.newFirstStoreList.length,
                  //     shrinkWrap: true,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       childAspectRatio: 0.8,
                  //       crossAxisCount: 3,
                  //       crossAxisSpacing: 10,
                  //       mainAxisSpacing: 10,
                  //     ),
                  //     itemBuilder: (context, index) => GestureDetector(
                  //           onTap: () {
                  //             switch (index) {
                  //               case 0:
                  //                 HomeController controller =
                  //                     Get.put(HomeController());
                  //                 controller.appBarTitle = "Buy";
                  //                 controller.currentIndex = 2;
                  //                 controller.currentWidget = BuyScreen(
                  //                   categoryId: API.generalMedicineCategoryId,
                  //                 );
                  //                 controller.update();
                  //                 //   Get.to(() => const home.HomeScreen());

                  //                 break;
                  //               case 1:
                  //                 Get.to(() => UnlistedProductScreen());
                  //                 break;
                  //             }
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: ColorsConst.semiGreyColor.withOpacity(0.3),
                  //                   spreadRadius: 2,
                  //                   blurRadius: 1,
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Image.asset(
                  //                   "${storeController.newFirstStoreList[index]["icon"]}",
                  //                   height: 52,
                  //                   width: 52,
                  //                   package: 'store_app_b2b',
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 SizedBox(height: height * 0.02),
                  //                 CommonText(
                  //                   content:
                  //                       "${storeController.newFirstStoreList[index]["title"]}",
                  //                   textColor: ColorsConst.textColor,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 12,
                  //                   textAlign: TextAlign.center,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         )),
                  // SizedBox(height: height * 0.02),
                  // GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: storeController.newSecondStoreList.length,
                  //     shrinkWrap: true,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       childAspectRatio: 1.1,
                  //       crossAxisCount: 2,
                  //       crossAxisSpacing: 14,
                  //       mainAxisSpacing: 20,
                  //     ),
                  //     itemBuilder: (context, index) => GestureDetector(
                  //           onTap: () {
                  //             switch (index) {
                  //               case 0:
                  //                 HomeController controller =
                  //                     Get.put(HomeController());
                  //                 controller.appBarTitle = "Buy";
                  //                 controller.currentIndex = 2;
                  //                 controller.currentWidget = BuyScreen(
                  //                   categoryId: API.generalMedicineCategoryId,
                  //                 );
                  //                 controller.update();
                  //                 //   Get.to(() => const home.HomeScreen());

                  //                 break;
                  //               case 1:
                  //                 Get.to(() => UnlistedProductScreen());
                  //                 break;
                  //             }
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: ColorsConst.semiGreyColor.withOpacity(0.3),
                  //                   spreadRadius: 2,
                  //                   blurRadius: 1,
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Image.asset(
                  //                   "${storeController.newSecondStoreList[index]["icon"]}",
                  //                   height: 52,
                  //                   width: 52,
                  //                   package: 'store_app_b2b',
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 SizedBox(height: height * 0.02),
                  //                 CommonText(
                  //                   content:
                  //                       "${storeController.newSecondStoreList[index]["title"]}",
                  //                   textColor: ColorsConst.textColor,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 12,
                  //                   textAlign: TextAlign.center,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         )),
                  // SizedBox(height: height * 0.02),
                  // SizedBox(height: height * 0.02),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          margin: const EdgeInsets.only(right: 2.5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              // BoxShadow(
                              //   color:
                              //       ColorsConst.semiGreyColor.withOpacity(0.3),
                              //   spreadRadius: 1,
                              //   blurRadius: 3,
                              // ),
                            ],
                          ),
                          child: Obx(() => (storeController
                                  .isCreditLimitLoading.value)
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CommonText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      content: 'Credit Limit',
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w600,
                                      textSize: 11,
                                    ),
                                    CommonText(
                                      content:
                                          '₹ ${(storeController.accountStatusModel.creditLimit == null) ? '0.00' : storeController.accountStatusModel.creditLimit!.toStringAsFixed(2)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w600,
                                      textSize: 15,
                                    ),
                                    // RichText(
                                    //     text: TextSpan(
                                    //         text:
                                    //             // '${(storeController.accountStatusModel.usedLimit == null) ? '0.00' : storeController.accountStatusModel.usedLimit!.toStringAsFixed(2)}% ',
                                    //             "Avaiable credit limit : ",
                                    //         style: GoogleFonts.poppins(
                                    //             color: storeController
                                    //                             .accountStatusModel
                                    //                             .usedLimit !=
                                    //                         null &&
                                    //                     storeController
                                    //                             .accountStatusModel
                                    //                             .usedLimit! >
                                    //                         100
                                    //                 ? ColorsConst.appTomatoRed
                                    //                 : ColorsConst.greenColorShade,
                                    //             fontSize: 10.7,
                                    //             fontWeight: FontWeight.w600),
                                    //         children: [
                                    //       TextSpan(
                                    //           text: 'Used',
                                    //           style: GoogleFonts.poppins(
                                    //               color: const Color(0xff777777),
                                    //               fontWeight: FontWeight.w400,
                                    //               fontSize: 10.7))
                                    //     ])),
                                    // const SizedBox(height: 10),
                                    // const CommonText(
                                    //   content:
                                    //       'Increase Your Limit by paying outstanding amount on time',
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   textSize: 8,
                                    //   textColor: Color(0xff989898),
                                    // )
                                    const CommonText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      content: 'Available Credit Limit',
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w600,
                                      textSize: 12,
                                    ),
                                    CommonText(
                                      content:
                                          '₹ ${(storeController.accountStatusModel.creditLimit == null && storeController.accountStatusModel.outStandingAmount == null) ? '0.00' : storeController.accountStatusModel.outStandingAmount! < 0 ? storeController.accountStatusModel.creditLimit!.toStringAsFixed(2) : storeController.accountStatusModel.outStandingAmount! > storeController.accountStatusModel.creditLimit! ? (storeController.accountStatusModel.outStandingAmount! - storeController.accountStatusModel.creditLimit!).toStringAsFixed(2) : (storeController.accountStatusModel.creditLimit! - storeController.accountStatusModel.outStandingAmount!).toStringAsFixed(2)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textColor: storeController
                                                      .accountStatusModel
                                                      .creditLimit ==
                                                  null &&
                                              storeController.accountStatusModel
                                                      .outStandingAmount ==
                                                  null
                                          ? ColorsConst.appblack54
                                          : storeController.accountStatusModel
                                                      .creditLimit! >
                                                  storeController
                                                      .accountStatusModel
                                                      .outStandingAmount!
                                              ? ColorsConst.greenColor
                                              : ColorsConst.redColor,
                                      boldNess: FontWeight.w600,
                                      textSize: 15,
                                    ),
                                  ],
                                )),
                        ),
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 2.5),
                          height: 120,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              // BoxShadow(
                              //   color:
                              //       ColorsConst.semiGreyColor.withOpacity(0.3),
                              //   spreadRadius: 1,
                              //   blurRadius: 3,
                              // ),
                            ],
                          ),
                          child: Obx(() => (storeController
                                  .isCreditLimitLoading.value)
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CommonText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      content: 'OutStanding Amount',
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w600,
                                      textSize: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CommonText(
                                          content:
                                              '₹ ${(storeController.accountStatusModel.outStandingAmount == null) ? '0.00' : storeController.accountStatusModel.outStandingAmount! >= 0 ? storeController.accountStatusModel.outStandingAmount!.toStringAsFixed(2) : (storeController.accountStatusModel.outStandingAmount! * -1).toStringAsFixed(2)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textColor: ColorsConst.appblack54,
                                          boldNess: FontWeight.w600,
                                          textSize: 15,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                '${(storeController.accountStatusModel.outStandingAmount == null) ? '' : storeController.accountStatusModel.outStandingAmount! > 0 ? " (DR)" : "( CR)"}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textColor: ColorsConst.appblack54,
                                            boldNess: FontWeight.w600,
                                            textSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    (storeController.accountStatusModel
                                                    .accountLocked !=
                                                null &&
                                            storeController.accountStatusModel
                                                .accountLocked!.isNotEmpty &&
                                            storeController.accountStatusModel
                                                    .accountLocked!
                                                    .toLowerCase() ==
                                                'y')
                                        ? const Row(children: [
                                            Flexible(
                                              child: CommonText(
                                                content: 'Purchase Locked',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: Color(0xff777777),
                                                boldNess: FontWeight.w400,
                                                textSize: 10.7,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.lock_outline_rounded,
                                              color: Color(0xffEF5454),
                                              size: 15,
                                            ),
                                          ])
                                        : Row(children: [
                                            const Flexible(
                                              child: CommonText(
                                                content: 'Purchase UnLocked',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: Color(0xff777777),
                                                boldNess: FontWeight.w400,
                                                textSize: 10.7,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Icon(
                                              Icons.lock_open_outlined,
                                              color: ColorsConst.greenColor,
                                              size: 15,
                                            ),
                                          ]),
                                    const SizedBox(height: 10),
                                    if (storeController.accountStatusModel
                                                .outStandingAmount !=
                                            null &&
                                        storeController.accountStatusModel
                                                .outStandingAmount! >
                                            0)
                                      InkWell(
                                        // onTap: () {
                                        //   final controller =
                                        //       Get.put(HomeController());
                                        //   controller.appBarTitle = "Payments";
                                        //   controller.currentIndex = 3;
                                        //   controller.currentWidget =
                                        //       PaymentScreen();
                                        //   controller.update();
                                        // },
                                        onTap: () {
                                          GlobalMainController gmController =
                                              Get.find<GlobalMainController>();
                                          if (!gmController
                                              .isPayNearOutstandingAmountNeeded) {
                                            final controller =
                                                Get.put(HomeController());
                                            controller.appBarTitle = "Payments";
                                            controller.currentIndex = 3;
                                            controller.currentWidget =
                                                PaymentScreen();
                                            controller.update();
                                            return;
                                          }

                                          print("printing in pay now");
                                          // storeController.selectItem =
                                          //     paymentController
                                          //         .paymentRequestList[index];
                                          // logs(
                                          //     'SelectedItem --> ${paymentController.selectItem?.toJson()}');
                                          storeController
                                                  .outstandingAmountEnterController
                                                  .value
                                                  .text =
                                              '${(storeController.accountStatusModel.outStandingAmount == null) ? "0.00" : storeController.accountStatusModel.outStandingAmount!.toStringAsFixed(0)}';

                                          // GlobalMainController gmController =
                                          //     Get.put(GlobalMainController());

                                          // bool isEditable =
                                          //     gmController.isPartialPaymentAllowedB2B;

                                          // print("isEditable -> $isEditable");

                                          //  storeController.accountStatusModel.outStandingAmount!.toStringAsFixed(2) : (storeController.accountStatusModel.outStandingAmount! * -1).toStringAsFixed(2);

                                          Get.dialog(
                                            AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              insetPadding: EdgeInsets.zero,
                                              contentPadding: EdgeInsets.zero,
                                              content: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: ColorsConst
                                                              .appGradientColor,
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const CommonText(
                                                            content:
                                                                "Amount Payable",
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            icon: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    CommonText(
                                                      content: "Enter amount",
                                                      textColor:
                                                          ColorsConst.hintColor,
                                                    ),
                                                    SizedBox(
                                                      width: width / 4,
                                                      child: TextField(
                                                        // readOnly: !isEditable,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        controller: storeController
                                                            .outstandingAmountEnterController
                                                            .value,
                                                        textAlign:
                                                            TextAlign.center,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: "₹",
                                                          border:
                                                              UnderlineInputBorder(),
                                                          focusedBorder:
                                                              UnderlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.white,
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        String inputValue =
                                                            storeController
                                                                .outstandingAmountEnterController
                                                                .value
                                                                .text
                                                                .trim();
                                                        double parsedValue =
                                                            double.tryParse(
                                                                    inputValue) ??
                                                                0.0;

                                                        String formattedValue =
                                                            parsedValue
                                                                .toStringAsFixed(
                                                                    2);

                                                        num result = num.parse(
                                                            formattedValue);

                                                        num maxValue = (storeController
                                                                    .accountStatusModel
                                                                    .outStandingAmount ==
                                                                null)
                                                            ? 0
                                                            : storeController
                                                                .accountStatusModel
                                                                .outStandingAmount!;

                                                        if (result > maxValue) {
                                                          CommonSnackBar.showError(
                                                              "Maximum payable value ₹$maxValue");
                                                          return;
                                                        }

                                                        if (result < 1) {
                                                          CommonSnackBar.showError(
                                                              "Payable amount must be greater than ₹0");
                                                          return;
                                                        }

                                                        print(
                                                            "printing going amount formated -> $formattedValue");

                                                        print(
                                                            "printing going amount -> $result");
                                                        // return;
                                                        Get.back();
                                                        storeController.getRazorPayDataApi(
                                                            // int.parse(paymentController
                                                            //         .amountEnterController
                                                            //         .value
                                                            //         .text
                                                            //         .trim())
                                                            //     .toDouble(),
                                                            result,
                                                            // paymentController
                                                            //     .selectItem
                                                            //     ?.orderId,
                                                            "ACIN0-2362738",
                                                            "${ApiConfig.razorpayKey}");
                                                      },
                                                      child: CommonText(
                                                        content: "Pay",
                                                        textSize: width * 0.035,
                                                        textColor: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 24.51,
                                          width: 62.76,
                                          decoration: BoxDecoration(
                                              color: ColorsConst.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(6.57)),
                                          alignment: Alignment.center,
                                          child: const CommonText(
                                            content: 'Pay Now',
                                            textSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                )),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 20),
                  // GridView(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     childAspectRatio: 1.4,
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: 10,
                  //     mainAxisSpacing: 20,
                  //   ),
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(15),
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: ColorsConst.semiGreyColor.withOpacity(0.3),
                  //             spreadRadius: 3,
                  //             blurRadius: 3,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Obx(() => (storeController.isCreditLimitLoading.value)
                  //           ? const Center(child: CircularProgressIndicator())
                  //           : Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 const CommonText(
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   content: 'Credit Limit',
                  //                   textColor: ColorsConst.appblack54,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 12,
                  //                 ),
                  //                 CommonText(
                  //                   content:
                  //                       '₹ ${(storeController.accountStatusModel.creditLimit == null) ? '0.00' : storeController.accountStatusModel.creditLimit!.toStringAsFixed(2)}',
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   textColor: ColorsConst.appblack54,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 19.87,
                  //                 ),
                  //                 // RichText(
                  //                 //     text: TextSpan(
                  //                 //         text:
                  //                 //             // '${(storeController.accountStatusModel.usedLimit == null) ? '0.00' : storeController.accountStatusModel.usedLimit!.toStringAsFixed(2)}% ',
                  //                 //             "Avaiable credit limit : ",
                  //                 //         style: GoogleFonts.poppins(
                  //                 //             color: storeController
                  //                 //                             .accountStatusModel
                  //                 //                             .usedLimit !=
                  //                 //                         null &&
                  //                 //                     storeController
                  //                 //                             .accountStatusModel
                  //                 //                             .usedLimit! >
                  //                 //                         100
                  //                 //                 ? ColorsConst.appTomatoRed
                  //                 //                 : ColorsConst.greenColorShade,
                  //                 //             fontSize: 10.7,
                  //                 //             fontWeight: FontWeight.w600),
                  //                 //         children: [
                  //                 //       TextSpan(
                  //                 //           text: 'Used',
                  //                 //           style: GoogleFonts.poppins(
                  //                 //               color: const Color(0xff777777),
                  //                 //               fontWeight: FontWeight.w400,
                  //                 //               fontSize: 10.7))
                  //                 //     ])),
                  //                 // const SizedBox(height: 10),
                  //                 // const CommonText(
                  //                 //   content:
                  //                 //       'Increase Your Limit by paying outstanding amount on time',
                  //                 //   maxLines: 2,
                  //                 //   overflow: TextOverflow.ellipsis,
                  //                 //   textSize: 8,
                  //                 //   textColor: Color(0xff989898),
                  //                 // )
                  //                 const CommonText(
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   content: 'Available Credit Limit',
                  //                   textColor: ColorsConst.appblack54,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 12,
                  //                 ),
                  //                 CommonText(
                  //                   content:
                  //                       '₹ ${(storeController.accountStatusModel.creditLimit == null && storeController.accountStatusModel.outStandingAmount == null) ? '0.00' : storeController.accountStatusModel.outStandingAmount! < 0 ? storeController.accountStatusModel.creditLimit!.toStringAsFixed(2) : storeController.accountStatusModel.outStandingAmount! > storeController.accountStatusModel.creditLimit! ? (storeController.accountStatusModel.outStandingAmount! - storeController.accountStatusModel.creditLimit!).toStringAsFixed(2) : (storeController.accountStatusModel.creditLimit! - storeController.accountStatusModel.outStandingAmount!).toStringAsFixed(2)}',
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   textColor: storeController
                  //                                   .accountStatusModel.creditLimit ==
                  //                               null &&
                  //                           storeController.accountStatusModel
                  //                                   .outStandingAmount ==
                  //                               null
                  //                       ? ColorsConst.appblack54
                  //                       : storeController
                  //                                   .accountStatusModel.creditLimit! >
                  //                               storeController.accountStatusModel
                  //                                   .outStandingAmount!
                  //                           ? ColorsConst.greenColor
                  //                           : ColorsConst.redColor,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 19.87,
                  //                 ),
                  //               ],
                  //             )),
                  //     ),
                  //     Container(
                  //       padding: const EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(15),
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: ColorsConst.semiGreyColor.withOpacity(0.3),
                  //             spreadRadius: 3,
                  //             blurRadius: 3,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Obx(() => (storeController.isCreditLimitLoading.value)
                  //           ? const Center(child: CircularProgressIndicator())
                  //           : Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 const CommonText(
                  //                   maxLines: 1,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   content: 'OutStanding Amount',
                  //                   textColor: ColorsConst.appblack54,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 12,
                  //                 ),
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   children: [
                  //                     CommonText(
                  //                       content:
                  //                           '₹ ${(storeController.accountStatusModel.outStandingAmount == null) ? '0.00' : storeController.accountStatusModel.outStandingAmount! > 0 ? storeController.accountStatusModel.outStandingAmount!.toStringAsFixed(2) : (storeController.accountStatusModel.outStandingAmount! * -1).toStringAsFixed(2)}',
                  //                       maxLines: 1,
                  //                       overflow: TextOverflow.ellipsis,
                  //                       textColor: ColorsConst.appblack54,
                  //                       boldNess: FontWeight.w600,
                  //                       textSize: 19.87,
                  //                     ),
                  //                     CommonText(
                  //                       content:
                  //                           '${(storeController.accountStatusModel.outStandingAmount == null) ? '' : storeController.accountStatusModel.outStandingAmount! > 0 ? " (DR)" : "( CR)"}',
                  //                       maxLines: 1,
                  //                       overflow: TextOverflow.ellipsis,
                  //                       textColor: ColorsConst.appblack54,
                  //                       boldNess: FontWeight.w600,
                  //                       textSize: 12,
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 (storeController.accountStatusModel
                  //                                 .purchaseAccountStatus !=
                  //                             null &&
                  //                         storeController.accountStatusModel
                  //                             .purchaseAccountStatus!.isNotEmpty &&
                  //                         storeController.accountStatusModel
                  //                                 .purchaseAccountStatus!
                  //                                 .toLowerCase() ==
                  //                             'y')
                  //                     ? const Row(children: [
                  //                         Flexible(
                  //                           child: CommonText(
                  //                             content: 'Purchase Locked',
                  //                             maxLines: 1,
                  //                             overflow: TextOverflow.ellipsis,
                  //                             textColor: Color(0xff777777),
                  //                             boldNess: FontWeight.w400,
                  //                             textSize: 10.7,
                  //                           ),
                  //                         ),
                  //                         SizedBox(width: 5),
                  //                         Icon(
                  //                           Icons.lock_outline_rounded,
                  //                           color: Color(0xffEF5454),
                  //                           size: 15,
                  //                         ),
                  //                       ])
                  //                     : Row(children: [
                  //                         const Flexible(
                  //                           child: CommonText(
                  //                             content: 'Purchase UnLocked',
                  //                             maxLines: 1,
                  //                             overflow: TextOverflow.ellipsis,
                  //                             textColor: Color(0xff777777),
                  //                             boldNess: FontWeight.w400,
                  //                             textSize: 10.7,
                  //                           ),
                  //                         ),
                  //                         const SizedBox(width: 2),
                  //                         Icon(
                  //                           Icons.lock_open_outlined,
                  //                           color: ColorsConst.greenColor,
                  //                           size: 15,
                  //                         ),
                  //                       ]),
                  //                 const SizedBox(height: 10),
                  //                 InkWell(
                  //                   onTap: () {
                  //                     final controller = Get.put(HomeController());
                  //                     controller.appBarTitle = "Payments";
                  //                     controller.currentIndex = 3;
                  //                     controller.currentWidget = PaymentScreen();
                  //                     controller.update();
                  //                   },
                  //                   child: Container(
                  //                     height: 24.51,
                  //                     width: 62.76,
                  //                     decoration: BoxDecoration(
                  //                         color: ColorsConst.primaryColor,
                  //                         borderRadius: BorderRadius.circular(6.57)),
                  //                     alignment: Alignment.center,
                  //                     child: const CommonText(
                  //                       content: 'Pay Now',
                  //                       textSize: 10,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             )),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 5),
                  // GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: storeController.firstStoreList.length,
                  //     shrinkWrap: true,
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       childAspectRatio: 1.2,
                  //       crossAxisCount: 2,
                  //       crossAxisSpacing: 20,
                  //       mainAxisSpacing: 20,
                  //     ),
                  //     itemBuilder: (context, index) => GestureDetector(
                  //           onTap: () {
                  //             switch (index) {
                  //               case 0:
                  //                 HomeController controller =
                  //                     Get.put(HomeController());
                  //                 controller.appBarTitle = "Buy";
                  //                 controller.currentIndex = 2;
                  //                 controller.currentWidget = BuyScreen(
                  //                   categoryId: API.generalMedicineCategoryId,
                  //                 );
                  //                 controller.update();
                  //                 break;
                  //               case 1:
                  //                 Get.to(() => UnlistedProductScreen());
                  //                 break;
                  //             }
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: ColorsConst.semiGreyColor.withOpacity(0.3),
                  //                   spreadRadius: 3,
                  //                   blurRadius: 3,
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Image.asset(
                  //                   "${storeController.firstStoreList[index]["icon"]}",
                  //                   package: 'store_app_b2b',
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 SizedBox(height: height * 0.02),
                  //                 CommonText(
                  //                   content:
                  //                       "${storeController.firstStoreList[index]["title"]}",
                  //                   textColor: ColorsConst.textColor,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 16,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         )),
                  // SizedBox(height: height * 0.03),

                  // GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: storeController.firstStoreList.length,
                  //     shrinkWrap: true,
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       childAspectRatio: 1.2,
                  //       crossAxisCount: 2,
                  //       crossAxisSpacing: 20,
                  //       mainAxisSpacing: 20,
                  //     ),
                  //     itemBuilder: (context, index) => GestureDetector(
                  //           onTap: () {
                  //             switch (index) {
                  //               case 0:
                  //                 HomeController controller =
                  //                     Get.put(HomeController());
                  //                 controller.appBarTitle = "Buy";
                  //                 controller.currentIndex = 2;
                  //                 controller.currentWidget = BuyScreen(
                  //                   categoryId: API.generalMedicineCategoryId,
                  //                 );
                  //                 controller.update();
                  //                 break;
                  //               case 1:
                  //                 Get.to(() => UnlistedProductScreen());
                  //                 break;
                  //             }
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: ColorsConst.semiGreyColor.withOpacity(0.3),
                  //                   spreadRadius: 3,
                  //                   blurRadius: 3,
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Image.asset(
                  //                   "${storeController.firstStoreList[index]["icon"]}",
                  //                   package: 'store_app_b2b',
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 SizedBox(height: height * 0.02),
                  //                 CommonText(
                  //                   content:
                  //                       "${storeController.firstStoreList[index]["title"]}",
                  //                   textColor: ColorsConst.textColor,
                  //                   boldNess: FontWeight.w600,
                  //                   textSize: 16,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         )),
                  // SizedBox(height: height * 0.03),
                  // CommonText(
                  //     content: 'Buy Products',
                  //     textSize: 14,
                  //     textColor: ColorsConst.greyTextColor,
                  //     boldNess: FontWeight.w600),
                  // SizedBox(height: height * 0.02),
                  Obx(
                    () => storeController.isStoreCategoriesLoading.value
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 0,
                              ),
                              // CircularProgressIndicator(),
                              GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                    crossAxisCount: 4,
                                    height: 100,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return const AppShimmerEffectView(
                                        // baseColor: Colors.grey.shade400,
                                        );
                                  }),
                              const SizedBox(
                                height: 5,
                              )
                            ],
                          )
                        : storeController.storeCategoryList.length < 4
                            ? const SizedBox()
                            : Obx(() => GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      storeController.storeCategoryList.length -
                                          storeController
                                              .storeCategoryReminder.value,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                    crossAxisCount: 4,
                                    height: 100,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        print(
                                            "printing on store category click");
                                        HomeController controller =
                                            Get.put(HomeController());
                                        controller.currentIndex = 2;
                                        controller.appBarTitle = storeController
                                                .storeCategoryList[index]
                                                .categoryName ??
                                            '';
                                        controller.appBarTitle = storeController
                                                .storeCategoryList[index]
                                                .categoryName ??
                                            '';
                                        controller.currentWidget = BuyScreen(
                                          categoryId: storeController
                                                  .storeCategoryList[index]
                                                  .categoryId ??
                                              '',
                                        );
                                        controller.update();
                                        // Get.to(() => BuyScreen(
                                        //       categoryId: storeController
                                        //               .storeCategoryList[index].categoryId ??
                                        //           '',
                                        //     ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.white,
                                          boxShadow: [
                                            // BoxShadow(
                                            //   color: ColorsConst.semiGreyColor
                                            //       .withOpacity(0.3),
                                            //   spreadRadius: 1,
                                            //   blurRadius: 1,
                                            // ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Image.network(
                                            //   "${storeController.storeCategoryList[index].imgUrl}",
                                            //   // scale: 1,
                                            //   height: 60,
                                            //   // package: 'store_app_b2b',
                                            //   fit: BoxFit.cover,
                                            // ),
                                            Gap(15),
                                            Expanded(
                                              child: Container(
                                                // color: Colors.red,
                                                // margin:
                                                //     EdgeInsets.only(top: 10),
                                                width: double.infinity,
                                                child: AppImageAsset(
                                                  image: storeController
                                                      .storeCategoryList[index]
                                                      .imgUrl,
                                                  height: 40,
                                                  width: 40,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                // color: Colors.red,
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: CommonText(
                                                    content:
                                                        "${storeController.storeCategoryList[index].categoryName}",
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    boldNess: FontWeight.w600,
                                                    textAlign: TextAlign.center,
                                                    textSize: 11,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                  ),

                  //for 3 grids starts here

                  Obx(() => storeController.storeCategoryReminder.value == 3 &&
                          storeController.isStoreCategoriesLoading != true &&
                          storeController.storeCategoryList.length > 3
                      ? const SizedBox(
                          height: 5,
                        )
                      : const SizedBox()),
                  Obx(() => storeController.storeCategoryReminder.value == 3 &&
                          storeController.isStoreCategoriesLoading != true
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                  crossAxisCount: 3,
                                  height: 100,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemBuilder: (context, i) {
                            int index =
                                storeController.storeCategoryList.length - 1;
                            if (i == 0) {
                              index =
                                  storeController.storeCategoryList.length - 3;
                            }

                            if (i == 1) {
                              index =
                                  storeController.storeCategoryList.length - 2;
                            }

                            if (i == 2) {
                              index =
                                  storeController.storeCategoryList.length - 1;
                            }
                            return InkWell(
                              onTap: () {
                                HomeController controller =
                                    Get.put(HomeController());
                                controller.currentIndex = 2;
                                controller.appBarTitle = storeController
                                        .storeCategoryList[index]
                                        .categoryName ??
                                    '';
                                controller.appBarTitle = storeController
                                        .storeCategoryList[index]
                                        .categoryName ??
                                    '';
                                controller.currentWidget = BuyScreen(
                                  categoryId: storeController
                                          .storeCategoryList[index]
                                          .categoryId ??
                                      '',
                                );
                                controller.update();
                                // Get.to(() => BuyScreen(
                                //       categoryId: storeController
                                //               .storeCategoryList[index].categoryId ??
                                //           '',
                                //     ));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  boxShadow: [
                                    // BoxShadow(
                                    //   color: ColorsConst.semiGreyColor
                                    //       .withOpacity(0.3),
                                    //   spreadRadius: 0,
                                    //   blurRadius: 1,
                                    // ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Gap(15),
                                    Expanded(
                                      child: AppImageAsset(
                                        image: storeController
                                            .storeCategoryList[index].imgUrl,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Expanded(
                                      child: CommonText(
                                        content:
                                            "${storeController.storeCategoryList[index].categoryName}",
                                        textColor: ColorsConst.textColor,
                                        boldNess: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                        textSize: 11,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox()),

                  //for 3 grids ends here

                  Obx(() => storeController.storeCategoryReminder.value == 1 &&
                          storeController.isStoreCategoriesLoading != true &&
                          storeController.storeCategoryList.length > 2
                      ? const SizedBox(
                          height: 5,
                        )
                      : const SizedBox()),
                  Obx(() => storeController.storeCategoryReminder.value == 1 &&
                          storeController.isStoreCategoriesLoading != true
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                  crossAxisCount: 1,
                                  height: 100,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            int index =
                                storeController.storeCategoryList.length - 1;
                            return InkWell(
                              onTap: () {
                                HomeController controller =
                                    Get.put(HomeController());
                                controller.currentIndex = 2;
                                controller.appBarTitle = storeController
                                        .storeCategoryList[index]
                                        .categoryName ??
                                    '';
                                controller.appBarTitle = storeController
                                        .storeCategoryList[index]
                                        .categoryName ??
                                    '';
                                controller.currentWidget = BuyScreen(
                                  categoryId: storeController
                                          .storeCategoryList[index]
                                          .categoryId ??
                                      '',
                                );
                                controller.update();
                                // Get.to(() => BuyScreen(
                                //       categoryId: storeController
                                //               .storeCategoryList[index].categoryId ??
                                //           '',
                                //     ));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  boxShadow: [
                                    // BoxShadow(
                                    //   color: ColorsConst.semiGreyColor
                                    //       .withOpacity(0.3),
                                    //   spreadRadius: 1,
                                    //   blurRadius: 1,
                                    // ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppImageAsset(
                                      image: storeController
                                          .storeCategoryList[index].imgUrl,
                                      height: 40,
                                      width: 40,
                                    ),
                                    CommonText(
                                      content:
                                          "${storeController.storeCategoryList[index].categoryName}",
                                      textColor: ColorsConst.textColor,
                                      boldNess: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                      textSize: 11,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox()),

                  Obx(() => storeController.storeCategoryReminder.value == 2 &&
                          storeController.isStoreCategoriesLoading != true &&
                          storeController.storeCategoryList.length > 2
                      ? const SizedBox(
                          height: 5,
                        )
                      : const SizedBox()),
                  Obx(() => storeController.storeCategoryReminder.value == 2 &&
                          storeController.isStoreCategoriesLoading != true
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 2,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                  crossAxisCount: 2,
                                  height: 100,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemBuilder: (context, i) {
                            int index =
                                storeController.storeCategoryList.length - 1;
                            if (i == 0) {
                              index =
                                  storeController.storeCategoryList.length - 2;
                            }

                            if (i == 1) {
                              index =
                                  storeController.storeCategoryList.length - 1;
                            }
                            return InkWell(
                              onTap: () {
                                HomeController controller =
                                    Get.put(HomeController());
                                controller.currentIndex = 2;
                                controller.appBarTitle = storeController
                                        .storeCategoryList[index]
                                        .categoryName ??
                                    '';
                                controller.appBarTitle = storeController
                                        .storeCategoryList[index]
                                        .categoryName ??
                                    '';
                                controller.currentWidget = BuyScreen(
                                  categoryId: storeController
                                          .storeCategoryList[index]
                                          .categoryId ??
                                      '',
                                );
                                controller.update();
                                // Get.to(() => BuyScreen(
                                //       categoryId: storeController
                                //               .storeCategoryList[index].categoryId ??
                                //           '',
                                //     ));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  boxShadow: [
                                    // BoxShadow(
                                    //   color: ColorsConst.semiGreyColor
                                    //       .withOpacity(0.3),
                                    //   spreadRadius: 1,
                                    //   blurRadius: 1,
                                    // ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppImageAsset(
                                      image: storeController
                                          .storeCategoryList[index].imgUrl,
                                      height: 40,
                                      width: 40,
                                    ),
                                    CommonText(
                                      content:
                                          "${storeController.storeCategoryList[index].categoryName}",
                                      textColor: ColorsConst.textColor,
                                      boldNess: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                      textSize: 11,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox()),

                  Obx(() => storeController.isMedicalCategoryPresent.value &&
                          storeController.isStoreCategoriesLoading != true
                      ? const SizedBox(height: 5)
                      : const SizedBox()),
                  // SizedBox(height: height * 0.02),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: storeController.buyProductList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisCount: 4,
                            height: 100,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          String userId = await SharPreferences.getString(
                                  SharPreferences.loginId) ??
                              '';

                          if (userId.isEmpty) {
                            Get.dialog(const LoginDialog());

                            return;
                          }

                          HomeController controller = Get.put(HomeController());
                          switch (index) {
                            // case 0:
                            //   controller.currentIndex = 2;
                            //   controller.appBarTitle = "Medicines";
                            //   controller.currentWidget = BuyScreen(
                            //     categoryId: API.generalMedicineCategoryId,
                            //   );
                            //   controller.update();
                            //   break;
                            // case 1:
                            //   controller.currentIndex = 2;
                            //   controller.appBarTitle = "Generic medicine";
                            //   controller.currentWidget = BuyScreen(
                            //     categoryId: API.genericMedicineCategoryId,
                            //   );
                            //   controller.update();
                            //   break;
                            // case 2:
                            //   controller.currentIndex = 2;
                            //   controller.appBarTitle = "Speciality Medicines";
                            //   controller.currentWidget = BuyScreen(
                            //     categoryId: API.sppCategoryId,
                            //   );
                            //   controller.update();
                            //   break;
                            case 3:
                              //Get.to(() => const AToZSoonScreen());
                              Get.to(() => UnlistedProductScreen());
                              // Get.to(() => BrandsScreen());

                              break;
                            case 4:
                              entryDataDialog(context, isUpdate: false);
                              // Get.to(() => const UnlistedSoonScreen());
                              // Get.to(() => BrandsScreen());

                              break;
                            case 5:
                              // case 6:
                              Get.to(() => const QuickDeliveryScreen());
                              controller.update();
                              break;
                            case 6:
                              // case 6:

                              if (!storeController.networkStatus.value) {
                                CommonSnackBar.showError(
                                    "Please enable network retailer option to access this feature");

                                return;
                              }
                              Get.to(() => NetworkRetailerListScreen());
                              controller.update();
                              break;
                            case 0:
                              // Get.to(() => LucidSoonScreen());
                              Get.to(() => DiagnosisScreen());
                              break;
                            case 1:
                              // Get.to(() => const UnlistedSoonScreen());

                              // if (gmController
                              //     .highMarginCategoryId.isEmpty) {
                              //   Get.to(() => const UnlistedSoonScreen());
                              // } else {
                              //   print(
                              //       "printing high margin cat id -> ${gmController.highMarginCategoryId}");
                              //   controller.currentIndex = 2;
                              //   controller.appBarTitle =
                              //       "High Margin Products";
                              //   controller.currentWidget = BuyScreen(
                              //     categoryId:
                              //         gmController.highMarginCategoryId,
                              //   );
                              //   controller.update();
                              // }

                              Get.to(() => const AppointmnetScreen(
                                    istopDoctors: false,
                                    councelling: '',
                                  ));
                              break;

                            //  break;
                            case 2:
                              Get.to(() => const OrderStatusScreen());
                              break;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              // BoxShadow(
                              //   color:
                              //       ColorsConst.semiGreyColor.withOpacity(0.3),
                              //   spreadRadius: 1,
                              //   blurRadius: 2,
                              // ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              index == 6 ? Gap(3) : Gap(0),
                              index != 6
                                  ? SizedBox(
                                      height: 15,
                                    )
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      //                showDialog(
                                      //   context: context,
                                      //   barrierDismissible: true,
                                      //   useRootNavigator: false,
                                      //   builder: (context) {
                                      //     return expiryPopup(context,
                                      //         showContinue: showContinue);
                                      //   },
                                      // );
                                      child: ValueListenableBuilder<bool>(
                                          valueListenable:
                                              storeController.networkStatus,
                                          builder: (context, isActive, child) {
                                            return Container(
                                              padding: EdgeInsets.all(
                                                  0), // Ensures the switch fits within the border
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: isActive
                                                      ? Color.fromRGBO(
                                                          18, 21, 28, 1)
                                                      : Color.fromRGBO(
                                                          207,
                                                          207,
                                                          207,
                                                          1), // Border color
                                                  width: 1, // Border width
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Rounded corners
                                              ),

                                              child: GestureDetector(
                                                onTap: () async {
                                                  // _showConfirmationDialog(
                                                  //     isActive);

                                                  String userId =
                                                      await SharPreferences
                                                              .getString(
                                                                  SharPreferences
                                                                      .loginId) ??
                                                          '';

                                                  if (userId.isEmpty) {
                                                    Get.dialog(
                                                        const LoginDialog());

                                                    return;
                                                  }

                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    useRootNavigator: false,
                                                    builder: (context) {
                                                      return retailerNetworkPopup(
                                                          context,
                                                          statusToUpdate:
                                                              storeController
                                                                          .networkStatus
                                                                          .value ==
                                                                      true
                                                                  ? "N"
                                                                  : "Y");
                                                    },
                                                  );
                                                },
                                                child: AbsorbPointer(
                                                  child: AdvancedSwitch(
                                                    controller: storeController
                                                        .networkStatus,
                                                    height: 10,
                                                    width: 25,
                                                    activeColor: Colors.white,
                                                    inactiveColor: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    thumb:
                                                        ValueListenableBuilder<
                                                            bool>(
                                                      valueListenable:
                                                          storeController
                                                              .networkStatus,
                                                      builder: (context,
                                                          isActive, child) {
                                                        print(
                                                            "isThumb active -> ${isActive}");

                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isActive
                                                                ? Colors.orange
                                                                : Colors
                                                                    .black, // Thumb colors
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    initialValue:
                                                        storeController
                                                            .networkStatus
                                                            .value,
                                                    onChanged: (value) {
                                                      // _showConfirmationDialog(
                                                      //     value);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),

                              Expanded(
                                child: index == 5
                                    ? Lottie.asset(
                                        'assets/icons/quick_delivery_ani.json',
                                        width: 40,
                                        package: 'store_app_b2b')
                                    : index != 6
                                        ? Image.asset(
                                            "${storeController.buyProductList[index]["icon"]}",
                                            height: 40,
                                            width: 40,
                                            package: 'store_app_b2b',
                                            fit: BoxFit.contain,
                                          )
                                        : storeController.networkStatus.value
                                            ? Image.asset(
                                                "assets/icons/network_retailer_active.png",
                                                height: 40,
                                                width: 40,
                                                package: 'store_app_b2b',
                                                fit: BoxFit.contain,
                                              )
                                            : Image.asset(
                                                "assets/icons/network_retailer_inactive.png",
                                                height: 40,
                                                width: 40,
                                                package: 'store_app_b2b',
                                                fit: BoxFit.contain,
                                              ),
                              ),
                              // index == 3
                              //     ? const SizedBox(
                              //         height: 10,
                              //       )
                              //     : const SizedBox(),
                              Expanded(
                                child: index != 6
                                    ? CommonText(
                                        content:
                                            "${storeController.buyProductList[index]["title"]}",
                                        textColor: ColorsConst.textColor,
                                        boldNess: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                        textSize: 11,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : storeController.networkStatus.value
                                        ? CommonText(
                                            content:
                                                "${storeController.buyProductList[index]["title"]}",
                                            textColor: ColorsConst.textColor,
                                            boldNess: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                            textSize: 11,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : CommonText(
                                            content:
                                                "${storeController.buyProductList[index]["title"]}",
                                            textColor:
                                                Color.fromRGBO(25, 23, 23, 0.4),
                                            boldNess: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                            textSize: 11,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  !isLogin
                      ? const SizedBox()
                      : const SizedBox(
                          height: 5,
                        ),
                  const SizedBox(
                    height: 0,
                  ),

                  Obx(
                    () => (storeController.isCreditLimitLoading.value)
                        ? const SizedBox()
                        : !isLogin
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorsConst.semiGreyColor
                                            .withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(6)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const CommonText(
                                          content: "Store Grade : ",
                                          textColor: AppColors.appblack,
                                          textSize: 14,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            content: storeController
                                                        .accountStatusModel
                                                        .storeGrade ==
                                                    null
                                                ? " - "
                                                : storeController
                                                    .accountStatusModel
                                                    .storeGrade!,
                                            textColor: AppColors.greenColor,
                                            boldNess: FontWeight.w600,
                                            textSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const CommonText(
                                          content: "Credit Days Per Order : ",
                                          textColor: AppColors.appblack,
                                          textSize: 14,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            content: storeController
                                                        .accountStatusModel
                                                        .unlockDays ==
                                                    null
                                                ? " - "
                                                : storeController
                                                    .accountStatusModel
                                                    .unlockDays!
                                                    .toStringAsFixed(0),
                                            textColor: AppColors.appblack,
                                            boldNess: FontWeight.w600,
                                            textSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const CommonText(
                                          content: "Daily Order Limit : ",
                                          textColor: AppColors.appblack,
                                          textSize: 14,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            content: storeController
                                                        .accountStatusModel
                                                        .dailyOrderLimit ==
                                                    null
                                                ? " - "
                                                : "₹ ${storeController.accountStatusModel.dailyOrderLimit!.toStringAsFixed(0)}",
                                            textColor: AppColors.appblack,
                                            boldNess: FontWeight.w600,
                                            textSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    if (storeController.accountStatusModel
                                            .creditApplicable ==
                                        "Y")
                                      Row(
                                        children: [
                                          const CommonText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            content: 'Credit Limit : ',
                                            textSize: 14,
                                            textColor: AppColors.appblack,
                                            // boldNess: FontWeight.w600,
                                            // textSize: 12,
                                          ),
                                          CommonText(
                                            content:
                                                '₹ ${(storeController.accountStatusModel.creditLimit == null) ? '0.00' : storeController.accountStatusModel.creditLimit!.toStringAsFixed(2)}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textColor: AppColors.appblack,
                                            boldNess: FontWeight.w600,
                                            textSize: 14,
                                          ),
                                        ],
                                      ),
                                    if (storeController.accountStatusModel
                                            .creditApplicable ==
                                        "Y")
                                      Row(
                                        children: [
                                          const CommonText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            content:
                                                'Available Credit Limit : ',
                                            textColor: AppColors.appblack,
                                            textSize: 14,
                                          ),
                                          CommonText(
                                            content:
                                                '₹ ${(storeController.accountStatusModel.creditLimit == null && storeController.accountStatusModel.outStandingAmount == null) ? '0.00' : storeController.accountStatusModel.outStandingAmount! < 0 ? storeController.accountStatusModel.creditLimit!.toStringAsFixed(2) : storeController.accountStatusModel.outStandingAmount! > storeController.accountStatusModel.creditLimit! ? (storeController.accountStatusModel.outStandingAmount! - storeController.accountStatusModel.creditLimit!).toStringAsFixed(2) : (storeController.accountStatusModel.creditLimit! - storeController.accountStatusModel.outStandingAmount!).toStringAsFixed(2)}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textColor: storeController
                                                            .accountStatusModel
                                                            .creditLimit ==
                                                        null &&
                                                    storeController
                                                            .accountStatusModel
                                                            .outStandingAmount ==
                                                        null
                                                ? ColorsConst.appblack54
                                                : storeController
                                                            .accountStatusModel
                                                            .creditLimit! >
                                                        storeController
                                                            .accountStatusModel
                                                            .outStandingAmount!
                                                    ? ColorsConst.greenColor
                                                    : ColorsConst.redColor,
                                            boldNess: FontWeight.w600,
                                            textSize: 14,
                                          ),
                                        ],
                                      ),
                                    if (storeController.accountStatusModel
                                            .creditApplicable !=
                                        "Y")
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CommonText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            content: 'Credit Applicable : ',
                                            textColor: AppColors.appblack,
                                            textSize: 14,
                                          ),
                                          CommonText(
                                            content: 'NO',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textColor: ColorsConst.redColor,
                                            boldNess: FontWeight.w600,
                                            textSize: 14,
                                          ),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        const CommonText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          content: 'Later Delivery : ',
                                          textColor: AppColors.appblack,
                                          textSize: 14,
                                        ),
                                        CommonText(
                                          content:
                                              '${(storeController.accountStatusModel.laterDeliveryIsEnable == "Y" ? "Available" : "Not Available")}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textColor: ColorsConst.appBlack34,
                                          boldNess: FontWeight.w600,
                                          textSize: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                  ),

                  // SizedBox(
                  //   height: 10,
                  // ),

                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(() => OrderStatusScreen());
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  //     decoration: BoxDecoration(
                  //         color: AppColors.appWhite,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Lottie.asset('assets/image/animation - vasavi.json',
                  //                 width: 50, package: 'store_app_b2b'),
                  //             // Image.asset(
                  //             //   "assets/icons/tracking-shipment.png",
                  //             //   width: 40,
                  //             //   package: 'store_app_b2b',
                  //             //   fit: BoxFit.cover,
                  //             // ),
                  //             SizedBox(
                  //               width: 10,
                  //             ),
                  //             CommonText(
                  //               content: "Order Status",
                  //               textColor: AppColors.appblack,
                  //               boldNess: FontWeight.w600,
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Obx(
                    () => SizedBox(
                      height: storeController.latestOrderResponseModel.isEmpty
                          ? 5
                          : 0,
                    ),
                  ),
                  Obx(() => (storeController.latestOrderResponseModel.isEmpty)
                      ? const SizedBox()
                      : Container(
                          height: 120,
                          width: width,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          // margin: EdgeInsets.only(top: height * 0.03),
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              // scrollDirection: Axis.vertical,
                              // autoPlay: true,
                              viewportFraction: 1,
                            ),
                            itemCount:
                                storeController.latestOrderResponseModel.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      // BoxShadow(
                                      //     color: Colors.black.withOpacity(0.3),
                                      //     offset: const Offset(0, 1),
                                      //     blurRadius: 1.2)
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                    color: ColorsConst.appWhite),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                'Order ID: ${storeController.latestOrderResponseModel[index].orderId ?? ''}',
                                            textSize: 14,
                                            textColor: const Color(0xff404040),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        AppHtmlText(
                                          storeController
                                                  .latestOrderResponseModel[
                                                      index]
                                                  .orderStatus ??
                                              '',
                                          fontSize: 11,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            content:
                                                'Placed on ${storeController.latestOrderResponseModel[index].orderDate!.day}-${storeController.latestOrderResponseModel[index].orderDate!.month}-${storeController.latestOrderResponseModel[index].orderDate!.year}',
                                            textSize: 12,
                                            textColor: const Color(0xff818181),
                                            boldNess: FontWeight.w400,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   onTap: () => Get.to(
                                        //       () => OrderDetailsScreen(),
                                        //       arguments: {
                                        //         'orderId': storeController
                                        //                 .latestOrderResponseModel[
                                        //                     index]
                                        //                 .orderId ??
                                        //             ''
                                        //       }),
                                        //   child: Container(
                                        //     height: 27,
                                        //     width: 85,
                                        //     margin: EdgeInsets.only(top: 10),
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(8),
                                        //       border: Border.all(
                                        //           color:
                                        //               ColorsConst.primaryColor),
                                        //     ),
                                        //     alignment: Alignment.center,
                                        //     child: CommonText(
                                        //         content: 'View Details',
                                        //         textSize: 10,
                                        //         textColor:
                                        //             ColorsConst.primaryColor),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const CommonText(
                                                content: 'Time: ',
                                                textColor: Color(0xff818181),
                                                textSize: 12,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                boldNess: FontWeight.w600,
                                              ),
                                              CommonText(
                                                content:
                                                    storeController.timeFormate(
                                                        "${storeController.latestOrderResponseModel[index].orderTime}"),
                                                // '${storeController.latestOrderResponseModel[index].orderTime ?? ''}',
                                                textColor:
                                                    const Color(0xff404040),
                                                textSize: 12,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                boldNess: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Get.to(
                                              () => OrderDetailsScreen(),
                                              arguments: {
                                                'orderId': storeController
                                                        .latestOrderResponseModel[
                                                            index]
                                                        .orderId ??
                                                    ''
                                              }),
                                          child: Container(
                                            height: 27,
                                            width: 85,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      ColorsConst.primaryColor),
                                            ),
                                            alignment: Alignment.center,
                                            child: CommonText(
                                                content: 'View Details',
                                                textSize: 10,
                                                textColor:
                                                    ColorsConst.primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )),
                  const SizedBox(height: 0),

                  // Obx(
                  //   () => storeController.isMedicalCategoryPresent.value
                  //       ? GridView.builder(
                  //           itemCount: storeController.secondStoreList.length,
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           padding: EdgeInsets.zero,
                  //           // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //           //   childAspectRatio: 1.2,
                  //           //   crossAxisCount: 2,
                  //           //   crossAxisSpacing: 20,
                  //           //   mainAxisSpacing: 20,
                  //           // ),
                  //           gridDelegate:
                  //               const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  //                   crossAxisCount: 3,
                  //                   height: 130,
                  //                   crossAxisSpacing: 10,
                  //                   mainAxisSpacing: 10),
                  //           itemBuilder: (context, index) {
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 switch (index) {
                  //                   // case 0:
                  //                   //   Get.to(() => const NotificationScreen());
                  //                   //   break;
                  //                   // case 1:
                  //                   //   Get.to(() => OrderHistoryScreen());
                  //                   //   break;
                  //                   // case 2:
                  //                   //   Get.to(() => SuppliersScreen());
                  //                   //   break;
                  //                   case 0:
                  //                     Get.to(() => OrderHistoryScreen());
                  //                     break;
                  //                   case 1:
                  //                     Get.to(() => const NotificationScreen());
                  //                     break;
                  //                   case 2:
                  //                     // Get.to(() => SuppliersScreen());
                  //                     Get.to(() => GrbOrderHistoryScreen());
                  //                     break;
                  //                   case 3:
                  //                     Get.to(() => InventoryScreen());
                  //                     break;
                  //                 }
                  //               },
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                   color: Colors.white,
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                       color: ColorsConst.semiGreyColor
                  //                           .withOpacity(0.3),
                  //                       spreadRadius: 3,
                  //                       blurRadius: 3,
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Image.asset(
                  //                       "${storeController.secondStoreList[index]["icon"]}",
                  //                       scale: 5,
                  //                       package: 'store_app_b2b',
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                     SizedBox(height: height * 0.02),
                  //                     CommonText(
                  //                       content:
                  //                           "${storeController.secondStoreList[index]["title"]}",
                  //                       textColor: ColorsConst.textColor,
                  //                       boldNess: FontWeight.w600,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         )
                  //       : GridView.builder(
                  //           itemCount: storeController.secondStoreList.length - 1,
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           padding: EdgeInsets.zero,
                  //           // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //           //   childAspectRatio: 1.2,
                  //           //   crossAxisCount: 2,
                  //           //   crossAxisSpacing: 20,
                  //           //   mainAxisSpacing: 20,
                  //           // ),
                  //           gridDelegate:
                  //               const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  //                   crossAxisCount: 2,
                  //                   height: 140,
                  //                   crossAxisSpacing: 10,
                  //                   mainAxisSpacing: 10),
                  //           itemBuilder: (context, index) {
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 switch (index) {
                  //                   // case 0:
                  //                   //   Get.to(() => const NotificationScreen());
                  //                   //   break;
                  //                   // case 1:
                  //                   //   Get.to(() => OrderHistoryScreen());
                  //                   //   break;
                  //                   // case 2:
                  //                   //   Get.to(() => SuppliersScreen());
                  //                   //   break;
                  //                   case 0:
                  //                     Get.to(() => OrderHistoryScreen());
                  //                     break;
                  //                   case 1:
                  //                     Get.to(() => const NotificationScreen());
                  //                     break;
                  //                   case 2:
                  //                     // Get.to(() => SuppliersScreen());
                  //                     Get.to(() => GrbOrderHistoryScreen());
                  //                     break;
                  //                   case 3:
                  //                     Get.to(() => InventoryScreen());
                  //                     break;
                  //                 }
                  //               },
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                   color: Colors.white,
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                       color: ColorsConst.semiGreyColor
                  //                           .withOpacity(0.3),
                  //                       spreadRadius: 3,
                  //                       blurRadius: 3,
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Image.asset(
                  //                       "${storeController.secondStoreList[index]["icon"]}",
                  //                       scale: 5,
                  //                       package: 'store_app_b2b',
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                     SizedBox(height: height * 0.02),
                  //                     CommonText(
                  //                       content:
                  //                           "${storeController.secondStoreList[index]["title"]}",
                  //                       textColor: ColorsConst.textColor,
                  //                       boldNess: FontWeight.w600,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(() => ExpiryProductsInfoScreen(
                  //           categoryId: '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                  //         ));
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(6)),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Image.asset(
                  //           "assets/image/expiry_dates_icon.png",
                  //           package: 'store_app_b2b',
                  //         ),
                  //         Gap(10),
                  //         Expanded(
                  //           child: CommonText(
                  //             content: 'Expiry dates product info',
                  //             textColor: Colors.black,
                  //             boldNess: FontWeight.w600,
                  //           ),
                  //         ),
                  //         Icon(Icons.chevron_right)
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // Gap(10),
                  GridView.builder(
                    itemCount: storeController.secondStoreList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //   childAspectRatio: 1.2,
                    //   crossAxisCount: 2,
                    //   crossAxisSpacing: 20,
                    //   mainAxisSpacing: 20,
                    // ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisCount: 4,
                            height: 100,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String userId = await SharPreferences.getString(
                                  SharPreferences.loginId) ??
                              '';

                          if (userId.isEmpty) {
                            Get.dialog(const LoginDialog());
                            return;
                          }
                          switch (index) {
                            // case 0:
                            //   Get.to(() => const NotificationScreen());
                            //   break;
                            // case 1:
                            //   Get.to(() => OrderHistoryScreen());
                            //   break;
                            // case 2:
                            //   Get.to(() => SuppliersScreen());
                            //   break;

                            //expiry start
                            case 0:
                              // Get.to(() => ExpiryProductsInfoScreen(
                              //       categoryId:
                              //           '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                              //     ));
                              Future<bool> fetchDateAndCheck() async {
                                // setState(() {
                                //   _isLoading = true;
                                // });

                                try {
                                  // Fetch current date from NTP server
                                  DateTime currentTime = await NTP.now();
                                  int currentMonth = currentTime.day;

                                  if ((currentMonth >= 1 &&
                                      currentMonth <= 10)) {
                                    // performAction();

                                    return true;
                                  } else {
                                    print("No action for this month.");
                                    return false;
                                  }
                                } catch (e) {
                                  print("Failed to fetch time from NTP: $e");
                                  return false;
                                }

                                //setState(() {
                                //   _isLoading = false;
                                // });
                              }

                              bool showContinue = await fetchDateAndCheck();

                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                useRootNavigator: false,
                                builder: (context) {
                                  return expiryPopup(context,
                                      showContinue: showContinue);
                                },
                              );
                              break;
                            // //expiry end
                            case 1:
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: true,
                              //   useRootNavigator: false,
                              //   builder: (context) {
                              //     return campaignEmergencyDialog(context);
                              //   },
                              // );
                              // return;
                              Get.to(() => const GrbProductsScreen(
                                    categoryId:
                                        '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                                  ));
                              // Get.to(() => const NotificationScreen());
                              break;
                            // case 2:
                            //   // Get.to(() => SuppliersScreen());
                            //   Get.to(() => GrbOrderHistoryScreen());
                            //   break;

                            //below is the previouse second store before split
                            // case 0:
                            //   Get.to(() => OrderHistoryScreen());
                            //   break;
                            // case 1:
                            //   // showDialog(
                            //   //   context: context,
                            //   //   barrierDismissible: true,
                            //   //   useRootNavigator: false,
                            //   //   builder: (context) {
                            //   //     return campaignEmergencyDialog(context);
                            //   //   },
                            //   // );
                            //   // return;
                            //   Get.to(() => GrbProductsScreen(
                            //         categoryId:
                            //             '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                            //       ));
                            //   // Get.to(() => const NotificationScreen());
                            //   break;
                            case 2:
                              // Get.to(() => SuppliersScreen());
                              Get.to(() => const GrbOrderHistoryScreen());
                              break;

                            case 3:
                              Get.to(() => OrderHistoryScreen());
                              break;
                            // case 3:
                            //   Get.to(() => CreditNoteScreen());

                            //   break;
                            // case 4:
                            //   Get.to(() => GrbProductsScreen(
                            //         categoryId:
                            //             '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                            //       ));
                            //   break;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              // BoxShadow(
                              //   color:
                              //       ColorsConst.semiGreyColor.withOpacity(0.3),
                              //   spreadRadius: 3,
                              //   blurRadius: 3,
                              // ),
                            ],
                          ),
                          padding: EdgeInsets.all(3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Gap(15),
                              Expanded(
                                child: Image.asset(
                                  "${storeController.secondStoreList[index]["icon"]}",
                                  height: 40,
                                  width: 40,
                                  package: 'store_app_b2b',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: CommonText(
                                  content:
                                      "${storeController.secondStoreList[index]["title"]}",
                                  textColor: ColorsConst.textColor,
                                  boldNess: FontWeight.w600,
                                  textSize: 11,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Gap(5),
                  GridView.builder(
                    itemCount: storeController.thirdStoreList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //   childAspectRatio: 1.2,
                    //   crossAxisCount: 2,
                    //   crossAxisSpacing: 20,
                    //   mainAxisSpacing: 20,
                    // ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisCount: 2,
                            height: 100,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String userId = await SharPreferences.getString(
                                  SharPreferences.loginId) ??
                              '';

                          if (userId.isEmpty) {
                            Get.dialog(const LoginDialog());
                            return;
                          }

                          switch (index) {
                            // case 0:
                            //   Get.to(() => const NotificationScreen());
                            //   break;
                            // case 1:
                            //   Get.to(() => OrderHistoryScreen());
                            //   break;
                            // case 2:
                            //   Get.to(() => SuppliersScreen());
                            //   break;
                            // case 0:
                            //   Get.to(() => OrderHistoryScreen());
                            //   break;
                            case 0:
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: true,
                              //   useRootNavigator: false,
                              //   builder: (context) {
                              //     return campaignEmergencyDialog(context);
                              //   },
                              // );
                              // return;
                              Get.to(() => const CreditNoteScreen());
                              break;
                            case 1:
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: true,
                              //   useRootNavigator: false,
                              //   builder: (context) {
                              //     return campaignEmergencyDialog(context);
                              //   },
                              // );
                              // return;
                              Get.to(() => const EntryNoteScreen());
                              break;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              // BoxShadow(
                              //   color:
                              //       ColorsConst.semiGreyColor.withOpacity(0.3),
                              //   spreadRadius: 3,
                              //   blurRadius: 3,
                              // ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Gap(15),
                              Expanded(
                                child: Image.asset(
                                  "${storeController.thirdStoreList[index]["icon"]}",
                                  height: 40,
                                  width: 40,
                                  package: 'store_app_b2b',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: CommonText(
                                  content:
                                      "${storeController.thirdStoreList[index]["title"]}",
                                  textColor: ColorsConst.textColor,
                                  boldNess: FontWeight.w600,
                                  textSize: 11,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Obx(
                    () => Container(
                      height: height * 0.25,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: ColorsConst.yellowColor,
                      ),
                      child: storeController.bannerBottomImageList.isEmpty
                          ? AppShimmerEffectView(
                              width: width,
                              borderRadius: 12,
                              baseColor: Colors.grey.withOpacity(0.9),
                              highlightColor: Colors.grey.withOpacity(0.3),
                            )
                          : CarouselSlider.builder(
                              options: CarouselOptions(
                                autoPlay: true,
                                viewportFraction: 1,
                              ),
                              itemCount:
                                  storeController.bannerBottomImageList.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                // print(itemIndex);
                                return storeController.bannerBottomImageList[
                                                itemIndex]['imageId'] !=
                                            null &&
                                        storeController
                                            .bannerBottomImageList[itemIndex]
                                                ['imageId']
                                            .isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: AppImageAsset(
                                          image: storeController
                                                  .bannerBottomImageList[
                                              itemIndex]?['imageId'],
                                          width: width,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : const SizedBox();
                              }),
                    ),
                  ),

                  if (storeController.storeCreditRating != null &&
                      isLogin &&
                      storeController.storeCreditRating!.avgPaymentPercentage !=
                          null) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      // height: 250,
                      padding: const EdgeInsets.fromLTRB(16, 0, 10, 10),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 0),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: SpeedometerGauge(storeController
                                    .storeCreditRating!.avgPaymentPercentage ??
                                0), // Pass your value here (e.g., 70)
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Table(
                              columnWidths: const <int, TableColumnWidth>{
                                0: FlexColumnWidth(1.3),

                                // 1: FixedColumnWidth(75),
                                // 2: FixedColumnWidth(65),
                                // 3: FixedColumnWidth(65)
                              },
                              border: TableBorder.all(
                                  color: Colors.black), // Table border
                              children: [
                                // Header Row
                                TableRow(
                                  children: [
                                    _buildColoredCell('', Colors.transparent,
                                        isHeader: true),
                                    _buildColoredCell('', Colors.red,
                                        isHeader: true),
                                    _buildColoredCell('', Colors.orange,
                                        isHeader: true),
                                    _buildColoredCell('', Colors.yellow,
                                        isHeader: true),
                                    _buildColoredCell('', Colors.green.shade200,
                                        isHeader: true),
                                    _buildColoredCell('', Colors.green,
                                        isHeader: true),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildColoredCell(
                                        'Discount on PTR', Colors.transparent,
                                        fontSize: 14.5.sp, isHeader: true),
                                    _buildColoredCell('Block', Colors.white,
                                        fontSize: 14.5.sp, isHeader: true),
                                    _buildColoredCell('0%', Colors.white,
                                        fontSize: 14.5.sp, isHeader: true),
                                    _buildColoredCell('2%', Colors.white,
                                        fontSize: 14.5.sp, isHeader: true),
                                    _buildColoredCell('4%', Colors.white,
                                        fontSize: 14.5.sp, isHeader: true),
                                    _buildColoredCell('6%', Colors.white,
                                        fontSize: 14.5.sp, isHeader: true),
                                  ],
                                ),
                              ]),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            content:
                                'Total Payments : ${storeController.storeCreditRating!.numOrders}',
                            textColor: ColorsConst.appblack54,
                            boldNess: FontWeight.w600,
                            textSize: 16,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            content:
                                'On Time Payments :  ${storeController.storeCreditRating!.numPaidOnTime}',
                            textColor: ColorsConst.appblack54,
                            boldNess: FontWeight.w600,
                            textSize: 16,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            content:
                                'Late Payments :  ${storeController.storeCreditRating!.numDelayedPayments}',
                            textColor: ColorsConst.appblack54,
                            boldNess: FontWeight.w600,
                            textSize: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],

                  if (storeController.storeCreditRating != null &&
                      isLogin &&
                      storeController.storeCreditRating!.totalOrderAmount !=
                          null &&
                      storeController.storeCreditRating!.totalOrderAmount !=
                          0) ...[
                    Container(
                      height: 250,
                      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      padding: const EdgeInsets.fromLTRB(4, 20, 4, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 0),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      width: double.infinity,
                      // color: Colors.blue,
                      child: CustomBarGraph(
                        chartData: {
                          "maxY": storeController.storeCreditRating!
                              .totalOrderAmount, // has to be int or double
                          "minY": 0, // has to be int or double
                          "width":
                              30, //has to be double or int or can be null. if null 10 width will be taken for bars.
                          "data": [
                            {
                              "xAxisName": "Order Amount", // has to be string,
                              "data": storeController
                                      .storeCreditRating!.totalOrderAmount ??
                                  0
                            },
                            {
                              "xAxisName": "Paid Amount", // has to be string
                              "data": storeController
                                      .storeCreditRating!.totalPaidAmount ??
                                  0 // has to be int or double,
                            },
                            {
                              "xAxisName": "Balance Amount", // has to be string
                              "data": storeController
                                      .storeCreditRating!.totalBalance ??
                                  0 // has to be int or double,
                            },
                          ]
                        },
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 139, 3, 1),
                            Color.fromRGBO(254, 198, 132, 1),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0)),
                        showLeftTitles: true,
                        showRightTiles: false,
                      ),
                    ),
                  ],

                  !isLogin
                      ? const SizedBox()
                      : const SizedBox(
                          height: 5,
                        ),

                  /// Top Buying Products Table Starts Here
                  !isLogin
                      ? const SizedBox()
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: const [
                              // BoxShadow(
                              //   color: Color.fromRGBO(0, 0, 0, 0.25),
                              //   offset: Offset(0, 0),
                              //   blurRadius: 3,
                              //   spreadRadius: 0,
                              // ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(2),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  CommonText(
                                    content: "Top Selling Products",
                                    textSize: 14,
                                    textColor: Color.fromRGBO(255, 139, 3, 1),
                                    boldNess: FontWeight.w500,
                                  ),
                                  SizedBox(width: 10),
                                  // Icon(
                                  //   Icons.payments,
                                  //   color: Color.fromRGBO(255, 139, 3, 1),
                                  // )
                                  AppImageAsset(
                                    image:
                                        'assets/icons/top_selling_product_icon.png',
                                    height: 18,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            196, 196, 196, 1))),
                                child: Column(
                                  children: [
                                    Table(
                                      border: const TableBorder(
                                          verticalInside: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                              style: BorderStyle.solid),
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                              style: BorderStyle.solid)),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      columnWidths: const <int,
                                          TableColumnWidth>{
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(1),
                                        // 1: FixedColumnWidth(75),
                                        // 2: FixedColumnWidth(65),
                                        // 3: FixedColumnWidth(65)
                                      },
                                      children: [
                                        TableRow(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                topRight: Radius.circular(7)),
                                            color:
                                                Color.fromRGBO(255, 139, 3, 1),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 4,
                                                  top: 4,
                                                  bottom: 4),
                                              child: CommonText(
                                                content: "Products",
                                                textSize: width * 0.035,
                                                textColor: Colors.white,
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 4,
                                                    top: 4,
                                                    bottom: 4),
                                                child: CommonText(
                                                  content: "Quantity",
                                                  textSize: width * 0.035,
                                                  textAlign: TextAlign.center,
                                                  textColor: Colors.white,
                                                  boldNess: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GetBuilder<DashboardController>(
                                      builder: (controller) {
                                        return dashboardController
                                                .isTopBuyingProductsLoading
                                            ? const Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  AppShimmerEffectView(
                                                      height: 150,
                                                      width: double.infinity),
                                                ],
                                              )
                                            : Container(
                                                height: 130,
                                                child: Container(
                                                  child: SingleChildScrollView(
                                                    child: Table(
                                                      defaultVerticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .middle,
                                                      columnWidths: const <int,
                                                          TableColumnWidth>{
                                                        0: FlexColumnWidth(2),
                                                        1: FlexColumnWidth(1),
                                                        // 1: FixedColumnWidth(75),
                                                        // 2: FixedColumnWidth(65),
                                                        // 3: FixedColumnWidth(65),
                                                      },
                                                      // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                                                      border: const TableBorder(

                                                          // horizontalInside: BorderSide(
                                                          //     width: 1,
                                                          //     color: Color.fromRGBO(224, 224, 224, 1),
                                                          //     style: BorderStyle.solid),
                                                          // left: BorderSide(
                                                          //     color: Color.fromRGBO(
                                                          //         196, 196, 196, 1)),
                                                          // right: BorderSide(
                                                          //     color: Color.fromRGBO(
                                                          //         196, 196, 196, 1)),
                                                          // bottom: BorderSide(
                                                          //     color: Color.fromRGBO(
                                                          //         196, 196, 196, 1)),
                                                          verticalInside:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          224,
                                                                          224,
                                                                          224,
                                                                          1),
                                                                  style: BorderStyle
                                                                      .solid)),
                                                      children: List.generate(
                                                        !isLogin ||
                                                                dashboardController
                                                                    .topBuyingProductsList
                                                                    .isEmpty
                                                            ? 5
                                                            : dashboardController
                                                                .topBuyingProductsList
                                                                .length,
                                                        (index) => TableRow(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 4,
                                                                      top: 4,
                                                                      bottom:
                                                                          4),
                                                              child: CommonText(
                                                                content: isLogin &&
                                                                        dashboardController
                                                                            .topBuyingProductsList
                                                                            .isNotEmpty
                                                                    ? dashboardController
                                                                            .topBuyingProductsList[index]
                                                                            .productName ??
                                                                        ""
                                                                    : " -",
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                                textColor:
                                                                    const Color
                                                                            .fromRGBO(
                                                                        77,
                                                                        77,
                                                                        77,
                                                                        1),
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 4,
                                                                      top: 4,
                                                                      bottom:
                                                                          4),
                                                              child: CommonText(
                                                                content: isLogin &&
                                                                        dashboardController
                                                                            .topBuyingProductsList
                                                                            .isNotEmpty
                                                                    ? dashboardController.topBuyingProductsList[index].finalQuantity !=
                                                                            null
                                                                        ? (dashboardController.topBuyingProductsList[index].finalQuantity!)
                                                                            .toStringAsFixed(0)
                                                                        : ""
                                                                    : " -",
                                                                textSize:
                                                                    width *
                                                                        0.03,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                textColor:
                                                                    const Color
                                                                            .fromRGBO(
                                                                        77,
                                                                        77,
                                                                        77,
                                                                        1),
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                  !isLogin ? const SizedBox() : const SizedBox(height: 5),

                  /// Purchases and profits container + table starts here

                  !isLogin
                      ? const SizedBox()
                      : GetBuilder<DashboardController>(builder: (context) {
                          DateTime now = DateTime.now();
                          String currentMonth =
                              DateFormat('MMMM yyyy').format(now);
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              // border: Border.all(
                              //     color: const Color.fromRGBO(203, 203, 203, 1),
                              //     width: 1),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    CommonText(
                                      content: "Purchases & Profit",
                                      textSize: 14,
                                      textColor: Color.fromRGBO(255, 139, 3, 1),
                                      boldNess: FontWeight.w500,
                                    ),
                                    SizedBox(width: 10),
                                    // Icon(
                                    //   Icons.payments,
                                    //   color: Color.fromRGBO(255, 139, 3, 1),
                                    // )
                                    AppImageAsset(
                                      image:
                                          'assets/icons/purchase_profit_icon.png',
                                      height: 18,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                dashboardController.isLtdSalesInfoLoading
                                    ? const AppShimmerEffectView(
                                        height: 130, width: double.infinity)
                                    : Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromRGBO(
                                                    196, 196, 196, 1))),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  height: 35,
                                                  width: 120,
                                                  child: const DottedLine(
                                                    direction: Axis.vertical,
                                                    lineLength: 35.0,
                                                    lineThickness: 1.0,
                                                    dashLength: 4.0,
                                                    dashColor: Colors.grey,
                                                    dashGapLength: 4.0,
                                                  ),
                                                  // color:
                                                  //     Color.fromRGBO(255, 139, 3, 1),
                                                ),
                                                // SizedBox(width: 5),
                                                // Container(
                                                //   color: Color.fromRGBO(255, 139, 3, 1),
                                                // ),
                                                Expanded(
                                                  child: CommonText(
                                                    content: "Purchase (₹)",
                                                    // textAlign: isLogin
                                                    //     ? TextAlign.start
                                                    //     : TextAlign.center,
                                                    textAlign: TextAlign.center,
                                                    textSize: 14.sp,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            139, 136, 136, 1),
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const DottedLine(
                                                  direction: Axis.vertical,
                                                  lineLength: 35.0,
                                                  lineThickness: 1.0,
                                                  dashLength: 4.0,
                                                  dashColor: Colors.grey,
                                                  dashGapLength: 4.0,
                                                ),
                                                Expanded(
                                                  child: CommonText(
                                                    content: "Profit (₹)",
                                                    textSize: 14.sp,
                                                    textAlign: TextAlign.center,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            139, 136, 136, 1),
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                            // const SizedBox(height: 10),
                                            Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: const Color.fromRGBO(
                                                  196, 196, 196, 1),
                                            ),
                                            // const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 50,
                                                  width: 120,
                                                  // color:
                                                  //     Color.fromRGBO(255, 139, 3, 1),
                                                  child: const Row(
                                                    children: [
                                                      Expanded(
                                                        child: CommonText(
                                                          content: "Till Date",
                                                          textSize: 14,
                                                          textColor:
                                                              Colors.black,
                                                          boldNess:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      DottedLine(
                                                        direction:
                                                            Axis.vertical,
                                                        lineLength: 50.0,
                                                        lineThickness: 1.0,
                                                        dashLength: 4.0,
                                                        dashColor: Colors.grey,
                                                        dashGapLength: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: CommonText(
                                                    content: isLogin &&
                                                            dashboardController
                                                                .ltdSalesInfo
                                                                .isNotEmpty
                                                        ? "${dashboardController.ltdSalesInfo["ltdSalesAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["ltdSalesAmount"].toStringAsFixed(2)}"
                                                        : "-",
                                                    textSize: 14,
                                                    // textAlign: isLogin
                                                    //     ? TextAlign.start
                                                    //     : TextAlign.center,
                                                    textAlign: TextAlign.center,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            30, 170, 36, 1),
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const DottedLine(
                                                  direction: Axis.vertical,
                                                  lineLength: 50.0,
                                                  lineThickness: 1.0,
                                                  dashLength: 4.0,
                                                  dashColor: Colors.grey,
                                                  dashGapLength: 4.0,
                                                ),
                                                Expanded(
                                                  child: CommonText(
                                                    content: isLogin &&
                                                            dashboardController
                                                                .ltdSalesInfo
                                                                .isNotEmpty
                                                        ? "${dashboardController.ltdSalesInfo["ltdDiscountAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["ltdDiscountAmount"].toStringAsFixed(2)}"
                                                        : "-",
                                                    textSize: 14,
                                                    textAlign: TextAlign.center,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            30, 170, 36, 1),
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                            // const SizedBox(height: 10),
                                            Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: const Color.fromRGBO(
                                                  196, 196, 196, 1),
                                            ),
                                            // const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 60,
                                                  width: 120,
                                                  // color:
                                                  //     Color.fromRGBO(255, 139, 3, 1),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: CommonText(
                                                            content:
                                                                currentMonth,
                                                            textSize: 14,
                                                            textColor:
                                                                Colors.black,
                                                            boldNess:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const DottedLine(
                                                        direction:
                                                            Axis.vertical,
                                                        lineLength: 60.0,
                                                        lineThickness: 1.0,
                                                        dashLength: 4.0,
                                                        dashColor: Colors.grey,
                                                        dashGapLength: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: CommonText(
                                                    content: isLogin &&
                                                            dashboardController
                                                                .ltdSalesInfo
                                                                .isNotEmpty
                                                        ? "${dashboardController.ltdSalesInfo["currentMonthSalesAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["currentMonthSalesAmount"].toStringAsFixed(2)}"
                                                        : "-",
                                                    textSize: 14,
                                                    // textAlign: isLogin
                                                    //     ? TextAlign.start
                                                    //     : TextAlign.center,
                                                    textAlign: TextAlign.center,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            30, 170, 36, 1),
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const DottedLine(
                                                  direction: Axis.vertical,
                                                  lineLength: 60.0,
                                                  lineThickness: 1.0,
                                                  dashLength: 4.0,
                                                  dashColor: Colors.grey,
                                                  dashGapLength: 4.0,
                                                ),
                                                Expanded(
                                                  child: CommonText(
                                                    content: isLogin &&
                                                            dashboardController
                                                                .ltdSalesInfo
                                                                .isNotEmpty
                                                        ? "${dashboardController.ltdSalesInfo["currentMonthDiscountAmount"] == null ? "0.00" : dashboardController.ltdSalesInfo["currentMonthDiscountAmount"].toStringAsFixed(2)}"
                                                        : "-",
                                                    textSize: 14,
                                                    textAlign: TextAlign.center,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            30, 170, 36, 1),
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),

                  /// Purchases and profits container + table ends here

                  /// Top Buying Products Table Ends Here
                  const SizedBox(height: 10),

                  // // Payment Dues Table Starts Here

                  // GetBuilder<PaymentController>(builder: (paymentController) {
                  //   return Container(
                  //       width: double.infinity,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         color: const Color.fromRGBO(255, 255, 255, 1),
                  //         boxShadow: const [
                  //           BoxShadow(
                  //             color: Color.fromRGBO(0, 0, 0, 0.25),
                  //             offset: Offset(0, 0),
                  //             blurRadius: 3,
                  //             spreadRadius: 0,
                  //           ),
                  //         ],
                  //       ),
                  //       padding: const EdgeInsets.all(12),
                  //       margin: EdgeInsets.all(2),
                  //       child: Column(
                  //         children: [
                  //           Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 child: const Row(
                  //                   children: [
                  //                     CommonText(
                  //                       content: "Payment Dues",
                  //                       textSize: 14,
                  //                       textColor:
                  //                           Color.fromRGBO(255, 139, 3, 1),
                  //                       boldNess: FontWeight.w500,
                  //                     ),
                  //                     SizedBox(width: 10),
                  //                     Icon(
                  //                       Icons.payments,
                  //                       color: Color.fromRGBO(255, 139, 3, 1),
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 5,
                  //               ),
                  //               Container(
                  //                 height: 1,
                  //                 width: 140,
                  //                 color: Colors.black,
                  //               )
                  //             ],
                  //           ),
                  //           SizedBox(height: 10),
                  //           Obx(
                  //             () => paymentController.isLoading.value
                  //                 ? AppShimmerEffectView(
                  //                     width: double.infinity,
                  //                     height: 180,
                  //                   )
                  //                 : Column(
                  //                     children: [
                  //                       isLogin &&
                  //                               paymentController
                  //                                   .paymentRequestList.isEmpty
                  //                           ? SizedBox()
                  //                           : Padding(
                  //                               padding: const EdgeInsets.only(
                  //                                   bottom: 10),
                  //                               child: Table(
                  //                                 // border: const TableBorder(
                  //                                 //     verticalInside: BorderSide(
                  //                                 //         width: 1,
                  //                                 //         color: Color.fromRGBO(
                  //                                 //             224, 224, 224, 1),
                  //                                 //         style:
                  //                                 //             BorderStyle.solid),
                  //                                 //     bottom: BorderSide(
                  //                                 //         width: 1,
                  //                                 //         color: Color.fromRGBO(
                  //                                 //             224, 224, 224, 1),
                  //                                 //         style:
                  //                                 //             BorderStyle.solid)
                  //                                 //             ),
                  //                                 defaultVerticalAlignment:
                  //                                     TableCellVerticalAlignment
                  //                                         .middle,
                  //                                 columnWidths: const <int,
                  //                                     TableColumnWidth>{
                  //                                   // 0: FlexColumnWidth(),
                  //                                   // 1: FixedColumnWidth(75),
                  //                                   0: FixedColumnWidth(90),
                  //                                   // 1: FixedColumnWidth(75),
                  //                                   1: FlexColumnWidth(),
                  //                                   2: FixedColumnWidth(85),
                  //                                   3: FixedColumnWidth(75)
                  //                                 },
                  //                                 children: [
                  //                                   TableRow(
                  //                                     children: [
                  //                                       Padding(
                  //                                         padding:
                  //                                             const EdgeInsets
                  //                                                 .all(4.0),
                  //                                         child: Container(
                  //                                           decoration: BoxDecoration(
                  //                                               color: Color
                  //                                                   .fromRGBO(
                  //                                                       255,
                  //                                                       139,
                  //                                                       3,
                  //                                                       1),
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           8)),
                  //                                           padding: EdgeInsets
                  //                                               .symmetric(
                  //                                                   horizontal:
                  //                                                       15,
                  //                                                   vertical:
                  //                                                       5),
                  //                                           child: CommonText(
                  //                                             content:
                  //                                                 "Invoice Date",
                  //                                             textSize:
                  //                                                 width * 0.035,
                  //                                             textColor:
                  //                                                 Colors.white,
                  //                                             boldNess:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       TableCell(
                  //                                         child: Padding(
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                   .all(4.0),
                  //                                           child: Container(
                  //                                             decoration: BoxDecoration(
                  //                                                 color: Color
                  //                                                     .fromRGBO(
                  //                                                         255,
                  //                                                         139,
                  //                                                         3,
                  //                                                         1),
                  //                                                 borderRadius:
                  //                                                     BorderRadius
                  //                                                         .circular(
                  //                                                             8)),
                  //                                             padding: EdgeInsets
                  //                                                 .symmetric(
                  //                                                     horizontal:
                  //                                                         15,
                  //                                                     vertical:
                  //                                                         5),
                  //                                             child: CommonText(
                  //                                               textAlign:
                  //                                                   TextAlign
                  //                                                       .center,
                  //                                               content:
                  //                                                   "Invoice \nNo",
                  //                                               textSize:
                  //                                                   width *
                  //                                                       0.033,
                  //                                               textColor:
                  //                                                   Colors
                  //                                                       .white,
                  //                                               boldNess:
                  //                                                   FontWeight
                  //                                                       .w500,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       Padding(
                  //                                         padding:
                  //                                             const EdgeInsets
                  //                                                 .all(4.0),
                  //                                         child: Container(
                  //                                           alignment: Alignment
                  //                                               .center,
                  //                                           decoration: BoxDecoration(
                  //                                               color: Color
                  //                                                   .fromRGBO(
                  //                                                       255,
                  //                                                       139,
                  //                                                       3,
                  //                                                       1),
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           8)),
                  //                                           padding: EdgeInsets
                  //                                               .symmetric(
                  //                                                   // horizontal:
                  //                                                   //     15,
                  //                                                   vertical:
                  //                                                       5),
                  //                                           child: CommonText(
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             content:
                  //                                                 "Amount\n(₹)",
                  //                                             textSize:
                  //                                                 width * 0.035,
                  //                                             textColor:
                  //                                                 Colors.white,
                  //                                             boldNess:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       Padding(
                  //                                         padding:
                  //                                             const EdgeInsets
                  //                                                 .all(4.0),
                  //                                         child: Container(
                  //                                           decoration: BoxDecoration(
                  //                                               color: Color
                  //                                                   .fromRGBO(
                  //                                                       255,
                  //                                                       139,
                  //                                                       3,
                  //                                                       1),
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           8)),
                  //                                           padding: EdgeInsets
                  //                                               .symmetric(
                  //                                                   horizontal:
                  //                                                       15,
                  //                                                   vertical:
                  //                                                       5),
                  //                                           child: CommonText(
                  //                                             content:
                  //                                                 "Due Days",
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             textSize:
                  //                                                 width * 0.035,
                  //                                             textColor:
                  //                                                 Colors.white,
                  //                                             boldNess:
                  //                                                 FontWeight
                  //                                                     .w500,
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                       Container(
                  //                         height: 140,
                  //                         child:
                  //                             isLogin &&
                  //                                     paymentController
                  //                                         .paymentRequestList
                  //                                         .isEmpty
                  //                                 ? const Center(
                  //                                     child: CommonText(
                  //                                         content:
                  //                                             "No Payment Dues",
                  //                                         boldNess:
                  //                                             FontWeight.w500,
                  //                                         textColor:
                  //                                             Color.fromRGBO(
                  //                                                 157,
                  //                                                 157,
                  //                                                 157,
                  //                                                 1)),
                  //                                   )
                  //                                 : SingleChildScrollView(
                  //                                     child: Table(
                  //                                       defaultVerticalAlignment:
                  //                                           TableCellVerticalAlignment
                  //                                               .middle,
                  //                                       columnWidths: const <int,
                  //                                           TableColumnWidth>{
                  //                                         // 0: FlexColumnWidth(),
                  //                                         // 1: FixedColumnWidth(75),
                  //                                         0: FixedColumnWidth(
                  //                                             90),
                  //                                         // 1: FixedColumnWidth(75),
                  //                                         1: FlexColumnWidth(),
                  //                                         2: FixedColumnWidth(
                  //                                             85),
                  //                                         3: FixedColumnWidth(
                  //                                             75)
                  //                                       },
                  //                                       // border: TableBorder.all(color: const Color(0xffD8D5D5)),
                  //                                       // border:
                  //                                       //     const TableBorder(
                  //                                       //         // horizontalInside: BorderSide(
                  //                                       //         //     width: 1,
                  //                                       //         //     color: Color.fromRGBO(224, 224, 224, 1),
                  //                                       //         //     style: BorderStyle.solid),
                  //                                       //         verticalInside: BorderSide(
                  //                                       //             width: 1,
                  //                                       //             color: Color
                  //                                       //                 .fromRGBO(
                  //                                       //                     224,
                  //                                       //                     224,
                  //                                       //                     224,
                  //                                       //                     1),
                  //                                       //             style: BorderStyle
                  //                                       //                 .solid)),
                  //                                       children: List.generate(
                  //                                         paymentController
                  //                                                 .paymentRequestList
                  //                                                 .isNotEmpty
                  //                                             ? paymentController
                  //                                                         .paymentRequestList
                  //                                                         .length *
                  //                                                     2 +
                  //                                                 1
                  //                                             : isLogin
                  //                                                 ? 0
                  //                                                 : 7,
                  //                                         // (index) => index ==
                  //                                         //         paymentController
                  //                                         //                 .paymentRequestList
                  //                                         //                 .length *
                  //                                         //             2
                  //                                         (index) => index ==
                  //                                                 (isLogin &&
                  //                                                         paymentController
                  //                                                             .paymentRequestList
                  //                                                             .isNotEmpty
                  //                                                     ? paymentController
                  //                                                             .paymentRequestList
                  //                                                             .length *
                  //                                                         2
                  //                                                     : 6)
                  //                                             ? TableRow(
                  //                                                 children: [
                  //                                                   CommonText(
                  //                                                     content:
                  //                                                         "",
                  //                                                     textSize:
                  //                                                         width *
                  //                                                             0.035,
                  //                                                     textColor:
                  //                                                         const Color.fromRGBO(
                  //                                                             45,
                  //                                                             54,
                  //                                                             72,
                  //                                                             1),
                  //                                                     boldNess:
                  //                                                         FontWeight
                  //                                                             .w400,
                  //                                                   ),
                  //                                                   TableCell(
                  //                                                     child:
                  //                                                         CommonText(
                  //                                                       content:
                  //                                                           "",
                  //                                                       textSize:
                  //                                                           width *
                  //                                                               0.035,
                  //                                                       textColor: Color.fromRGBO(
                  //                                                           45,
                  //                                                           54,
                  //                                                           72,
                  //                                                           1),
                  //                                                       boldNess:
                  //                                                           FontWeight.w400,
                  //                                                     ),
                  //                                                   ),
                  //                                                   CommonText(
                  //                                                     content:
                  //                                                         "",
                  //                                                     textSize:
                  //                                                         width *
                  //                                                             0.035,
                  //                                                     textColor:
                  //                                                         const Color.fromRGBO(
                  //                                                             45,
                  //                                                             54,
                  //                                                             72,
                  //                                                             1),
                  //                                                     boldNess:
                  //                                                         FontWeight
                  //                                                             .w400,
                  //                                                   ),
                  //                                                   CommonText(
                  //                                                     content:
                  //                                                         "",
                  //                                                     textAlign:
                  //                                                         TextAlign
                  //                                                             .center,
                  //                                                     textSize:
                  //                                                         width *
                  //                                                             0.035,
                  //                                                     textColor:
                  //                                                         Color.fromRGBO(
                  //                                                             45,
                  //                                                             54,
                  //                                                             72,
                  //                                                             1),
                  //                                                     boldNess:
                  //                                                         FontWeight
                  //                                                             .w400,
                  //                                                   ),
                  //                                                 ],
                  //                                               )
                  //                                             : index % 2 == 0
                  //                                                 ? TableRow(
                  //                                                     decoration: BoxDecoration(
                  //                                                         borderRadius: BorderRadius.circular(
                  //                                                             8),
                  //                                                         color: Color.fromRGBO(
                  //                                                             255,
                  //                                                             246,
                  //                                                             235,
                  //                                                             1)),
                  //                                                     children: [
                  //                                                       Padding(
                  //                                                         padding:
                  //                                                             const EdgeInsets.all(4.0),
                  //                                                         child:
                  //                                                             CommonText(
                  //                                                           textAlign:
                  //                                                               TextAlign.center,
                  //                                                           content: isLogin && paymentController.paymentRequestList.isNotEmpty
                  //                                                               ? paymentController.paymentRequestList[index ~/ 2].billDate == null
                  //                                                                   ? ""
                  //                                                                   : DateFormat('dd-MM-yy').format(paymentController.paymentRequestList[index ~/ 2].billDate ?? DateTime.now())
                  //                                                               : " -",
                  //                                                           textSize:
                  //                                                               width * 0.035,
                  //                                                           textColor: const Color.fromRGBO(
                  //                                                               77,
                  //                                                               77,
                  //                                                               77,
                  //                                                               1),
                  //                                                           boldNess:
                  //                                                               FontWeight.w400,
                  //                                                         ),
                  //                                                       ),
                  //                                                       Padding(
                  //                                                         padding:
                  //                                                             const EdgeInsets.all(4.0),
                  //                                                         child:
                  //                                                             Tooltip(
                  //                                                           textStyle:
                  //                                                               GoogleFonts.poppins(color: Colors.white),
                  //                                                           decoration:
                  //                                                               BoxDecoration(
                  //                                                             color: Colors.black,
                  //                                                             borderRadius: BorderRadius.circular(10),
                  //                                                           ),
                  //                                                           verticalOffset:
                  //                                                               10,
                  //                                                           triggerMode:
                  //                                                               TooltipTriggerMode.tap,
                  //                                                           preferBelow:
                  //                                                               false,
                  //                                                           showDuration:
                  //                                                               const Duration(seconds: 3),
                  //                                                           message:
                  //                                                               "Order No: ${isLogin && paymentController.paymentRequestList.isNotEmpty ? paymentController.paymentRequestList[index ~/ 2].orderId ?? "" : " -"} \nAmount : ₹${isLogin && paymentController.paymentRequestList.isNotEmpty ? (paymentController.paymentRequestList[index ~/ 2].billedAmount == null) ? '' : paymentController.paymentRequestList[index ~/ 2].billedAmount!.toStringAsFixed(0) : " -"}\nOrder On : ${isLogin && paymentController.paymentRequestList.isNotEmpty ? paymentController.paymentRequestList[index ~/ 2].billDate == null ? "" : DateFormat('dd-MM-yy').format(paymentController.paymentRequestList[index ~/ 2].billDate ?? DateTime.now()) : " -"}",
                  //                                                           child:
                  //                                                               CommonText(
                  //                                                             textAlign: TextAlign.center,
                  //                                                             content: isLogin && paymentController.paymentRequestList.isNotEmpty ? paymentController.paymentRequestList[index ~/ 2].orderId ?? "" : " -",
                  //                                                             textSize: width * 0.03,
                  //                                                             textColor: const Color.fromRGBO(77, 77, 77, 1),
                  //                                                             boldNess: FontWeight.w400,
                  //                                                           ),
                  //                                                         ),
                  //                                                       ),
                  //                                                       Padding(
                  //                                                         padding:
                  //                                                             const EdgeInsets.all(4.0),
                  //                                                         child:
                  //                                                             Column(
                  //                                                           crossAxisAlignment:
                  //                                                               CrossAxisAlignment.start,
                  //                                                           children: [
                  //                                                             Container(
                  //                                                               alignment: Alignment.center,
                  //                                                               child: CommonText(
                  //                                                                 content: isLogin && paymentController.paymentRequestList.isNotEmpty
                  //                                                                     ? (paymentController.paymentRequestList[index ~/ 2].balanceToBePaid == null)
                  //                                                                         ? ''
                  //                                                                         : paymentController.paymentRequestList[index ~/ 2].balanceToBePaid!.toStringAsFixed(0)
                  //                                                                     : " -",
                  //                                                                 textSize: width * 0.035,
                  //                                                                 textColor: const Color.fromRGBO(77, 77, 77, 1),
                  //                                                                 boldNess: FontWeight.w400,
                  //                                                               ),
                  //                                                             ),
                  //                                                           ],
                  //                                                         ),
                  //                                                       ),
                  //                                                       Padding(
                  //                                                         padding:
                  //                                                             EdgeInsets.all(4.0),
                  //                                                         child:
                  //                                                             Column(
                  //                                                           children: [
                  //                                                             isLogin && paymentController.paymentRequestList.isNotEmpty
                  //                                                                 ? AppHtmlText(
                  //                                                                     '${paymentController.paymentRequestList[index ~/ 2].dueSince ?? ''}',
                  //                                                                     fontSize: 14,
                  //                                                                   )
                  //                                                                 : CommonText(
                  //                                                                     content: "-",
                  //                                                                     textSize: width * 0.035,
                  //                                                                     textColor: const Color.fromRGBO(77, 77, 77, 1),
                  //                                                                     boldNess: FontWeight.w400,
                  //                                                                   ),
                  //                                                             GestureDetector(
                  //                                                               onTap: () {
                  //                                                                 if (isLogin && paymentController.paymentRequestList.isNotEmpty) {
                  //                                                                   Get.to(() => const home.HomeScreen(
                  //                                                                         moveToBottomIndex: 3,
                  //                                                                       ));
                  //                                                                 }
                  //                                                               },
                  //                                                               child: Container(
                  //                                                                 width: 40,
                  //                                                                 decoration: BoxDecoration(color: isLogin && paymentController.paymentRequestList.isNotEmpty ? Color.fromRGBO(255, 122, 0, 1) : Color.fromRGBO(139, 136, 136, 1), borderRadius: BorderRadius.circular(6)),
                  //                                                                 child: Center(
                  //                                                                   child: CommonText(
                  //                                                                     content: "Pay",
                  //                                                                     textSize: width * 0.035,
                  //                                                                     textColor: AppColors.appWhite,
                  //                                                                     boldNess: FontWeight.w500,
                  //                                                                   ),
                  //                                                                 ),
                  //                                                               ),
                  //                                                             )
                  //                                                           ],
                  //                                                         ),
                  //                                                       ),
                  //                                                     ],
                  //                                                   )
                  //                                                 : TableRow(
                  //                                                     children: [
                  //                                                       Container(
                  //                                                         height:
                  //                                                             10,
                  //                                                         color:
                  //                                                             Colors.white,
                  //                                                       ),
                  //                                                       Container(
                  //                                                         height:
                  //                                                             10,
                  //                                                         color:
                  //                                                             Colors.white,
                  //                                                       ),
                  //                                                       Container(
                  //                                                         height:
                  //                                                             10,
                  //                                                         color:
                  //                                                             Colors.white,
                  //                                                       ),
                  //                                                       Container(
                  //                                                         height:
                  //                                                             10,
                  //                                                         color:
                  //                                                             Colors.white,
                  //                                                       ),

                  //                                                       // DottedLine(
                  //                                                       //   dashColor: Color.fromRGBO(
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       1),
                  //                                                       // ),
                  //                                                       // DottedLine(
                  //                                                       //   dashColor: Color.fromRGBO(
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       1),
                  //                                                       // ),
                  //                                                       // DottedLine(
                  //                                                       //   dashColor: Color.fromRGBO(
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       1),
                  //                                                       // ),
                  //                                                       // DottedLine(
                  //                                                       //   dashColor: Color.fromRGBO(
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       224,
                  //                                                       //       1),
                  //                                                       // ),
                  //                                                     ],
                  //                                                   ),
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //           ),
                  //         ],
                  //       ));
                  // }),

                  // // Payment Dues Table Ends Here

                  // SizedBox(height: height * 0.05),
                ],
              ),
            ),
          );
        });
  }

  Widget retailerNetworkPopup(
    BuildContext, {
    required String statusToUpdate,
  }) {
    print("checking campaignsShowing in dialog --> ${API.campaignImg}");
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 90.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Gap(40),
            // Image.asset(
            //   "assets/image/grb_pop.png",
            //   package: 'store_app_b2b',
            // ),
            const Gap(20),
            const CommonText(
              content: "Are you sure ?",
              textColor: Color.fromRGBO(255, 139, 3, 1),
              textAlign: TextAlign.center,
              boldNess: FontWeight.w700,
              textSize: 16,
            ),
            const Gap(15),
            CommonText(
              content:
                  "Are you sure you want to ${statusToUpdate == "Y" ? "enable" : "disable"} the Network Retailer option to make it visible to other retailers?",
              textColor: Colors.black,
              textAlign: TextAlign.center,
              textSize: 14,
              boldNess: FontWeight.w400,
            ),
            const Gap(23),
            Obx(
              () => storeController.isUpdateNrLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 35.w,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: CommonText(
                                content: "Cancel",
                                textColor: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            storeController.updateNetworkRetailerStatus(
                                updateStatus: statusToUpdate);
                            // Get.back();
                            // Get.to(() => const ExpiryProductsInfoScreen(
                            //       categoryId: '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                            //     ));
                          },
                          child: Container(
                            width: 35.w,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: const CommonText(content: "Confirm")),
                          ),
                        ),
                      ],
                    ),
            ),
            // if (showContinue)

            // if (showContinue)
            const Gap(20),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(bool currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Switch State'),
          content: Text(
              'Do you want to turn ${currentValue ? 'Off' : 'On'} the switch?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                storeController.networkStatus.value =
                    !currentValue; // Update switch state
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(currentValue ? 'Off' : 'On'),
            ),
          ],
        );
      },
    );
  }
}

Widget expiryPopup(BuildContext, {required bool showContinue}) {
  print("checking campaignsShowing in dialog --> ${API.campaignImg}");
  return AlertDialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 0),
    contentPadding: EdgeInsets.zero,
    content: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 90.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(40),
          Image.asset(
            "assets/image/grb_pop.png",
            package: 'store_app_b2b',
          ),
          const Gap(20),
          const CommonText(
            content:
                "Expiry products are accepted from the 1st to 10th of each month, with a credit note issued for 40% on Net Rate for each product.",
            textColor: Colors.black,
            textAlign: TextAlign.center,
            textSize: 14,
          ),
          const Gap(20),
          const CommonText(
            content:
                "Only products expiring in the next 1 to 3 months are accepted; current month expiry products are not accepted.",
            textColor: Colors.black,
            textAlign: TextAlign.center,
            textSize: 14,
          ),
          const Gap(20),
          const CommonText(
            content:
                "Example: In October only November, December & January expiry products are accepted",
            textColor: Colors.black,
            textAlign: TextAlign.center,
            textSize: 14,
          ),
          const Gap(20),
          if (showContinue)
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(() => const ExpiryProductsInfoScreen(
                      categoryId: '3d1592c3-60fa-4f5e-9229-2ba36bcca886',
                    ));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: const CommonText(content: "Continue"),
              ),
            ),
          if (showContinue) const Gap(20),
        ],
      ),
    ),
  );
}

class SpeedometerGauge extends StatelessWidget {
  final double value; // The value to display on the speedometer

  SpeedometerGauge(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 220,
              width: double.infinity,
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: AnimatedRadialGauge(
                value: value, // Set the actual value you want to represent
                axis: const GaugeAxis(
                  pointer: GaugePointer.needle(
                    width: 4,
                    height: 110,
                    color: Colors.black, // Needle color
                  ),
                  style: GaugeAxisStyle(
                    thickness: 50,
                    background: Colors.transparent, // Background for the gauge
                    segmentSpacing: 0,
                  ),
                  min: 0,
                  max: 100, // Ensure this matches your value range
                  segments: [
                    GaugeSegment(
                        from: 0,
                        to: 20,
                        color: Colors.transparent), // Static red segment
                    GaugeSegment(
                        from: 20,
                        to: 45,
                        color: Colors.transparent), // Static yellow segment
                    GaugeSegment(
                        from: 45,
                        to: 100,
                        color: Colors.transparent), // Static green segment
                  ],
                ),
                duration: const Duration(
                    seconds: 1), // Animation duration for pointer movement
              ),
            ),
            Positioned(
              child: Container(
                height: 200,
                width: double.infinity,
                child: AnimatedRadialGauge(
                  value: 0, // Set the actual value you want to represent
                  axis: GaugeAxis(
                    pointer: const GaugePointer.needle(
                      width: 4,
                      height: 150,
                      color: Colors.transparent, // Needle color
                    ),
                    style: const GaugeAxisStyle(
                      thickness: 50,
                      background: Color(0xFFDFE2EC), // Background for the gauge
                      segmentSpacing: 0,
                    ),
                    min: 0,
                    max: 100, // Ensure this matches your value range
                    segments: [
                      const GaugeSegment(
                          from: 0,
                          to: 20,
                          color: Colors.red), // Static red segment
                      const GaugeSegment(
                          from: 20, to: 40, color: Colors.orange),
                      const GaugeSegment(
                          from: 40, to: 60, color: Colors.yellow),
                      GaugeSegment(
                        from: 60,
                        to: 80,
                        color: Colors.green.shade200,
                      ), // Static yellow segment
                      const GaugeSegment(
                          from: 80,
                          to: 100,
                          color: Colors.green), // Static green segment
                    ],
                  ),
                  duration: const Duration(
                      seconds: 1), // Animation duration for pointer movement
                ),
              ),
            ),
            Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: value),
                      duration: const Duration(
                          seconds: 1), // Duration for the animation
                      builder: (context, value, child) {
                        return Text(
                          value
                              .toInt()
                              .toString(), // Display the current value as an integer
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

Widget _buildColoredCell(String text, Color color,
    {bool isHeader = false, num fontSize = 16}) {
  return Container(
    color: color,
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
            fontSize: fontSize.toDouble()),
      ),
    ),
  );
}

void entryDataDialog(BuildContext context,
    {required bool isUpdate, String paidDate = '', String amount = ''}) {
  EntryNoteController controller = Get.put(EntryNoteController());
  controller.amountController.clear();
  controller.dateController.clear();
  controller.displayDate = "";
  if (isUpdate) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(paidDate);
    String parseDate = DateFormat('dd-MM-yyyy').format(date);
    controller.dateController.text = parseDate;
    controller.formattedDate = paidDate;
    controller.amountController.text = amount;
    print('dhana ${controller.dateController.text}');
    controller.update();
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor:
            Colors.black.withOpacity(0.01), // Slightly transparent background
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText(
                "Paid Amount",
                color: Color.fromRGBO(255, 139, 3, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: AppFont.poppins,
              ),
              Gap(2.h),
              TextFormField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7)
                ],
                decoration: InputDecoration(
                  counterText: "",
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  hintText: "Enter Amount",
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 208, 207, 207),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFont.poppins,
                  ),
                  border: InputBorder.none,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(
                      color: Colors.black,
                      //Color.fromRGBO(185, 185, 185, 1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              Gap(2.h),
              TextFormField(
                controller: controller.dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    controller.formattedDate =
                        DateFormat("yyyy-MM-dd").format(pickedDate);
                    controller.displayDate =
                        DateFormat("dd-MM-yyyy").format(pickedDate);

                    controller.dateController.text = controller.displayDate;
                    controller.update();
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: "",
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  hintText: "Paid Date",
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 208, 207, 207),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFont.poppins,
                  ),
                  border: InputBorder.none,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(
                      color: Colors.black,
                      //Color.fromRGBO(185, 185, 185, 1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              Gap(2.h),
              GestureDetector(
                onTap: () {
                  if (controller.validation()) {
                    isUpdate
                        ? controller.updateAmountAndDate()
                        : controller.paymetData();
                  }
                },
                child: Container(
                  width: 24.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromRGBO(255, 139, 3, 1),
                  ),
                  child: Center(
                    child: AppText(
                      "Enter",
                      fontFamily: AppFont.poppins,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
