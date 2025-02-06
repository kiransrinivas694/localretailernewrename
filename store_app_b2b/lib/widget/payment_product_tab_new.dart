import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/order_history_controller/order_details_controller_new.dart';
import 'package:store_app_b2b/model/order_details_model_new.dart';
import 'package:store_app_b2b/widget/app_html_text_new.dart';

class PaymentProductTab extends StatelessWidget {
  final String payerId;
  final String storeId;
  final String orderId;

  const PaymentProductTab(
      {super.key,
      required this.orderId,
      required this.storeId,
      required this.payerId});

  @override
  Widget build(BuildContext context) {
    logs('order id ---> ${orderId}');
    logs('storeId id ---> ${storeId}');
    logs('payerId id ---> ${orderId}');
    return GetBuilder<OrderDetailsController>(
      init: OrderDetailsController(),
      initState: (state) {
        Future.delayed(
          Duration(microseconds: 300),
          () {
            final orderDetailsController = Get.find<OrderDetailsController>();
            orderDetailsController.getOrderDetails(orderId: orderId);
          },
        );
      },
      builder: (OrderDetailsController orderDetailsController) {
        final width = MediaQuery.of(context).size.width;
        return Scaffold(
          extendBody: true,
          backgroundColor: ColorsConst.bgColor,
          body: Stack(
            children: [
              (orderDetailsController.orderDetailsModel == null ||
                      orderDetailsController.orderDetailsModel!.items.isEmpty)
                  ? Center(
                      child: CommonText(
                          content: 'No product found',
                          textColor: ColorsConst.textColor,
                          textSize: 18,
                          boldNess: FontWeight.w500),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                          onTap: () {
                                            orderDetailsController
                                                .currentActive = 0;
                                            orderDetailsController.update();
                                          },
                                          child: Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: orderDetailsController
                                                                .currentActive ==
                                                            0
                                                        ? 2
                                                        : 2,
                                                    color: orderDetailsController
                                                                .currentActive ==
                                                            0
                                                        ? ColorsConst
                                                            .primaryColor
                                                        : Colors.transparent),
                                              ),
                                            ),
                                            child: Center(
                                              child: CommonText(
                                                content: "Confirmed",
                                                textColor: orderDetailsController
                                                            .currentActive ==
                                                        0
                                                    ? ColorsConst.primaryColor
                                                    : Colors.black,
                                                boldNess: orderDetailsController
                                                            .currentActive ==
                                                        0
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                          onTap: () {
                                            orderDetailsController
                                                .currentActive = 1;
                                            orderDetailsController.update();
                                          },
                                          child: Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: orderDetailsController
                                                                .currentActive ==
                                                            1
                                                        ? 2
                                                        : 2,
                                                    color: orderDetailsController
                                                                .currentActive ==
                                                            1
                                                        ? ColorsConst
                                                            .primaryColor
                                                        : Colors.transparent),
                                              ),
                                            ),
                                            child: Center(
                                              child: CommonText(
                                                content: "Not Available",
                                                textColor: orderDetailsController
                                                            .currentActive ==
                                                        1
                                                    ? ColorsConst.primaryColor
                                                    : Colors.black,
                                                boldNess: orderDetailsController
                                                            .currentActive ==
                                                        1
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: orderDetailsController
                                                .orderDetailsModel ==
                                            null
                                        ? 0
                                        : orderDetailsController
                                                    .currentActive ==
                                                0
                                            ? orderDetailsController
                                                .availableList.length
                                            : orderDetailsController
                                                .notAvailableList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      OrderItem orderItem =
                                          orderDetailsController
                                                      .currentActive ==
                                                  0
                                              ? orderDetailsController
                                                  .availableList[index]
                                              : orderDetailsController
                                                  .notAvailableList[index];
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              content:
                                                  '${orderItem.productName ?? ''}',
                                              boldNess: FontWeight.w600,
                                              textColor:
                                                  ColorsConst.greyTextColor,
                                              textSize: 15,
                                            ),
                                            CommonText(
                                              content:
                                                  "${orderItem.manufacturer ?? '-'}",
                                              boldNess: FontWeight.w500,
                                              textColor:
                                                  ColorsConst.greyTextColor,
                                              textSize: 12,
                                            ),
                                            orderItem.schemeName != null &&
                                                    orderItem.schemeName != ""
                                                ? Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/offer.png",
                                                        scale: 4,
                                                        package:
                                                            'store_app_b2b',
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.01),
                                                      Expanded(
                                                        child: CommonText(
                                                          content:
                                                              "${orderItem.schemeName ?? ''}",
                                                          textSize: 12,
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor: ColorsConst
                                                              .textColor,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: AppHtmlText(
                                                  orderItem.stockStatus ?? '',
                                                  fontSize: 12),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      CommonText(
                                                        content: "MRP ",
                                                        boldNess:
                                                            FontWeight.w400,
                                                        textColor: ColorsConst
                                                            .hintColor,
                                                        textSize: 12,
                                                      ),
                                                      CommonText(
                                                        content:
                                                            "₹ ${(orderItem.mrp ?? 0).toStringAsFixed(2)}",
                                                        boldNess:
                                                            FontWeight.w500,
                                                        textColor: ColorsConst
                                                            .greyTextColor,
                                                        textSize: 12,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // orderDetailsController
                                                //             .orderDetailsModel
                                                //             ?.billed !=
                                                //         "1" ?
                                                Expanded(
                                                  child: CommonText(
                                                    textAlign: TextAlign.center,
                                                    content:
                                                        "Req Qty : ${num.parse('${orderItem.quantity ?? 0}').toStringAsFixed(0)}",
                                                    boldNess: FontWeight.w500,
                                                    textColor: ColorsConst
                                                        .primaryColor,
                                                    textSize: 12,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                // : const SizedBox(),
                                                Expanded(child: SizedBox())
                                                // CommonText(
                                                //   content:
                                                //   '',
                                                //   boldNess: FontWeight.w600,
                                                //   textColor: ColorsConst.textColor,
                                                //   textSize: 16,
                                                // ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      CommonText(
                                                        content: "PTR ",
                                                        boldNess:
                                                            FontWeight.w400,
                                                        textColor: ColorsConst
                                                            .hintColor,
                                                        textSize: 12,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      CommonText(
                                                        content:
                                                            "₹ ${orderDetailsController.orderDetailsModel?.billed != "1" ? (orderItem.price ?? 0).toStringAsFixed(2) : (orderItem.finalPtr ?? 0).toStringAsFixed(2)}",
                                                        boldNess:
                                                            FontWeight.w500,
                                                        textColor: ColorsConst
                                                            .greyTextColor,
                                                        textSize: 12,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // if (orderDetailsController.orderDetailsModel
                                                //             ?.orderStatus !=
                                                //         '0' &&
                                                //     orderDetailsController.orderDetailsModel
                                                //             ?.orderStatus !=
                                                //         '1')
                                                Expanded(
                                                  child: CommonText(
                                                    textAlign: TextAlign.center,
                                                    content:
                                                        "Avl Qty: ${num.parse('${orderItem.confirmQuantity ?? 0}').toStringAsFixed(0)}",
                                                    boldNess: FontWeight.w500,
                                                    textColor:
                                                        ColorsConst.greenColor,
                                                    textSize: 12,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CommonText(
                                                    textAlign: TextAlign.end,
                                                    content:
                                                        '₹ ${(orderDetailsController.orderDetailsModel?.billed != "1" ? (orderItem.buyQuantity ?? 0) * (orderItem.price ?? 0) : (orderItem.buyQuantity ?? 0) * (orderItem.finalPtr ?? 0)).toStringAsFixed(2)}',
                                                    boldNess: FontWeight.w600,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    textSize: 16,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            index == 5 - 1
                                                ? const SizedBox()
                                                : const Divider(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          content:
                                              // "Order value : ₹ ${(orderDetailsController.orderDetailsModel?.orderTotalValue ?? 0).toStringAsFixed(2)}",
                                              "Order Value : ${orderDetailsController.orderDetailsModel?.items.map((obj) => double.parse(obj.totalPrice.toString())).reduce((acc, price) => acc + price).round()}",
                                          boldNess: FontWeight.w600,
                                          textColor: ColorsConst.textColor,
                                          textSize: width * 0.04,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          content:
                                              "CR/DR Note : ₹ ${(orderDetailsController.orderDetailsModel?.creditNoteAmountAdjusted ?? 0).toStringAsFixed(2)}",
                                          boldNess: FontWeight.w600,
                                          textColor: ColorsConst.textColor,
                                          textSize: width * 0.04,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          content:
                                              "Total value : ₹ ${(orderDetailsController.orderDetailsModel?.orderTotalValue ?? 0).toStringAsFixed(2)}",
                                          boldNess: FontWeight.w600,
                                          textColor: ColorsConst.textColor,
                                          textSize: width * 0.04,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            content: "Status : ",
                                            textColor: ColorsConst.textColor,
                                            textSize: width * 0.042,
                                            boldNess: FontWeight.w600),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: AppHtmlText(
                                              '${(orderDetailsController.orderDetailsModel != null && orderDetailsController.orderDetailsModel!.orderEventStatus != null) ? orderDetailsController.orderDetailsModel!.orderEventStatus : ''}',
                                              maxLines: 2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.042,
                                              textOverFlow:
                                                  TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    orderDetailsController.orderDetailsModel !=
                                                null &&
                                            orderDetailsController
                                                    .orderDetailsModel!
                                                    .deliveryStatus !=
                                                null &&
                                            orderDetailsController
                                                    .orderDetailsModel!
                                                    .deliveryStatus ==
                                                '1'
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                  content:
                                                      "Order Accepted By User : ",
                                                  textColor:
                                                      ColorsConst.textColor,
                                                  textSize: width * 0.042,
                                                  boldNess: FontWeight.w600),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: AppHtmlText(
                                                    '${(orderDetailsController.orderDetailsModel != null && orderDetailsController.orderDetailsModel!.orderReceived != null) ? orderDetailsController.orderDetailsModel!.orderReceived == "Y" ? "Yes" : "No" : ''}',
                                                    maxLines: 2,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width * 0.042,
                                                    textOverFlow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                orderDetailsController.orderDetailsModel !=
                                            null &&
                                        orderDetailsController
                                                .orderDetailsModel!.packed !=
                                            null &&
                                        orderDetailsController
                                                .orderDetailsModel!.packed ==
                                            '1'
                                    ? orderDetailsController.isCSVSendLoading
                                        ? CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              orderDetailsController.sendCSV(
                                                  orderId: orderDetailsController
                                                          .orderDetailsModel!
                                                          .id ??
                                                      "");
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryColor,
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      "assets/icons/mail.png",
                                                      scale: 3.5,
                                                      package: 'store_app_b2b',
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                CommonText(
                                                  content: "Send CSV",
                                                  textColor:
                                                      AppColors.primaryColor,
                                                  boldNess: FontWeight.bold,
                                                  textSize: 12,
                                                )
                                              ],
                                            ),
                                          )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              // : Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     margin: const EdgeInsets.all(15),
              //     padding: const EdgeInsets.symmetric(
              //         vertical: 10, horizontal: 5),
              //     child: ListView.separated(
              //       separatorBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 5),
              //           child: const Divider(),
              //         );
              //       },
              //       itemCount:
              //           orderDetailsController.orderDetailsModel == null
              //               ? 0
              //               : orderDetailsController
              //                       .orderDetailsModel?.items.length ??
              //                   0,
              //       shrinkWrap: true,
              //       padding: EdgeInsets.zero,
              //       physics: const BouncingScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         OrderItem orderItem = orderDetailsController
              //                 .orderDetailsModel?.items[index] ??
              //             OrderItem();
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 5),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               CommonText(
              //                 content: '${orderItem.productName ?? ''}',
              //                 boldNess: FontWeight.w600,
              //                 textColor: ColorsConst.greyTextColor,
              //                 textSize: 15,
              //               ),
              //               CommonText(
              //                 content:
              //                     "${orderItem.manufacturer ?? 'No manufacturer'}",
              //                 boldNess: FontWeight.w500,
              //                 textColor: ColorsConst.greyTextColor,
              //                 textSize: 12,
              //               ),
              //               SizedBox(height: 10),
              //               // Align(
              //               //   alignment: Alignment.centerRight,
              //               //   child: AppHtmlText(orderItem.stockStatus ?? '',
              //               //       fontSize: 12),
              //               // ),
              //               SizedBox(
              //                 width: 115,
              //                 child: Row(
              //                   children: [
              //                     CommonText(
              //                       content: "MRP ",
              //                       boldNess: FontWeight.w400,
              //                       textColor: ColorsConst.hintColor,
              //                       textSize: 12,
              //                     ),
              //                     CommonText(
              //                       content:
              //                           "₹ ${(orderItem.mrp ?? 0).toStringAsFixed(2)}",
              //                       boldNess: FontWeight.w500,
              //                       textColor: ColorsConst.greyTextColor,
              //                       textSize: 12,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               Row(
              //                 mainAxisAlignment:
              //                     MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Row(
              //                     children: [
              //                       CommonText(
              //                         content: "PTR ",
              //                         boldNess: FontWeight.w400,
              //                         textColor: ColorsConst.hintColor,
              //                         textSize: 12,
              //                       ),
              //                       CommonText(
              //                         // content:
              //                         //     "₹ ${(orderItem.price ?? 0).toStringAsFixed(2)}",
              //                         content:
              //                             "₹ ${orderDetailsController.orderDetailsModel?.billed != "1" ? (orderItem.price ?? 0).toStringAsFixed(2) : (orderItem.finalPtr ?? 0).toStringAsFixed(2)}",
              //                         boldNess: FontWeight.w500,
              //                         textColor: ColorsConst.greyTextColor,
              //                         textSize: 12,
              //                       ),
              //                     ],
              //                   ),
              //                   Row(
              //                     children: [
              //                       CommonText(
              //                         content: "Qty: ",
              //                         boldNess: FontWeight.w400,
              //                         textColor: ColorsConst.hintColor,
              //                         textSize: 12,
              //                       ),
              //                       CommonText(
              //                         content: "${orderItem.quantity ?? 0}",
              //                         boldNess: FontWeight.w500,
              //                         textColor: ColorsConst.greyTextColor,
              //                         textSize: 12,
              //                       ),
              //                     ],
              //                   ),
              //                   CommonText(
              //                     // content:
              //                     //     '₹ ${((orderItem.quantity ?? 0) * (orderItem.price ?? 0)).toStringAsFixed(2)}',
              //                     content:
              //                         '₹ ${(orderDetailsController.orderDetailsModel?.billed != "1" ? (orderItem.buyQuantity ?? 0) * (orderItem.price ?? 0) : (orderItem.buyQuantity ?? 0) * (orderItem.finalPtr ?? 0)).toStringAsFixed(2)}',
              //                     boldNess: FontWeight.w600,
              //                     textColor: ColorsConst.textColor,
              //                     textSize: 16,
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              if (orderDetailsController.isLoading) AppLoader(),
            ],
          ),
        );
      },
    );
    // return Center(
    //   child: CommonText(
    //     content: '${orderId}\n${storeId}\n${payerId}',
    //     textColor: ColorsConst.textColor,
    //   ),
    // );
  }
}
