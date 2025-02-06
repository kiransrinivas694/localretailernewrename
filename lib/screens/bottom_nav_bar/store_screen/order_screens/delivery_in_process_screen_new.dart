import 'dart:developer';

import 'package:b2c/utils/custom_date_utils_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_search_field_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bottom_controller/order_controller/delivery_process_controller_new.dart';

import 'controller/delivery_in_progress_controller_new.dart';
import 'controller/new_order_screen_controller_new.dart';
import 'order_review_screens/review_order_screen_new.dart';

class DeliveryInProcessScreen extends StatefulWidget {
  DeliveryInProcessScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryInProcessScreen> createState() =>
      _DeliveryInProcessScreenState();
}

class _DeliveryInProcessScreenState extends State<DeliveryInProcessScreen> {
  final DeliveryInProcessController deliveryProcessController =
      Get.put(DeliveryInProcessController());

  ScrollController scrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool isLoadingMore = false.obs;
  @override
  void initState() {
    // TODO: implement onInit
    log('DELEVERY IN POGRESS ORDER TAB INIT');
    DeliveryProgressController.to.deliveryProgressRes.clear();
    DeliveryProgressController.to.deliveryProgressList.clear();
    DeliveryProgressController.to.deliveryProgressApi(
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
      await DeliveryProgressController.to.deliveryProgressApi(
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
          content: "Delivery in process",
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
      body: /*Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            CommonSearchField(
                controller: deliveryProcessController.searchController,
                suffixIcon: Image.asset(
                  "assets/icons/filter_icon.png",
                  scale: 4.5,
                )),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount:
                      DeliveryProgressController.to.deliveryProgressList.length,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content: "Order #253641",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w600,
                                  ),
                                  CommonText(
                                    content: "S. Srinivas",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                  CommonText(
                                    content: "Items     :  5",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                  CommonText(
                                    content: "Del Type : Instant",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CommonText(
                                    content: "2:05 pm",
                                    textSize: width * 0.038,
                                    textColor: AppColors.textColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                  SizedBox(height: height * 0.03),
                                  CommonText(
                                    content: "Picked up",
                                    textSize: width * 0.038,
                                    textColor: AppColors.greenColor,
                                    boldNess: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Obx(
                            () => deliveryProcessController.viewMore.value !=
                                    index.toString()
                                ? const SizedBox()
                                : SizedBox(
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              content: "₹308",
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
                                              content: "Debit Card",
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
                                                  "22 Feb 2022 (7 am - 10 am)",
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
                                              content: "0000000000",
                                              textSize: width * 0.038,
                                              textColor: AppColors.textColor,
                                              boldNess: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          InkWell(
                            onTap: () {
                              if (deliveryProcessController.viewMore.value !=
                                  "") {
                                if (deliveryProcessController.viewMore.value ==
                                    index.toString()) {
                                  deliveryProcessController.viewMore.value = "";
                                } else {
                                  deliveryProcessController.viewMore.value =
                                      index.toString();
                                }
                              } else {
                                deliveryProcessController.viewMore.value =
                                    index.toString();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CommonText(
                                  content: deliveryProcessController
                                              .viewMore.value ==
                                          index.toString()
                                      ? "View less"
                                      : "View More",
                                  textSize: width * 0.04,
                                  textColor: AppColors.hintColor,
                                  boldNess: FontWeight.w400,
                                ),
                                Icon(
                                  deliveryProcessController.viewMore.value ==
                                          index.toString()
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.hintColor,
                                  size: 18,
                                ),
                              ],
                            ),
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
            )
          ],
        ),
      )*/
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Obx(() {
              return DeliveryProgressController.to.deliveryProgressRes.isEmpty
                  ? Expanded(
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: DeliveryProgressController
                            .to.deliveryProgressList.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            content:
                                                "Order #${DeliveryProgressController.to.deliveryProgressList[index]['id']}",
                                            textSize: width * 0.038,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w600,
                                          ),
                                          CommonText(
                                            content: DeliveryProgressController
                                                    .to
                                                    .deliveryProgressList[index]
                                                ['userName'],
                                            textSize: width * 0.038,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w400,
                                          ),
                                          CommonText(
                                            content:
                                                "Items     :  ${DeliveryProgressController.to.deliveryProgressList[index]['items'].length}",
                                            textSize: width * 0.038,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w400,
                                          ),
                                          /*CommonText(
                                            content:
                                                "Del Type : ${DeliveryProgressController.to.deliveryProgressList[index]['isExpressDelivery']}",
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
                                      onPressed: () {
                                        Get.to(() => ReviewOrderScreen(
                                              orderData:
                                                  DeliveryProgressController.to
                                                          .deliveryProgressList[
                                                      index],
                                              orderStatus:
                                                  'Delivery In Process',
                                              orderStatusText:
                                                  'Delivery In Process',
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
                                /* SizedBox(height: height * 0.01),*/
                                /* widget.viewMore != index.toString()
                            ? const SizedBox()
                            :*/
                                SizedBox(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                "₹${double.parse(((DeliveryProgressController.to.deliveryProgressList[index]['paidAmount'] ?? 0) - (DeliveryProgressController.to.deliveryProgressList[index]['deliveryCharges'] ?? 0) - (DeliveryProgressController.to.deliveryProgressList[index]['serviceCharges'] ?? 0)).toString()).toStringAsFixed(0)}",
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
                                                "${DeliveryProgressController.to.deliveryProgressList[index]?['paymentMode'] ?? '--'}",
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
                                                // "${DeliveryProgressController.to.deliveryProgressList[index]['deliveryDate']} ${DeliveryProgressController.to.deliveryProgressList[index]['slot']}",
                                                "${(DeliveryProgressController.to.deliveryProgressList[index]['deliveryDate'] == null || DeliveryProgressController.to.deliveryProgressList[index]['deliveryDate'] == "") ? "" : customDateSubstringFormat(DeliveryProgressController.to.deliveryProgressList[index]['deliveryDate'])} ${DeliveryProgressController.to.deliveryProgressList[index]['slot']}",
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
                                                "${DeliveryProgressController.to.deliveryProgressList[index]['mobileNumber'] ?? '-'}",
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
                      ),
                    );
            }),
            Obx(() {
              return isLoadingMore.value
                  ? CupertinoActivityIndicator()
                  : SizedBox();
            })
          ],
        ),
      ),
    );
  }
}
