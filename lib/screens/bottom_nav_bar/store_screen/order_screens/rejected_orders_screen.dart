import 'dart:developer';
import 'package:b2c/utils/custom_date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_search_field.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'controller/delivered_controller.dart';
import 'controller/rejected_order_controller.dart';
import 'order_review_screens/review_order_screen.dart';

class RejectedOrderScreen extends StatefulWidget {
  RejectedOrderScreen({Key? key}) : super(key: key);

  @override
  State<RejectedOrderScreen> createState() => _RejectedOrderScreenState();
}

class _RejectedOrderScreenState extends State<RejectedOrderScreen> {
  // final DeliveredController deliveredController =
  // Get.put(DeliveredController());

  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('DELEVERY IN POGRESS ORDER TAB INIT');
    RejectedOrderController.to.rejectedOrdersRes.clear();
    RejectedOrderController.to.rejectedOrdersList.clear();
    RejectedOrderController.to.rejectedOrdersApi(
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
      await RejectedOrderController.to.rejectedOrdersApi(
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
          content: "Rejected orders",
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
              controller: TextEditingController(),
              /*suffixIcon: Image.asset(
                  "assets/icons/filter_icon.png",
                  scale: 4.5,
                )*/
            ),
            Expanded(
              child: Obx(() {
                return RejectedOrderController.to.rejectedOrdersRes.isEmpty
                    ? Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: RejectedOrderController
                            .to.rejectedOrdersList.length,
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          content:
                                              "Order ${RejectedOrderController.to.rejectedOrdersList[index]['id'] ?? '--'}",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w600,
                                        ),
                                        CommonText(
                                          content: RejectedOrderController
                                                  .to.rejectedOrdersList[index]
                                              ['userName'],
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                        CommonText(
                                          content:
                                              "Items     :  ${RejectedOrderController.to.rejectedOrdersList[index]['items'].length}",
                                          textSize: width * 0.038,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                        // CommonText(
                                        //   content:
                                        //       "Del Type : ${RejectedOrderController.to.rejectedOrdersList[index]['paymentMode'] ?? '-'}",
                                        //   textSize: width * 0.038,
                                        //   textColor: AppColors.textColor,
                                        //   boldNess: FontWeight.w400,
                                        // ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        // CommonText(
                                        //   content: "Rejected",
                                        //   textSize: width * 0.038,
                                        //   textColor: AppColors.redColor,
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
                                                      RejectedOrderController.to
                                                              .rejectedOrdersList[
                                                          index],
                                                  orderStatus: 'Rejected',
                                                  orderStatusText: "Rejected",
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
                                    ),
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
                                              "₹${double.parse(((RejectedOrderController.to.rejectedOrdersList[index]['paidAmount'] ?? 0) - (RejectedOrderController.to.rejectedOrdersList[index]['deliveryCharges'] ?? 0) - (RejectedOrderController.to.rejectedOrdersList[index]['serviceCharges'] ?? 0)).toString()).toStringAsFixed(0)}",
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
                                              "${RejectedOrderController.to.rejectedOrdersList[index]['paymentMode'] ?? '0'}",
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
                                              // "${RejectedOrderController.to.rejectedOrdersList[index]['deliveryDate']} ${RejectedOrderController.to.rejectedOrdersList[index]['slot']}",
                                              "${(RejectedOrderController.to.rejectedOrdersList[index]['deliveryDate'] == null || RejectedOrderController.to.rejectedOrdersList[index]['deliveryDate'] == "") ? "" : customDateSubstringFormat(RejectedOrderController.to.rejectedOrdersList[index]['deliveryDate'])} ${RejectedOrderController.to.rejectedOrdersList[index]['slot']}",
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
                                              "${RejectedOrderController.to.rejectedOrdersList[index]['mobileNumber'] ?? '-'}",
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
