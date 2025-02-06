import 'dart:developer';

import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/new_order_screen_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/review_order_screen_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:get/get.dart';
import 'package:b2c/utils/custom_date_utils_new.dart';

class NewOrdersTab extends StatefulWidget {
  NewOrdersTab({
    Key? key,
    this.viewMore,
  }) : super(key: key);

  // final TextEditingController paymentSearchController;

  // final VoidCallback onTapMoreProduct;
  String? viewMore = "";

  @override
  State<NewOrdersTab> createState() => _NewOrdersTabState();
}

class _NewOrdersTabState extends State<NewOrdersTab> {
  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('NEW ORDER TAB INIT');
    NewOrderScreenController.to.newOrdersList.clear();
    NewOrderScreenController.to.newOrdersApi(
        queryParameters: {"page": page.value, "size": 10},
        storeID: GetHelperController.storeID.value);
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
      await NewOrderScreenController.to.newOrdersApi(
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
      return NewOrderScreenController.to.newOrdersRes.isEmpty
          ? CupertinoActivityIndicator(
              color: AppColors.primaryColor,
            )
          : ListView.builder(
              itemCount: NewOrderScreenController.to.newOrdersList.length,
              controller: scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 30),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  content:
                                      "${NewOrderScreenController.to.newOrdersList[index]['id']}",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w600,
                                ),
                                CommonText(
                                  content: NewOrderScreenController
                                      .to.newOrdersList[index]['userName'],
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                                CommonText(
                                  content:
                                      "Items     :  ${NewOrderScreenController.to.newOrdersList[index]['items'].length}",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),
                                /*  CommonText(
                                  content:
                                      "Del Type : ${NewOrderScreenController.to.newOrdersList[index]['isExpressDelivery']}",
                                  textSize: width * 0.038,
                                  textColor: AppColors.textColor,
                                  boldNess: FontWeight.w400,
                                ),*/
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () async {
                              final result =
                                  await Get.to(() => ReviewOrderScreen(
                                        orderData: NewOrderScreenController
                                            .to.newOrdersList[index],
                                      ));

                              if (result == "true") {
                                NewOrderScreenController.to.newOrdersList
                                    .clear();
                                page.value = 0;
                                NewOrderScreenController.to.newOrdersApi(
                                    queryParameters: {
                                      "page": page.value,
                                      "size": 10
                                    },
                                    storeID: GetHelperController.storeID.value);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CommonText(
                                content: "Review",
                                textSize: width * 0.035,
                                textColor: Colors.white,
                                boldNess: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      /* SizedBox(height: height * 0.01),*/
                      /* widget.viewMore != index.toString()
                    ? const SizedBox()
                    :*/
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
                                      "₹${double.parse(((NewOrderScreenController.to.newOrdersList[index]['paidAmount'] ?? 0) - (NewOrderScreenController.to.newOrdersList[index]['deliveryCharges'] ?? 0) - (NewOrderScreenController.to.newOrdersList[index]['serviceCharges'] ?? 0)).toString()).toStringAsFixed(0)}",
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
                                      "${NewOrderScreenController.to.newOrdersList[index]?['paymentMode'] ?? '--'}",
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
                                      // "${NewOrderScreenController.to.newOrdersList[index]['deliveryDate']} ${NewOrderScreenController.to.newOrdersList[index]['slot']}",
                                      "${(NewOrderScreenController.to.newOrdersList[index]['deliveryDate'] == null || NewOrderScreenController.to.newOrdersList[index]['deliveryDate'] == "") ? "" : customDateSubstringFormat(NewOrderScreenController.to.newOrdersList[index]['deliveryDate'])} ${NewOrderScreenController.to.newOrdersList[index]['slot']}",
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
                                      "${NewOrderScreenController.to.newOrdersList[index]['mobileNumber']}",
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
                        if (viewMore != "") {
                          if (viewMore == index.toString()) {
                            viewMore = "";
                          } else {
                            viewMore = index.toString();
                          }
                        } else {
                          viewMore = index.toString();
                        }
                        setState(() {});

                        print(viewMore);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(
                            content: viewMore == index.toString()
                                ? "View less"
                                : "View More",
                            textSize: width * 0.04,
                            textColor: ColorsConst.hintColor,
                            boldNess: FontWeight.w400,
                          ),
                          Icon(
                            viewMore == index.toString()
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
