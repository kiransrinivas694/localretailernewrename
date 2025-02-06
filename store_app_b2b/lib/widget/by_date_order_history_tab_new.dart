import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_calendar_dailog_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/order_history_controller/order_history_controller_new.dart';
import 'package:store_app_b2b/model/by_date_order_history_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/order_history_screens/order_details_screen_new.dart';
import 'package:store_app_b2b/widget/app_html_text_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class ByDateOrderHistoryTab extends StatelessWidget {
  ByDateOrderHistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<OrderHistoryController>(
      builder: (OrderHistoryController controller) {
        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    content: "From",
                    boldNess: FontWeight.w400,
                    textColor: ColorsConst.notificationTextColor,
                    textSize: width * 0.03,
                  ),
                  InkWell(
                    onTap: () async {
                      controller.selectFrom = await Get.dialog(CalendarDialog(
                        minSelectedDate: DateTime(DateTime.now().year - 1),
                      ));
                      controller.selectTo = null;
                      logs(
                          'by page selectFrom ----------> ${controller.selectFrom}');
                      controller.update();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ColorsConst.notificationTextColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: controller.selectFrom == null
                                ? "dd/MM/yyyy"
                                : DateFormat('dd/MM/yyyy').format(
                                    controller.selectFrom ?? DateTime.now()),
                            boldNess: FontWeight.w400,
                            textColor: ColorsConst.textColor,
                            textSize: width * 0.025,
                          ),
                          const Icon(Icons.calendar_month, size: 20),
                          // Image.asset(
                          //   "assets/icons/calender_icon.png",
                          //   scale: 4.5,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  CommonText(
                    content: "To",
                    boldNess: FontWeight.w400,
                    textColor: ColorsConst.notificationTextColor,
                    textSize: width * 0.03,
                  ),
                  InkWell(
                    onTap: () async {
                      controller.selectTo = await Get.dialog(CalendarDialog(
                        minSelectedDate: controller.selectFrom,
                      ));
                      logs(
                          'by page selectTo ----------> ${controller.selectTo}');
                      controller.update();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ColorsConst.notificationTextColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: controller.selectTo == null
                                ? "dd/MM/yyyy"
                                : DateFormat('dd/MM/yyyy').format(
                                    controller.selectTo ?? DateTime.now()),
                            boldNess: FontWeight.w400,
                            textColor: ColorsConst.textColor,
                            textSize: width * 0.025,
                          ),
                          const Icon(Icons.calendar_month, size: 20),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        controller.getBuyByDate();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: ColorsConst.appGradientColor,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        height: 30,
                        child: Center(
                          child: CommonText(
                            content: "Submit",
                            textSize: width * 0.035,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (controller.byProductList.isEmpty)
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/empty_order_history.png',
                          package: 'store_app_b2b',
                          fit: BoxFit.cover,
                          height: 258,
                        ),
                        SizedBox(height: 5),
                        CommonText(
                            content: 'Place Your First Order Now!',
                            textColor: ColorsConst.textColor,
                            textSize: 16,
                            boldNess: FontWeight.w500),
                      ],
                    ),
                  )
                : controller.isLoading.value
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.appWhite.withOpacity(0.4),
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor)),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: controller.byProductList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        content:
                                            '${DateFormat("yyyy-MM-dd").format(controller.byProductList[index].date ?? DateTime.now())}',
                                        boldNess: FontWeight.w500,
                                        textColor: Colors.black,
                                        textSize: width * 0.035,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CommonText(
                                                content: "Items : ",
                                                boldNess: FontWeight.w400,
                                                textColor:
                                                    ColorsConst.greyByTextColor,
                                                textSize: width * 0.035,
                                              ),
                                              CommonText(
                                                content:
                                                    '${controller.byProductList[index].totalItem}',
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
                                                textColor:
                                                    ColorsConst.greyByTextColor,
                                                textSize: width * 0.035,
                                              ),
                                              CommonText(
                                                content:
                                                    '${controller.byProductList[index].totalOrders}',
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
                                                textColor:
                                                    ColorsConst.greyByTextColor,
                                                textSize: width * 0.035,
                                              ),
                                              CommonText(
                                                content:
                                                    "₹ ${controller.byProductList[index].totalOrdersValue}",
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
                                ListView.builder(
                                  itemCount: controller.byProductList[index]
                                      .userOrderMobileDisplay.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, subIndex) {
                                    UserOrderMobileDisplay userOrder =
                                        controller.byProductList[index]
                                            .userOrderMobileDisplay[subIndex];
                                    return GestureDetector(
                                      onTap: () => Get.to(
                                          () => OrderDetailsScreen(),
                                          arguments: {
                                            'orderId': userOrder.orderId ?? ''
                                          }),
                                      child: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: CommonText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    content:
                                                        '${userOrder.storeName}',
                                                    boldNess: FontWeight.w600,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    textSize: width * 0.038,
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.07),
                                                // Expanded(
                                                //   child: CommonText(
                                                //     content: "#${userOrder.orderId}",
                                                //     boldNess: FontWeight.w600,
                                                //     textColor: ColorsConst.primaryColor,
                                                //     textSize: width * 0.038,
                                                //     overflow: TextOverflow.ellipsis,
                                                //   ),
                                                // ),
                                                CommonText(
                                                  content:
                                                      "₹ ${(userOrder.orderValue ?? 0).toStringAsFixed(2)}",
                                                  boldNess: FontWeight.w600,
                                                  textColor:
                                                      ColorsConst.textColor,
                                                  textSize: width * 0.038,
                                                ),
                                              ],
                                            ),
                                            CommonText(
                                              content: "#${userOrder.orderId}",
                                              boldNess: FontWeight.w600,
                                              textColor:
                                                  ColorsConst.primaryColor,
                                              textSize: width * 0.038,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          CommonText(
                                                            content:
                                                                "${DateFormat('hh:mm a').format(userOrder.orderDate ?? DateTime.now())}",
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textColor: ColorsConst
                                                                .notificationTextColor,
                                                            textSize:
                                                                width * 0.03,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () => Get.to(
                                                                () =>
                                                                    OrderDetailsScreen(),
                                                                arguments: {
                                                                  'orderId':
                                                                      userOrder
                                                                              .orderId ??
                                                                          ''
                                                                }),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: ColorsConst
                                                                        .textColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 3),
                                                              child: CommonText(
                                                                content:
                                                                    'Details',
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                                textColor:
                                                                    ColorsConst
                                                                        .notificationTextColor,
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // CommonText(
                                                      //   content: "${DateFormat('hh:mm a').format(userOrder.orderDate ?? DateTime.now())} | ${userOrder.supplierAddr ?? ''
                                                      //   }",
                                                      //   boldNess: FontWeight.w500,
                                                      //   textColor: ColorsConst
                                                      //       .notificationTextColor,
                                                      //   textSize: width * 0.03,
                                                      // ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CommonText(
                                                                content:
                                                                    "Items : ",
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                                textColor:
                                                                    ColorsConst
                                                                        .greyByTextColor,
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                              ),
                                                              CommonText(
                                                                content:
                                                                    '${userOrder.totalItems ?? 0}',
                                                                boldNess:
                                                                    FontWeight
                                                                        .w500,
                                                                textColor:
                                                                    ColorsConst
                                                                        .textColor,
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.03),
                                                          Row(
                                                            children: [
                                                              CommonText(
                                                                content:
                                                                    "Status : ",
                                                                boldNess:
                                                                    FontWeight
                                                                        .w400,
                                                                textColor:
                                                                    ColorsConst
                                                                        .greyByTextColor,
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                              ),
                                                              AppHtmlText(
                                                                userOrder
                                                                        .orderStatus ??
                                                                    '',
                                                                fontSize:
                                                                    width *
                                                                        0.035,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            index == 3 - 1
                                                ? const SizedBox()
                                                : const Divider(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      ),
          ],
        );
      },
    );
  }
}
