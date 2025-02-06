import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_primary_button_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/order_history_controller/order_details_controller_new.dart';
import 'package:store_app_b2b/model/order_details_model_new.dart';
import 'package:store_app_b2b/widget/app_html_text_new.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<OrderDetailsController>(
      init: OrderDetailsController(),
      initState: (state) {
        Map<String, dynamic> getArguments = Get.arguments;
        logs('getArguments --> $getArguments');
        Future.delayed(
          Duration(microseconds: 300),
          () {
            final orderDetailsController = Get.find<OrderDetailsController>();
            orderDetailsController.getOrderDetails(
                orderId: getArguments['orderId']);
          },
        );
      },
      builder: (OrderDetailsController orderDetailsController) {
        return Scaffold(
          extendBody: true,
          backgroundColor: ColorsConst.bgColor,
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: "Order Id: #${Get.arguments['orderId']}",
              boldNess: FontWeight.w600,
              textSize: width * 0.047,
            ),
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff2F394B), Color(0xff090F1A)],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              orderDetailsController.isLoading
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: const Color(0xffE5E5E5),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CommonText(
                                    content: "Date: ",
                                    boldNess: FontWeight.w400,
                                    textColor: ColorsConst.greyTextColor,
                                    textSize: 12,
                                  ),
                                  CommonText(
                                    content: DateFormat('dd MMM yy').format(
                                        orderDetailsController.orderDetailsModel
                                                ?.orderCreatedDate ??
                                            DateTime.now()),
                                    boldNess: FontWeight.w600,
                                    textColor: Color(0xff090F1A),
                                    textSize: 12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CommonText(
                                    content: "Items: ",
                                    boldNess: FontWeight.w400,
                                    textColor: ColorsConst.greyTextColor,
                                    textSize: 12,
                                  ),
                                  CommonText(
                                    content: (orderDetailsController
                                                .orderDetailsModel
                                                ?.items
                                                .length ??
                                            0)
                                        .toString()
                                        .padLeft(2, '0'),
                                    boldNess: FontWeight.w600,
                                    textColor: Color(0xff090F1A),
                                    textSize: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                orderDetailsController
                                            .orderDetailsModel!.orderStatus ==
                                        "0"
                                    ? SizedBox()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  orderDetailsController
                                                      .currentActive = 0;
                                                  orderDetailsController
                                                      .update();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: orderDetailsController
                                                                      .currentActive ==
                                                                  0
                                                              ? 2
                                                              : 0,
                                                          color: orderDetailsController
                                                                      .currentActive ==
                                                                  0
                                                              ? ColorsConst
                                                                  .primaryColor
                                                              : Colors
                                                                  .transparent),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: CommonText(
                                                      content:
                                                          "Confirmed \nProducts",
                                                      textColor:
                                                          orderDetailsController
                                                                      .currentActive ==
                                                                  0
                                                              ? ColorsConst
                                                                  .primaryColor
                                                              : Colors.black,
                                                      boldNess:
                                                          orderDetailsController
                                                                      .currentActive ==
                                                                  0
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  orderDetailsController
                                                      .currentActive = 1;
                                                  orderDetailsController
                                                      .update();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: orderDetailsController
                                                                      .currentActive ==
                                                                  1
                                                              ? 2
                                                              : 0,
                                                          color: orderDetailsController
                                                                      .currentActive ==
                                                                  1
                                                              ? ColorsConst
                                                                  .primaryColor
                                                              : Colors
                                                                  .transparent),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: CommonText(
                                                      content:
                                                          "Not Available\nProducts",
                                                      textColor:
                                                          orderDetailsController
                                                                      .currentActive ==
                                                                  1
                                                              ? ColorsConst
                                                                  .primaryColor
                                                              : Colors.black,
                                                      boldNess:
                                                          orderDetailsController
                                                                      .currentActive ==
                                                                  1
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                orderDetailsController
                                            .orderDetailsModel!.orderStatus ==
                                        "0"
                                    ? SizedBox()
                                    : SizedBox(
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
                                                orderDetailsController
                                                            .orderDetailsModel!
                                                            .orderStatus ==
                                                        "0"
                                                    ? SizedBox()
                                                    : Expanded(
                                                        child: CommonText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          content:
                                                              "Avl Qty: ${num.parse('${orderItem.confirmQuantity ?? 0}').toStringAsFixed(0)}",
                                                          boldNess:
                                                              FontWeight.w500,
                                                          textColor: ColorsConst
                                                              .greenColor,
                                                          textSize: 12,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Expanded(
                              //                 child: CommonText(
                              //                   content:
                              //                       "Total value : ₹ ${(orderDetailsController.orderDetailsModel?.orderTotalValue ?? 0).toStringAsFixed(2)}",
                              //                   boldNess: FontWeight.w600,
                              //                   textColor: ColorsConst.textColor,
                              //                   textSize: width * 0.04,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               CommonText(
                              //                   content: "Status : ",
                              //                   textColor: ColorsConst.textColor,
                              //                   textSize: width * 0.042,
                              //                   boldNess: FontWeight.w600),
                              //               Padding(
                              //                 padding: const EdgeInsets.only(top: 2),
                              //                 child: AppHtmlText(
                              //                     '${(orderDetailsController.orderDetailsModel != null && orderDetailsController.orderDetailsModel!.orderEventStatus != null) ? orderDetailsController.orderDetailsModel!.orderEventStatus : ''}',
                              //                     maxLines: 2,
                              //                     fontWeight: FontWeight.w600,
                              //                     fontSize: width * 0.042,
                              //                     textOverFlow:
                              //                         TextOverflow.ellipsis),
                              //               ),

                              //               // Container(width: 100,height: 50,child: Center(child: Text,),)
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              // Container(
                              //   margin: EdgeInsets.only(right: 20),
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: 10, horizontal: 20),
                              //   decoration: BoxDecoration(
                              //       color: Colors.black,
                              //       borderRadius: BorderRadius.circular(10)),
                              //   child: Center(
                              //     child: CommonText(
                              //       content: "Pay Now",
                              //       boldNess: FontWeight.bold,
                              //       textColor: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              //   ],
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                textColor:
                                                    ColorsConst.textColor,
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
                                        orderDetailsController
                                                        .orderDetailsModel !=
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
                                                      boldNess:
                                                          FontWeight.w600),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    child: AppHtmlText(
                                                        '${(orderDetailsController.orderDetailsModel != null && orderDetailsController.orderDetailsModel!.orderReceived != null) ? orderDetailsController.orderDetailsModel!.orderReceived == "Y" ? "Yes" : "No" : ''}',
                                                        maxLines: 2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: width * 0.042,
                                                        textOverFlow:
                                                            TextOverflow
                                                                .ellipsis),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                    orderDetailsController.orderDetailsModel !=
                                                null &&
                                            orderDetailsController
                                                    .orderDetailsModel!
                                                    .packed !=
                                                null &&
                                            orderDetailsController
                                                    .orderDetailsModel!
                                                    .packed ==
                                                '1'
                                        ? orderDetailsController
                                                .isCSVSendLoading
                                            ? CircularProgressIndicator(
                                                color: AppColors.primaryColor,
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  orderDetailsController.sendCSV(
                                                      orderId:
                                                          orderDetailsController
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
                                                          package:
                                                              'store_app_b2b',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    CommonText(
                                                      content: "Send CSV",
                                                      textColor: AppColors
                                                          .primaryColor,
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
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     CommonText(
                              //       content:
                              //           "Total value : ₹ ${(orderDetailsController.orderDetailsModel?.orderTotalValue ?? 0).toStringAsFixed(2)}",
                              //       boldNess: FontWeight.w600,
                              //       textColor: ColorsConst.textColor,
                              //       textSize: width * 0.04,
                              //     ),
                              //   ],
                              // ),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     CommonText(
                              //         content: "Status : ",
                              //         textColor: ColorsConst.textColor,
                              //         textSize: width * 0.042,
                              //         boldNess: FontWeight.w600),
                              //     Flexible(
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(top: 2),
                              //         child: AppHtmlText(
                              //             '${(orderDetailsController.orderDetailsModel != null && orderDetailsController.orderDetailsModel!.orderEventStatus != null) ? orderDetailsController.orderDetailsModel!.orderEventStatus : ''}',
                              //             maxLines: 2,
                              //             fontWeight: FontWeight.w600,
                              //             fontSize: width * 0.042,
                              //             textOverFlow: TextOverflow.ellipsis),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // orderDetailsController.orderDetailsModel != null &&
                              //         orderDetailsController
                              //                 .orderDetailsModel!.deliveryStatus !=
                              //             null &&
                              //         orderDetailsController
                              //                 .orderDetailsModel!.deliveryStatus ==
                              //             '1'
                              //     ? Row(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           CommonText(
                              //               content: "Order Accepted By User : ",
                              //               textColor: ColorsConst.textColor,
                              //               textSize: width * 0.042,
                              //               boldNess: FontWeight.w600),
                              //           Flexible(
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(top: 2),
                              //               child: AppHtmlText(
                              //                   '${(orderDetailsController.orderDetailsModel != null && orderDetailsController.orderDetailsModel!.orderReceived != null) ? orderDetailsController.orderDetailsModel!.orderReceived == "Y" ? "Yes" : "No" : ''}',
                              //                   maxLines: 2,
                              //                   fontWeight: FontWeight.w600,
                              //                   fontSize: width * 0.042,
                              //                   textOverFlow: TextOverflow.ellipsis),
                              //             ),
                              //           ),
                              //         ],
                              //       )
                              //     : SizedBox(),
                              if (orderDetailsController.orderDetailsModel !=
                                      null &&
                                  orderDetailsController
                                          .orderDetailsModel!.deliveryStatus !=
                                      null &&
                                  orderDetailsController
                                          .orderDetailsModel!.deliveryStatus ==
                                      '1')
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       vertical: 10, horizontal: 10),
                                //   child: ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //       elevation: 0,
                                //       backgroundColor: Colors.white,
                                //       side: const BorderSide(color: Colors.black),
                                //       fixedSize: Size(width, 45),
                                //     ),
                                //     onPressed: () => Get.to(() => PrintInvoiceScreen(
                                //         orderId: orderDetailsController
                                //             .orderDetailsModel?.id)),
                                //     child: CommonText(
                                //       content: "Invoice",
                                //       textSize: width * 0.04,
                                //       textColor: Colors.black,
                                //       boldNess: FontWeight.w500,
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.white,
                                      fixedSize: Size(width, 45),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    onPressed: () => launchUrl(
                                        Uri.parse(
                                          orderDetailsController
                                                  .orderDetailsModel!
                                                  .invoiceDownloadURL ??
                                              '',
                                        ),
                                        mode: LaunchMode.externalApplication),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.download,
                                            color: Colors.black),
                                        SizedBox(width: width * 0.02),
                                        CommonText(
                                          content: "Download",
                                          textSize: width * 0.035,
                                          textColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
              if (orderDetailsController.isLoading) AppLoader(),
            ],
          ),
        );
      },
    );
  }
}
