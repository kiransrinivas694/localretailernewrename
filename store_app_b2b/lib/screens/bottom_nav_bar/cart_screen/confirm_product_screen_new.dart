import 'dart:convert';
import 'dart:developer';

import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/order_history_controller/order_history_controller_new.dart';
import 'package:store_app_b2b/helper/firebase_token_storeb2b_helper_new.dart';
import 'package:store_app_b2b/model/cart_model_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/order_placed_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class ConfirmProductScreen extends StatelessWidget {
  String? paidAmount = "";
  String? transactionId = "";
  List<StoreVo> checkOutList = [];

  ConfirmProductScreen(
      {Key? key,
      required this.paidAmount,
      required this.checkOutList,
      required this.transactionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetX<CartController>(initState: (state) async {
      await state.controller!.getUserId();
      await state.controller!.getVerifiedProductDataApi();
      await state.controller!.getProductFindApiList();
    }, builder: (cartController) {
      return Scaffold(
        backgroundColor: ColorsConst.greyBgColor,
        appBar: AppBar(
          centerTitle: false,
          title: CommonText(
            content: "Check Out Product",
            boldNess: FontWeight.w600,
            textSize: width * 0.047,
          ),
          elevation: 0,
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    content:
                        "Today, ${DateFormat('dd MMM yy').format(DateTime.now())}",
                    boldNess: FontWeight.w500,
                    textColor: Colors.black,
                    textSize: width * 0.035,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (cartController.isPlaceOrderLoading.value) {
                  return;
                }

                print("printing onclick in confirm order");

                cartController.isPlaceOrderLoading.value = true;

                // Comment minimum order check starts here
                OrderHistoryController orderController =
                    Get.put(OrderHistoryController());

                // orderController.selectFrom = DateTime.now();
                // orderController.selectTo = DateTime.now();
                bool? isPlaced = await orderController.getTodayOrderCount();

                if (isPlaced == null) return;

                print(
                    "prinitng today order length -> ${orderController.byProductList.length}");
                // Comment minimum order check ends here

                // if (double.parse(paidAmount!) <= 0.0) {
                //   CommonSnackBar.showError(
                //       'Please remove Out of Stock products');
                //   return;
                // }

                // Comment minimum order check starts here
                GlobalMainController gmController =
                    Get.find<GlobalMainController>();

                if (isPlaced == false &&
                    gmController.minimumOrderAmountConditionNeeded) {
                  if (double.parse(paidAmount!) <=
                      gmController.minimumOrderAmountValue) {
                    CommonSnackBar.showError(
                        'Minimum order value is ₹${gmController.minimumOrderAmountValue}');

                    cartController.isPlaceOrderLoading.value = false;
                    return;
                  }
                }

                // Comment minimum order check ends here

                String mobileNumber = await SharPreferences.getString(
                        SharPreferences.mobileNumber) ??
                    "";
                String ownerName = await SharPreferences.getString(
                        SharPreferences.ownerName) ??
                    "";
                String addressLine1 = await SharPreferences.getString(
                        SharPreferences.addressLine1) ??
                    "";
                String latitude =
                    await SharPreferences.getString(SharPreferences.latitude) ??
                        "";
                String longitude = await SharPreferences.getString(
                        SharPreferences.longitude) ??
                    "";
                String storeName = await SharPreferences.getString(
                        SharPreferences.storeName) ??
                    "";
                String userId =
                    await SharPreferences.getString(SharPreferences.loginId) ??
                        "";
                String storeNumber = await SharPreferences.getString(
                        SharPreferences.storeNumber) ??
                    "";
                String deliveryDate =
                    await DateFormat('ddMMyyyy').format(DateTime.now());
                // String fcmToken =
                //     await FirebaseMessaging.instance.getToken() ?? "";
                String fcmToken = await getFirebaseTokenStoreb2b();
                List cartIdJson = [];

                for (int i = 0; i < checkOutList.length; i++) {
                  List<String> productIdList = [];

                  checkOutList[i].items.forEach((element) {
                    logs('Element --> $element');
                    // if (element.stockAvailable != "3") {
                    productIdList.add(element.skuId ?? '');
                    // }
                  });
                  cartIdJson.add({
                    "storeId": checkOutList[i].storeId ?? '',
                    "productId": productIdList
                  });
                }
                print(cartIdJson);
                var bodyParse = {
                  "id": transactionId,
                  "transactionId": transactionId,
                  "transactionStatus": "S",
                  "paidAmount": 0,
                  "toBePaid": double.parse(paidAmount!),
                  "checkoutItems": cartIdJson,
                  "deliveryAddress": {
                    "mobileNumber": mobileNumber,
                    "name": ownerName,
                    "addressType": "Store",
                    "addressLine1": addressLine1,
                    "latitude": latitude,
                    "longitude": longitude,
                  },
                  "userName": storeName,
                  "userId": userId,
                  "mobileNumber": storeNumber,
                  "paymentMode": "Offline",
                  "slot": "Morning",
                  "deliveryDate": deliveryDate,
                  "expressDeliveryCharges": 0,
                  "fcmToken": fcmToken,
                  "expressDelivery": 'N'
                };
                log('checkout bodyParse --> ${jsonEncode(bodyParse)}');

                await cartController
                    .getConfirmOrderApi(bodyParse)
                    .then((value) {
                  print("confirmOrder>>>>>>>>>>>>>>>>>>$value");
                  Map<String, dynamic> responseMap = jsonDecode(value);
                  print("confirmOrder responseMap --- ${responseMap}");
                  if (responseMap["status"] == false) {
                    print("confirmOrder ---- called");
                    if (responseMap.containsKey('data') &&
                        responseMap['data'] != null) {
                      CommonSnackBar.showError(responseMap['data']);
                      // "${responseMap['data']}".showError();
                    } else {
                      CommonSnackBar.showError('Something went wrong');
                    }
                  } else {
                    Get.offAll(() => const OrderPlacedScreen());
                  }
                });
                // Get.to(() => OrderHistoryScreen());
              },
              child: Container(
                height: 42,
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: ColorsConst.appGradientColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: cartController.isPlaceOrderLoading.value
                      ? const Center(
                          child: CupertinoActivityIndicator(
                              animating: true, radius: 10, color: Colors.white),
                        )
                      : CommonText(
                          content: "Confirm Order",
                          textSize: width * 0.035,
                          textColor: Colors.white,
                        ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: checkOutList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    _buildList(checkOutList[index], width, height, paidAmount),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildList(StoreVo list, width, height, paidAmount) {
    // if (list != null)
    //   return Builder(builder: (context) {
    //     return ListTile(leading: SizedBox(), title: Text(list['No Product']));
    //   });
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(vertical: 10),
      textColor: ColorsConst.textColor,
      shape: const OutlineInputBorder(borderSide: BorderSide.none),
      iconColor: ColorsConst.textColor,
      initiallyExpanded: true,
      onExpansionChanged: (value) {
        print(value);
      },
      title: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  list.storeName ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                // "₹${(list.totalPriceByStore != null) ? list.totalPriceByStore!.toStringAsFixed(2) : "0.00"}",
                "₹${double.parse(paidAmount).toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      children: List.generate(
        list.items.length,
        (index) {
          var itemsList = list.items[index];
          // return itemsList.stockAvailable != "3"
          // ?
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CommonText(
                        content: "${itemsList.productName ?? ''}",
                        boldNess: FontWeight.w600,
                        textColor: Colors.black,
                      ),
                    ),
                    CommonText(
                      content:
                          "₹${((itemsList.price ?? 0) * (itemsList.buyQuantity)).toStringAsFixed(2)}",
                      boldNess: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonText(
                              content: "MRP",
                              textColor: ColorsConst.semiGreyColor,
                              textSize: width * 0.035,
                            ),
                            SizedBox(width: width * 0.01),
                            CommonText(
                              content:
                                  "₹${((itemsList.mrp == null) ? 0 : itemsList.mrp!.toStringAsFixed(2))}",
                              textSize: width * 0.035,
                              boldNess: FontWeight.w600,
                              textColor: ColorsConst.textColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CommonText(
                              content: "PTR",
                              textColor: ColorsConst.semiGreyColor,
                              textSize: width * 0.035,
                            ),
                            SizedBox(width: width * 0.01),
                            CommonText(
                              content:
                                  "₹${(itemsList.price == null) ? "" : itemsList.price!.toStringAsFixed(2)}",
                              textSize: width * 0.035,
                              boldNess: FontWeight.w600,
                              textColor: ColorsConst.textColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.03),
                    if (itemsList.schemeId != null &&
                        itemsList.schemeId!.isNotEmpty)
                      Image.asset(
                        "assets/icons/offer.png",
                        scale: 4,
                        package: 'store_app_b2b',
                      ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: CommonText(
                        content: "${itemsList.schemeName ?? ''}",
                        textSize: width * 0.035,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        boldNess: FontWeight.w600,
                        textColor: ColorsConst.textColor,
                      ),
                    ),
                    if (itemsList.schemeId == null ||
                        itemsList.schemeId!.isEmpty)
                      Row(
                        children: [
                          CommonText(
                            content: "QTY ",
                            textColor: ColorsConst.semiGreyColor,
                            textSize: width * 0.035,
                          ),
                          CommonText(
                            content:
                                "${itemsList.buyQuantity.toStringAsFixed(2)}",
                            textSize: width * 0.035,
                            boldNess: FontWeight.w600,
                            textColor: ColorsConst.textColor,
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: (itemsList.schemeId != null &&
                          itemsList.schemeId!.isNotEmpty)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (itemsList.schemeId != null &&
                        itemsList.schemeId!.isNotEmpty)
                      Column(
                        children: [
                          CommonText(
                            content: "QTY",
                            boldNess: FontWeight.w400,
                            textColor: ColorsConst.semiGreyColor,
                            textSize: width * 0.036,
                          ),
                          CommonText(
                            content:
                                "${((itemsList.buyQuantity)).toStringAsFixed(2)}",
                            textSize: width * 0.035,
                            boldNess: FontWeight.w600,
                            textColor: ColorsConst.textColor,
                          ),
                        ],
                      ),
                    if (itemsList.schemeId != null &&
                        itemsList.schemeId!.isNotEmpty)
                      Column(
                        children: [
                          CommonText(
                            content: "Free QTY",
                            boldNess: FontWeight.w400,
                            textColor: ColorsConst.semiGreyColor,
                            textSize: width * 0.036,
                          ),
                          CommonText(
                            content:
                                "${((itemsList.freeQuantity ?? 0)).toStringAsFixed(2)}",
                            textSize: width * 0.035,
                            boldNess: FontWeight.w600,
                            textColor: ColorsConst.textColor,
                          ),
                        ],
                      ),
                    if (itemsList.schemeId != null &&
                        itemsList.schemeId!.isNotEmpty)
                      Column(
                        children: [
                          CommonText(
                            content: "Final QTY",
                            boldNess: FontWeight.w400,
                            textColor: ColorsConst.semiGreyColor,
                            textSize: width * 0.036,
                          ),
                          CommonText(
                            content:
                                "${(itemsList.finalQuantity ?? 0).toStringAsFixed(2)}",
                            textSize: width * 0.035,
                            boldNess: FontWeight.w600,
                            textColor: ColorsConst.textColor,
                          )
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );
          // : SizedBox();
        },
      ),
    );
  }
}
