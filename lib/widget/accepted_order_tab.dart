import 'dart:developer';

import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/review_order_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:get/get.dart';
import 'package:b2c/utils/custom_date_utils.dart';
import '../screens/bottom_nav_bar/store_screen/order_screens/controller/new_order_screen_controller.dart';

class AcceptedOrderTab extends StatefulWidget {
  AcceptedOrderTab({
    Key? key,
    required this.viewMore,
  }) : super(key: key);

  String viewMore = "";

  @override
  State<AcceptedOrderTab> createState() => _AcceptedOrderTabState();
}

class _AcceptedOrderTabState extends State<AcceptedOrderTab> {
  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('NEW ORDER TAB INIT');
    NewOrderScreenController.to.acceptedOrdersList.clear();
    NewOrderScreenController.to.acceptedOrdersApi(
      queryParameters: {"page": page.value, "size": 10},
      storeID: GetHelperController.storeID.value,
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
      await NewOrderScreenController.to.acceptedOrdersApi(
          queryParameters: {"page": page.value, "size": 10},
          storeID: GetHelperController.storeID.value);

      isLoadingMore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      return NewOrderScreenController.to.acceptedOrdersRes.isEmpty
          ? CupertinoActivityIndicator(
              color: AppColors.primaryColor,
            )
          : ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: NewOrderScreenController.to.acceptedOrdersList.length,
              padding: const EdgeInsets.only(top: 30),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  content: NewOrderScreenController.to
                                          .acceptedOrdersList[index]?['id'] ??
                                      '--',
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w600,
                                ),
                                CommonText(
                                  content: NewOrderScreenController
                                              .to.acceptedOrdersList[index]
                                          ?['userName'] ??
                                      '--',
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                                CommonText(
                                  content: "Items   : " +
                                      (NewOrderScreenController.to
                                                      .acceptedOrdersList[index]
                                                  ['items'] ??
                                              [])
                                          .length
                                          .toString(),
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                                /* CommonText(
                                  content:
                                      "Del Type : ${NewOrderScreenController.to.acceptedOrdersList[index]?['isExpressDelivery'] ?? '--'}",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),*/
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  Get.to(() => ReviewOrderScreen(
                                        orderData: NewOrderScreenController
                                            .to.acceptedOrdersList[index],
                                        orderStatus: 'Accepted',
                                        orderStatusText: 'Accepted',
                                      ));
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: CommonText(
                                    content: "Ready to Pick",
                                    textSize: width * 0.035,
                                    textColor: Colors.white,
                                    boldNess: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(height: height * 0.01),
                      SizedBox(
                        width: width,
                        child: Column(
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
                                      "₹${double.parse(((NewOrderScreenController.to.acceptedOrdersList[index]['paidAmount'] ?? 0) - (NewOrderScreenController.to.acceptedOrdersList[index]['deliveryCharges'] ?? 0) - (NewOrderScreenController.to.acceptedOrdersList[index]['serviceCharges'] ?? 0)).toString()).toStringAsFixed(0)}",
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
                                      "${NewOrderScreenController.to.acceptedOrdersList[index]['paymentMode'] ?? '--'}",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CommonText(
                                  content: "Delivery On:",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                                SizedBox(width: width * 0.02),
                                CommonText(
                                  content:
                                      // "${NewOrderScreenController.to.acceptedOrdersList[index]['deliveryDate']} ${NewOrderScreenController.to.acceptedOrdersList[index]['slot']}",
                                      "${(NewOrderScreenController.to.acceptedOrdersList[index]['deliveryDate'] == null || NewOrderScreenController.to.acceptedOrdersList[index]['deliveryDate'] == "") ? "" : customDateSubstringFormat(NewOrderScreenController.to.acceptedOrdersList[index]['deliveryDate'])} ${NewOrderScreenController.to.acceptedOrdersList[index]['slot']}",
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
                                      "${NewOrderScreenController.to.acceptedOrdersList[index]['mobileNumber']}",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      /* InkWell(
                  onTap: () {
                    if (widget.viewMore != "") {
                      if (widget.viewMore == index.toString()) {
                        widget.viewMore = "";
                      } else {
                        widget.viewMore = index.toString();
                      }
                    } else {
                      widget.viewMore = index.toString();
                    }

                    print(widget.viewMore);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        content: widget.viewMore == index.toString()
                            ? "View less"
                            : "View More",
                        textSize: width * 0.04,
                        textColor: AppColors.hintColor,
                        boldNess: FontWeight.w400,
                      ),
                      Icon(
                        widget.viewMore == index.toString()
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: ColorsConst.hintColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),*/
                      Divider(
                          color: AppColors.semiGreyColor,
                          thickness: 1,
                          height: 20)
                    ],
                  ),
                );
              },
            );
    });
  }
}
