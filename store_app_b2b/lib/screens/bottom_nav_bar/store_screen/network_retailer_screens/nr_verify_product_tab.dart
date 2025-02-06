import 'dart:convert';

import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_cart_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/cart_details_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/confirm_product_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_cart_details_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_confirm_product_screen.dart';

class NrVerifyProductTab extends StatelessWidget {
  NrVerifyProductTab({
    Key? key,
    required this.cartController,
  }) : super(key: key);

  final NrCartController cartController;
  final StoreController storeController = Get.put(StoreController());
  final GlobalMainController globalMainController =
      Get.find<GlobalMainController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<NrCartController>(builder: (controller) {
      return Column(
        children: [
          Expanded(
            child: cartController.cartListModel == null
                ? Center(
                    child: Image.asset(
                      'assets/image/empty_cart.png',
                      package: 'store_app_b2b',
                      fit: BoxFit.cover,
                      height: height * 0.3,
                    ),
                  )
                : (cartController.cartListModel!.storeVo.isEmpty)
                    ? Center(
                        child: Image.asset(
                          'assets/image/empty_cart.png',
                          package: 'store_app_b2b',
                          fit: BoxFit.cover,
                          height: height * 0.3,
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartController.cartListModel?.storeVo.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => NrCartDetailsScreen(
                                      cartId: cartController.cartListModel
                                              ?.storeVo[index].cartId ??
                                          '',
                                      storeName: cartController.cartListModel
                                              ?.storeVo[index].storeName ??
                                          '',
                                      storeId: cartController.cartListModel
                                              ?.storeVo[index].storeId ??
                                          '',
                                      cartController: cartController,
                                      items: cartController.cartListModel
                                              ?.storeVo[index].items ??
                                          [],
                                      storeIndex: index,
                                    ),
                                  )?.then(
                                    (value) async => await cartController
                                        .getVerifiedProductDataApi(),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: 15,
                                      left: 15,
                                      top: index == 0 ? 10 : 0,
                                      bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: CommonText(
                                              content: cartController
                                                      .cartListModel
                                                      ?.storeVo[index]
                                                      .storeName ??
                                                  '',
                                              boldNess: FontWeight.w600,
                                              textColor: Colors.black,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          CommonText(
                                            content:
                                                "₹${num.parse(cartController.cartListModel?.storeVo[index].totalPriceByStore!.toStringAsFixed(2) ?? "0").round().toStringAsFixed(2)}",
                                            boldNess: FontWeight.w600,
                                            textColor: Colors.black,
                                          )
                                        ],
                                      ),
                                      CommonText(
                                        content: cartController.cartListModel
                                                ?.storeVo[index].address ??
                                            '',
                                        textColor: ColorsConst.textColor,
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
                                                "${cartController.cartListModel?.storeVo[index].items.length}",
                                            boldNess: FontWeight.w600,
                                            textColor: Colors.black,
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => cartController
                                                .getStoreWiseDeleteProductApi(
                                                    index: index),
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
                content: "Note : Original bill includes PTR , -Discount , +Tax",
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: width,
                  color: const Color(0xffE5E5E5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        content:
                            "Today, ${DateFormat('dd MMM yy').format(DateTime.now())}",
                        textColor: Colors.black,
                        textSize: width * 0.035,
                        boldNess: FontWeight.w600,
                      ),
                      SizedBox(height: height * 0.001),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content:
                                "Products : ${cartController.productTotal.value}",
                            textSize: width * 0.035,
                            textColor: ColorsConst.textColor,
                          ),
                          CommonText(
                            content:
                                "Distributors : ${cartController.cartListModel?.storeVo.length ?? 0}",
                            textSize: width * 0.035,
                            textColor: ColorsConst.textColor,
                          ),
                          CommonText(
                            content:
                                "Total : ${cartController.cartListModel?.totalPrice != null ? num.parse(cartController.cartListModel?.totalPrice!.toStringAsFixed(2) ?? "0.00").round().toStringAsFixed(2) : 0.00}",
                            textSize: width * 0.035,
                            textColor: ColorsConst.textColor,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.0),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: globalMainController.isAllStoresLocked
                          ? null
                          :
                          // (storeController.accountStatusModel
                          //                 .purchaseAccountStatus ==
                          //             null ||
                          //         storeController.accountStatusModel
                          //             .purchaseAccountStatus!.isEmpty ||
                          //         storeController.accountStatusModel
                          //                 .purchaseAccountStatus!
                          //                 .toLowerCase() ==
                          //             'y')
                          //     ? null
                          //     :
                          () async {
                              await storeController.getAccountStatus();

                              if ((storeController
                                          .accountStatusModel.accountLocked ==
                                      null ||
                                  storeController.accountStatusModel
                                      .accountLocked!.isEmpty ||
                                  storeController
                                          .accountStatusModel.accountLocked!
                                          .toLowerCase() ==
                                      'y')) {
                                "Purchase Lock".showError();
                                return;
                              }
                              ;

                              if (cartController.cartListModel != null &&
                                  cartController
                                      .cartListModel!.storeVo.isNotEmpty) {
                                List cartIdJson = [];

                                for (int i = 0;
                                    i <
                                        (cartController.cartListModel?.storeVo
                                                .length ??
                                            0);
                                    i++) {
                                  List<String> productIdList = [];

                                  cartController.cartListModel?.storeVo[i].items
                                      .forEach((element) {
                                    if (element.stockAvailable == "3") {
                                      logs(
                                          'Element before checkout --> ${element.toJson()}');
                                    }

                                    // logs(
                                    // 'Element before checkout stock available --> ${element.}');
                                    // if (element.stockAvailable != "3") {
                                    productIdList.add(element.skuId ?? '');
                                    // }
                                  });
                                  cartIdJson.add({
                                    "storeId": cartController.cartListModel
                                            ?.storeVo[i].storeId ??
                                        "",
                                    "productId": productIdList,
                                  });
                                }

                                var body = {
                                  "cartId": cartIdJson,
                                  "userId": cartController.userId.value,
                                  "rewards": 'N',
                                  "cashback": 'N',
                                  "couponCode": 'N'
                                };

                                print(
                                    ">>>>>>>>>>>>>>>before checkout body>>>>${jsonEncode(body)}");

                                await cartController
                                    .getPlaceOrderApi(body)
                                    .then((value) {
                                  print("getPlaceOrderApi value>>>>$value");
                                  if (value != null) {
                                    print("this is not null");

                                    print(
                                        "printing tobepaid value -> ${value["toBePaid"]}");

                                    if (value["toBePaid"] == null) {
                                      "Something went wrong".showError();
                                      return;
                                    }

                                    if (value["toBePaid"] <= 0.0) {
                                      CommonSnackBar.showError(
                                          'Please add products to the cart');
                                      return;
                                    }

                                    void getVerifiedProductData() async {
                                      await cartController
                                          .getVerifiedProductDataApi();

                                      Get.to(
                                        () => NrConfirmProductScreen(
                                          paidAmount:
                                              value['toBePaid'].toString(),
                                          checkOutList: cartController
                                              .cartListModel!.storeVo,
                                          transactionId: value['id'].toString(),
                                        ),
                                      );
                                    }

                                    getVerifiedProductData();
                                  }
                                });
                                print(body);
                              } else {
                                CommonSnackBar.showError(
                                    'Please add products to cart');
                              }
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
                          child: storeController.isCreditLimitLoading.value ||
                                  cartController.isPlaceOrderLoading.value
                              ? const Center(
                                  child: CupertinoActivityIndicator(
                                      animating: true,
                                      radius: 10,
                                      color: Colors.white),
                                )
                              : globalMainController.isAllStoresLocked
                                  ? CommonText(
                                      content: "Purchase Lock",
                                      textSize: width * 0.035,
                                      textColor: Colors.white,
                                    )
                                  : (storeController.accountStatusModel
                                                  .accountLocked ==
                                              null ||
                                          storeController.accountStatusModel
                                              .accountLocked!.isEmpty ||
                                          storeController.accountStatusModel
                                                  .accountLocked!
                                                  .toLowerCase() ==
                                              'y')
                                      ? CommonText(
                                          content: "Purchase Lock",
                                          textSize: width * 0.035,
                                          textColor: Colors.white,
                                        )
                                      : CommonText(
                                          content: "Check Out",
                                          textSize: width * 0.035,
                                          textColor: Colors.white,
                                        ),
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
      );
    });
  }
}
