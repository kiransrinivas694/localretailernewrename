import 'dart:developer';

import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/grb_return_controller/grb_return_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/grb_return_controller/grb_scheme_return_controller_new.dart';
import 'package:store_app_b2b/model/grb_scheme_batch_model_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_dropdown_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/grb_cart_details_screen_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';

class GrbSchemeReturnScreen extends StatefulWidget {
  GrbSchemeReturnScreen({
    super.key,
    required this.orderId,
    required this.productId,
    this.isEdit = false,
    this.editableBatchNo,
    this.confirmedQuantity,
    this.freeQuantity,
    this.orderedQuantity,
    this.returnReason,
    this.returnQuantity,
    this.isFromScreen = "grb",
    required this.itemId,
    required this.schemeName,
  });

  final String orderId;
  final String productId;
  final String itemId;
  final bool isEdit;

  //below keys should be sent only if edit is true
  final String? editableBatchNo;
  final String? returnReason;
  final String schemeName;
  final num? orderedQuantity;
  final num? returnQuantity;
  final num? freeQuantity;
  final num? confirmedQuantity;
  final String isFromScreen;

  @override
  State<GrbSchemeReturnScreen> createState() => _GrbSchemeReturnScreenState();
}

class _GrbSchemeReturnScreenState extends State<GrbSchemeReturnScreen> {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<GrbSchemeReturnController>(
        init: GrbSchemeReturnController(),
        initState: (state) {
          GrbSchemeReturnController controller =
              Get.put(GrbSchemeReturnController());

          controller.getGRBSchemeBatches(
            orderId: widget.orderId,
            productId: widget.productId,
            isEdit: widget.isEdit,
            returnReason: widget.returnReason,
            itemId: widget.itemId,
            batchNo:
                widget.isEdit ? widget.editableBatchNo : widget.editableBatchNo,
            returnQuantity: widget.returnQuantity,
          );
          // if (widget.isEdit) {
          controller.returnBuyQtyMainController.text =
              '${widget.returnQuantity!.toStringAsFixed(0)}';

          controller.toggleMainReturnQty();
          // }
        },
        builder: (controller) {
          return Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "GRB Product",
                boldNess: FontWeight.w600,
                textSize: width * 0.047,
              ),
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff2F394B),
                      Color(0xff090F1A),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: ColorsConst.bgColor,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: controller.isGetSchemeProductLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : controller.grbSchemeBatchesData.isEmpty
                                ? SizedBox(
                                    child: Center(
                                      child: CommonText(
                                        content: 'Data Not Found',
                                        textColor: AppColors.appblack,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CommonText(
                                                // content: searchProduct.productName!,
                                                content: controller
                                                        .grbSchemeBatchesData[0]
                                                        .productName ??
                                                    "",
                                                textColor: AppColors.appblack,
                                                boldNess: FontWeight.w600,
                                              ),
                                            ),
                                            if (widget.schemeName.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0, right: 10),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/offer.png",
                                                      scale: 3.5,
                                                      package: 'store_app_b2b',
                                                    ),
                                                    SizedBox(width: 5),
                                                    CommonText(
                                                      // content: "${searchProduct.schemeName ?? ''}",
                                                      content:
                                                          "${controller.grbSchemeBatchesData[0].schemeName ?? ""}",
                                                      textSize: 12,
                                                      boldNess: FontWeight.w600,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(width: 0),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),

                                        CommonText(
                                          // content: searchProduct.orderId!,
                                          content: widget.orderId,
                                          textColor: AppColors.primaryColor,
                                          boldNess: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // if (widget.isEdit)
                                        Row(
                                          children: [
                                            CommonText(
                                              content: "Batch No : ",
                                              textColor: AppColors.appblack,
                                              textSize: 14,
                                              // boldNess: FontWeight.w600,
                                            ),
                                            CommonText(
                                              content:
                                                  '${widget.editableBatchNo}',
                                              textColor: AppColors.appblack,
                                              boldNess: FontWeight.w600,
                                              textSize: 14,
                                            ),
                                          ],
                                        ),
                                        // if (!widget.isEdit)
                                        // Row(
                                        //   children: [
                                        //     CommonText(
                                        //       content: "Ordered : ",
                                        //       textColor: AppColors.appblack,
                                        //       // boldNess: FontWeight.w600,
                                        //     ),
                                        //     CommonText(
                                        //       content:
                                        //           '${widget.isEdit ? widget.orderedQuantity : controller.grbSchemeBatchesData[0].totalQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalQuantity.toString())}',
                                        //       textColor: AppColors.appblack,
                                        //       boldNess: FontWeight.w600,
                                        //     ),
                                        //   ],
                                        // ),

                                        // if (widget.isEdit)
                                        //   Row(
                                        //     children: [
                                        //       CommonText(
                                        //         content: "Return : ",
                                        //         textColor: AppColors.appblack,
                                        //         // boldNess: FontWeight.w600,
                                        //       ),
                                        //       CommonText(
                                        //         content:
                                        //             '${controller.grbSchemeBatchesData[0].totalBuyQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalBuyQuantity.toString())}',
                                        //         textColor: AppColors.appblack,
                                        //         boldNess: FontWeight.w600,
                                        //       ),
                                        //     ],
                                        //   ),

                                        //buy
                                        // if (!widget.isEdit)
                                        //   Row(
                                        //     children: [
                                        //       CommonText(
                                        //         content: "Buy : ",
                                        //         textColor: AppColors.appblack,
                                        //         // boldNess: FontWeight.w600,
                                        //       ),
                                        //       CommonText(
                                        //         content:
                                        //             '${controller.grbSchemeBatchesData[0].totalBuyQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalBuyQuantity.toString())}',
                                        //         textColor: AppColors.appblack,
                                        //         boldNess: FontWeight.w600,
                                        //       ),
                                        //     ],
                                        //   ),

                                        //free
                                        // if (!widget.isEdit)
                                        // Row(
                                        //   children: [
                                        //     CommonText(
                                        //       content: "Free : ",
                                        //       textColor: AppColors.appblack,
                                        //       // boldNess: FontWeight.w600,
                                        //     ),
                                        //     CommonText(
                                        //       content:
                                        //           '${widget.isEdit ? controller.mainSchemeBatchItems[0].freeQuantity : controller.grbSchemeBatchesData[0].totalFreeQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalFreeQuantity.toString())}',
                                        //       textColor: AppColors.appblack,
                                        //       boldNess: FontWeight.w600,
                                        //     ),
                                        //   ],
                                        // ),

                                        //confirmed
                                        Row(
                                          children: [
                                            CommonText(
                                              content: "Confirmed : ",
                                              textColor: AppColors.appblack,
                                              textSize: 14,
                                              // boldNess: FontWeight.w600,
                                            ),
                                            CommonText(
                                              content:
                                                  // '${widget.isEdit ? widget.returnQuantity : controller.grbSchemeBatchesData[0].totalConfirmQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalConfirmQuantity.toString())}',
                                                  '${widget.isEdit ? widget.confirmedQuantity!.toStringAsFixed(0) : widget.returnQuantity!.toStringAsFixed(0)}',
                                              textColor: AppColors.appblack,
                                              boldNess: FontWeight.w600,
                                              textSize: 14,
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        if (widget.isFromScreen == 'expiry' &&
                                            controller.mainSchemeBatchItems[0]
                                                    .expiryReturnAmount !=
                                                null)
                                          Row(
                                            children: [
                                              CommonText(
                                                content:
                                                    "Expiry Return Amount : ",
                                                textColor: AppColors.appblack,
                                                textSize: 14,
                                                // boldNess: FontWeight.w600,
                                              ),
                                              CommonText(
                                                content:
                                                    // '${widget.isEdit ? widget.returnQuantity : controller.grbSchemeBatchesData[0].totalConfirmQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalConfirmQuantity.toString())}',
                                                    '₹${controller.mainSchemeBatchItems[0].expiryReturnAmount!.toStringAsFixed(2)}',
                                                textColor: AppColors.appblack,
                                                boldNess: FontWeight.w600,
                                                textSize: 14,
                                              ),
                                              Gap(4),
                                              Expanded(
                                                child: CommonText(
                                                  content:
                                                      // '${widget.isEdit ? widget.returnQuantity : controller.grbSchemeBatchesData[0].totalConfirmQuantity == null ? 0 : formatNumber(controller.grbSchemeBatchesData[0].totalConfirmQuantity.toString())}',
                                                      '(for each product)',
                                                  textColor: AppColors.appblack,
                                                  textSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),

                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(left: 2.0, bottom: 2),
                                        //   child: CommonText(
                                        //     content: "Return Quantity",
                                        //     textColor: AppColors.appblack,
                                        //     // boldNess: FontWeight.w600,
                                        //   ),
                                        // ),

                                        // //return buy qty text field
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: TextFormField(
                                        //         // controller: controller.buyQuantityDialogController,
                                        //         controller:
                                        //             controller.returnBuyQtyMainController,
                                        //         enabled:
                                        //             controller.isMainReturnQuantityEditable,
                                        //         keyboardType: TextInputType.number,
                                        //         inputFormatters: <TextInputFormatter>[
                                        //           // FilteringTextInputFormatter.allow(
                                        //           //     RegExp(r'^\d*\.?\d*')),
                                        //           FilteringTextInputFormatter.digitsOnly
                                        //         ],

                                        //         decoration: InputDecoration(
                                        //           isDense: true,
                                        //           contentPadding: const EdgeInsets.symmetric(
                                        //               vertical: 10, horizontal: 10),
                                        //           border: OutlineInputBorder(
                                        //             borderRadius: const BorderRadius.all(
                                        //                 Radius.circular(10)),
                                        //             borderSide: BorderSide(
                                        //               color: ColorsConst.semiGreyColor,
                                        //               width: 1,
                                        //             ),
                                        //           ),
                                        //           disabledBorder: OutlineInputBorder(
                                        //             borderRadius: const BorderRadius.all(
                                        //                 Radius.circular(10)),
                                        //             borderSide: BorderSide(
                                        //               color: ColorsConst.semiGreyColor,
                                        //               width: 1,
                                        //             ),
                                        //           ),
                                        //           enabledBorder: OutlineInputBorder(
                                        //             borderRadius: const BorderRadius.all(
                                        //                 Radius.circular(5)),
                                        //             borderSide: BorderSide(
                                        //               color: ColorsConst.semiGreyColor,
                                        //               width: 1,
                                        //             ),
                                        //           ),
                                        //           focusedBorder: OutlineInputBorder(
                                        //             borderRadius: const BorderRadius.all(
                                        //                 Radius.circular(10)),
                                        //             borderSide: BorderSide(
                                        //               color: ColorsConst.semiGreyColor,
                                        //               width: 1,
                                        //             ),
                                        //           ),
                                        //           errorBorder: OutlineInputBorder(
                                        //             borderRadius: const BorderRadius.all(
                                        //                 Radius.circular(10)),
                                        //             borderSide: BorderSide(
                                        //               color: ColorsConst.semiGreyColor,
                                        //               width: 1,
                                        //             ),
                                        //           ),
                                        //           hintText: "Enter Return Quantity",
                                        //           hintStyle: GoogleFonts.poppins(
                                        //             color: ColorsConst.hintColor,
                                        //           ),
                                        //         ),
                                        //         onChanged: (value) {
                                        //           // Map<String, dynamic> jsonMap = {
                                        //           //   // "schemeId": schemeId,
                                        //           //   // "schemeName": schemeName,
                                        //           //   // "buyQuantity": addBuyQty,
                                        //           //   // "freeQuantity": addFreeQty,
                                        //           //   // "finalQuantity": addFinalQty,
                                        //           //   // "quantity": quantity,
                                        //           // };
                                        //           // controller.getSchemeQty(
                                        //           //   schemeId: controller
                                        //           //           .grbSchemeBatchesData[0]
                                        //           //           .schemeId ??
                                        //           //       "",
                                        //           //   schemeName: controller
                                        //           //           .grbSchemeBatchesData[0]
                                        //           //           .schemeName ??
                                        //           //       "",
                                        //           //   addBuyQty: 0,
                                        //           //   addFreeQty: 0,
                                        //           //   addFinalQty: 0,
                                        //           //   quantity: num.parse(controller
                                        //           //       .returnBuyQtyMainController.text),
                                        //           // );
                                        //         },
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //     GestureDetector(
                                        //       onTap: () {
                                        //         if ((controller.returnBuyQtyMainController
                                        //             .text.isEmpty)) {
                                        //           CommonSnackBar.showError(
                                        //               "Qty must not be empty");

                                        //           return;
                                        //         }

                                        //         if (num.parse(controller
                                        //                 .returnBuyQtyMainController.text) ==
                                        //             0) {
                                        //           CommonSnackBar.showError(
                                        //               "Qty must be greater than 0");

                                        //           return;
                                        //         }

                                        //         if (num.parse(controller
                                        //                 .returnBuyQtyMainController.text) >
                                        //             (widget.isEdit
                                        //                 ? widget.confirmedQuantity!
                                        //                 : controller.grbSchemeBatchesData[0]
                                        //                     .totalConfirmQuantity!)) {
                                        //           CommonSnackBar.showError(
                                        //               "Maximum return quantity must be less than or equal to ${widget.isEdit ? widget.confirmedQuantity!.toInt() : controller.grbSchemeBatchesData[0].totalConfirmQuantity!.toInt()}");

                                        //           return;
                                        //         }

                                        //         controller.toggleMainReturnQty();
                                        //       },
                                        //       child: Container(
                                        //         width: 134,
                                        //         height: 43.5,
                                        //         padding: EdgeInsets.symmetric(
                                        //             vertical: 8, horizontal: 24),
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.circular(5),
                                        //             color: ColorsConst.primaryColor),
                                        //         child: Center(
                                        //           child: AppText(
                                        //             controller.isMainReturnQuantityEditable
                                        //                 ? 'Save'
                                        //                 : 'Edit',
                                        //             fontWeight: FontWeight.w500,
                                        //             fontSize: 16,
                                        //             color: ColorsConst.appWhite,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        // controller.returnBuyQtyMainController.text != "" &&
                                        //         controller.returnBuyQtyMainController.text !=
                                        //             "0"
                                        //     ? Row(
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         mainAxisAlignment: MainAxisAlignment.start,
                                        //         children: [
                                        //           CommonText(
                                        //             content:
                                        //                 'Qty: ${controller.finalQTYNum.toStringAsFixed(0)} ',
                                        //             boldNess: FontWeight.w500,
                                        //             textColor: ColorsConst.greyTextColor,
                                        //             textSize: width * 0.036,
                                        //           ),
                                        //           CommonText(
                                        //             content:
                                        //                 '(${((controller.buyQTYNum)).toStringAsFixed(2)} + ',
                                        //             boldNess: FontWeight.w500,
                                        //             textColor: ColorsConst.greyTextColor,
                                        //             textSize: width * 0.036,
                                        //           ),
                                        //           CommonText(
                                        //             content:
                                        //                 '${((controller.freeQTYNum)).toStringAsFixed(2)})',
                                        //             boldNess: FontWeight.w500,
                                        //             textColor: ColorsConst.greyTextColor,
                                        //             textSize: width * 0.036,
                                        //           )
                                        //         ],
                                        //       )
                                        //     : SizedBox(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (!controller
                                                .isMainReturnQuantityEditable &&
                                            controller
                                                .returnBuyQtyMainController
                                                .text
                                                .isNotEmpty) ...[
                                          // SizedBox(
                                          //   height: 20,
                                          // ),

                                          //Return Batch Wise List.
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0, bottom: 2),
                                            child: CommonText(
                                              content:
                                                  "Max quantity you can return from below batch - ${widget.confirmedQuantity!.toStringAsFixed(0)}",
                                              textColor: AppColors.appblack,
                                              textSize: 15.sp,
                                              // boldNess: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: controller
                                                .mainSchemeBatchItems.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                // height: 100,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: ColorsConst.appWhite,
                                                ),
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // CommonText(
                                                          //     content:
                                                          //         'Batch No. ${controller.mainSchemeBatchItems[index].batchNumber}',
                                                          //     // "Batch No. 2375t2375627",
                                                          //     textSize: 12,
                                                          //     overflow:
                                                          //         TextOverflow.ellipsis,
                                                          //     textColor: ColorsConst
                                                          //         .notificationTextColor,
                                                          //     boldNess: FontWeight.w500),
                                                          CommonText(
                                                              content:
                                                                  // 'Batch No. ${searchProduct.batchNumber == null ? '' : searchProduct.batchNumber}',
                                                                  "Buy :  ${controller.mainSchemeBatchItems[index].buyQuantity}",
                                                              textSize: 13,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textColor: ColorsConst
                                                                  .notificationTextColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500),
                                                          CommonText(
                                                              content:
                                                                  // 'Batch No. ${searchProduct.batchNumber == null ? '' : searchProduct.batchNumber}',
                                                                  "Free :  ${controller.mainSchemeBatchItems[index].freeQuantity}",
                                                              textSize: 13,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textColor: ColorsConst
                                                                  .notificationTextColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500),
                                                          CommonText(
                                                            content:
                                                                // 'Batch No. ${searchProduct.batchNumber == null ? '' : searchProduct.batchNumber}',
                                                                // "Total s:  ${controller.mainSchemeBatchItems[index].freeQuantity! + controller.grbSchemeBatchesData[0].items![index].buyQuantity!}",
                                                                "Total:  ${controller.mainSchemeBatchItems[index].freeQuantity! + controller.mainSchemeBatchItems[index].buyQuantity!}",
                                                            textSize: 13,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textColor: ColorsConst
                                                                .notificationTextColor,
                                                            boldNess:
                                                                FontWeight.w500,
                                                          ),

                                                          CommonText(
                                                            content:
                                                                // 'Batch No. ${searchProduct.batchNumber == null ? '' : searchProduct.batchNumber}',
                                                                controller
                                                                        .batchWiseErrors[
                                                                    index],
                                                            textSize: 12,
                                                            // overflow: TextOverflow.ellipsis,
                                                            textColor:
                                                                ColorsConst
                                                                    .redColor,
                                                            boldNess:
                                                                FontWeight.bold,
                                                          ),
                                                        ],

                                                        //return qty inside batch textfierld
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0,
                                                                    bottom: 2),
                                                            child: CommonText(
                                                              content:
                                                                  "Return Quantity",
                                                              textSize: 10,
                                                              textColor:
                                                                  AppColors
                                                                      .appblack,
                                                              // boldNess: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            child:
                                                                TextFormField(
                                                              // controller: controller.buyQuantityDialogController,
                                                              controller: controller
                                                                      .batchWiseControllers[
                                                                  index],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                // FilteringTextInputFormatter.allow(
                                                                //     RegExp(r'^\d*\.?\d*')),
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly
                                                              ],
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            10),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: ColorsConst
                                                                        .semiGreyColor,
                                                                    width: 0,
                                                                  ),
                                                                ),
                                                                disabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: ColorsConst
                                                                        .semiGreyColor,
                                                                    width: 0,
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: ColorsConst
                                                                        .semiGreyColor,
                                                                    width:
                                                                        2, // You can adjust the width as needed for the focused state
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: ColorsConst
                                                                        .semiGreyColor,
                                                                    width:
                                                                        2, // You can adjust the width as needed for the focused state
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: ColorsConst
                                                                        .semiGreyColor,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                hintText:
                                                                    "Return Qty",
                                                                hintStyle: GoogleFonts.poppins(
                                                                    color: ColorsConst
                                                                        .hintColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0,
                                                                    bottom: 2),
                                                            child: CommonText(
                                                              content: "Reason",
                                                              textSize: 10,
                                                              textColor:
                                                                  AppColors
                                                                      .appblack,
                                                              // boldNess: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 40,
                                                            child:
                                                                LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                double
                                                                    maxWidth =
                                                                    constraints
                                                                        .maxWidth;
                                                                return AppDropdown(
                                                                  valuesList: widget
                                                                              .isFromScreen ==
                                                                          'expiry'
                                                                      ? const [
                                                                          'Expired',
                                                                          'Damaged'
                                                                        ]
                                                                      : const [
                                                                          // 'Expiry',
                                                                          'Immovable',
                                                                          // 'Damaged',
                                                                          'Mismatched'
                                                                        ],

                                                                  themeController:
                                                                      themeController,
                                                                  itemsWidth:
                                                                      maxWidth -
                                                                          20,
                                                                  dropdownIconShowOnSelect:
                                                                      true,
                                                                  selectedValue:
                                                                      controller
                                                                              .batchWiseReasons[
                                                                          index],
                                                                  hintText:
                                                                      "Reason",
                                                                  hintColor:
                                                                      themeController
                                                                          .textSecondaryColor,
                                                                  containerBorderColor:
                                                                      themeController
                                                                          .nav1,
                                                                  // borderColor: widget.themeController.nav1,
                                                                  selectedTextAlignment:
                                                                      TextAlign
                                                                          .left,
                                                                  onValueChanged:
                                                                      (p0) {
                                                                    setState(
                                                                        () {
                                                                      // sampleCollectionController
                                                                      //         .selectedUrgent =
                                                                      //     p0 ?? '';

                                                                      controller
                                                                              .batchWiseReasons[index] =
                                                                          p0 ??
                                                                              '';
                                                                      controller
                                                                          .update();
                                                                    });
                                                                  },

                                                                  containerBorderRadius:
                                                                      4,
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(
                                                height: 10,
                                              );
                                            },
                                            shrinkWrap: true,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () async {
                                                num totalBatchWiseValue = 0;

                                                for (int index = 0;
                                                    index <
                                                        controller
                                                            .batchWiseControllers
                                                            .length;
                                                    index++) {
                                                  TextEditingController i =
                                                      controller
                                                              .batchWiseControllers[
                                                          index];

                                                  if (i.text.isNotEmpty &&
                                                      num.parse(i.text) != 0 &&
                                                      num.parse(i.text) >
                                                          controller
                                                                  .batchWiseTotals[
                                                              index]) {
                                                    controller.batchWiseErrors[
                                                            index] =
                                                        "Qty must be less than or equal to ${controller.batchWiseTotals[index]}";
                                                    controller.update();
                                                    print(
                                                        "grb scheme return - index $index ${controller.batchWiseControllers[index].text} limit reached -> ${controller.batchWiseTotals[index]}");
                                                  } else if (i
                                                          .text.isNotEmpty &&
                                                      num.parse(i.text) != 0 &&
                                                      controller.batchWiseReasons[
                                                              index] ==
                                                          null) {
                                                    controller.batchWiseErrors[
                                                            index] =
                                                        "Reason must be selected";
                                                    controller.update();
                                                  } else if (i.text.isEmpty) {
                                                    controller.batchWiseErrors[
                                                            index] =
                                                        "Return quantity must not be empty";
                                                    controller.update();
                                                  } else {
                                                    controller.batchWiseErrors[
                                                        index] = "";
                                                    controller.update();
                                                  }

                                                  if (i.text.isNotEmpty) {
                                                    totalBatchWiseValue +=
                                                        num.parse(i.text);
                                                  }
                                                }

                                                print(
                                                    "grb scheme return - totalBatchWiseValue -> $totalBatchWiseValue  , mainCOntroller -> ${controller.returnBuyQtyMainController.text}");
                                                bool isAnyErrorThere =
                                                    controller.batchWiseErrors
                                                        .any((str) =>
                                                            str.isNotEmpty);

                                                print(
                                                    'is Any error there -> ${isAnyErrorThere}');

                                                if (totalBatchWiseValue >
                                                        (widget
                                                            .confirmedQuantity!) ||
                                                    isAnyErrorThere) {
                                                  if (!isAnyErrorThere)
                                                    CommonSnackBar.showError(
                                                        "Qty must be less than or equal to ${controller.returnBuyQtyMainController.text}");
                                                } else {
                                                  String userId =
                                                      await SharPreferences
                                                              .getString(
                                                                  SharPreferences
                                                                      .loginId) ??
                                                          "";

                                                  String storeId =
                                                      await SharPreferences
                                                              .getString(
                                                                  SharPreferences
                                                                      .supplierId) ??
                                                          "";
                                                  ;

                                                  //list of body starts here - new process
                                                  List<Map<String, dynamic>>
                                                      body = [];
                                                  for (int index = 0;
                                                      index <
                                                          controller
                                                              .batchWiseControllers
                                                              .length;
                                                      index++) {
                                                    TextEditingController i =
                                                        controller
                                                                .batchWiseControllers[
                                                            index];

                                                    String reason = controller
                                                                .batchWiseReasons[
                                                            index] ??
                                                        '';

                                                    GrbSchemeBatchModel
                                                        grbMain = controller
                                                            .grbSchemeBatchesData[0];

                                                    // GrbSchemeBatchItem grbItem = controller
                                                    //     .grbSchemeBatchesData[0].items![index];

                                                    GrbSchemeBatchItem grbItem =
                                                        controller
                                                                .mainSchemeBatchItems[
                                                            index];

                                                    String storeName =
                                                        await SharPreferences
                                                                .getString(
                                                                    SharPreferences
                                                                        .storeName) ??
                                                            '';

                                                    if (i.text.isNotEmpty &&
                                                        num.parse(i.text) > 0) {
                                                      Map<String, dynamic>
                                                          itemBody = {
                                                        "orderId":
                                                            grbMain.orderId,
                                                        "itemId":
                                                            grbItem.itemId,
                                                        'invoiceId':
                                                            grbItem.invoiceId,
                                                        "productId":
                                                            grbMain.productId,
                                                        "productName":
                                                            grbMain.productName,
                                                        'skuId': grbItem.skuId,
                                                        'netRate':
                                                            grbItem.netRate,
                                                        // "measure": "string",
                                                        "schemeName":
                                                            grbMain.schemeName,
                                                        "schemeId":
                                                            grbMain.schemeId,
                                                        "manufacturer": grbMain
                                                            .manufacturer,
                                                        // "quantity": grbMain.quantity,
                                                        // "finalQuantity": 0,
                                                        "freeQuantity": 0,
                                                        "buyQuantity":
                                                            num.parse(i.text),
                                                        "orderedQuantity":
                                                            grbItem
                                                                .confirmQuantity,
                                                        'confrimQuantity':
                                                            grbItem
                                                                .confirmQuantity,
                                                        'lineAmount':
                                                            grbItem.lineAmount,
                                                        // "price": 0,
                                                        "finalPtr":
                                                            grbItem.finalPtr,
                                                        "mrp": grbItem.mrp,

                                                        // "productUrl": "string",
                                                        // "storeName": storeName,
                                                        // "tabletsPerStrip": "string",
                                                        // "categoryName": "string",
                                                        // "prescriptionIsRequired": true,
                                                        // "checkOutStatus": "string",
                                                        // "timePassed": "string",
                                                        "batchNumber":
                                                            grbItem.batchNumber,
                                                        "returnReason": reason,
                                                        'sgstPercent':
                                                            grbItem.sgstPercent,
                                                        'cgstPercent':
                                                            grbItem.cgstPercent,
                                                        'discount':
                                                            grbItem.discount,
                                                        'hsn': grbItem.hsn,
                                                        'skuCode':
                                                            grbMain.skuCode,
                                                        'expiryDate':
                                                            grbItem.expDate,
                                                        "screenDisplay":
                                                            widget.isFromScreen,
                                                      };

                                                      body.add(itemBody);
                                                    }
                                                  }

                                                  // print(
                                                  //     'printing grb add to cart main body -> $body');

                                                  log('log body -> ${body}');

                                                  // return;

                                                  //list of body ends here - new process
                                                  // for (int index = 0;
                                                  //     index <
                                                  //         controller
                                                  //             .batchWiseControllers.length;
                                                  //     index++) {
                                                  //   TextEditingController i = controller
                                                  //       .batchWiseControllers[index];
                                                  //   if (i.text.isNotEmpty &&
                                                  //       num.parse(i.text) > 0) {
                                                  //     var body = {
                                                  //       "invoiceId": controller
                                                  //           .grbSchemeBatchesData[0]
                                                  //           .items![index]
                                                  //           .invoiceId,
                                                  //       "orderId": controller
                                                  //           .grbSchemeBatchesData[0].orderId,
                                                  //       "orderItemId": controller
                                                  //           .grbSchemeBatchesData[0]
                                                  //           .items![index]
                                                  //           .itemId,
                                                  //       "productId": controller
                                                  //           .grbSchemeBatchesData[0]
                                                  //           .productId,
                                                  //       "returnBuyQty": num.parse(i.text),
                                                  //       "returnFreeQty": 0,
                                                  //       "storeId": storeId,
                                                  //       "userId": userId
                                                  //     };

                                                  //     print(
                                                  //         'print add to cart grb order body - ${body}');

                                                  //     controller.addToGrbCartApiCalls.add(
                                                  //         controller.addGrbOrderToCart(body));
                                                  //     print(
                                                  //         "grb scheme return -> check each controller on success -> ${i.text}");
                                                  //   }
                                                  //   print(
                                                  //       "grb scheme return -> check each controller on success -> index: $index, value: ${i.text}");
                                                  // }

                                                  Map<String, dynamic>
                                                      editBody = {};

                                                  if (widget.isEdit) {
                                                    for (int index = 0;
                                                        index <
                                                            controller
                                                                .batchWiseControllers
                                                                .length;
                                                        index++) {
                                                      TextEditingController i =
                                                          controller
                                                                  .batchWiseControllers[
                                                              index];

                                                      String reason = controller
                                                                  .batchWiseReasons[
                                                              index] ??
                                                          '';

                                                      GrbSchemeBatchModel
                                                          grbMain = controller
                                                              .grbSchemeBatchesData[0];

                                                      // GrbSchemeBatchItem grbItem = controller
                                                      //     .grbSchemeBatchesData[0].items![index];

                                                      GrbSchemeBatchItem
                                                          grbItem = controller
                                                                  .mainSchemeBatchItems[
                                                              index];

                                                      editBody = {
                                                        "orderId":
                                                            grbMain.orderId,
                                                        "itemId":
                                                            grbItem.itemId,
                                                        "userId": userId,
                                                        "buyQuantity":
                                                            num.parse(i.text),
                                                        "returnReason": reason,
                                                        'orderedQuantity':
                                                            grbItem
                                                                .confirmQuantity,
                                                        'storeId': storeId,
                                                      };
                                                    }
                                                  }

                                                  if (widget.isEdit) {
                                                    await controller
                                                        .editGrbItem(editBody);
                                                  } else {
                                                    await controller
                                                        .addToCartGrb(body);
                                                  }

                                                  // await Future.wait(
                                                  //     controller.addToGrbCartApiCalls);

                                                  // controller.isAddTOGrbCartApisLoading =
                                                  //     false;
                                                  // controller.update();

                                                  // CommonSnackBar.showError(
                                                  //     "Added to cart successfulll");
                                                }
                                              },
                                              child: Container(
                                                width: 134,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 24),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: ColorsConst
                                                        .primaryColor),
                                                child: Center(
                                                  child: AppText(
                                                    widget.isEdit
                                                        ? 'Update'
                                                        : 'Add to Cart',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorsConst.appWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                      ),
                    ),
                    if (widget.isFromScreen == "expiry")
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: ColorsConst.bgColor,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: ColorsConst.appWhite,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText(
                                content: "NOTE:",
                                textColor: Colors.black,
                                textAlign: TextAlign.center,
                                textSize: 10,
                                boldNess: FontWeight.bold,
                              ),
                              Gap(6),
                              Expanded(
                                child: CommonText(
                                  content: "40% on Net Rate for each product.",
                                  textColor: Colors.black,
                                  textSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                controller.grbItemUpdateLoading ? AppLoader() : SizedBox(),
              ],
            ),
          );
        });
  }
}
