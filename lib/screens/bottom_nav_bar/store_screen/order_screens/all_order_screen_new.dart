import 'dart:developer';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/all_order_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/review_order_screen_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_search_field_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'controller/cancelled_controller_new.dart';
import 'controller/delivered_controller_new.dart';
import 'controller/rejected_order_controller_new.dart';

class AllOrderScreen extends StatefulWidget {
  AllOrderScreen({Key? key}) : super(key: key);

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  // final DeliveredController deliveredController =
  // Get.put(DeliveredController());

  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('DELEVERY IN POGRESS ORDER TAB INIT');

    AllItemController.to.allOrdersApi(
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
      await AllItemController.to.allOrdersApi(
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
          content: "All orders",
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
                return ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: AllItemController.to.allOrdersList.length,
                  padding: const EdgeInsets.only(top: 30),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content:
                                        "Order ${AllItemController.to.allOrdersList[index]['id'] ?? '--'}",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w600,
                                  ),
                                  CommonText(
                                    content:
                                        "Items     :  ${AllItemController.to.allOrdersList[index]['items'].length}",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                  CommonText(
                                    content:
                                        "Del Type : ${AllItemController.to.allOrdersList[index]['paymentMode'] ?? '-'}",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CommonText(
                                    content: "All",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textBlackColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      Get.to(() => ReviewOrderScreen(
                                            orderData: AllItemController
                                                .to.allOrdersList[index],
                                            orderStatus: 'All',
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
                                        "₹${double.parse(((AllItemController.to.allOrdersList[index]['paidAmount'] ?? 0) - (AllItemController.to.allOrdersList[index]['deliveryCharges'] ?? 0) - (AllItemController.to.allOrdersList[index]['serviceCharges'] ?? 0)).toString()).toStringAsFixed(0)}",
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
                                        "${AllItemController.to.allOrdersList[index]['paymentMode'] ?? '0'}",
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
                                        "${AllItemController.to.allOrdersList[index]['deliveryDate']} ${AllItemController.to.allOrdersList[index]['slot']}",
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
                                        "${AllItemController.to.allOrdersList[index]['mobileNumber'] ?? '-'}",
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
