import 'dart:developer';

import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/review_order_screen_new.dart';
import 'package:b2c/utils/custom_date_utils_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_search_field_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bottom_controller/order_controller/delivered_order_controller_new.dart';

import 'controller/delivered_controller_new.dart';

class DeliveredOrderScreen extends StatefulWidget {
  DeliveredOrderScreen({Key? key}) : super(key: key);

  @override
  State<DeliveredOrderScreen> createState() => _DeliveredOrderScreenState();
}

class _DeliveredOrderScreenState extends State<DeliveredOrderScreen> {
  final DeliveredController deliveredController =
      Get.put(DeliveredController());

  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('DELEVERY IN POGRESS ORDER TAB INIT');
    DeliveredItemsController.to.deliveredRes.clear();
    DeliveredItemsController.to.deliveredList.clear();
    DeliveredItemsController.to.deliveredApi(
      queryParameters: {"page": page.value, "size": 10},
    );
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoadingMore.value = true;
      page.value = page.value + 1;
      log(
        page.value.toString(),
        name: "PAGE CHANGE",
      );
      await DeliveredItemsController.to.deliveredApi(
        queryParameters: {"page": page.value, "size": 10},
      );

      isLoadingMore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "Delivered orders",
          boldNess: FontWeight.w600,
          textSize: width * 0.047,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.appGradientColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            CommonSearchField(
              controller: deliveredController.searchController,
              /*suffixIcon: Image.asset(
                  "assets/icons/filter_icon.png",
                  scale: 4.5,
                )*/
            ),
            Expanded(
              child: Obx(() {
                return DeliveredItemsController.to.deliveredRes.isEmpty
                    ? CupertinoActivityIndicator(
                        color: AppColors.primaryColor,
                      )
                    : ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount:
                            DeliveredItemsController.to.deliveredList.length,
                        padding: const EdgeInsets.only(top: 30),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            content:
                                                "Order ${DeliveredItemsController.to.deliveredList[index]['id'] ?? '--'}",
                                            textSize: width * 0.038,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w600,
                                          ),
                                          CommonText(
                                            content: DeliveredItemsController
                                                    .to.deliveredList[index]
                                                ['userName'],
                                            textSize: width * 0.038,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w400,
                                          ),
                                          CommonText(
                                            content:
                                                "Items     :  ${DeliveredItemsController.to.deliveredList[index]['items'].length}",
                                            textSize: width * 0.038,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w400,
                                          ),
                                          // CommonText(
                                          //   content:
                                          //       "Del Type : ${DeliveredItemsController.to.deliveredList[index]['paymentMode'] ?? '-'}",
                                          //   textSize: width * 0.038,
                                          //   textColor: AppColors.textColor,
                                          //   boldNess: FontWeight.w400,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        // CommonText(
                                        //   content: "Delivered",
                                        //   textSize: width * 0.038,
                                        //   textColor: AppColors.greenColor,
                                        //   boldNess: FontWeight.w400,
                                        // ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.black,
                                          ),
                                          onPressed: () {
                                            Get.to(() => ReviewOrderScreen(
                                                  orderData:
                                                      DeliveredItemsController
                                                          .to
                                                          .deliveredList[index],
                                                  orderStatus: 'Delivered',
                                                  orderStatusText: "Delivered",
                                                ));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: CommonText(
                                              content: "Review",
                                              textSize: width * 0.035,
                                              textColor: Colors.white,
                                              boldNess: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CommonText(
                                          content: "Amount   :",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        CommonText(
                                          content:
                                              "₹${DeliveredItemsController.to.deliveredList[index]['orderTotalValue'] ?? ''}",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CommonText(
                                          content: "Payment :",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        CommonText(
                                          content:
                                              "${DeliveredItemsController.to.deliveredList[index]['paymentMode'] ?? '0'}",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CommonText(
                                          content: "Delivery   :",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        CommonText(
                                          content:
                                              // "${DeliveredItemsController.to.deliveredList[index]['deliveryDate']} ${DeliveredItemsController.to.deliveredList[index]['slot']}",
                                              "${(DeliveredItemsController.to.deliveredList[index]['deliveryDate'] == null || DeliveredItemsController.to.deliveredList[index]['deliveryDate'] == "") ? "" : customDateSubstringFormat(DeliveredItemsController.to.deliveredList[index]['deliveryDate'])} ${DeliveredItemsController.to.deliveredList[index]['slot']}",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CommonText(
                                          content: "Contact   :",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        CommonText(
                                          content:
                                              "${DeliveredItemsController.to.deliveredList[index]['mobileNumber'] ?? '-'}",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: AppColors.semiGreyColor,
                                    thickness: 1,
                                    height: 20)
                              ],
                            ),
                          );
                        },
                      );
              }),
            ),
            Obx(() {
              return isLoadingMore.value
                  ? CupertinoActivityIndicator()
                  : SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
