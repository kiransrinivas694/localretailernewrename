import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_primary_button.dart';
import 'package:store_app_b2b/components/common_search_field.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/order_history_screens/order_details_screen.dart';

class ShortSupplyOrderHistoryTab extends StatelessWidget {
  const ShortSupplyOrderHistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    content: "Mishra Enterprises ",
                    boldNess: FontWeight.w600,
                    textColor: ColorsConst.textColor,
                    textSize: width * 0.04,
                  ),
                  CommonText(
                    content: "Ramnagar, Manikonda",
                    boldNess: FontWeight.w400,
                    textColor: ColorsConst.textColor,
                    textSize: width * 0.03,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CommonText(
                        content: "Items : ",
                        boldNess: FontWeight.w400,
                        textColor: ColorsConst.greyByTextColor,
                        textSize: width * 0.035,
                      ),
                      CommonText(
                        content: "119",
                        boldNess: FontWeight.w500,
                        textColor: Colors.black,
                        textSize: width * 0.035,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CommonText(
                        content: "Orders : ",
                        boldNess: FontWeight.w400,
                        textColor: ColorsConst.greyByTextColor,
                        textSize: width * 0.035,
                      ),
                      CommonText(
                        content: "6",
                        boldNess: FontWeight.w500,
                        textColor: Colors.black,
                        textSize: width * 0.035,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CommonText(
                        content: "Total : ",
                        boldNess: FontWeight.w400,
                        textColor: ColorsConst.greyByTextColor,
                        textSize: width * 0.035,
                      ),
                      CommonText(
                        content: "₹ 1,11,088",
                        boldNess: FontWeight.w500,
                        textColor: Colors.black,
                        textSize: width * 0.035,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CommonText(
                                content: "02 Aug 2022",
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.textColor,
                                textSize: width * 0.04,
                              ),
                              SizedBox(width: width * 0.02),
                              CommonText(
                                content: "01:30pm ",
                                boldNess: FontWeight.w400,
                                textColor: ColorsConst.notificationTextColor,
                                textSize: width * 0.03,
                              ),
                            ],
                          ),
                          CommonText(
                            content: "₹15,236",
                            boldNess: FontWeight.w600,
                            textColor: ColorsConst.textColor,
                            textSize: width * 0.038,
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      CommonText(
                                        content: "Items : ",
                                        boldNess: FontWeight.w400,
                                        textColor: ColorsConst.greyByTextColor,
                                        textSize: width * 0.035,
                                      ),
                                      CommonText(
                                        content: "-15",
                                        boldNess: FontWeight.w500,
                                        textColor: ColorsConst.textColor,
                                        textSize: width * 0.035,
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Row(
                                        children: [
                                          CommonText(
                                            content: "Status : ",
                                            boldNess: FontWeight.w400,
                                            textColor:
                                                ColorsConst.greyByTextColor,
                                            textSize: width * 0.035,
                                          ),
                                          CommonText(
                                            content: "Billed",
                                            boldNess: FontWeight.w500,
                                            textColor: ColorsConst.greenColor,
                                            textSize: width * 0.035,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            // onTap: () => Get.to(() => OrderDetailsScreen(), arguments: {'orderId': userOrder.orderId ?? ''}),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorsConst.textColor,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: CommonText(
                                content: "Details",
                                boldNess: FontWeight.w400,
                                textColor: ColorsConst.notificationTextColor,
                                textSize: width * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                      index == 3 - 1 ? const SizedBox() : const Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
