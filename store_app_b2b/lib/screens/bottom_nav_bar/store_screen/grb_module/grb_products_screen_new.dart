import 'package:b2c/constants/colors_const.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:store_app_b2b/components/common_search_field_new.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';

import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';

import 'package:store_app_b2b/controllers/bottom_controller/store_controller/grb_return_controller/grb_return_controller_new.dart';
import 'package:store_app_b2b/model/grb_return_orders_pageable_model_new.dart';

import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/grb_module/grb_scheme_return_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';

import 'package:store_app_b2b/widget/time_check_new.dart';

class GrbProductsScreen extends StatefulWidget {
  const GrbProductsScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<GrbProductsScreen> createState() => _GrbProductsScreenState();
}

class _GrbProductsScreenState extends State<GrbProductsScreen> {
  final controller = Get.put(GrbReturnController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<GrbReturnController>(
      init: GrbReturnController(),
      initState: (state) async {
        Future.delayed(
          Duration(milliseconds: 300),
          () {
            GrbReturnController controller = Get.put(GrbReturnController());
            controller.getGrbProdutsList(initial: true);
          },
        );
      },
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: "GRB",
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
              Container(
                color: ColorsConst.bgColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                  child: Column(
                    children: [
                      Obx(() => CommonSearchField(
                            showCloseIcon: controller
                                .grbOrderSearchControllerText.value.isNotEmpty,
                            closeOnTap: () {
                              controller.grbOrderSearchControllerText.value =
                                  "";
                              controller.grbOrderSearchController.value.text =
                                  "";
                              controller.getGrbProdutsList(
                                  fromSearch: true,
                                  initial: true,
                                  searchText: "");
                              // controller.searchController.value.clear();
                              // controller.getBuyByProductDataApi("",
                              //     categoryId: categoryId);
                            },
                            // controller: controller.searchController.value,
                            controller:
                                controller.grbOrderSearchController.value,
                            onChanged: (String value) {
                              controller.grbOrderSearchControllerText.value =
                                  value;
                              if (value.isNotEmpty) {
                                controller.getGrbProdutsList(
                                  fromSearch: true,
                                  initial: true,
                                  searchText: value,
                                );
                              } else {
                                controller.getGrbProdutsList(
                                    fromSearch: true,
                                    initial: true,
                                    searchText: "");
                                // controller.isLoading(true);
                                // controller.byProductList.clear();
                                // controller.isLoading(false);
                                // controller.getBuyByProductDataApi("",
                                //     showLoading: false, categoryId: categoryId);
                                // controller.update();
                              }
                            },
                          )),
                      SizedBox(height: 2),
                      controller.isGrbOrderListLoadInitial
                          ? Expanded(
                              child: Center(child: CircularProgressIndicator()))
                          : controller.grbReturnOrdersList.isNotEmpty
                              ? Expanded(
                                  child: GetBuilder(
                                    builder: (GrbReturnController controller) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child:
                                                  Obx(() => ScrollConfiguration(
                                                        behavior:
                                                            const ScrollBehavior()
                                                                .copyWith(
                                                                    overscroll:
                                                                        false),
                                                        child: ListView.builder(
                                                          controller: controller
                                                              .scrollController,
                                                          keyboardDismissBehavior:
                                                              ScrollViewKeyboardDismissBehavior
                                                                  .onDrag,
                                                          itemCount: controller
                                                              .grbReturnOrdersList
                                                              .length,
                                                          // padding: EdgeInsets.only(
                                                          //     bottom: height * 0.1),
                                                          itemBuilder:
                                                              (context, index) {
                                                            GrbReturnOrderModel
                                                                searchProduct =
                                                                controller
                                                                        .grbReturnOrdersList[
                                                                    index];
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      0,
                                                                      10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorsConst
                                                                    .appWhite,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                                    child: CommonText(
                                                                                      content: '${searchProduct.productName == null ? '' : searchProduct.productName}',
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      boldNess: FontWeight.w600,
                                                                                      textColor: ColorsConst.textColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                if (searchProduct.schemeName != null && searchProduct.schemeName != "")
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 8.0, right: 10),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Image.asset(
                                                                                          "assets/icons/offer.png",
                                                                                          scale: 3.5,
                                                                                          package: 'store_app_b2b',
                                                                                        ),
                                                                                        SizedBox(width: width * 0.01),
                                                                                        CommonText(
                                                                                          content: "${searchProduct.schemeName ?? ''}",
                                                                                          textSize: 12,
                                                                                          boldNess: FontWeight.w600,
                                                                                          textColor: ColorsConst.textColor,
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        SizedBox(width: width * 0.01),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                            CommonText(
                                                                                content: 'Batch No. ${searchProduct.batchNumber == null ? '' : searchProduct.batchNumber}',
                                                                                textSize: 12,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textColor: ColorsConst.notificationTextColor,
                                                                                boldNess: FontWeight.w500),
                                                                            CommonText(
                                                                              content: 'Order Id. ${searchProduct.orderId == null ? '' : searchProduct.orderId}',
                                                                              textSize: 12,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                              boldNess: FontWeight.w500,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            CommonText(
                                                                                content: 'MRP',
                                                                                textSize: 12,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textColor: ColorsConst.notificationTextColor,
                                                                                boldNess: FontWeight.bold),
                                                                            CommonText(
                                                                              content: '${searchProduct.mrp == null ? '' : searchProduct.mrp}',
                                                                              textSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            CommonText(
                                                                                content: 'PTR',
                                                                                textSize: 12,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textColor: ColorsConst.notificationTextColor,
                                                                                boldNess: FontWeight.bold),
                                                                            CommonText(
                                                                              content: '${searchProduct.finalPtr == null ? '' : searchProduct.finalPtr}',
                                                                              textSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            CommonText(
                                                                                content: 'NET RATE',
                                                                                textSize: 12,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textColor: ColorsConst.notificationTextColor,
                                                                                boldNess: FontWeight.bold),
                                                                            CommonText(
                                                                              content: '${searchProduct.netRate == null ? '' : searchProduct.netRate}',
                                                                              textSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            CommonText(
                                                                                content: 'ORDERED',
                                                                                textSize: 12,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textColor: ColorsConst.notificationTextColor,
                                                                                boldNess: FontWeight.bold),
                                                                            CommonText(
                                                                              content: '${searchProduct.quantity == null ? '' : formatNumber(searchProduct.quantity!.toString())}',
                                                                              textSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            CommonText(
                                                                                content: 'CONFIRMED',
                                                                                textSize: 12,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textColor: ColorsConst.notificationTextColor,
                                                                                boldNess: FontWeight.bold),
                                                                            CommonText(
                                                                              content: '${searchProduct.confirmQuantity == null ? '' : formatNumber(searchProduct.confirmQuantity!.toString())}',
                                                                              textSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              SizedBox())
                                                                    ],
                                                                  ),
                                                                  // SizedBox(
                                                                  //   height: 10,
                                                                  // ),

                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CommonText(
                                                                              content: 'Ordered on : ',
                                                                              textSize: 12,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                            ),
                                                                            CommonText(
                                                                              content: '${searchProduct.orderCreatedDate == null ? '' : DateFormat('dd-MM-yyyy').format(searchProduct.orderCreatedDate!)}',
                                                                              textSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textColor: ColorsConst.notificationTextColor,
                                                                              boldNess: FontWeight.bold,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      addToCartButton(
                                                                          index,
                                                                          searchProduct),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )),
                                            ),
                                            controller.isGrbOrderListLoadMore
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      CircularProgressIndicator(),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                      child: const Text(
                                    'No products found',
                                    style: TextStyle(fontSize: 17),
                                  )),
                                ),
                    ],
                  ),
                ),
              ),
              Obx(() => controller.isCheckGrbItemInCart.value
                  ? Positioned.fill(
                      child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black38,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ))
                  : SizedBox()),
            ],
          ),
        ));
      },
    );
  }

  String formatNumber(String numberString) {
    // Parse the string to a double
    double number = double.parse(numberString);

    // Check if the number is an integer
    if (number % 1 == 0) {
      // If the number is an integer, return it as an integer string
      return number.toInt().toString();
    } else {
      // Otherwise, return the original string
      return number.toString();
    }
  }

  addToCartButton(int index, GrbReturnOrderModel searchProduct) {
    return GestureDetector(
      onTap: () async {
        // FocusManager.instance.primaryFocus!.unfocus();

        // if (searchProduct.schemeName != null &&
        //     searchProduct.schemeName != "") {
        await controller
            .checkGrbItemAvailableInCart(
                itemId: searchProduct.itemId ?? '',
                storeId: searchProduct.storeId ?? '')
            .then((value) {
          if (value != null &&
              value.containsKey("status") &&
              value["status"] == false) {
            Get.to(() => GrbSchemeReturnScreen(
                  schemeName: searchProduct.schemeName ?? '',
                  itemId: searchProduct.itemId ?? '',
                  orderId: searchProduct.orderId ?? "",
                  productId: searchProduct.productId ?? "",
                  editableBatchNo: searchProduct.batchNumber ?? '',
                  returnQuantity: searchProduct.buyQuantity ?? 0,
                  confirmedQuantity: searchProduct.confirmQuantity ?? 0,
                ));
          } else if (value != null &&
              value.containsKey("status") &&
              value["status"] == true) {
            CommonSnackBar.showError(value["message"]);
          } else {
            CommonSnackBar.showError("Something Went Wrong");
          }
        });

        return;

        return;
        // }

        var body = {
          "invoiceId": searchProduct.invoiceId,
          "orderId": searchProduct.orderId,
          "orderItemId": searchProduct.itemId,
          "productId": searchProduct.productId,
          "returnBuyQty": 0,
          "returnFreeQty": 0,
          "storeId": searchProduct.storeId,
          "userId": searchProduct.userId
        };

        // logs('$body');
        controller.buyQuantityDialogController.text =
            formatNumber(searchProduct.buyQuantity!.toString());

        controller.freeQuantityDialogController.text =
            formatNumber(searchProduct.freeQuantity!.toString());

        controller.update();

        Get.dialog(Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            child: Container(
              // height: 480,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonText(
                          content: searchProduct.orderId!,
                          textColor: AppColors.primaryColor,
                          boldNess: FontWeight.bold,
                        ),
                      ),
                      if (searchProduct.schemeName != null &&
                          searchProduct.schemeName != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, right: 10),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/offer.png",
                                scale: 3.5,
                                package: 'store_app_b2b',
                              ),
                              SizedBox(width: 5),
                              CommonText(
                                content: "${searchProduct.schemeName ?? ''}",
                                textSize: 12,
                                boldNess: FontWeight.w600,
                                textColor: ColorsConst.textColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 0),
                            ],
                          ),
                        ),
                    ],
                  ),
                  CommonText(
                    content: searchProduct.productName!,
                    textColor: AppColors.appblack,
                    boldNess: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: [
                  //     CommonText(
                  //       content: "Scheme Name : ",
                  //       textColor: AppColors.appblack,
                  //       // boldNess: FontWeight.w600,
                  //     ),
                  //     CommonText(
                  //       content: searchProduct.schemeName == null ||
                  //               searchProduct.schemeName == ""
                  //           ? '--'
                  //           : searchProduct.schemeName!,
                  //       textColor: AppColors.appblack,
                  //       boldNess: FontWeight.w600,
                  //     ),
                  //   ],
                  // ),

                  //ordered
                  Row(
                    children: [
                      CommonText(
                        content: "Ordered : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                      CommonText(
                        content:
                            '${searchProduct.quantity == null ? 0 : formatNumber(searchProduct.quantity!.toString())}',
                        textColor: AppColors.appblack,
                        boldNess: FontWeight.w600,
                      ),
                    ],
                  ),

                  //buy
                  Row(
                    children: [
                      CommonText(
                        content: "Buy : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                      CommonText(
                        content:
                            '${searchProduct.buyQuantity == null ? 0 : formatNumber(searchProduct.buyQuantity!.toString())}',
                        textColor: AppColors.appblack,
                        boldNess: FontWeight.w600,
                      ),
                    ],
                  ),

                  //free
                  Row(
                    children: [
                      CommonText(
                        content: "Free : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                      CommonText(
                        content:
                            '${searchProduct.freeQuantity == null ? 0 : formatNumber(searchProduct.freeQuantity!.toString())}',
                        textColor: AppColors.appblack,
                        boldNess: FontWeight.w600,
                      ),
                    ],
                  ),

                  //confirmed
                  Row(
                    children: [
                      CommonText(
                        content: "Confirmed : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                      CommonText(
                        content:
                            '${searchProduct.confirmQuantity == null ? 0 : formatNumber(searchProduct.confirmQuantity!.toString())}',
                        textColor: AppColors.appblack,
                        boldNess: FontWeight.w600,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CommonText(
                    content: "Return Quantities",
                    textColor: AppColors.appblack,
                    boldNess: FontWeight.w600,
                  ),

                  const SizedBox(height: 10),

                  //text for buy quantity
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0, bottom: 2),
                    child: CommonText(
                      content: "Return Buy Qty",
                      textColor: AppColors.appblack,
                      // boldNess: FontWeight.w600,
                    ),
                  ),
                  TextFormField(
                    controller: controller.buyQuantityDialogController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: ColorsConst.semiGreyColor,
                          width: 1,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: ColorsConst.semiGreyColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: ColorsConst.semiGreyColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: ColorsConst.semiGreyColor,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: ColorsConst.semiGreyColor,
                          width: 1,
                        ),
                      ),
                      hintText: "Enter Return Buy Qty",
                      hintStyle: GoogleFonts.poppins(
                        color: ColorsConst.hintColor,
                      ),
                    ),
                  ),

                  if (searchProduct.schemeName != "" &&
                      searchProduct.schemeName != null) ...[
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, bottom: 2),
                      child: CommonText(
                        content: "Free Qty : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                    ),
                    //text for free quantity
                    TextFormField(
                      controller: controller.freeQuantityDialogController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: ColorsConst.semiGreyColor,
                            width: 1,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: ColorsConst.semiGreyColor,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: ColorsConst.semiGreyColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: ColorsConst.semiGreyColor,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: ColorsConst.semiGreyColor,
                            width: 1,
                          ),
                        ),
                        hintText: "Enter Free Qty",
                        hintStyle: GoogleFonts.poppins(
                          color: ColorsConst.hintColor,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(
                    height: 20,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // if (num.parse(
                        //         controller.buyQuantityDialogController.text) >
                        //     searchProduct.buyQuantity!) {
                        //   CommonSnackBar.showError(
                        //       "Buy qty should not be greater than ${searchProduct.buyQuantity}");
                        //   return;
                        // }
                        if (searchProduct.schemeName != "" &&
                            searchProduct.schemeName != null) {
                          if (num.parse(controller
                                  .freeQuantityDialogController.text) >
                              searchProduct.freeQuantity!) {
                            CommonSnackBar.showError(
                                "Free qty should not be greater than ${searchProduct.freeQuantity}");

                            return;
                          }
                        }

                        //              "returnBuyQty": 0,
                        // "returnFreeQty": 0,

                        body["returnBuyQty"] = formatNumber(
                            controller.buyQuantityDialogController.text);
                        body["returnFreeQty"] = formatNumber(
                            controller.freeQuantityDialogController.text);

                        controller.addGrbOrderToCart(body).then((value) {
                          if (value) {
                            CommonSnackBar.showError("Added to Grb Cart");
                            Get.back();
                          }
                        });
                      },
                      child: Container(
                        width: 134,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorsConst.primaryColor),
                        child: Center(
                          child: Obx(() => controller.grbUpdateLoading.value
                              ? SizedBox(
                                  height: 30,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: AppColors.appWhite,
                                  ),
                                )
                              : AppText(
                                  'Save',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: ColorsConst.appWhite,
                                )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 134,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ColorsConst.primaryColor),
        child: Center(
          child: AppText(
            'Add to Cart',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: ColorsConst.appWhite,
          ),
        ),
      ),
    );
  }

  Color getStockStatusTextColor(String stockAvailable) {
    bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
    bool isTimePassedInMain =
        isMaxTimeStopNeededInMain ? isAfterDynamicTimeSystemCheck() : false;
    switch (stockAvailable) {
      case "1":
        return isTimePassedInMain ? Colors.green : Colors.green;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  // decreaseProductButton(int index, GrbReturnOrderModel searchProduct) {
  //   return GestureDetector(
  //     onTap: () {
  //       FocusScope.of(context).unfocus();
  //       // if (controller.qtyList[index].value > 0) {
  //       //   controller.qtyList[index].value--;
  //       //   if (controller.qtyList[index].value == 0) {
  //       //     controller.qtyTextControllerList[index].clear();
  //       //   } else {
  //       //     controller.qtyTextControllerList[index].text =
  //       //         '${controller.qtyList[index]}';
  //       //   }
  //       //   // if (searchProduct.schemeAvailable) {
  //       //   //   controller.getSchemeQty(
  //       //   //       quantity: controller.qtyList[index].value,
  //       //   //       index: index,
  //       //   //       schemeId: searchProduct.schemeId ?? '',
  //       //   //       schemeName: searchProduct.schemeName ?? '',
  //       //   //       addBuyQty: controller.qtyList[index].value,
  //       //   //       addFreeQty: 0,
  //       //   //       finalQty: controller.finalQTYList[index].value);
  //       //   // }
  //       // }
  //     },
  //     child: Icon(Icons.remove, color: ColorsConst.primaryColor, size: 20),
  //   );
  // }

  // addProductTextField(int index, GrbReturnOrderModel searchProduct) {
  //   // return SizedBox(
  //   //     width: 60, child: TextFormField(textAlign: TextAlign.center));
  //   return Obx(() => SizedBox(
  //         width: 60,
  //         child: TextField(
  //         //   maxLength: 4,
  //         //   controller: controller.qtyTextControllerList[index],
  //         //   textAlign: TextAlign.center,
  //         //   style: TextStyle(
  //         //     color: ColorsConst.primaryColor,
  //         //     fontSize: 16,
  //         //     fontWeight: FontWeight.w500,
  //         //   ),
  //         //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //         //   onChanged: (value) {
  //         //     if (value.isNotEmpty) {
  //         //       controller.qtyList[index].value = int.parse(value);
  //         //     } else {
  //         //       controller.qtyTextControllerList[index].clear();
  //         //       FocusScope.of(context).unfocus();
  //         //       controller.qtyList[index].value = 0;
  //         //     }
  //         //     // if (searchProduct.schemeAvailable) {
  //         //     //   controller.getSchemeQty(
  //         //     //       quantity: controller.qtyList[index].value,
  //         //     //       index: index,
  //         //     //       schemeId: searchProduct.schemeId ?? '',
  //         //     //       schemeName: searchProduct.schemeName ?? '',
  //         //     //       addBuyQty: controller.qtyList[index].value,
  //         //     //       addFreeQty: 0,
  //         //     //       finalQty: controller.finalQTYList[index].value);
  //         //     // }
  //         //   },
  //         //   onSubmitted: (value) {
  //         //     if (value.isNotEmpty) {
  //         //       controller.qtyList[index].value = int.parse(value);
  //         //     } else {
  //         //       controller.qtyList[index].value = 0;
  //         //     }
  //         //     // if (searchProduct.schemeAvailable) {
  //         //     //   controller.getSchemeQty(
  //         //     //       quantity: controller.qtyList[index].value,
  //         //     //       index: index,
  //         //     //       schemeId: searchProduct.schemeId ?? '',
  //         //     //       schemeName: searchProduct.schemeName ?? '',
  //         //     //       addBuyQty: controller.qtyList[index].value,
  //         //     //       addFreeQty: 0,
  //         //     //       finalQty: controller.finalQTYList[index].value);
  //         //     // }
  //         //   },
  //         //   keyboardType: TextInputType.phone,
  //         //   textInputAction: TextInputAction.done,
  //         //   decoration: InputDecoration(
  //         //       counterText: "",
  //         //       hintText: 'Add',
  //         //       hintStyle: TextStyle(
  //         //         color: ColorsConst.primaryColor,
  //         //         fontSize: 16,
  //         //         fontWeight: FontWeight.w500,
  //         //       ),
  //         //       contentPadding: EdgeInsets.only(top: 5, bottom: 0),
  //         //       border: OutlineInputBorder(borderSide: BorderSide.none)),
  //         // ),
  //       ),);
  // }

  // increaseProductButton(int index, GrbReturnOrderModel searchProduct) {
  //   return GestureDetector(
  //     onTap: () {
  //       FocusScope.of(context).unfocus();
  //       if (controller.qtyList[index].value <= 1000) {
  //         controller.qtyList[index].value++;
  //         logs('qty ==> ${controller.qtyList[index].value}');
  //         controller.qtyTextControllerList[index].text =
  //             '${controller.qtyList[index].value}';
  //         // if (searchProduct.schemeAvailable) {
  //         //   controller.getSchemeQty(
  //         //       quantity: controller.qtyList[index].value,
  //         //       index: index,
  //         //       schemeId: searchProduct.schemeId ?? '',
  //         //       schemeName: searchProduct.schemeName ?? '',
  //         //       addBuyQty: controller.qtyList[index].value,
  //         //       addFreeQty: 0,
  //         //       finalQty: controller.finalQTYList[index].value);
  //         // }
  //       }
  //     },
  //     child: Icon(Icons.add, color: ColorsConst.primaryColor, size: 20),
  //   );
  // }
}
