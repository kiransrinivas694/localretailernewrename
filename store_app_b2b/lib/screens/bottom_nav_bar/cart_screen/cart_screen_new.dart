import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/screens/cart/cart_labtest_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/order_placed_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/tomorrow_delivery_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_verify_product_tab_new.dart';
import 'package:store_app_b2b/widget/grb_cart_overview_tab_new.dart';
import 'package:store_app_b2b/widget/tomorrow_delivery_tab.dart';
import 'package:store_app_b2b/widget/unverify_product_tab.dart';
import 'package:store_app_b2b/widget/verify_product_tab.dart';
import '../../../utils/shar_preferences_new.dart';

class CartScreen extends StatefulWidget {
  final int tabSelect;

  const CartScreen({Key? key, this.tabSelect = 0}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLogin = false;

  @override
  void initState() {
    getLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GlobalMainController gmController = Get.find<GlobalMainController>();
    if (gmController.isNeedToShowPaymentAwarenessPopups) {
      gmController.paymentAwarenessImgUrls.forEach((url) => precacheImage(
            NetworkImage(url),
            context,
            onError: (error, stackTrace) {
              print('Image failed to load: $error');
            },
          ));
    }
  }

  Future<dynamic> getLogin() async {
    isLogin =
        await SharPreferences.getBoolean(SharPreferences.isLogin) ?? false;
    log('cart isLogin ---> $isLogin');
    print('cart isLogin ---> $isLogin');
    !isLogin
        ? Get.dialog(barrierDismissible: false, const LoginDialog())
        : const SizedBox();
    // Future.delayed(
    //   Duration(seconds: 5),
    //   () {
    //     if (isLogin) {
    //       if (Get.isDialogOpen!) {
    //         // Close the open dialog
    //         print("after 5 seconds called");
    //         log("after 5 seconds called");
    //         Get.back();
    //       }
    //     }
    //   },
    // );
    setState(() {});
  }

  CartLabtestController cartLabtestController =
      Get.put(CartLabtestController());

  NrCartController nrCartController = Get.put(NrCartController());

  @override
  Widget build(BuildContext context) {
    cartLabtestController.rebook.value = false;
    log('tabSelect --->${widget.tabSelect}');
    log('cart isLogin inside build ---> $isLogin');
    print('cart isLogin inside build ---> $isLogin');
    return GetBuilder<CartController>(
        initState: (state) async {
          if (state.controller != null) {}
          //Future.delayed(const Duration(milliseconds: 150), () {
          CartController controller = Get.put(CartController());
          controller.tabController.animateTo(widget.tabSelect);
          // final StoreController storeController = Get.put(StoreController());
          // storeController.getAccountStatus();
          controller.getVerifiedProductDataApi();
          controller.getProductFindApiList();

          GlobalMainController gmController = Get.find<GlobalMainController>();

          bool isUserLoggedIn =
              await SharPreferences.getBoolean(SharPreferences.isLogin) ??
                  false;

          print("printing islogin before payment awwaareness -> $isLogin");

          if (gmController.isNeedToShowPaymentAwarenessPopups &&
              isUserLoggedIn) {
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: false,
              builder: (context) {
                return paymentAwarenessDialog(context);
              },
            );
          }
          //});
        },
        init: CartController(),
        builder: (cartController) {
          return !isLogin
              ? const SizedBox()
              : Column(
                  children: [
                    // Expanded(
                    //   child: VerifyProductTab(
                    //     cartController: cartController,

                    //     // onPlaceOrder: () {
                    //     //   Get.to(() => OrderPlacedScreen());
                    //     // },
                    //   ),
                    // ),
                    DefaultTabController(
                      initialIndex: widget.tabSelect ?? 0,
                      length: 5,
                      child: PreferredSize(
                        preferredSize: const Size.fromHeight(kToolbarHeight),
                        child: Material(
                          color: Colors.white,
                          child: TabBar(
                            isScrollable: true,
                            // isScrollable: true,
                            controller: cartController.tabController,
                            indicatorColor: ColorsConst.primaryColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 0,
                            indicator: const MD2Indicator(
                              indicatorSize: MD2IndicatorSize.normal,
                              indicatorHeight: 3.0,
                              indicatorColor: Colors.orange,
                            ),
                            onTap: (value) async {
                              if (value == 0) {
                                await cartController
                                    .getVerifiedProductDataApi();
                              } else if (value == 1) {
                                // await cartController.getGRBCart();
                                await cartController.getProductFindApiList();
                              } else if (value == 2) {
                                await cartController.getGRBCart();
                                // await cartController.getLaterDeliveryDataApi();
                              } else if (value == 3) {
                                print('clicked on 3');
                                await nrCartController
                                    .getVerifiedProductDataApi();
                                // await cartController.getProductFindApiList();
                              }
                            },
                            tabs: const [
                              Tab(
                                height: 55,
                                child: CommonText(
                                  content: "Cart",
                                  textAlign: TextAlign.center,
                                  textColor: Colors.black,
                                  boldNess: FontWeight.w600,
                                ),
                              ),
                              Tab(
                                height: 55,
                                child: CommonText(
                                  content: "Unlisted Cart",
                                  textAlign: TextAlign.center,
                                  textColor: Colors.black,
                                  boldNess: FontWeight.w600,
                                ),
                              ),

                              Tab(
                                height: 55,
                                child: CommonText(
                                  content: "GRB Cart",
                                  textAlign: TextAlign.center,
                                  textColor: Colors.black,
                                  boldNess: FontWeight.w600,
                                ),
                              ),
                              Tab(
                                height: 55,
                                child: CommonText(
                                  content: "Retailer Cart",
                                  textAlign: TextAlign.center,
                                  textColor: Colors.black,
                                  boldNess: FontWeight.w600,
                                ),
                              ),
                              Tab(
                                height: 55,
                                child: CommonText(
                                  content: "Diagnostic",
                                  textAlign: TextAlign.center,
                                  textColor: Colors.black,
                                  boldNess: FontWeight.w600,
                                ),
                              ),
                              // Tab(
                              //   height: 55,
                              //   child: CommonText(
                              //     content: "Later Delivery",
                              //     textAlign: TextAlign.center,
                              //     textColor: Colors.black,
                              //     boldNess: FontWeight.w600,
                              //   ),
                              // ),
                              // Tab(
                              //   height: 55,
                              //   child: CommonText(
                              //     content: "Unlisted Products",
                              //     textAlign: TextAlign.center,
                              //     textColor: Colors.black,
                              //     boldNess: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: cartController.tabController,
                        children: [
                          VerifyProductTab(
                            cartController: cartController,

                            // onPlaceOrder: () {
                            //   Get.to(() => OrderPlacedScreen());
                            // },
                          ),
                          UnVerifiedProductTab(
                              onOrderPlace: () {}, controller: cartController),
                          // VerifyProductTab(
                          //   cartController: cartController,

                          //   // onPlaceOrder: () {
                          //   //   Get.to(() => OrderPlacedScreen());
                          //   // },
                          // ),

                          GrbCartOverviewTab(
                            cartController: cartController,
                          ),
                          NrVerifyProductTab(
                            cartController: nrCartController,

                            // onPlaceOrder: () {
                            //   Get.to(() => OrderPlacedScreen());
                            // },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CartLabTestScreen()),
                          ),

                          // TomorrowDeliveryTab(),

                          // cartController.isLoading.value
                          //     ? const AppLoader()
                          //     : UnVerifiedProductTab(
                          //         controller: cartController,
                          //         onOrderPlace: () {
                          //           Get.to(() => const OrderPlacedScreen());
                          //         },
                          //       ),

                          // TomorrowDeliveryScreen()
                        ],
                      ),
                    ),
                  ],
                );
        });
  }

  Widget paymentAwarenessDialog(BuildContext) {
    // print("checking campaignsShowing in dialog --> ${API.campaignImg}");
    GlobalMainController gmController = Get.find<GlobalMainController>();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GetBuilder<CartController>(builder: (controller) {
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: gmController.paymentAwarenessImgUrls[
                                  controller.currentBanner],
                              placeholder: (context, url) {
                                return Container(
                                    // height: 200,
                                    width: double.infinity,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              },
                              placeholderFadeInDuration: Duration.zero,
                            )),
                      ),
                      Positioned(
                          top: -10,
                          right: -10,
                          child: GestureDetector(
                            onTap: () {
                              // Get.back();
                              if (controller.currentBanner ==
                                  gmController.paymentAwarenessImgUrls.length -
                                      1) {
                                Get.back();
                                Future.delayed(
                                  Duration(seconds: 1),
                                  () {
                                    controller.currentBanner = 0;
                                    controller.update();
                                  },
                                );

                                return;
                              }

                              controller.setAwarenessBanner();
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
          ),
        );
      }),
    );
  }
}
