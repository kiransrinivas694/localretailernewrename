import 'dart:developer';

import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/tax_invoice_screen_new.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentTransactionTab extends StatelessWidget {
  final String orderId;
  final String storeId;
  final String payerId;
  const PaymentTransactionTab(
      {super.key,
      required this.orderId,
      required this.storeId,
      required this.payerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      initState: (state) {
        Future.delayed(
          Duration(microseconds: 300),
          () {
            PaymentController controller = Get.find<PaymentController>();
            controller.getPaymentHistoryByOrder(
                orderId: orderId, storeId: storeId, payerId: payerId);
            controller.getOrderDetails(orderId: orderId);
          },
        );
      },
      init: PaymentController(),
      builder: (controller) {
        return Obx(
          () => controller.isLoading.value
              ? AppLoader()
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 10),
                        children: [
                          Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorsConst.appWhite,
                                border: Border.all(
                                  color:
                                      ColorsConst.borderColor.withOpacity(0.2),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: CommonText(
                                            content: controller
                                                    .paymentHistoryByOrderModel
                                                    .userName ??
                                                '',
                                            textColor: ColorsConst.textColor,
                                            boldNess: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textSize: 15)),
                                    // RichText(
                                    //   text: TextSpan(
                                    //       text: 'Status: ',
                                    //       style: GoogleFonts.poppins(
                                    //           color: ColorsConst.textColor,
                                    //           fontSize: 13,
                                    //           fontWeight: FontWeight.w400),
                                    //       children: [
                                    //         TextSpan(
                                    //           style: GoogleFonts.poppins(
                                    //               color: ColorsConst.greenColor,
                                    //               fontSize: 13,
                                    //               fontWeight: FontWeight.w400),
                                    //           text: controller
                                    //                   .paymentHistoryByOrderModel
                                    //                   .orderStatus ??
                                    //               '',
                                    //         )
                                    //       ]),
                                    // )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              content: 'Invoice Number:',
                                              textColor: ColorsConst.textColor,
                                              textSize: 12,
                                              boldNess: FontWeight.w400),
                                          CommonText(
                                              content: controller
                                                      .paymentHistoryByOrderModel
                                                      .orderId ??
                                                  '',
                                              textColor: ColorsConst.textColor,
                                              textSize: 12,
                                              boldNess: FontWeight.w600),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              content: 'Invoice Date:',
                                              textColor: ColorsConst.textColor,
                                              textSize: 12,
                                              boldNess: FontWeight.w400),
                                          CommonText(
                                              content: controller
                                                          .paymentHistoryByOrderModel
                                                          .orderDate ==
                                                      null
                                                  ? ""
                                                  : DateFormat('dd/MM/yyyy')
                                                      .format(controller
                                                              .paymentHistoryByOrderModel
                                                              .orderDate ??
                                                          DateTime.now()),
                                              textColor: ColorsConst.textColor,
                                              textSize: 12,
                                              boldNess: FontWeight.w600),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              content: 'Invoice Amount :',
                                              textColor: ColorsConst.textColor,
                                              textSize: 12,
                                              boldNess: FontWeight.w400),
                                          CommonText(
                                              content:
                                                  '₹ ${(controller.paymentHistoryByOrderModel.billedAmount == null) ? '0.00' : double.parse(controller.paymentHistoryByOrderModel.billedAmount.toString()).toStringAsFixed(2)}',
                                              textColor: ColorsConst.textColor,
                                              textSize: 12,
                                              boldNess: FontWeight.w600),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            content: 'Paid Amount:',
                                            textColor: ColorsConst.textColor,
                                            textSize: 12,
                                            boldNess: FontWeight.w400),
                                        CommonText(
                                            content:
                                                ' ₹ ${(controller.paymentHistoryByOrderModel.paidAmount == null) ? '0.00' : double.parse(controller.paymentHistoryByOrderModel.paidAmount.toString()).toStringAsFixed(2)}',
                                            textColor: ColorsConst.greenColor,
                                            textSize: 12,
                                            boldNess: FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            content: 'Balance ',
                                            textColor: ColorsConst.textColor,
                                            textSize: 12,
                                            boldNess: FontWeight.w400),
                                        CommonText(
                                            content:
                                                '₹ ${(controller.paymentHistoryByOrderModel.balanceTobePaid == null) ? '0.00' : double.parse(controller.paymentHistoryByOrderModel.balanceTobePaid.toString()).toStringAsFixed(2)}',
                                            textColor: ColorsConst.redColor,
                                            textSize: 12,
                                            boldNess: FontWeight.w600),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                          const CommonText(
                            content: 'Complete Order Transactions',
                            textColor: AppColors.appGrey,
                            textSize: 10,
                            textAlign: TextAlign.center,
                          ),
                          if (controller.paymentHistoryByOrderModel.paymentInfo
                              .isNotEmpty)
                            Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorsConst.appWhite,
                                  border: Border.all(
                                    color: ColorsConst.borderColor
                                        .withOpacity(0.2),
                                  )),
                              child: Column(
                                children: controller
                                    .paymentHistoryByOrderModel.paymentInfo
                                    .map((paymentInfo) => Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 5, left: 10, right: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: ColorsConst.appWhite,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Color(0xffC4C4C4)))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CommonText(
                                                      content:
                                                          'Trans ID : ${paymentInfo.paymentId ?? ''}',
                                                      textSize: 12,
                                                      textColor:
                                                          AppColors.appGrey,
                                                      maxLines: 1,
                                                      boldNess: FontWeight.w500,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   child:  CommonText(
                                                  //     content:
                                                  //     'Paid Date: ${(paymentInfo.paidDate == null) ? "" : DateFormat('MM-dd-yyyy').format(paymentInfo.paidDate ?? DateTime.now())}',
                                                  //     textSize: 10,
                                                  //     textColor: ColorsConst.greyTextColor,
                                                  //     maxLines: 1,
                                                  //     textAlign: TextAlign.end,
                                                  //     boldNess: FontWeight.w600,
                                                  //     overflow:
                                                  //     TextOverflow.ellipsis,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              CommonText(
                                                content:
                                                    'Paid Date: ${(paymentInfo.paidDate == null) ? "" : DateFormat('dd-MM-yyyy : hh:mm a').format(paymentInfo.paidDate ?? DateTime.now())}',
                                                textSize: 12,
                                                textColor:
                                                    ColorsConst.greyTextColor,
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                boldNess: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  CommonText(
                                                    content: 'Paid Amount: ',
                                                    textSize: 12,
                                                    textColor:
                                                        AppColors.appGrey,
                                                    maxLines: 1,
                                                    boldNess: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  CommonText(
                                                    content: paymentInfo
                                                        .paidAmount!
                                                        .toStringAsFixed(2),
                                                    textSize: 12,
                                                    textColor:
                                                        AppColors.appGrey,
                                                    maxLines: 1,
                                                    boldNess: FontWeight.w600,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              if (paymentInfo
                                                      .trasactionStatus !=
                                                  null)
                                                CommonText(
                                                  content:
                                                      '${paymentInfo.trasactionStatus}',
                                                  textColor:
                                                      ColorsConst.greenColor,
                                                  textSize: 12,
                                                  boldNess: FontWeight.w500,
                                                ),
                                            ],
                                          ),
                                          // child: Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Flexible(
                                          //         child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //           mainAxisAlignment: MainAxisAlignment.start,
                                          //       children: [
                                          //         CommonText(
                                          //           content:
                                          //               'Trans ID : ${paymentInfo.paymentId ?? ''}',
                                          //           textSize: 8,
                                          //           textColor:
                                          //               AppColors.appGrey,
                                          //           maxLines: 1,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //         ),
                                          //         SizedBox(height: 6),
                                          //         CommonText(
                                          //           content: (paymentInfo
                                          //                       .paidDate ==
                                          //                   null)
                                          //               ? ""
                                          //               : DateFormat(
                                          //                       'MM-dd-yyyy')
                                          //                   .format(paymentInfo
                                          //                           .paidDate ??
                                          //                       DateTime.now()),
                                          //           textSize: 10,
                                          //           textColor: Colors.black,
                                          //           maxLines: 1,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //         ),
                                          //       ],
                                          //     )),
                                          //     Flexible(
                                          //         child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.end,
                                          //       mainAxisAlignment: MainAxisAlignment.start,
                                          //       children: [
                                          //         CommonText(
                                          //           content:
                                          //               'Paid Date: ${(paymentInfo.paidDate == null) ? "" : DateFormat('MM-dd-yyyy').format(paymentInfo.paidDate ?? DateTime.now())}',
                                          //           textSize: 10,
                                          //           textColor: ColorsConst.greyTextColor,
                                          //           maxLines: 1,
                                          //           boldNess: FontWeight.w600,
                                          //           overflow:
                                          //           TextOverflow.ellipsis,
                                          //         ),
                                          //         CommonText(
                                          //           content:
                                          //           'Bill Date: ${(paymentInfo.paidDate == null) ? "" : DateFormat('MM-dd-yyyy').format(paymentInfo.paidDate ?? DateTime.now())}',
                                          //           textSize: 10,
                                          //           textColor: ColorsConst.greyTextColor,
                                          //           maxLines: 1,
                                          //           boldNess: FontWeight.w600,
                                          //           overflow:
                                          //           TextOverflow.ellipsis,
                                          //         ),
                                          //       ],
                                          //     ))
                                          //   ],
                                          // ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          const SizedBox(height: 5),
                          if (controller.paymentHistoryByOrderModel.fullyPaid !=
                              'N')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle,
                                    color: ColorsConst.greenColor),
                                CommonText(
                                    content: 'Received Complete Payment',
                                    textColor: ColorsConst.greenColor,
                                    textSize: 10),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorsConst.appWhite,
                            side: BorderSide(color: Color(0xffC4C4C4)),
                          ),
                          // onPressed: () => Get.to(
                          //     () => PrintInvoiceScreen(orderId: orderId)),
                          onPressed: () {
                            // log('loggin url ${controller.ordersContent!.invoiceDownloadURL}');
                            if (controller.ordersContent != null) {
                              launchUrl(
                                  Uri.parse(
                                    '${controller.ordersContent!.invoiceDownloadURL ?? ''}',
                                  ),
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/print.svg',
                                package: 'store_app_b2b',
                              ),
                              SizedBox(width: 8),
                              CommonText(
                                  content: 'Download',
                                  textColor: Color(0xff3C3C55),
                                  textSize: 15)
                            ],
                          )),
                    )
                  ],
                ),
        );
      },
    );
  }
}
