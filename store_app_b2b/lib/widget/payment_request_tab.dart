import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_search_field.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_details_screen.dart';
import 'package:store_app_b2b/widget/app_html_text.dart';

class PaymentRequestTab extends StatelessWidget {
  const PaymentRequestTab({
    Key? key,
    //required this.onTapDetails,
  }) : super(key: key);

  //final VoidCallback onTapDetails;

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
              paymentController.isOverviewLoading ||
                      paymentController.paymentOverview.isEmpty
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: ColorsConst.semiGreyColor,
                          width: 0.5,
                        ),
                        color: ColorsConst.bgColor,
                      ),
                      child: Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedAlignment: Alignment.centerLeft,
                          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          title: CommonText(
                            content: "Payment Transaction Overview",
                            textColor: ColorsConst.appBlack34,
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                              side: BorderSide.none),
                          shape: const RoundedRectangleBorder(
                              side: BorderSide.none),
                          // leading: SvgPicture.asset('assets/icons/business_details.svg',
                          //     fit: BoxFit.cover),
                          collapsedIconColor: AppColors.appGreyShade300,
                          iconColor: AppColors.appGreyShade300,
                          // title: const CommonText(
                          //   content: "Business Details",
                          //   textColor: Color(0xff333333),
                          //   textSize: 16,
                          //   boldNess: FontWeight.w600,
                          // ),

                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        content: "Billed Amount:",
                                        textSize: width * 0.032,
                                        textColor: Colors.black,
                                      ),
                                      CommonText(
                                        content:
                                            "₹ ${(paymentController.paymentOverview[0].totalBilledAmount == null) ? '' : paymentController.paymentOverview[0].totalBilledAmount!.toStringAsFixed(2)}",
                                        textSize: width * 0.032,
                                        textColor: ColorsConst.primaryColor,
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
                                            "₹ ${(paymentController.paymentOverview[0].totalAmountPaid == null) ? '' : paymentController.paymentOverview[0].totalAmountPaid!.toStringAsFixed(2)}",
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
                                        content: "Balance:",
                                        textSize: width * 0.032,
                                        textColor: Colors.black,
                                      ),
                                      CommonText(
                                        content:
                                            "₹ ${(paymentController.paymentOverview[0].totalBalanceToBePaid == null) ? '' : paymentController.paymentOverview[0].totalBalanceToBePaid!.toStringAsFixed(2)}",
                                        textSize: width * 0.032,
                                        textColor: Colors.red,
                                        boldNess: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              CommonSearchField(
                hintText: "Search By Order Id",
                showCloseIcon: paymentController
                    .searchRequestController.value.text.isNotEmpty,
                closeOnTap: () {
                  paymentController.paymentRequestList.clear();
                  paymentController.searchRequestController.value.clear();
                  paymentController.getPaymentRequestDataApi();
                  paymentController.update();
                },
                controller: paymentController.searchRequestController.value,
                onChanged: (String? value) {
                  paymentController.paymentRequestList.clear();
                  paymentController.getPaymentRequestDataApi(
                      searchQuery: value);
                  paymentController.update();
                },
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Obx(
                  () => Stack(
                    children: [
                      paymentController.paymentRequestList.length == 0
                          ? Center(
                              child: AppText(
                                "No Pending Payments Found",
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  paymentController.paymentRequestList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
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
                                                      .paymentRequestList[index]
                                                      .storeName ??
                                                  "",
                                              boldNess: FontWeight.w500,
                                              textColor: Colors.black,
                                            ),
                                          ),
                                          // const SizedBox(width: 10),
                                          // Row(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     CommonText(
                                          //       content: "Status: ",
                                          //       textColor: Colors.black,
                                          //       textSize: 12,
                                          //     ),
                                          //     AppHtmlText(
                                          //       paymentController
                                          //               .paymentRequestList[index]
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                          .paymentRequestList[
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
                                          //                 .paymentRequestList[index]
                                          //                 .billNumber ??
                                          //             "",
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
                                                              .paymentRequestList[
                                                                  index]
                                                              .billDate ==
                                                          null
                                                      ? ""
                                                      : DateFormat('dd/MM/yyyy')
                                                          .format(paymentController
                                                                  .paymentRequestList[
                                                                      index]
                                                                  .billDate ??
                                                              DateTime.now()),
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
                                                      "₹ ${((paymentController.paymentRequestList[index].billedAmount == null ? 0 : paymentController.paymentRequestList[index].billedAmount!) + (paymentController.paymentRequestList[index].creditNoteAmountAdjusted == null ? 0 : paymentController.paymentRequestList[index].creditNoteAmountAdjusted!)).toStringAsFixed(2)}",
                                                  // content:
                                                  // "₹ ${(paymentController.paymentRequestList[index].billedAmount == null) ? '' : paymentController.paymentRequestList[index].billedAmount!.toStringAsFixed(2)}",
                                                  textSize: width * 0.032,
                                                  textColor:
                                                      ColorsConst.primaryColor,
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
                                          //         content: "Invocie Amount:",
                                          //         textSize: width * 0.032,
                                          //         textColor: Colors.black,
                                          //       ),
                                          //       CommonText(
                                          //         content:
                                          //             "₹ ${(paymentController.paymentRequestList[index].billedAmount == null) ? '' : paymentController.paymentRequestList[index].billedAmount!.toStringAsFixed(2)}",
                                          //         textSize: width * 0.032,
                                          //         textColor:
                                          //             ColorsConst.primaryColor,
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
                                                              .paymentRequestList[
                                                                  index]
                                                              .creditNoteAmountAdjusted ==
                                                          null
                                                      ? "-"
                                                      : "₹ ${(paymentController.paymentRequestList[index].creditNoteAmountAdjusted == null) ? '' : paymentController.paymentRequestList[index].creditNoteAmountAdjusted!.toStringAsFixed(2)}",
                                                  textSize: width * 0.032,
                                                  textColor:
                                                      ColorsConst.primaryColor,
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
                                                      "₹ ${(paymentController.paymentRequestList[index].billedAmount == null) ? "" : paymentController.paymentRequestList[index].billedAmount!.toStringAsFixed(2)}",
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
                                                      "₹ ${(paymentController.paymentRequestList[index].amountPaid == null) ? "" : paymentController.paymentRequestList[index].amountPaid!.toStringAsFixed(2)}",
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
                                          //             '₹ ${(paymentController.paymentRequestList[index].balanceToBePaid == null) ? "" : paymentController.paymentRequestList[index].balanceToBePaid!.toStringAsFixed(2)}',
                                          //         textSize: width * 0.032,
                                          //         textColor: Colors.red,
                                          //         boldNess: FontWeight.w600,
                                          //       ),
                                          //     ],
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      SizedBox(height: height * 0.009),
                                      Row(
                                        children: [
                                          Column(
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
                                                    '₹ ${(paymentController.paymentRequestList[index].balanceToBePaid == null) ? "" : paymentController.paymentRequestList[index].balanceToBePaid!.toStringAsFixed(2)}',
                                                textSize: width * 0.032,
                                                textColor: Colors.red,
                                                boldNess: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CommonText(
                                                  content: 'Due Since: ',
                                                  textSize: 14,
                                                  textColor:
                                                      ColorsConst.textColor,
                                                  boldNess: FontWeight.w400,
                                                ),
                                                AppHtmlText(
                                                  '${paymentController.paymentRequestList[index].dueSince ?? ''}',
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      if (paymentController
                                                  .paymentRequestList[index]
                                                  .message !=
                                              null &&
                                          paymentController
                                              .paymentRequestList[index]
                                              .message!
                                              .isNotEmpty)
                                        AppHtmlText(
                                            '${paymentController.paymentRequestList[index].message ?? ''}',
                                            fontSize: 12,
                                            maxLines: 1,
                                            textOverFlow: TextOverflow.ellipsis,
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
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                              onPressed: () => Get.to(
                                                  () => PaymentDetailsScreen(
                                                        orderId: paymentController
                                                                .paymentRequestList[
                                                                    index]
                                                                .orderId ??
                                                            '',
                                                        payerId: paymentController
                                                                .paymentRequestList[
                                                                    index]
                                                                .payerId ??
                                                            '',
                                                        storeId: paymentController
                                                                .paymentRequestList[
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
                                          SizedBox(width: width * 0.03),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                print("printing in pay now");
                                                paymentController.selectItem =
                                                    paymentController
                                                            .paymentRequestList[
                                                        index];
                                                logs(
                                                    'SelectedItem --> ${paymentController.selectItem?.toJson()}');
                                                paymentController
                                                        .amountEnterController
                                                        .value
                                                        .text =
                                                    '${(paymentController.paymentRequestList[index].balanceToBePaid == null) ? "" : paymentController.paymentRequestList[index].balanceToBePaid!.toStringAsFixed(0)}';

                                                GlobalMainController
                                                    gmController = Get.put(
                                                        GlobalMainController());

                                                bool isEditable = gmController
                                                    .isPartialPaymentAllowedB2B;

                                                print(
                                                    "isEditable -> $isEditable");

                                                Get.dialog(
                                                  AlertDialog(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    content: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: ColorsConst
                                                                    .appGradientColor,
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                              ),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                const CommonText(
                                                                  content:
                                                                      "Amount Payable",
                                                                ),
                                                                const Spacer(),
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: height *
                                                                  0.02),
                                                          CommonText(
                                                            content:
                                                                "Enter amount",
                                                            textColor:
                                                                ColorsConst
                                                                    .hintColor,
                                                          ),
                                                          SizedBox(
                                                            width: width / 4,
                                                            child: TextField(
                                                              readOnly:
                                                                  !isEditable,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly
                                                              ],
                                                              controller:
                                                                  paymentController
                                                                      .amountEnterController
                                                                      .value,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText: "₹",
                                                                border:
                                                                    UnderlineInputBorder(),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: height *
                                                                  0.02),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed: () {
                                                              String
                                                                  inputValue =
                                                                  paymentController
                                                                      .amountEnterController
                                                                      .value
                                                                      .text
                                                                      .trim();
                                                              double
                                                                  parsedValue =
                                                                  double.tryParse(
                                                                          inputValue) ??
                                                                      0.0;

                                                              String
                                                                  formattedValue =
                                                                  parsedValue
                                                                      .toStringAsFixed(
                                                                          2);

                                                              num result =
                                                                  num.parse(
                                                                      formattedValue);

                                                              num maxValue = (paymentController
                                                                          .paymentRequestList[
                                                                              index]
                                                                          .balanceToBePaid ==
                                                                      null)
                                                                  ? 0
                                                                  : paymentController
                                                                      .paymentRequestList[
                                                                          index]
                                                                      .balanceToBePaid!;

                                                              if (result >
                                                                  maxValue) {
                                                                CommonSnackBar
                                                                    .showError(
                                                                        "Maximum payable value ₹$maxValue");
                                                                return;
                                                              }

                                                              if (result < 1) {
                                                                CommonSnackBar
                                                                    .showError(
                                                                        "Payable amount must be greater than ₹0");
                                                                return;
                                                              }

                                                              print(
                                                                  "printing going amount formated -> $formattedValue");

                                                              print(
                                                                  "printing going amount -> $result");
                                                              // return;
                                                              Get.back();
                                                              paymentController.getRazorPayDataApi(
                                                                  // int.parse(paymentController
                                                                  //         .amountEnterController
                                                                  //         .value
                                                                  //         .text
                                                                  //         .trim())
                                                                  //     .toDouble(),
                                                                  result,
                                                                  paymentController.selectItem?.orderId,
                                                                  "${ApiConfig.razorpayKey}");
                                                            },
                                                            child: CommonText(
                                                              content: "Pay",
                                                              textSize:
                                                                  width * 0.035,
                                                              textColor:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  gradient: LinearGradient(
                                                    colors: ColorsConst
                                                        .appGradientColor,
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: CommonText(
                                                    content: "Pay Now",
                                                    textSize: width * 0.035,
                                                    textColor: Colors.white,
                                                  ),
                                                ),
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
              )
            ],
          ),
        );
      },
    );
  }
}
