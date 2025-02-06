import 'dart:convert';

import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/cart_details_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/confirm_product_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/grb_cart_details_screen_new.dart';

class GrbCartOverviewTab extends StatelessWidget {
  GrbCartOverviewTab({
    Key? key,
    required this.cartController,
  }) : super(key: key);

  final CartController cartController;
  final StoreController storeController = Get.put(StoreController());
  final GlobalMainController globalMainController =
      Get.find<GlobalMainController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<GlobalMainController>(builder: (controller) {
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: cartController.grbCartDetails == null ||
                        cartController.grbCartDetails!.storeVo == null ||
                        cartController.grbCartDetails!.storeVo!.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/image/empty_cart.png',
                          package: 'store_app_b2b',
                          fit: BoxFit.cover,
                          height: height * 0.3,
                        ),
                      )
                    : cartController.isDeleteGrbLoading
                        ? Center(child: CircularProgressIndicator())
                        : (cartController.grbCartDetails!.storeVo![0].items ==
                                    null ||
                                cartController
                                    .grbCartDetails!.storeVo![0].items!.isEmpty)
                            ? Center(
                                child: Image.asset(
                                  'assets/image/empty_cart.png',
                                  package: 'store_app_b2b',
                                  fit: BoxFit.cover,
                                  height: height * 0.3,
                                ),
                              )
                            : ListView.builder(
                                itemCount: 1,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => GrbCartDetailsScreen());
                                        },
                                        // onTap: () {
                                        //   Get.to(
                                        //     () => CartDetailsScreen(
                                        //       cartId: cartController.cartListModel
                                        //               ?.storeVo[index].cartId ??
                                        //           '',
                                        //       storeName: cartController.cartListModel
                                        //               ?.storeVo[index].storeName ??
                                        //           '',
                                        //       storeId: cartController.cartListModel
                                        //               ?.storeVo[index].storeId ??
                                        //           '',
                                        //       cartController: cartController,
                                        //       items: cartController.cartListModel
                                        //               ?.storeVo[index].items ??
                                        //           [],
                                        //       storeIndex: index,
                                        //     ),
                                        //   )?.then(
                                        //     (value) async => await cartController
                                        //         .getVerifiedProductDataApi(),
                                        //   );
                                        // },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 15,
                                              left: 15,
                                              top: index == 0 ? 10 : 0,
                                              bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: CommonText(
                                                      content: cartController
                                                              .grbCartDetails!
                                                              .storeVo![0]
                                                              .storeName ??
                                                          'ACINTYO LOCAL ORIENTED CUSTOMER APPLICATIONS PVT LTD',
                                                      boldNess: FontWeight.w600,
                                                      textColor: Colors.black,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  CommonText(
                                                    content:
                                                        "₹${num.parse(cartController.grbCartDetails!.storeVo![0].totalPriceByStore!.toStringAsFixed(2))}",
                                                    // "₹ ${cartController.grbCartDetails == null ? "0" : cartController.totalGrbAmount.round().toStringAsFixed(0)}",
                                                    // 'sdlfnjdsjifds',
                                                    boldNess: FontWeight.w600,
                                                    textColor: Colors.black,
                                                  )
                                                ],
                                              ),
                                              CommonText(
                                                content: cartController
                                                        .grbCartDetails
                                                        ?.userName ??
                                                    'ACINTYO LOCAL HYDERABAD',
                                                textColor:
                                                    ColorsConst.textColor,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              Row(
                                                children: [
                                                  const CommonText(
                                                    content: "Items :",
                                                    textColor: Colors.black,
                                                  ),
                                                  SizedBox(width: width * 0.02),
                                                  CommonText(
                                                    content:
                                                        "${cartController.grbCartDetails!.storeVo![0].items!.length}",
                                                    // 'slfjskfnsdf',
                                                    boldNess: FontWeight.w600,
                                                    textColor: Colors.black,
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () => cartController
                                                        .deleteGrbCart(
                                                            cartId: cartController
                                                                    .grbCartDetails!
                                                                    .id ??
                                                                ''),
                                                    child: Image.asset(
                                                        'assets/icons/delete_icon.png',
                                                        scale: 4),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: CommonText(
                    content: "Note : Original bill includes +Tax",
                    textColor: Colors.green,
                    boldNess: FontWeight.w500,
                    textSize: width * 0.030,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Container(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //   width: width,
                    //   color: const Color(0xffE5E5E5),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       CommonText(
                    //         content:
                    //             "Today, ${DateFormat('dd MMM yy').format(DateTime.now())}",
                    //         textColor: Colors.black,
                    //         textSize: width * 0.035,
                    //         boldNess: FontWeight.w600,
                    //       ),
                    //       SizedBox(height: height * 0.001),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     CommonText(
                    //       content:
                    //           "Products : ${cartController.productTotal.value}",
                    //       textSize: width * 0.035,
                    //       textColor: ColorsConst.textColor,
                    //     ),
                    //     CommonText(
                    //       content:
                    //           "Distributors : ${cartController.cartListModel?.storeVo.length ?? 0}",
                    //       textSize: width * 0.035,
                    //       textColor: ColorsConst.textColor,
                    //     ),
                    //     CommonText(
                    //       content:
                    //           "Total : ${cartController.cartListModel?.totalPrice != null ? num.parse(cartController.cartListModel?.totalPrice!.toStringAsFixed(2) ?? "0.00").round().toStringAsFixed(2) : 0.00}",
                    //       textSize: width * 0.035,
                    //       textColor: ColorsConst.textColor,
                    //     )
                    //   ],
                    // )
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          // if (cartController.grbCartDetails == null ||
                          //     cartController.grbCartDetails!.items == null ||
                          //     cartController.grbCartDetails!.items!.length < 1) {
                          //   CommonSnackBar.showError(
                          //       "Please add grb items to cart");
                          //   return;
                          // }

                          // previopusly used checkout
                          // cartController.generateGrb();

                          //curretn checkout
                          cartController.checkoutGrb();
                        },
                        child: Container(
                          height: 42,
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: ColorsConst.appGradientColor,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: CommonText(
                              content: "GRB Checkout",
                              textSize: width * 0.035,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ],
          ),
          cartController.grbCheckoutLoading ? AppLoader() : SizedBox()
        ],
      );
    });
  }
}
