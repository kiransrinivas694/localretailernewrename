import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_search_field.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_html_text.dart';

import '../controllers/bottom_controller/payment_controller/payment_controller.dart';
import '../screens/bottom_nav_bar/payment/payment_details_screen.dart';

class AllPaymentTab extends StatelessWidget {
  const AllPaymentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<PaymentController>(
      builder: (PaymentController paymentController) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            children: [
              CommonSearchField(
                showCloseIcon:
                    paymentController.searchAllController.value.text.isNotEmpty,
                closeOnTap: () {
                  paymentController.fullyPaidList.clear();
                  paymentController.searchAllController.value.clear();
                  paymentController.getFullyPaidDataApi();
                  paymentController.update();
                },
                controller: paymentController.searchAllController.value,
                onChanged: (String? value) {
                  paymentController.fullyPaidList.clear();
                  paymentController.getFullyPaidDataApi(searchQuery: value);
                  paymentController.update();
                },
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is UserScrollNotification) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          if ((paymentController.fullyPaidCurrentPage.value +
                                  1) <
                              paymentController.fullyPaidTotalPage.value) {
                            paymentController.fullyPaidCurrentPage.value =
                                paymentController.fullyPaidCurrentPage.value +
                                    1;
                            paymentController.getFullyPaidDataApi();
                          }
                        }
                      }
                      return true;
                    },
                    child: Stack(
                      children: [
                        paymentController.fullyPaidList.length == 0
                            ? Center(
                                child: AppText(
                                  "No Paid Bills Found",
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    paymentController.fullyPaidList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: ColorsConst.semiGreyColor),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: CommonText(
                                                content: paymentController
                                                        .fullyPaidList[index]
                                                        .storeName ??
                                                    "",
                                                boldNess: FontWeight.w500,
                                                textColor: Colors.black,
                                              ),
                                            ),
                                            // SizedBox(width: 10),
                                            // Row(
                                            //   children: [
                                            //     CommonText(
                                            //       content: "Status: ",
                                            //       textColor: Colors.black,
                                            //       textSize: 12,
                                            //     ),
                                            //     AppHtmlText(
                                            //       paymentController
                                            //               .fullyPaidList[index]
                                            //               .orderStatus ??
                                            //           "",
                                            //       fontSize: 12,
                                            //     )
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: height * 0.005),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Invoice ID:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content: paymentController
                                                            .fullyPaidList[
                                                                index]
                                                            .orderId ??
                                                        "",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: Column(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.start,
                                            //     children: [
                                            //       CommonText(
                                            //         content: "Bill number:",
                                            //         textSize: width * 0.032,
                                            //         textColor: Colors.black,
                                            //       ),
                                            //       CommonText(
                                            //         content: paymentController
                                            //                     .fullyPaidList[index]
                                            //                     .billNumber ==
                                            //                 null
                                            //             ? ""
                                            //             : paymentController
                                            //                     .fullyPaidList[index]
                                            //                     .billNumber ??
                                            //                 "",
                                            //         textSize: width * 0.032,
                                            //         textColor: Colors.black,
                                            //         boldNess: FontWeight.w600,
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Invoice Date:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content: paymentController
                                                                .fullyPaidList[
                                                                    index]
                                                                .billDate ==
                                                            null
                                                        ? ""
                                                        : DateFormat('dd/MM/yyyy').format(
                                                            paymentController
                                                                    .fullyPaidList[
                                                                        index]
                                                                    .billDate ??
                                                                DateTime.now()
                                                            // controller.paymentRequestList[index]
                                                            //         ['orderDate'] ??
                                                            //     ""
                                                            ),
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Invoice Amount:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content:
                                                        "₹ ${((paymentController.fullyPaidList[index].billedAmount == null ? 0 : paymentController.fullyPaidList[index].billedAmount!) + (paymentController.fullyPaidList[index].creditNoteAmountAdjusted == null ? 0 : paymentController.fullyPaidList[index].creditNoteAmountAdjusted!)).toStringAsFixed(2)}",
                                                    // content:
                                                    // "₹ ${(paymentController.paymentRequestList[index].billedAmount == null) ? '' : paymentController.paymentRequestList[index].billedAmount!.toStringAsFixed(2)}",
                                                    textSize: width * 0.032,
                                                    textColor: ColorsConst
                                                        .primaryColor,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Row(
                                          children: [
                                            // Expanded(
                                            //   child: Column(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.start,
                                            //     children: [
                                            //       CommonText(
                                            //         content: "Invoice Amount:",
                                            //         textSize: width * 0.032,
                                            //         textColor: Colors.black,
                                            //       ),
                                            //       CommonText(
                                            //         content:
                                            //             "₹ ${paymentController.fullyPaidList[index].billedAmount != null ? paymentController.fullyPaidList[index].billedAmount!.toStringAsFixed(2) : ""}",
                                            //         textSize: width * 0.032,
                                            //         textColor: ColorsConst
                                            //             .primaryColor,
                                            //         boldNess: FontWeight.w600,
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Credit Note:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content: paymentController
                                                                .fullyPaidList[
                                                                    index]
                                                                .creditNoteAmountAdjusted ==
                                                            null
                                                        ? "-"
                                                        : "₹ ${(paymentController.fullyPaidList[index].creditNoteAmountAdjusted == null) ? '' : paymentController.fullyPaidList[index].creditNoteAmountAdjusted!.toStringAsFixed(2)}",
                                                    textSize: width * 0.032,
                                                    textColor: ColorsConst
                                                        .primaryColor,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Grand Total:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content:
                                                        "₹ ${(paymentController.fullyPaidList[index].billedAmount == null) ? "" : paymentController.fullyPaidList[index].billedAmount!.toStringAsFixed(2)}",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.green,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Amount paid:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content:
                                                        "₹ ${paymentController.fullyPaidList[index].amountPaid != null ? paymentController.fullyPaidList[index].amountPaid!.toStringAsFixed(2) : ""}",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.green,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: Column(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.start,
                                            //     children: [
                                            //       CommonText(
                                            //         content: "Balance:",
                                            //         textSize: width * 0.032,
                                            //         textColor: Colors.black,
                                            //       ),
                                            //       CommonText(
                                            //         content:
                                            //             "₹ ${paymentController.fullyPaidList[index].balanceToBePaid != null ? paymentController.fullyPaidList[index].balanceToBePaid!.toStringAsFixed(2) : ""}",
                                            //         textSize: width * 0.032,
                                            //         textColor: Colors.red,
                                            //         boldNess: FontWeight.w600,
                                            //       ),
                                            //     ],
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Balance:",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content:
                                                        "₹ ${paymentController.fullyPaidList[index].balanceToBePaid != null ? paymentController.fullyPaidList[index].balanceToBePaid!.toStringAsFixed(2) : ""}",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.red,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Paid Date :",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    content: paymentController
                                                                .fullyPaidList[
                                                                    index]
                                                                .paidDate ==
                                                            null
                                                        ? "-"
                                                        : "${DateFormat('dd/MM/yyyy').format(paymentController.fullyPaidList[index].paidDate!)}",
                                                    textSize: width * 0.032,
                                                    textColor: Colors.black,
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(child: SizedBox())
                                          ],
                                        ),
                                        if (paymentController
                                                    .fullyPaidList[index]
                                                    .message !=
                                                null &&
                                            paymentController
                                                .fullyPaidList[index]
                                                .message!
                                                .isNotEmpty)
                                          AppHtmlText(
                                              '${paymentController.fullyPaidList[index].message ?? ""}',
                                              fontSize: 12,
                                              maxLines: 1,
                                              textOverFlow:
                                                  TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400),
                                        SizedBox(height: 5),
                                        Divider(
                                            color: ColorsConst.semiGreyColor,
                                            height: 1),
                                        SizedBox(height: height * 0.01),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor: Colors.white,
                                                  side: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () => Get.to(
                                                    () => PaymentDetailsScreen(
                                                          orderId: paymentController
                                                                  .fullyPaidList[
                                                                      index]
                                                                  .orderId ??
                                                              '',
                                                          payerId: paymentController
                                                                  .fullyPaidList[
                                                                      index]
                                                                  .payerId ??
                                                              '',
                                                          storeId: paymentController
                                                                  .fullyPaidList[
                                                                      index]
                                                                  .storeId ??
                                                              '',
                                                        )),
                                                child: CommonText(
                                                  content: "Details",
                                                  textSize: width * 0.035,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                        paymentController.isLoading.value
                            ? Center(
                                child: AppLoader(
                                    color: ColorsConst.primaryColor,
                                    opacity: 0.8))
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
