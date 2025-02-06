import 'dart:convert';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app_b2b/components/common_search_field_new.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller_new.dart';
import 'package:store_app_b2b/model/search_products_model_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/product_details_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/widget/time_check.dart';

class ByProductTab extends StatefulWidget {
  final String categoryId;
  final String? storeId;
  ByProductTab({Key? key, required this.categoryId, this.storeId})
      : super(key: key);

  @override
  State<ByProductTab> createState() => _ByProductTabState();
}

class _ByProductTabState extends State<ByProductTab> {
  final controller = Get.find<BuyController>();

  final gmcController = Get.find<GlobalMainController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<GlobalMainController>(initState: (state) {
      Future.delayed(
        Duration(milliseconds: 250),
        () {
          final StoreController storeController = Get.put(StoreController());
          storeController.getAccountStatus();
        },
      );
    }, builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Stack(
          children: [
            Column(
              children: [
                Obx(() => CommonSearchField(
                      showCloseIcon:
                          controller.searchController.value.text.isNotEmpty,
                      closeOnTap: () {
                        controller.searchController.value.clear();
                        controller.getBuyByProductDataApi("",
                            categoryId: widget.categoryId,
                            storeIdMain: widget.storeId);
                      },
                      controller: controller.searchController.value,
                      onChanged: (String value) {
                        if (value.isNotEmpty) {
                          controller.getBuyByProductDataApi(value,
                              showLoading: false,
                              categoryId: widget.categoryId,
                              storeIdMain: widget.storeId);
                        } else {
                          controller.isLoading(true);
                          controller.byProductList.clear();
                          controller.isLoading(false);
                          controller.getBuyByProductDataApi("",
                              showLoading: false,
                              storeIdMain: widget.storeId,
                              categoryId: widget.categoryId);
                          controller.update();
                        }
                      },
                    )),
                SizedBox(height: 10),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: CommonText(
                //     content: "Order before ${getAmPm()} - Today Delivery",
                //     textColor: ColorsConst.greenColor,
                //     textAlign: TextAlign.start,
                //     boldNess: FontWeight.w600,
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: CommonText(
                //     content: "Order after ${getAmPm()} - Tomorrow Delivery",
                //     textColor: ColorsConst.greenColor,
                //     boldNess: FontWeight.w600,
                //   ),
                // ),
                // SizedBox(height: 10),
                controller.byProductList.isNotEmpty
                    ? Expanded(
                        child: GetBuilder(
                          builder: (BuyController controller) {
                            return ListView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: controller.byProductList.length,
                              padding: EdgeInsets.only(bottom: height * 0.1),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                SearchProducts searchProduct =
                                    controller.byProductList[index];

                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => ProductDetailsScreen(
                                        productId: searchProduct.skuId ?? '',
                                        storeId: searchProduct.storeId ?? '',
                                        index: index,
                                        schemeId: searchProduct.schemeId,
                                        schemeAvailable:
                                            searchProduct.schemeAvailable,
                                        schemeName: searchProduct.schemeName,
                                        maxOrderQuantity:
                                            searchProduct.maxOrderQuantity ?? 0,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    decoration: BoxDecoration(
                                      color: ColorsConst.appWhite,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                                  searchProduct.productName ==
                                                          null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: CommonText(
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            content:
                                                                "${searchProduct.productName ?? ''}",
                                                            boldNess:
                                                                FontWeight.w600,
                                                            textColor:
                                                                ColorsConst
                                                                    .textColor,
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Text(searchProduct
                                                                  .productName!)
                                                              .boldSubString(
                                                            controller
                                                                .searchController
                                                                .value
                                                                .text,
                                                          ),
                                                        ),
                                                  CommonText(
                                                      content:
                                                          '${searchProduct.manufacturer == null || searchProduct.manufacturer == "NA" ? '' : searchProduct.manufacturer}',
                                                      textSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textColor: ColorsConst
                                                          .notificationTextColor,
                                                      boldNess:
                                                          FontWeight.w500),
                                                  CommonText(
                                                      content:
                                                          '${searchProduct.specs == null || searchProduct.specs == "NA" ? '' : searchProduct.specs}',
                                                      textSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      textColor: ColorsConst
                                                          .notificationTextColor,
                                                      boldNess:
                                                          FontWeight.w500),
                                                  if (gmcController
                                                      .showQuantity)
                                                    Row(
                                                      children: [
                                                        CommonText(
                                                          content:
                                                              "Quantity : ",
                                                          textSize: 14,
                                                          boldNess:
                                                              FontWeight.bold,
                                                          textColor:
                                                              Colors.black,
                                                        ),
                                                        CommonText(
                                                          content:
                                                              "${searchProduct.quantityAvailable != null ? searchProduct.quantityAvailable!.round() : ''}",
                                                          textSize: 14,
                                                          boldNess:
                                                              FontWeight.bold,
                                                          textColor: ColorsConst
                                                              .primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            // if (searchProduct.discount != null &&
                                            //     searchProduct.discount != 0)
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //     color: Colors.grey[300],
                                            //     borderRadius: BorderRadius.only(
                                            //         bottomLeft:
                                            //             Radius.circular(8),
                                            //         topRight:
                                            //             Radius.circular(10)),
                                            //   ),
                                            //   padding: EdgeInsets.only(
                                            //       left: 10, right: 10),
                                            //   child: Row(
                                            //     children: [
                                            //       Lottie.asset(
                                            //           'assets/icons/offertag.json',
                                            //           fit: BoxFit.cover,
                                            //           height: 20,
                                            //           package: 'store_app_b2b'),
                                            //       SizedBox(
                                            //         width: 5,
                                            //       ),
                                            //       CommonText(
                                            //         content:
                                            //             "${searchProduct.discount}% ",
                                            //         textColor: Colors.black,
                                            //         boldNess: FontWeight.w500,
                                            //       ),
                                            //       CommonText(
                                            //         content: "on PTR",
                                            //         textColor: Colors.black,
                                            //         boldNess: FontWeight.w500,
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),

                                            // if (searchProduct.discount != null &&
                                            //     searchProduct.discount != 0)
                                            //   Stack(
                                            //     alignment: Alignment.center,
                                            //     children: [
                                            //       Container(
                                            //         margin: EdgeInsets.fromLTRB(
                                            //             8, 2, 8, 8),
                                            //         // color: Colors.red,
                                            //         child: Image.asset(
                                            //           'assets/icons/offer_tag.png',
                                            //           package: 'store_app_b2b',
                                            //           // fit: BoxFit.cover,
                                            //           height: 64,
                                            //           width: 34,
                                            //         ),
                                            //       ),
                                            //       Positioned(
                                            //           bottom: 14,
                                            //           child: CommonText(
                                            //             content:
                                            //                 "${searchProduct.discount}${searchProduct.discountType == "%" ? "%" : "₹"} on\nPTR",
                                            //             // content: "140% on\nPTR",
                                            //             textSize: searchProduct
                                            //                         .discount! >
                                            //                     99
                                            //                 ? 6
                                            //                 : searchProduct
                                            //                             .discount! >
                                            //                         9
                                            //                     ? 7
                                            //                     : 7,
                                            //             textAlign:
                                            //                 TextAlign.center,
                                            //             boldNess: FontWeight.bold,
                                            //           )),
                                            //     ],
                                            //   )

                                            // Expanded(
                                            //   child: CommonText(
                                            //     maxLines: 2,
                                            //     overflow: TextOverflow.ellipsis,
                                            //     content:
                                            //         "${searchProduct.productName ?? ''}",
                                            //     boldNess: FontWeight.w600,
                                            //     textColor: ColorsConst.textColor,
                                            //   ),
                                            //   // child: buildRichText(
                                            //   //     searchProduct.productName!,
                                            //   //     controller.searchController
                                            //   //         .value.text),
                                            // ),
                                            // buildRichText(
                                            //     searchProduct.productName!,
                                            //     controller
                                            //         .searchController.value.text),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     controller
                                            //         .getFavoriteNameDataApi()
                                            //         .then((value) {
                                            //       if (value != null) {
                                            //         Get.dialog(favouriteDialog(
                                            //             width,
                                            //             height,
                                            //             searchProduct));
                                            //       }
                                            //     });
                                            //   },
                                            //   child: SvgPicture.asset(
                                            //       'assets/icons/favourite.svg',
                                            //       fit: BoxFit.cover,
                                            //       package: 'store_app_b2b'),
                                            // ),
                                          ],
                                        ),

                                        // CommonText(
                                        //     content:
                                        //         '${searchProduct.manufacturer == null || searchProduct.manufacturer == "NA" ? '' : searchProduct.manufacturer}',
                                        //     textSize: 12,
                                        //     overflow: TextOverflow.ellipsis,
                                        //     textColor:
                                        //         ColorsConst.notificationTextColor,
                                        //     boldNess: FontWeight.w500),
                                        // CommonText(
                                        //     content:
                                        //         '${searchProduct.specs == null || searchProduct.specs == "NA" ? '' : searchProduct.specs}',
                                        //     textSize: 12,
                                        //     overflow: TextOverflow.ellipsis,
                                        //     maxLines: 1,
                                        //     textColor:
                                        //         ColorsConst.notificationTextColor,
                                        //     boldNess: FontWeight.w500),
                                        // if (searchSupplier.schemeId != null &&
                                        //   searchSupplier.schemeId!.isNotEmpty)
                                        // widget.controller.freeQTYList[index]
                                        //             .value >
                                        //         0
                                        //     ?
                                        // if (searchProduct.schemeId != null &&
                                        //     searchProduct.schemeId!.isNotEmpty)
                                        //   controller.freeQTYList[index].value > 0
                                        //       ? Row(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.end,
                                        //           children: [
                                        //             Obx(
                                        //               () => CommonText(
                                        //                 content:
                                        //                     'Qty: ${(controller.finalQTYList[index].value).toStringAsFixed(0)}',
                                        //                 boldNess: FontWeight.w500,
                                        //                 textColor: ColorsConst
                                        //                     .greyTextColor,
                                        //                 textSize: width * 0.036,
                                        //               ),
                                        //             ),
                                        //             Obx(
                                        //               () => CommonText(
                                        //                 content:
                                        //                     '(${((controller.buyQTYList[index].value)).toStringAsFixed(2)} + ',
                                        //                 boldNess: FontWeight.w500,
                                        //                 textColor: ColorsConst
                                        //                     .greyTextColor,
                                        //                 textSize: width * 0.036,
                                        //               ),
                                        //             ),
                                        //             Obx(
                                        //               () => CommonText(
                                        //                 content:
                                        //                     '${((controller.freeQTYList[index].value)).toStringAsFixed(2)})',
                                        //                 boldNess: FontWeight.w500,
                                        //                 textColor: ColorsConst
                                        //                     .greyTextColor,
                                        //                 textSize: width * 0.036,
                                        //               ),
                                        //             )
                                        //           ],
                                        //         )
                                        //       : const SizedBox(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (searchProduct.schemeId !=
                                                    null &&
                                                searchProduct
                                                    .schemeId!.isNotEmpty)
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/offer.png",
                                                    scale: 3.5,
                                                    package: 'store_app_b2b',
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                  CommonText(
                                                    content:
                                                        "${searchProduct.schemeName ?? ''}",
                                                    textSize: 12,
                                                    boldNess: FontWeight.w600,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                ],
                                              ),
                                            if (searchProduct.schemeId !=
                                                    null &&
                                                searchProduct
                                                    .schemeId!.isNotEmpty)
                                              controller.freeQTYList[index]
                                                          .value >
                                                      0
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10, bottom: 4),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Obx(
                                                            () => CommonText(
                                                              content:
                                                                  'Qty: ${(controller.finalQTYList[index].value).toStringAsFixed(0)}',
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: ColorsConst
                                                                  .greyTextColor,
                                                              textSize:
                                                                  width * 0.036,
                                                            ),
                                                          ),
                                                          Obx(
                                                            () => CommonText(
                                                              content:
                                                                  '(${((controller.buyQTYList[index].value)).toStringAsFixed(2)} + ',
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: ColorsConst
                                                                  .greyTextColor,
                                                              textSize:
                                                                  width * 0.036,
                                                            ),
                                                          ),
                                                          Obx(
                                                            () => CommonText(
                                                              content:
                                                                  '${((controller.freeQTYList[index].value)).toStringAsFixed(2)})',
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: ColorsConst
                                                                  .greyTextColor,
                                                              textSize:
                                                                  width * 0.036,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                          ],
                                        ),

                                        // if (searchProduct.schemeId != null &&
                                        //     searchProduct.schemeId!.isNotEmpty)
                                        //   Row(
                                        //     children: [
                                        //       Image.asset(
                                        //         "assets/icons/offer.png",
                                        //         scale: 3.5,
                                        //         package: 'store_app_b2b',
                                        //       ),
                                        //       SizedBox(width: width * 0.01),
                                        //       CommonText(
                                        //         content:
                                        //             "${searchProduct.schemeName ?? ''}",
                                        //         textSize: 12,
                                        //         boldNess: FontWeight.w600,
                                        //         textColor: ColorsConst.textColor,
                                        //         maxLines: 1,
                                        //         overflow: TextOverflow.ellipsis,
                                        //       ),
                                        //       SizedBox(width: width * 0.01),
                                        //     ],
                                        //   ),
                                        if (searchProduct.schemeId != null &&
                                            searchProduct.schemeId!.isNotEmpty)
                                          SizedBox(
                                            height: 5,
                                          ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              content: "MRP",
                                                              textColor: ColorsConst
                                                                  .notificationTextColor,
                                                              textSize: 14,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015),
                                                            CommonText(
                                                              content:
                                                                  "₹ ${(searchProduct.mrp ?? 0).toStringAsFixed(2)}",
                                                              textSize: 14,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor:
                                                                  ColorsConst
                                                                      .textColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonText(
                                                              content: "PTR",
                                                              textColor: ColorsConst
                                                                  .notificationTextColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w600,
                                                              textSize: 14,
                                                            ),
                                                            CommonText(
                                                              content:
                                                                  "₹ ${(searchProduct.price ?? 0).toStringAsFixed(2)}",
                                                              textSize: 14,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: ColorsConst
                                                                  .notificationTextColor,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  // Row(
                                                  //   children: [
                                                  //     CommonText(
                                                  //       content: "MRP",
                                                  //       textColor: ColorsConst
                                                  //           .notificationTextColor,
                                                  //       textSize: 14,
                                                  //       boldNess: FontWeight.w600,
                                                  //     ),
                                                  //     SizedBox(
                                                  //         width: width * 0.015),
                                                  //     CommonText(
                                                  //       content:
                                                  //           "₹${(searchProduct.mrp ?? 0).toStringAsFixed(2)}",
                                                  //       textSize: 14,
                                                  //       boldNess: FontWeight.w500,
                                                  //       textColor:
                                                  //           ColorsConst.textColor,
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   children: [
                                                  //     CommonText(
                                                  //       content: "PTR",
                                                  //       textColor: ColorsConst
                                                  //           .notificationTextColor,
                                                  //       boldNess: FontWeight.w600,
                                                  //       textSize: 14,
                                                  //     ),
                                                  //     SizedBox(
                                                  //         width: width * 0.015),
                                                  //     CommonText(
                                                  //       content:
                                                  //           "₹${(searchProduct.price ?? 0).toStringAsFixed(2)}",
                                                  //       textSize: 14,
                                                  //       boldNess: FontWeight.w500,
                                                  //       textColor: ColorsConst
                                                  //           .notificationTextColor,
                                                  //     ),
                                                  //   ],
                                                  // ),

                                                  // searchProduct.stockAvailable !=
                                                  //         "3"
                                                  // ?
                                                  // Row(
                                                  //   children: [
                                                  //     CommonText(
                                                  //       content: "*",
                                                  //       textSize: 12,
                                                  //       boldNess:
                                                  //           FontWeight.w600,
                                                  //       textColor: searchProduct
                                                  //                   .stockAvailable ==
                                                  //               null
                                                  //           ? Colors.green
                                                  //           : getStockStatusStarColor(
                                                  //               searchProduct
                                                  //                   .stockAvailable!),
                                                  //     ),
                                                  //     CommonText(
                                                  //       content:
                                                  //           "${getStockStatusText(searchProduct.stockAvailable ?? "")}",
                                                  //       textSize: 12,
                                                  //       boldNess:
                                                  //           FontWeight.w600,
                                                  //       textColor: searchProduct
                                                  //                   .stockAvailable ==
                                                  //               null
                                                  //           ? Colors.green
                                                  //           : getStockStatusTextColor(
                                                  //               searchProduct
                                                  //                   .stockAvailable!),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  CommonText(
                                                    content:
                                                        "${getStockStatusText(searchProduct.stockAvailable ?? "")}",
                                                    textSize: 12,
                                                    boldNess: FontWeight.w600,
                                                    textColor: searchProduct
                                                                .stockAvailable ==
                                                            null
                                                        ? Colors.green
                                                        : getStockStatusTextColor(
                                                            searchProduct
                                                                .stockAvailable!),
                                                  ),
                                                  // : SizedBox(),
                                                  // Row(
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.start,
                                                  //   children: [
                                                  //     if (searchProduct
                                                  //                 .schemeId !=
                                                  //             null &&
                                                  //         searchProduct.schemeId!
                                                  //             .isNotEmpty)
                                                  //       Row(
                                                  //   children: [
                                                  //     Image.asset(
                                                  //       "assets/icons/offer.png",
                                                  //       scale: 4,
                                                  //       package:
                                                  //           'store_app_b2b',
                                                  //     ),
                                                  //     SizedBox(
                                                  //         width:
                                                  //             width * 0.01),
                                                  //     CommonText(
                                                  //       content:
                                                  //           "${searchProduct.schemeName ?? ''}",
                                                  //       textSize: 12,
                                                  //       boldNess:
                                                  //           FontWeight.w600,
                                                  //       textColor:
                                                  //           ColorsConst
                                                  //               .textColor,
                                                  //       maxLines: 1,
                                                  //       overflow:
                                                  //           TextOverflow
                                                  //               .ellipsis,
                                                  //     ),
                                                  //     SizedBox(
                                                  //         width:
                                                  //             width * 0.01),
                                                  //   ],
                                                  // ),
                                                  // Expanded(
                                                  //   child: Row(
                                                  //     crossAxisAlignment:
                                                  //         CrossAxisAlignment
                                                  //             .start,
                                                  //     children: [
                                                  //       CommonText(
                                                  //         content: "*",
                                                  //         textSize: 12,
                                                  //         boldNess:
                                                  //             FontWeight.w600,
                                                  //         textColor: searchProduct
                                                  //                     .stockAvailable ==
                                                  //                 null
                                                  //             ? Colors.green
                                                  //             : getStockStatusStarColor(
                                                  //                 searchProduct
                                                  //                     .stockAvailable!),
                                                  //       ),
                                                  //       Expanded(
                                                  //         child: CommonText(
                                                  //           content:
                                                  //               "${getStockStatusText(searchProduct.stockAvailable ?? "")}",
                                                  //           // content:
                                                  //           // "Tomorrow delivery",
                                                  //           textSize: 12,
                                                  //           boldNess:
                                                  //               FontWeight
                                                  //                   .w600,
                                                  //           textColor: searchProduct
                                                  //                       .stockAvailable ==
                                                  //                   null
                                                  //               ? Colors.green
                                                  //               : getStockStatusTextColor(
                                                  //                   searchProduct
                                                  //                       .stockAvailable!),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  //   ],
                                                  // ),

                                                  SizedBox(
                                                    height: searchProduct
                                                                    .discount !=
                                                                null &&
                                                            searchProduct
                                                                    .discount !=
                                                                0
                                                        ? 0
                                                        : 5,
                                                  ),

                                                  // Row(
                                                  //   children: [
                                                  //     Image.asset(
                                                  //       "assets/icons/net_rupee.png",
                                                  //       scale: 3.5,
                                                  //       package: 'store_app_b2b',
                                                  //     ),
                                                  //     SizedBox(
                                                  //       width: 5,
                                                  //     ),
                                                  //     CommonText(
                                                  //       content:
                                                  //           "NET  ₹${(searchProduct.discount == 0 || searchProduct.discount == null ? (searchProduct.price ?? 0) : searchProduct.discountType == "%" ? (searchProduct.price ?? 0) - ((searchProduct.price ?? 0) * (searchProduct.discount! / 100)) : ((searchProduct.price ?? 0) - searchProduct.discount!)).toStringAsFixed(2)}",
                                                  //       textSize: 16,
                                                  //       boldNess: FontWeight.w600,
                                                  //       textColor: ColorsConst
                                                  //           .primaryColor,
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  if (searchProduct.discount !=
                                                          null &&
                                                      searchProduct.discount !=
                                                          0)
                                                    CommonText(
                                                      content:
                                                          "Discount ${searchProduct.discount}${searchProduct.discountType == "%" ? "%" : "₹"} on PTR",
                                                      textColor: AppColors
                                                          .primaryColor,
                                                      boldNess: FontWeight.bold,
                                                      textSize: 14,
                                                    ),
                                                  if (searchProduct.discount !=
                                                          null &&
                                                      searchProduct.discount !=
                                                          0)
                                                    SizedBox(
                                                      height: 0,
                                                    ),
                                                  // Row(
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment
                                                  //           .start,
                                                  //   children: [
                                                  //     // CommonText(
                                                  //     //   content: "*",
                                                  //     //   textSize: 12,
                                                  //     //   boldNess: FontWeight.w600,
                                                  //     //   textColor: searchProduct
                                                  //     //               .stockAvailable ==
                                                  //     //           null
                                                  //     //       ? Colors.green
                                                  //     //       : getStockStatusStarColor(
                                                  //     //           searchProduct
                                                  //     //               .stockAvailable!),
                                                  //     // ),
                                                  //     Expanded(
                                                  //       child: CommonText(
                                                  //         content:
                                                  //             "${getStockStatusText(searchProduct.stockAvailable ?? "")}",
                                                  //         // content:
                                                  //         // "Tomorrow delivery",
                                                  //         textSize: 12,
                                                  //         boldNess:
                                                  //             FontWeight.w600,
                                                  //         textColor: searchProduct
                                                  //                     .stockAvailable ==
                                                  //                 null
                                                  //             ? Colors.green
                                                  //             : getStockStatusTextColor(
                                                  //                 searchProduct
                                                  //                     .stockAvailable!),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            // searchProduct.stockAvailable == "3"
                                            // ? Padding(
                                            //     padding:
                                            //         const EdgeInsets.only(
                                            //             right: 20),
                                            //     child: CommonText(
                                            //       content: "Out Of Stock",
                                            //       textSize: 12,
                                            //       boldNess: FontWeight.w600,
                                            //       textColor: searchProduct
                                            //                   .stockAvailable ==
                                            //               null
                                            //           ? Colors.green
                                            //           : getStockStatusTextColor(
                                            //               searchProduct
                                            //                   .stockAvailable!),
                                            //     ),
                                            //   )
                                            // :
                                            gmcController.popup2ndOptionNeededB2B ==
                                                        false &&
                                                    searchProduct
                                                            .stockAvailable ==
                                                        "3"
                                                ? SizedBox()
                                                : Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 3),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            height: 32,
                                                            width: 134,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        3),
                                                            decoration: BoxDecoration(
                                                                color: ColorsConst
                                                                    .appWhite,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                border: Border.all(
                                                                    color: ColorsConst
                                                                        .primaryColor)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                decreaseProductButton(
                                                                    index,
                                                                    searchProduct),
                                                                const SizedBox(
                                                                    width: 8),
                                                                addProductTextField(
                                                                    index,
                                                                    searchProduct),
                                                                const SizedBox(
                                                                    width: 8),
                                                                increaseProductButton(
                                                                    index,
                                                                    searchProduct),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          addToCartButton(index,
                                                              searchProduct)
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: (controller.searchController.value.text
                                  .trim()
                                  .isEmpty)
                              ? const Text(
                                  'Search for products',
                                  style: TextStyle(fontSize: 17),
                                )
                              : const Text(
                                  'Coming Soon',
                                  style: TextStyle(fontSize: 17),
                                ),
                        ),
                      ),
              ],
            ),
            Obx(() => controller.isAddCartLoading.value
                ? const AppLoader()
                : SizedBox()),
            if (controller.isLoading.value) const AppLoader()
          ],
        ),
      );
    });
  }

  String getStockStatusText(String stockAvailable) {
    bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
    bool isTimePassedInMain =
        isMaxTimeStopNeededInMain ? isAfterDynamicTimeSystemCheck() : false;

    if (gmcController.popup2ndOptionNeededB2B == false &&
        stockAvailable == "3") {
      return 'Not Available';
    }

    switch (stockAvailable) {
      case "1":
        return isTimePassedInMain
            ? "Available, Delivery Tomorrow"
            : "Available";
      case "2":
        return "Low Stock";
      case "3":
        return "Delivery Tomorrow";
      default:
        return "Available";
    }
  }

  Color getStockStatusTextColor(String stockAvailable) {
    bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
    bool isTimePassedInMain =
        isMaxTimeStopNeededInMain ? isAfterDynamicTimeSystemCheck() : false;

    if (gmcController.popup2ndOptionNeededB2B == false &&
        stockAvailable == "3") {
      return Colors.red;
    }

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

  Color getStockStatusStarColor(String stockAvailable) {
    bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
    bool isTimePassedInMain =
        isMaxTimeStopNeededInMain ? isAfterDynamicTimeSystemCheck() : false;
    switch (stockAvailable) {
      case "1":
        return isTimePassedInMain ? Colors.green : Colors.green;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  favouriteDialog(width, height, item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff2F394B), Color(0xff090F1A)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: CommonText(
                      content: "Favourites",
                      boldNess: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                content: "Select list to add the product",
                                boldNess: FontWeight.w400,
                                textColor: ColorsConst.textColor,
                                textSize: width * 0.03,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.favouriteNameController.value
                                      .clear();
                                  Get.dialog(favouriteNameDialog(
                                          width: width, height: height))
                                      .then((value) {
                                    setState(
                                      () {},
                                    );
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorsConst.primaryColor,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: List.generate(
                              controller.getFavoriteNameList.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  controller.favouriteSelect.value =
                                      controller.getFavoriteNameList[index];
                                  controller.update();
                                  setState(() {});
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: ColorsConst.hintColor,
                                      )),
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        content: controller
                                            .getFavoriteNameList[index],
                                        boldNess: FontWeight.w500,
                                        textColor: ColorsConst.textColor,
                                        textSize: width * 0.04,
                                      ),
                                      controller.favouriteSelect.value !=
                                              controller
                                                  .getFavoriteNameList[index]
                                          ? const SizedBox()
                                          : Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorsConst.primaryColor,
                                              ),
                                              padding: const EdgeInsets.all(1),
                                              child: const Icon(
                                                Icons.done,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: ColorsConst.redColor),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CommonText(
                                content: "Cancel",
                                textSize: width * 0.035,
                                textColor: ColorsConst.redColor,
                                boldNess: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorsConst.greenButtonColor,
                          ),
                          onPressed: () {
                            if (controller.favouriteSelect == "") {
                              CommonSnackBar.showError(
                                  "Please Select Favourite Product");
                            } else {
                              String id = "";
                              for (int i = 0;
                                  i < controller.getFavoriteNameList.length;
                                  i++) {
                                if (controller.getFavoriteNameList[i] ==
                                    controller.favouriteSelect.value) {
                                  id = i.toString();
                                }
                              }

                              Map<String, dynamic> itemMap = {
                                "productId": item.id,
                                "productName": item.productName,
                                "storeName": item.storeName,
                                "storeId": item.storeId,
                                "skuCode": item.skuCode,
                                "skuId": item.skuId,
                                "quantity": (controller.qtyAddToCartController
                                        .value.text.isEmpty)
                                    ? 0
                                    : int.parse(controller
                                        .qtyAddToCartController.value.text),
                              };
                              if (controller.userId.value.isNotEmpty) {
                                Map<String, dynamic> bodyMap = {
                                  "userId": controller.userId.value,
                                  "favName": controller.favouriteSelect.value,
                                  "favList": [
                                    {
                                      "items": [itemMap]
                                    }
                                  ],
                                  'createdDt': DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                };
                                logs('itemMap ---> $itemMap');
                                controller
                                    .getAddFavoriteApi(bodyMap)
                                    .then((value) {
                                  if (value != null) {
                                    Get.back();
                                    controller.favouriteSelect.value = "";
                                  }
                                });
                              } else if (!Get.isDialogOpen!) {
                                Get.dialog(const LoginDialog());
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: controller.isSaveFavLoading.value
                                ? const Center(
                                    child: CupertinoActivityIndicator(
                                        animating: true,
                                        radius: 10,
                                        color: Colors.black),
                                  )
                                : CommonText(
                                    content: "Save",
                                    textSize: width * 0.035,
                                    textColor: Colors.white,
                                    boldNess: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addProductTextField(int index, SearchProducts searchProduct) {
    return Obx(() => SizedBox(
          width: 60,
          child: TextField(
            maxLength: 4,
            controller: controller.qtyTextControllerList[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorsConst.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.qtyList[index].value = int.parse(value);
              } else {
                controller.qtyTextControllerList[index].clear();
                FocusScope.of(context).unfocus();
                controller.qtyList[index].value = 0;
              }
              if (searchProduct.schemeAvailable) {
                controller.getSchemeQty(
                    quantity: controller.qtyList[index].value,
                    index: index,
                    schemeId: searchProduct.schemeId ?? '',
                    schemeName: searchProduct.schemeName ?? '',
                    addBuyQty: controller.qtyList[index].value,
                    addFreeQty: 0,
                    finalQty: controller.finalQTYList[index].value);
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                controller.qtyList[index].value = int.parse(value);
              } else {
                controller.qtyList[index].value = 0;
              }
              if (searchProduct.schemeAvailable) {
                controller.getSchemeQty(
                    quantity: controller.qtyList[index].value,
                    index: index,
                    schemeId: searchProduct.schemeId ?? '',
                    schemeName: searchProduct.schemeName ?? '',
                    addBuyQty: controller.qtyList[index].value,
                    addFreeQty: 0,
                    finalQty: controller.finalQTYList[index].value);
              }
            },
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                counterText: "",
                hintText: 'Add',
                hintStyle: TextStyle(
                  color: ColorsConst.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.only(top: 5, bottom: 0),
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ));
  }

  increaseProductButton(int index, SearchProducts searchProduct) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (controller.qtyList[index].value <= 1000) {
          controller.qtyList[index].value++;
          logs('qty ==> ${controller.qtyList[index].value}');
          controller.qtyTextControllerList[index].text =
              '${controller.qtyList[index].value}';
          if (searchProduct.schemeAvailable) {
            controller.getSchemeQty(
                quantity: controller.qtyList[index].value,
                index: index,
                schemeId: searchProduct.schemeId ?? '',
                schemeName: searchProduct.schemeName ?? '',
                addBuyQty: controller.qtyList[index].value,
                addFreeQty: 0,
                finalQty: controller.finalQTYList[index].value);
          }
        }
      },
      child: Icon(Icons.add, color: ColorsConst.primaryColor, size: 20),
    );
  }

  decreaseProductButton(int index, SearchProducts searchProduct) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (controller.qtyList[index].value > 0) {
          controller.qtyList[index].value--;
          if (controller.qtyList[index].value == 0) {
            controller.qtyTextControllerList[index].clear();
          } else {
            controller.qtyTextControllerList[index].text =
                '${controller.qtyList[index]}';
          }
          if (searchProduct.schemeAvailable) {
            controller.getSchemeQty(
                quantity: controller.qtyList[index].value,
                index: index,
                schemeId: searchProduct.schemeId ?? '',
                schemeName: searchProduct.schemeName ?? '',
                addBuyQty: controller.qtyList[index].value,
                addFreeQty: 0,
                finalQty: controller.finalQTYList[index].value);
          }
        }
      },
      child: Icon(Icons.remove, color: ColorsConst.primaryColor, size: 20),
    );
  }

  addToCartButton(int index, SearchProducts searchProduct,
      {bool isFromPopup = false}) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        String userId =
            await SharPreferences.getString(SharPreferences.loginId) ?? '';

        if (userId.isEmpty) {
          // CommonSnackBar.showError("Please login to add the products to cart");
          // return;

          Get.dialog(const LoginDialog());
          return;
        }

        print("printing isdailog open ---> ${Get.isDialogOpen}");
        print("printing index of add to cart -> ${index}");
        print("printing searchProduct -> ${searchProduct.productName}");
        FocusManager.instance.primaryFocus!.unfocus();
        if (controller.qtyList[index].value == 0) {
          CommonSnackBar.showToast('Please Enter Qty', context,
              showTickMark: false);
        } else {
          if (!gmcController.popup2ndOptionNeededB2B &&
              searchProduct.stockAvailable == "0") {
            CommonSnackBar.showError("Product not available");
            return;
          }

          bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
          bool isTimePassedInMain =
              isMaxTimeStopNeededInMain ? await isAfterDynamicTime() : false;
          var body = [
            {
              "productId": searchProduct.id,
              "productName": searchProduct.productName,
              "mesuare": "",
              "schemeName": searchProduct.schemeName,
              "schemeId": searchProduct.schemeId,
              "manufacturer": searchProduct.manufacturer,
              "quantity": controller.qtyList[index].value,
              "finalQuantity": controller.finalQTYList[index].value,
              "freeQuantity": controller.freeQTYList[index].value,
              "buyQuantity": (searchProduct.schemeAvailable)
                  ? controller.buyQTYList[index].value
                  : controller.qtyList[index].value,
              "price": searchProduct.price,
              "mrp": searchProduct.mrp?.toStringAsFixed(2) ?? searchProduct.mrp,
              "skuId": searchProduct.skuId,
              "productUrl": "",
              "storeName": searchProduct.storeName,
              "tabletsPerStrip": "",
              "categoryName": "",
              "prescriptionIsRequired": true,
              "checkOutStatus": "N",
              "priceWithGst": searchProduct.priceWithGst,
              "timePassed": isTimePassedInMain ? "Y" : "N",
              //to open popups enable this code - starts here
              // "laterDelivery": isTimePassedInMain ? "Y" : "N",
              //to open popups enable this code - ends here
            }
          ];
          logs('Body --> $body');

          final cartController = Get.put(CartController());

          if (cartController.cartId != "") {
            print("printing in if");
            controller
                .checkProductAvailableInCart(
                    cartId: cartController.cartId,
                    skuId: searchProduct.skuId ?? "",
                    storeId: searchProduct.storeId ?? "")
                .then((value) async {
              if (value != null) {
                if (value["status"]) {
                  CommonSnackBar.showError(value["message"]);
                } else {
                  print(
                      "checking maxOrderQuantity -> ${searchProduct.maxOrderQuantity} , final ${controller.finalQTYList[index].value}");
                  // Max Order Quantity Check Starts here
                  if (gmcController.maxOrderQuantityCheckProductLevel.value) {
                    if (searchProduct.schemeAvailable) {
                      if (searchProduct.maxOrderQuantity != null &&
                          searchProduct.maxOrderQuantity != 0 &&
                          controller.finalQTYList[index].value >
                              searchProduct.maxOrderQuantity!) {
                        CommonSnackBar.showError(
                            "Max order quantity for this product is ${searchProduct.maxOrderQuantity!.toStringAsFixed(0)}");
                        return;
                      }
                    } else {
                      if (searchProduct.maxOrderQuantity != null &&
                          searchProduct.maxOrderQuantity != 0 &&
                          controller.qtyList[index].value >
                              searchProduct.maxOrderQuantity!) {
                        CommonSnackBar.showError(
                            "Max order quantity for this product is ${searchProduct.maxOrderQuantity!.toStringAsFixed(0)}");
                        return;
                      }
                    }
                  }
                  // Max Order Quantity Check Ends here

                  //to open popups enable this code - starts here
                  if (searchProduct.stockAvailable == "1" ||
                      searchProduct.stockAvailable == "2") {
                    dynamic data =
                        await controller.checkProductQuantityAvailable(
                            skuId: searchProduct.skuId ?? "",
                            storeId: searchProduct.storeId);

                    num currentQuantity = (searchProduct.schemeAvailable)
                        ? controller.finalQTYList[index].value
                        : controller.qtyList[index].value;

                    if (data == null || data["quantity"] == null) {
                      CommonSnackBar.showError("Something went wrong");
                      return;
                    }

                    if (currentQuantity > data["quantity"]) {
                      print(
                          "avail qauntity checkProductQuantityAvailableData --> ${data["quantity"]}");
                      // if (searchProduct.schemeAvailable) {
                      //   CommonSnackBar.showError(
                      //       "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                      // } else {
                      //   CommonSnackBar.showError(
                      //       "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                      // }

                      //scheme calculation starts here

                      num totalQuantityToBeAllowed = 0;
                      num maxFreeQuantityToBeAllowed = 0;
                      num maxQuantityToBeAllowed = 0;
                      bool isAtleastOneFullSchemeAvailable = false;

                      if (searchProduct.schemeAvailable) {
                        print(
                            "scheme calculation current quantity -> $currentQuantity");

                        print(
                            "scheme calculation scheme -> ${searchProduct.schemeName}");

                        String input = searchProduct.schemeName!;
                        List<String> parts = input.split(" + ");
                        int buyScheme = 0;
                        int freeScheme = 0;

                        if (parts.length == 2) {
                          buyScheme = int.parse(parts[0]);
                          freeScheme = int.parse(parts[1]);
                        } else {
                          print("scheme calculation Invalid input format");
                        }
                        print("scheme calculation scheme input -> ${parts}");
                        print(
                            "scheme calculation scheme buyScheme -> ${buyScheme}");
                        print(
                            "scheme calculation scheme freeScheme-> ${freeScheme}");

                        num totalScheme = buyScheme + freeScheme;
                        print("scheme calculation total scheme -> ${parts}");

                        print(
                            "scheme calculation available quantity -> ${data["quantity"]}");

                        num availableFullSchemeAdjustment =
                            data["quantity"] / totalScheme;

                        if (availableFullSchemeAdjustment < 1) {
                          isAtleastOneFullSchemeAvailable = false;
                        } else {
                          isAtleastOneFullSchemeAvailable = true;
                        }

                        print(
                            "scheme calculation availableFullSchemeAdjustment -> ${availableFullSchemeAdjustment}");

                        maxQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                            ? availableFullSchemeAdjustment.floor() * buyScheme
                            : 0;

                        maxFreeQuantityToBeAllowed =
                            isAtleastOneFullSchemeAvailable
                                ? availableFullSchemeAdjustment.floor() *
                                    freeScheme
                                : 0;

                        totalQuantityToBeAllowed =
                            maxFreeQuantityToBeAllowed + maxQuantityToBeAllowed;

                        num quantityRemainingAfterFullSchemes =
                            data["quantity"] - totalQuantityToBeAllowed;

                        print(
                            "scheme calculation maxQuantityToBeAllowed -> ${maxQuantityToBeAllowed}");

                        print(
                            "scheme calculation maxFreeQuantityToBeAllowed -> ${maxFreeQuantityToBeAllowed}");

                        print(
                            "scheme calculation totalQuantityToBeAllowed -> ${totalQuantityToBeAllowed}");

                        print(
                            "scheme calculation quantityRemainingAfterFullSchemes -> ${quantityRemainingAfterFullSchemes}");

                        print(
                            "scheme calculation --- full scheme calculation ends here ---");

                        num calculatedHalfScheme = (buyScheme + freeScheme) / 2;

                        num convertedCalculatedHalfScheme =
                            calculatedHalfScheme.ceil();

                        bool isHalfSchemeApplicable =
                            quantityRemainingAfterFullSchemes >=
                                convertedCalculatedHalfScheme;

                        if (isAtleastOneFullSchemeAvailable == false &&
                            isHalfSchemeApplicable) {
                          isAtleastOneFullSchemeAvailable = true;
                        }

                        if (isHalfSchemeApplicable) {
                          totalQuantityToBeAllowed = totalQuantityToBeAllowed +
                              convertedCalculatedHalfScheme;

                          maxQuantityToBeAllowed = maxQuantityToBeAllowed +
                              (calculatedHalfScheme <
                                      convertedCalculatedHalfScheme
                                  ? (buyScheme / 2) + 0.5
                                  : buyScheme / 2);

                          maxFreeQuantityToBeAllowed =
                              maxFreeQuantityToBeAllowed + (freeScheme / 2);
                        }

                        print(
                            "scheme calculation isHalfSchemeApplicable -> ${isHalfSchemeApplicable}");

                        print(
                            "scheme calculation calculatedHalfScheme -> ${calculatedHalfScheme}");

                        print(
                            "scheme calculation convertedCalculatedHalfScheme -> ${convertedCalculatedHalfScheme}");
                      }

                      //scheme calculation ends here

                      if (isFromPopup) {
                        if (searchProduct.schemeAvailable) {
                          CommonSnackBar.showError(
                              "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                        }

                        return;
                        //  else {
                        //   CommonSnackBar.showError(
                        //       "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                        // }
                      }
                      if (Get.isBottomSheetOpen!) {
                        return;
                      }

                      bool isMaxTimeStopNeeded =
                          API.needMaxTimeStopFunctionality;
                      bool isTimePassed = isMaxTimeStopNeeded
                          ? await isAfterDynamicTime()
                          : false;

                      print("printing is time passed or not --> $isTimePassed");

                      Get.dialog(
                        barrierDismissible: false,
                        WillPopScope(
                          onWillPop: () async {
                            controller.partialOrLaterDelivery = "";
                            controller.update();

                            return true;
                          },
                          child: Dialog(
                            alignment: Alignment.bottomCenter,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            insetPadding: EdgeInsets.all(0),
                            backgroundColor: AppColors.appWhite,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: GetBuilder<BuyController>(
                                builder: (controller) {
                                  if (searchProduct.schemeAvailable &&
                                      !isAtleastOneFullSchemeAvailable &&
                                      !gmcController.popup2ndOptionNeededB2B) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CommonText(
                                            content: gmcController
                                                .atleastOneSchemeNotApplicableText,
                                            textColor: AppColors.appblack,
                                            boldNess: FontWeight.w500,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: CommonText(
                                            // content:
                                            //     "The requested quantity exceeds available stock. This product will be delivered tomorrow. Are you sure you want to proceed?",
                                            // textSize: width * 0.04,
                                            content: searchProduct
                                                    .schemeAvailable
                                                ? isAtleastOneFullSchemeAvailable
                                                    // ? "Maximum quantity you can get today is ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed)"
                                                    ? "Choose Delivery Option"
                                                    : ""
                                                //? "The requested quantity exceeds available stock (${data["quantity"].round()}). Please adjust the quantity within the available limit to get delivery today or you can choose full delivery tomorrow option"
                                                // : "The requested quantity exceeds available stock. Please choose any one of the below options to proceed.",
                                                : "Choose delivery option",
                                            textColor: AppColors.appblack,
                                            boldNess: FontWeight.w500,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        searchProduct.schemeAvailable
                                            ? isAtleastOneFullSchemeAvailable
                                                ? SizedBox(
                                                    height: height * 0.02)
                                                : SizedBox()
                                            : (searchProduct.schemeAvailable
                                                    ? totalQuantityToBeAllowed <
                                                        1
                                                    : data["quantity"] < 1)
                                                ? SizedBox()
                                                : SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                        // if (!isTimePassed)
                                        searchProduct.schemeAvailable &&
                                                !isAtleastOneFullSchemeAvailable
                                            ?
                                            // !gmcController
                                            //         .popup2ndOptionNeededB2B
                                            //     ? GestureDetector(
                                            //         onTap: () {
                                            //           // if (searchProduct
                                            //           //     .schemeAvailable) {
                                            //           //   controller
                                            //           //           .partialOrLaterDelivery =
                                            //           //       "N";
                                            //           // } else {
                                            //           //   controller
                                            //           //           .partialOrLaterDelivery =
                                            //           //       "P";
                                            //           // }
                                            //           controller
                                            //                   .partialOrLaterDelivery =
                                            //               "N";

                                            //           controller.update();
                                            //         },
                                            //         child: Row(
                                            //           children: [
                                            //             Container(
                                            //               height: 20,
                                            //               width: 20,
                                            //               padding:
                                            //                   EdgeInsets.all(2),
                                            //               decoration:
                                            //                   BoxDecoration(
                                            //                       shape: BoxShape
                                            //                           .circle,
                                            //                       border: Border
                                            //                           .all(
                                            //                         color: AppColors
                                            //                             .appblack,
                                            //                       )),
                                            //               child: Container(
                                            //                 height: 15,
                                            //                 width: 15,
                                            //                 padding:
                                            //                     EdgeInsets.all(
                                            //                         10),
                                            //                 decoration:
                                            //                     BoxDecoration(
                                            //                   color: controller
                                            //                                   .partialOrLaterDelivery ==
                                            //                               "P" ||
                                            //                           controller
                                            //                                   .partialOrLaterDelivery ==
                                            //                               "N"
                                            //                       ? AppColors
                                            //                           .appblack
                                            //                       : AppColors
                                            //                           .appWhite,
                                            //                   shape: BoxShape
                                            //                       .circle,
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //             SizedBox(
                                            //               width: 10,
                                            //             ),
                                            //             Expanded(
                                            //               child: CommonText(
                                            //                 content: searchProduct
                                            //                         .schemeAvailable
                                            //                     ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                            //                     // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                            //                     : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                            //                 textSize:
                                            //                     width * 0.035,
                                            //                 textColor: AppColors
                                            //                     .appblack,
                                            //                 boldNess:
                                            //                     FontWeight.w500,
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       )
                                            SizedBox()
                                            : (searchProduct.schemeAvailable
                                                    ? totalQuantityToBeAllowed <
                                                        1
                                                    : data["quantity"] < 1)
                                                ? SizedBox()
                                                : GestureDetector(
                                                    onTap: () {
                                                      // if (searchProduct
                                                      //     .schemeAvailable) {
                                                      //   controller
                                                      //           .partialOrLaterDelivery =
                                                      //       "N";
                                                      // } else {
                                                      //   controller
                                                      //           .partialOrLaterDelivery =
                                                      //       "P";
                                                      // }
                                                      controller
                                                              .partialOrLaterDelivery =
                                                          "N";

                                                      controller.update();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .appblack,
                                                                  )),
                                                          child: Container(
                                                            height: 15,
                                                            width: 15,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: controller
                                                                              .partialOrLaterDelivery ==
                                                                          "P" ||
                                                                      controller
                                                                              .partialOrLaterDelivery ==
                                                                          "N"
                                                                  ? AppColors
                                                                      .appblack
                                                                  : AppColors
                                                                      .appWhite,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: CommonText(
                                                            content: searchProduct
                                                                    .schemeAvailable
                                                                ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                                                // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                                                : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                                            textSize:
                                                                width * 0.035,
                                                            textColor: AppColors
                                                                .appblack,
                                                            boldNess:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        if (gmcController
                                            .popup2ndOptionNeededB2B)
                                          searchProduct.schemeAvailable &&
                                                  !isAtleastOneFullSchemeAvailable
                                              ? SizedBox()
                                              : SizedBox(
                                                  height: 20,
                                                ),
                                        if (gmcController
                                            .popup2ndOptionNeededB2B)
                                          GestureDetector(
                                            onTap: () {
                                              controller
                                                  .partialOrLaterDelivery = "Y";
                                              controller.update();
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            AppColors.appblack,
                                                      )),
                                                  child: Container(
                                                    height: 15,
                                                    width: 15,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      // color: AppColors.appblack,
                                                      color: controller
                                                                  .partialOrLaterDelivery ==
                                                              "Y"
                                                          ? AppColors.appblack
                                                          : AppColors.appWhite,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: CommonText(
                                                    content: searchProduct
                                                            .schemeAvailable
                                                        ? '${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${(controller.finalQTYList[index].value).toStringAsFixed(0)} (${((controller.buyQTYList[index].value)).toStringAsFixed(2)} + ${((controller.freeQTYList[index].value)).toStringAsFixed(2)}) Quantity'
                                                        : "${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${controller.qtyTextControllerList[index].text} Quantity",
                                                    textSize: width * 0.035,
                                                    textColor:
                                                        AppColors.appblack,
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    side: const BorderSide(
                                                        color: AppColors
                                                            .appblack)),
                                                onPressed: () {
                                                  controller
                                                      .partialOrLaterDelivery = "";
                                                  controller.update();

                                                  for (int i = 0; i < 4; i++) {
                                                    if (Get.isDialogOpen!) {
                                                      print(
                                                          "printing get currrent loop -> $i");
                                                      Get.back();
                                                    }
                                                  }
                                                  // Get.back();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: CommonText(
                                                    content: "Back",
                                                    textSize: width * 0.035,
                                                    textColor:
                                                        AppColors.appblack,
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            // SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor: Colors.black,
                                                ),
                                                onPressed: () async {
                                                  if (controller
                                                          .partialOrLaterDelivery ==
                                                      "") {
                                                    CommonSnackBar.showError(
                                                        "Please select the option to proceed");
                                                    return;
                                                  }

                                                  if (searchProduct
                                                          .schemeAvailable &&
                                                      controller
                                                              .partialOrLaterDelivery ==
                                                          "N") {
                                                    await controller
                                                        .getSchemeQty(
                                                      schemeId: searchProduct
                                                              .schemeId ??
                                                          "",
                                                      schemeName: searchProduct
                                                              .schemeName ??
                                                          "",
                                                      addBuyQty:
                                                          maxQuantityToBeAllowed,
                                                      addFreeQty:
                                                          maxFreeQuantityToBeAllowed,
                                                      finalQty: 0,
                                                      quantity:
                                                          maxQuantityToBeAllowed
                                                              .toInt(),
                                                      index: index,
                                                    );

                                                    controller
                                                            .qtyTextControllerList[
                                                                index]
                                                            .text =
                                                        '${maxQuantityToBeAllowed.floor()}';
                                                    controller.qtyList[index]
                                                            .value =
                                                        maxQuantityToBeAllowed
                                                            .floor();
                                                  }

                                                  body = [
                                                    {
                                                      "productId":
                                                          searchProduct.id,
                                                      "productName":
                                                          searchProduct
                                                              .productName,
                                                      "mesuare": "",
                                                      "schemeName":
                                                          searchProduct
                                                              .schemeName,
                                                      "schemeId": searchProduct
                                                          .schemeId,
                                                      "manufacturer":
                                                          searchProduct
                                                              .manufacturer,
                                                      "quantity": !searchProduct
                                                                  .schemeAvailable &&
                                                              controller
                                                                      .partialOrLaterDelivery ==
                                                                  "N"
                                                          ? data["quantity"]
                                                              .toInt()
                                                          : controller
                                                              .qtyList[index]
                                                              .value,
                                                      "finalQuantity":
                                                          controller
                                                              .finalQTYList[
                                                                  index]
                                                              .value,
                                                      "freeQuantity": controller
                                                          .freeQTYList[index]
                                                          .value,
                                                      "buyQuantity": (searchProduct
                                                              .schemeAvailable)
                                                          ? controller
                                                              .buyQTYList[index]
                                                              .value
                                                          : controller.partialOrLaterDelivery ==
                                                                  "N"
                                                              ? data["quantity"]
                                                                  .toInt()
                                                              : controller
                                                                  .qtyList[
                                                                      index]
                                                                  .value,
                                                      "price":
                                                          searchProduct.price,
                                                      "mrp": searchProduct.mrp
                                                              ?.toStringAsFixed(
                                                                  2) ??
                                                          searchProduct.mrp,
                                                      "skuId":
                                                          searchProduct.skuId,
                                                      "productUrl": "",
                                                      "storeName": searchProduct
                                                          .storeName,
                                                      "tabletsPerStrip": "",
                                                      "categoryName": "",
                                                      "prescriptionIsRequired":
                                                          true,
                                                      "checkOutStatus": "N",
                                                      "priceWithGst":
                                                          searchProduct
                                                              .priceWithGst,
                                                      "timePassed":
                                                          isTimePassedInMain
                                                              ? "Y"
                                                              : "N",
                                                    }
                                                  ];

                                                  body[0]["laterDelivery"] =
                                                      controller
                                                          .partialOrLaterDelivery;

                                                  print(
                                                      "printing body in get dialog ---> ${body}");

                                                  await controller
                                                      .getAddToCartApi(body,
                                                          searchProduct.storeId)
                                                      .then(
                                                    (value) {
                                                      dynamic val =
                                                          jsonDecode(value);

                                                      if (val is Map<String,
                                                              dynamic> &&
                                                          val.containsKey(
                                                              "status") &&
                                                          val["status"] ==
                                                              false &&
                                                          val.containsKey(
                                                              "message") &&
                                                          val["message"] !=
                                                              null &&
                                                          val["message"]
                                                              .isNotEmpty) {
                                                        CommonSnackBar
                                                            .showError(
                                                                val["message"]);
                                                      }

                                                      if (val is! Map<String,
                                                              dynamic> ||
                                                          !val.containsKey(
                                                              "id")) {
                                                        return;
                                                      }

                                                      print(
                                                          "printing getAddToCartApi return value ---> $value");
                                                      CommonSnackBar.showToast(
                                                          'Added to Cart',
                                                          context);
                                                      controller
                                                          .qtyTextControllerList[
                                                              index]
                                                          .clear();
                                                      controller.qtyList[index]
                                                          .value = 0;

                                                      controller
                                                          .finalQTYList[index]
                                                          .value = 0;
                                                      controller
                                                          .freeQTYList[index]
                                                          .value = 0;
                                                      controller
                                                          .buyQTYList[index]
                                                          .value = 0;
                                                      controller.update();
                                                      final cartController =
                                                          Get.put(
                                                              CartController());
                                                      cartController
                                                          .getVerifiedProductDataApi();
                                                      print(
                                                          "value>>>>>>>>>>>>>>$value");
                                                    },
                                                  );

                                                  controller
                                                      .partialOrLaterDelivery = "";
                                                  controller.update();

                                                  for (int i = 0; i < 4; i++) {
                                                    if (Get.isDialogOpen!) {
                                                      print(
                                                          "printing get currrent loop -> $i");
                                                      Get.back();
                                                    }
                                                  }
                                                  // Get.back();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: CommonText(
                                                    // content:
                                                    // "Add To Cart in if",
                                                    content: "Add To Cart",
                                                    textSize: width * 0.035,
                                                    textColor:
                                                        AppColors.appWhite,
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );

                      return;
                    }
                  }
                  //to open popups enable this code - ends here

                  print("this is called after checking of dialog");

                  //to open popups enable this code - strats here
                  body[0]["laterDelivery"] =
                      searchProduct.stockAvailable == "1" ? "N" : "Y";
                  //to open popups enable this code - ends here
                  print("printing body after adding later delivery -> $body");

                  await controller
                      .getAddToCartApi(body, searchProduct.storeId)
                      .then(
                    (value) {
                      dynamic val = jsonDecode(value);

                      if (val is Map<String, dynamic> &&
                          val.containsKey("status") &&
                          val["status"] == false &&
                          val.containsKey("message") &&
                          val["message"] != null &&
                          val["message"].isNotEmpty) {
                        CommonSnackBar.showError(val["message"]);
                      }

                      if (val is! Map<String, dynamic> ||
                          !val.containsKey("id")) {
                        return;
                      }

                      print(
                          "printing getAddToCartApi return value ---> $value");
                      CommonSnackBar.showToast('Added to Cart', context);
                      controller.qtyTextControllerList[index].clear();
                      controller.qtyList[index].value = 0;

                      controller.finalQTYList[index].value = 0;
                      controller.freeQTYList[index].value = 0;
                      controller.buyQTYList[index].value = 0;
                      controller.update();
                      final cartController = Get.put(CartController());
                      cartController.getVerifiedProductDataApi();
                      print("value>>>>>>>>>>>>>>$value");
                    },
                  );
                }
              }
            });
          } else {
            print("printing in else");
            print(
                "checking maxxOrderQuantity -> ${searchProduct.maxOrderQuantity} , final ${controller.finalQTYList[index].value}");

            // Max Order Quantity Check Starts here
            if (gmcController.maxOrderQuantityCheckProductLevel.value) {
              if (searchProduct.schemeAvailable) {
                if (searchProduct.maxOrderQuantity != null &&
                    searchProduct.maxOrderQuantity != 0 &&
                    controller.finalQTYList[index].value >
                        searchProduct.maxOrderQuantity!) {
                  CommonSnackBar.showError(
                      "Max order quantity for this product is ${searchProduct.maxOrderQuantity!.toStringAsFixed(0)}");
                  return;
                }
              } else {
                if (searchProduct.maxOrderQuantity != null &&
                    searchProduct.maxOrderQuantity != 0 &&
                    controller.qtyList[index].value >
                        searchProduct.maxOrderQuantity!) {
                  CommonSnackBar.showError(
                      "Max order quantity for this product is ${searchProduct.maxOrderQuantity!.toStringAsFixed(0)}");
                  return;
                }
              }
            }
            // Max Order Quantity Check Ends here

            //to open popups enable this code - starts here
            if (searchProduct.stockAvailable == "1" ||
                searchProduct.stockAvailable == "2") {
              dynamic data = await controller.checkProductQuantityAvailable(
                  skuId: searchProduct.skuId ?? "",
                  storeId: searchProduct.storeId);

              num currentQuantity = (searchProduct.schemeAvailable)
                  ? controller.finalQTYList[index].value
                  : controller.qtyList[index].value;

              if (data == null || data["quantity"] == null) {
                CommonSnackBar.showError("Something went wrong");
                return;
              }

              if (currentQuantity > data["quantity"]) {
                print("checkProductQuantityAvailableData --> $data");
                // if (searchProduct.schemeAvailable) {
                //   CommonSnackBar.showError(
                //       "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                // } else {
                //   CommonSnackBar.showError(
                //       "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                // }

                //scheme calculation starts here

                num totalQuantityToBeAllowed = 0;
                num maxFreeQuantityToBeAllowed = 0;
                num maxQuantityToBeAllowed = 0;
                bool isAtleastOneFullSchemeAvailable = false;

                if (searchProduct.schemeAvailable) {
                  print(
                      "scheme calculation current quantity -> $currentQuantity");

                  print(
                      "scheme calculation scheme -> ${searchProduct.schemeName}");

                  String input = searchProduct.schemeName!;
                  List<String> parts = input.split(" + ");
                  int buyScheme = 0;
                  int freeScheme = 0;

                  if (parts.length == 2) {
                    buyScheme = int.parse(parts[0]);
                    freeScheme = int.parse(parts[1]);
                  } else {
                    print("scheme calculation Invalid input format");
                  }
                  print("scheme calculation scheme input -> ${parts}");
                  print("scheme calculation scheme buyScheme -> ${buyScheme}");
                  print("scheme calculation scheme freeScheme-> ${freeScheme}");

                  num totalScheme = buyScheme + freeScheme;
                  print("scheme calculation total scheme -> ${parts}");

                  print(
                      "scheme calculation available quantity -> ${data["quantity"]}");

                  num availableFullSchemeAdjustment =
                      data["quantity"] / totalScheme;

                  if (availableFullSchemeAdjustment < 1) {
                    isAtleastOneFullSchemeAvailable = false;
                  } else {
                    isAtleastOneFullSchemeAvailable = true;
                  }

                  print(
                      "scheme calculation availableFullSchemeAdjustment -> ${availableFullSchemeAdjustment}");

                  maxQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                      ? availableFullSchemeAdjustment.floor() * buyScheme
                      : 0;

                  maxFreeQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                      ? availableFullSchemeAdjustment.floor() * freeScheme
                      : 0;

                  totalQuantityToBeAllowed =
                      maxFreeQuantityToBeAllowed + maxQuantityToBeAllowed;

                  num quantityRemainingAfterFullSchemes =
                      data["quantity"] - totalQuantityToBeAllowed;

                  print(
                      "scheme calculation maxQuantityToBeAllowed -> ${maxQuantityToBeAllowed}");

                  print(
                      "scheme calculation maxFreeQuantityToBeAllowed -> ${maxFreeQuantityToBeAllowed}");

                  print(
                      "scheme calculation totalQuantityToBeAllowed -> ${totalQuantityToBeAllowed}");

                  print(
                      "scheme calculation quantityRemainingAfterFullSchemes -> ${quantityRemainingAfterFullSchemes}");

                  print(
                      "scheme calculation --- full scheme calculation ends here ---");

                  num calculatedHalfScheme = (buyScheme + freeScheme) / 2;

                  num convertedCalculatedHalfScheme =
                      calculatedHalfScheme.ceil();

                  bool isHalfSchemeApplicable =
                      quantityRemainingAfterFullSchemes >=
                          convertedCalculatedHalfScheme;

                  if (isAtleastOneFullSchemeAvailable == false &&
                      isHalfSchemeApplicable) {
                    isAtleastOneFullSchemeAvailable = true;
                  }

                  if (isHalfSchemeApplicable) {
                    totalQuantityToBeAllowed = totalQuantityToBeAllowed +
                        convertedCalculatedHalfScheme;

                    maxQuantityToBeAllowed = maxQuantityToBeAllowed +
                        (calculatedHalfScheme < convertedCalculatedHalfScheme
                            ? (buyScheme / 2) + 0.5
                            : buyScheme / 2);

                    maxFreeQuantityToBeAllowed =
                        maxFreeQuantityToBeAllowed + (freeScheme / 2);
                  }

                  print(
                      "scheme calculation isHalfSchemeApplicable -> ${isHalfSchemeApplicable}");

                  print(
                      "scheme calculation calculatedHalfScheme -> ${calculatedHalfScheme}");

                  print(
                      "scheme calculation convertedCalculatedHalfScheme -> ${convertedCalculatedHalfScheme}");
                }

                //scheme calculation ends here

                if (isFromPopup) {
                  if (searchProduct.schemeAvailable) {
                    CommonSnackBar.showError(
                        "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                  }

                  return;
                  //  else {
                  //   CommonSnackBar.showError(
                  //       "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                  // }
                }

                if (Get.isBottomSheetOpen!) {
                  return;
                }

                bool isMaxTimeStopNeeded = API.needMaxTimeStopFunctionality;
                bool isTimePassed =
                    isMaxTimeStopNeeded ? await isAfterDynamicTime() : false;
                // bool isTimePassed = true;

                print("printing is time passed or not --> $isTimePassed");

                Get.dialog(
                  barrierDismissible: false,
                  WillPopScope(
                    onWillPop: () async {
                      controller.partialOrLaterDelivery = "";
                      controller.update();
                      return true;
                    },
                    child: Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        insetPadding: EdgeInsets.all(0),
                        alignment: Alignment.bottomCenter,

                        // onClosing: () {},
                        backgroundColor: AppColors.appWhite,
                        // builder: (context) {
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          child: GetBuilder<BuyController>(
                            builder: (controller) {
                              print("printing logicasfd -> $isTimePassed");
                              print(
                                  "printing logic -> ${!isTimePassed || (searchProduct.schemeAvailable && !isAtleastOneFullSchemeAvailable)}");

                              if (searchProduct.schemeAvailable &&
                                  !isAtleastOneFullSchemeAvailable &&
                                  !gmcController.popup2ndOptionNeededB2B) {
                                return SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonText(
                                        content: gmcController
                                            .atleastOneSchemeNotApplicableText,
                                        textColor: AppColors.appblack,
                                        boldNess: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: width,
                                      child: CommonText(
                                        // content:
                                        //     "The requested quantity exceeds available stock. This product will be delivered tomorrow. Are you sure you want to proceed?",
                                        // textSize: width * 0.04,
                                        content: searchProduct.schemeAvailable
                                            ? isAtleastOneFullSchemeAvailable
                                                // ? "Maximum quantity you can get today is ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed)"
                                                ? "Choose Delivery Option"
                                                : ""
                                            //? "The requested quantity exceeds available stock (${data["quantity"].round()}). Please adjust the quantity within the available limit to get delivery today or you can choose full delivery tomorrow option"
                                            // : "The requested quantity exceeds available stock. Please choose any one of the below options to proceed.",
                                            : "Choose delivery option",
                                        textSize: width * 0.04,
                                        textColor: AppColors.appblack,
                                        boldNess: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    searchProduct.schemeAvailable
                                        ? isAtleastOneFullSchemeAvailable
                                            ? SizedBox(height: height * 0.02)
                                            : SizedBox()
                                        : (searchProduct.schemeAvailable
                                                ? totalQuantityToBeAllowed < 1
                                                : data["quantity"] < 1)
                                            ? SizedBox()
                                            : SizedBox(
                                                height: height * 0.02,
                                              ),

                                    //Scheme calculation just like in main page
                                    // if (searchProduct.schemeId != null &&
                                    //     searchProduct.schemeId!.isNotEmpty)
                                    //   controller.freeQTYList[index].value > 0
                                    //       ? Row(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.end,
                                    //           children: [
                                    //             Obx(
                                    //               () => CommonText(
                                    //                 content:
                                    //                     'Qty: ${(controller.finalQTYList[index].value).toStringAsFixed(0)}',
                                    //                 boldNess: FontWeight.w500,
                                    //                 textColor: ColorsConst
                                    //                     .greyTextColor,
                                    //                 textSize: width * 0.036,
                                    //               ),
                                    //             ),
                                    //             Obx(
                                    //               () => CommonText(
                                    //                 content:
                                    //                     '(${((controller.buyQTYList[index].value)).toStringAsFixed(2)} + ',
                                    //                 boldNess: FontWeight.w500,
                                    //                 textColor: ColorsConst
                                    //                     .greyTextColor,
                                    //                 textSize: width * 0.036,
                                    //               ),
                                    //             ),
                                    //             Obx(
                                    //               () => CommonText(
                                    //                 content:
                                    //                     '${((controller.freeQTYList[index].value)).toStringAsFixed(2)})',
                                    //                 boldNess: FontWeight.w500,
                                    //                 textColor: ColorsConst
                                    //                     .greyTextColor,
                                    //                 textSize: width * 0.036,
                                    //               ),
                                    //             )
                                    //           ],
                                    //         )
                                    //       : const SizedBox(),
                                    //Scheme calculation ends here

                                    //Add to cart facility starts here
                                    // searchProduct.schemeAvailable
                                    //     ? Row(
                                    //         children: [
                                    //           Expanded(
                                    //             child: Container(
                                    //               height: 32,
                                    //               // width: 134,
                                    //               padding: const EdgeInsets
                                    //                   .symmetric(vertical: 3),
                                    //               decoration: BoxDecoration(
                                    //                   color:
                                    //                       ColorsConst.appWhite,
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           4),
                                    //                   border: Border.all(
                                    //                       color: ColorsConst
                                    //                           .primaryColor)),
                                    //               child: Row(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .center,
                                    //                 children: [
                                    //                   decreaseProductButton(
                                    //                       index, searchProduct),
                                    //                   const SizedBox(width: 8),
                                    //                   addProductTextField(
                                    //                       index, searchProduct),
                                    //                   const SizedBox(width: 8),
                                    //                   increaseProductButton(
                                    //                       index, searchProduct),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           const SizedBox(width: 10),
                                    //           Expanded(
                                    //               child: addToCartButton(
                                    //                   index, searchProduct,
                                    //                   isFromPopup: true)),
                                    //         ],
                                    //       )
                                    //     : SizedBox(),
                                    //Add to cart facility ends here

                                    // searchProduct.schemeAvailable
                                    //     ? SizedBox(
                                    //         height: 10,
                                    //       )
                                    //     : SizedBox(),

                                    //ignore toberemoved statements

                                    // if ("toberemoved" == false)
                                    // searchProduct.schemeAvailable
                                    //     ? SizedBox()
                                    //     :
                                    // if (!isTimePassed)
                                    (searchProduct.schemeAvailable &&
                                            !isAtleastOneFullSchemeAvailable)
                                        ? SizedBox()
                                        : (searchProduct.schemeAvailable
                                                ? totalQuantityToBeAllowed < 1
                                                : data["quantity"] < 1)
                                            ? SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  // if (searchProduct
                                                  //     .schemeAvailable) {
                                                  //   controller
                                                  //           .partialOrLaterDelivery =
                                                  //       "N";
                                                  // } else {
                                                  //   controller
                                                  //           .partialOrLaterDelivery =
                                                  //       "P";
                                                  // }
                                                  controller
                                                          .partialOrLaterDelivery =
                                                      "N";

                                                  controller.update();
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: AppColors
                                                                .appblack,
                                                          )),
                                                      child: Container(
                                                        height: 15,
                                                        width: 15,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                          .partialOrLaterDelivery ==
                                                                      "P" ||
                                                                  controller.partialOrLaterDelivery ==
                                                                      "N"
                                                              ? AppColors
                                                                  .appblack
                                                              : AppColors
                                                                  .appWhite,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: CommonText(
                                                        content: searchProduct
                                                                .schemeAvailable
                                                            ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                                            // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                                            : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                                        textSize: width * 0.035,
                                                        textColor:
                                                            AppColors.appblack,
                                                        boldNess:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                    if (gmcController.popup2ndOptionNeededB2B)
                                      searchProduct.schemeAvailable &&
                                              !isAtleastOneFullSchemeAvailable
                                          ? SizedBox()
                                          : SizedBox(
                                              height: 20,
                                            ),
                                    if (gmcController.popup2ndOptionNeededB2B)
                                      GestureDetector(
                                        onTap: () {
                                          controller.partialOrLaterDelivery =
                                              "Y";
                                          controller.update();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.appblack,
                                                  )),
                                              child: Container(
                                                height: 15,
                                                width: 15,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  // color: AppColors.appblack,
                                                  color: controller
                                                              .partialOrLaterDelivery ==
                                                          "Y"
                                                      ? AppColors.appblack
                                                      : AppColors.appWhite,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CommonText(
                                                content: searchProduct
                                                        .schemeAvailable
                                                    ? '${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${(controller.finalQTYList[index].value).toStringAsFixed(0)} (${((controller.buyQTYList[index].value)).toStringAsFixed(2)} + ${((controller.freeQTYList[index].value)).toStringAsFixed(2)}) Quantity'
                                                    : "${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${controller.qtyTextControllerList[index].text} Quantity",
                                                textSize: width * 0.035,
                                                textColor: AppColors.appblack,
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                side: const BorderSide(
                                                    color: AppColors.appblack)),
                                            onPressed: () {
                                              controller
                                                  .partialOrLaterDelivery = "";
                                              controller.update();

                                              for (int i = 0; i < 4; i++) {
                                                if (Get.isDialogOpen!) {
                                                  print(
                                                      "printing get currrent loop -> $i");
                                                  Get.back();
                                                }
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: CommonText(
                                                content: "Back",
                                                textSize: width * 0.035,
                                                textColor: AppColors.appblack,
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: Colors.black,
                                            ),
                                            onPressed: () async {
                                              print(
                                                  "add to cart in popup clicked");
                                              if (controller
                                                      .qtyList[index].value ==
                                                  0) {
                                                CommonSnackBar.showToast(
                                                    'Please Enter Qty', context,
                                                    showTickMark: false);
                                                return;
                                              }

                                              if (controller
                                                      .partialOrLaterDelivery ==
                                                  "") {
                                                CommonSnackBar.showError(
                                                    "Please select the option to proceed");
                                                return;
                                              }

                                              if (searchProduct
                                                      .schemeAvailable &&
                                                  controller
                                                          .partialOrLaterDelivery ==
                                                      "N") {
                                                await controller.getSchemeQty(
                                                  schemeId:
                                                      searchProduct.schemeId ??
                                                          "",
                                                  schemeName: searchProduct
                                                          .schemeName ??
                                                      "",
                                                  addBuyQty:
                                                      maxQuantityToBeAllowed,
                                                  addFreeQty:
                                                      maxFreeQuantityToBeAllowed,
                                                  finalQty: 0,
                                                  quantity:
                                                      maxQuantityToBeAllowed
                                                          .toInt(),
                                                  index: index,
                                                );

                                                controller
                                                        .qtyTextControllerList[
                                                            index]
                                                        .text =
                                                    '${maxQuantityToBeAllowed.floor()}';
                                                controller
                                                        .qtyList[index].value =
                                                    maxQuantityToBeAllowed
                                                        .floor();
                                              }

                                              body = [
                                                {
                                                  "productId": searchProduct.id,
                                                  "productName":
                                                      searchProduct.productName,
                                                  "mesuare": "",
                                                  "schemeName":
                                                      searchProduct.schemeName,
                                                  "schemeId":
                                                      searchProduct.schemeId,
                                                  "manufacturer": searchProduct
                                                      .manufacturer,
                                                  "quantity": !searchProduct
                                                              .schemeAvailable &&
                                                          controller
                                                                  .partialOrLaterDelivery ==
                                                              "N"
                                                      ? data["quantity"].toInt()
                                                      : controller
                                                          .qtyList[index].value,
                                                  "finalQuantity": controller
                                                      .finalQTYList[index]
                                                      .value,
                                                  "freeQuantity": controller
                                                      .freeQTYList[index].value,
                                                  "buyQuantity": (searchProduct
                                                          .schemeAvailable)
                                                      ? controller
                                                          .buyQTYList[index]
                                                          .value
                                                      : controller.partialOrLaterDelivery ==
                                                              "N"
                                                          ? data["quantity"]
                                                              .toInt()
                                                          : controller
                                                              .qtyList[index]
                                                              .value,
                                                  "price": searchProduct.price,
                                                  "mrp": searchProduct.mrp
                                                          ?.toStringAsFixed(
                                                              2) ??
                                                      searchProduct.mrp,
                                                  "skuId": searchProduct.skuId,
                                                  "productUrl": "",
                                                  "storeName":
                                                      searchProduct.storeName,
                                                  "tabletsPerStrip": "",
                                                  "categoryName": "",
                                                  "prescriptionIsRequired":
                                                      true,
                                                  "checkOutStatus": "N",
                                                  "priceWithGst": searchProduct
                                                      .priceWithGst,
                                                  "timePassed":
                                                      isTimePassedInMain
                                                          ? "Y"
                                                          : "N",
                                                }
                                              ];

                                              body[0]["laterDelivery"] =
                                                  controller
                                                      .partialOrLaterDelivery;

                                              print(
                                                  "printing body in get dialog else---> ${body}");

                                              await controller
                                                  .getAddToCartApi(body,
                                                      searchProduct.storeId)
                                                  .then(
                                                (value) {
                                                  print(
                                                      "Type of value: ${value.runtimeType}");

                                                  dynamic val =
                                                      jsonDecode(value);

                                                  if (val is Map<String,
                                                          dynamic> &&
                                                      val.containsKey(
                                                          "status") &&
                                                      val["status"] == false &&
                                                      val.containsKey(
                                                          "message") &&
                                                      val["message"] != null &&
                                                      val["message"]
                                                          .isNotEmpty) {
                                                    CommonSnackBar.showError(
                                                        val["message"]);
                                                  }

                                                  if (val is! Map<String,
                                                          dynamic> ||
                                                      !val.containsKey("id")) {
                                                    return;
                                                  }

                                                  print(
                                                      "printing getAddToCartApi return value ---> $value");
                                                  CommonSnackBar.showToast(
                                                      'Added to Cart', context);
                                                  controller
                                                      .qtyTextControllerList[
                                                          index]
                                                      .clear();
                                                  controller
                                                      .qtyList[index].value = 0;

                                                  controller.finalQTYList[index]
                                                      .value = 0;
                                                  controller.freeQTYList[index]
                                                      .value = 0;
                                                  controller.buyQTYList[index]
                                                      .value = 0;
                                                  controller.update();
                                                  final cartController =
                                                      Get.put(CartController());
                                                  cartController
                                                      .getVerifiedProductDataApi();
                                                  print(
                                                      "value>>>>>>>>>>>>>>$value");
                                                },
                                              );

                                              controller
                                                  .partialOrLaterDelivery = "";
                                              controller.update();

                                              for (int i = 0; i < 4; i++) {
                                                if (Get.isDialogOpen!) {
                                                  print(
                                                      "printing get currrent loop -> $i");
                                                  Get.back();
                                                }
                                              }

                                              print(
                                                  "printing get current route -> ${Get.isDialogOpen}");
                                              // Get.back();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: CommonText(
                                                // content: "Add To Cart in else",
                                                content: "Add To Cart",
                                                textSize: width * 0.035,
                                                textColor: AppColors.appWhite,
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                );

                return;
              }
            }
            //to open popups enable this code - ends here

            print("this is called after checking of dialog");

            //to open popups enable this code - starts here
            body[0]["laterDelivery"] =
                searchProduct.stockAvailable == "1" ? "N" : "Y";
            //to open popups enable this code - ends here
            print("printing body after adding later delivery -> $body");

            await controller
                .getAddToCartApi(body, searchProduct.storeId)
                .then((value) {
              print("printing getAddToCartApi return value 2 ---> $value");

              dynamic val = jsonDecode(value);

              if (val is Map<String, dynamic> &&
                  val.containsKey("status") &&
                  val["status"] == false &&
                  val.containsKey("message") &&
                  val["message"] != null &&
                  val["message"].isNotEmpty) {
                CommonSnackBar.showError(val["message"]);
              }

              if (val is! Map<String, dynamic> || !val.containsKey("id")) {
                return;
              }

              print("printing getAddToCartApi return value 3 ---> $value");

              if (value != null) {
                CommonSnackBar.showToast('Added to Cart', context);
              }
              controller.qtyTextControllerList[index].clear();
              controller.qtyList[index].value = 0;

              controller.finalQTYList[index].value = 0;
              controller.freeQTYList[index].value = 0;
              controller.buyQTYList[index].value = 0;
              controller.update();
              final cartController = Get.put(CartController());
              cartController.getVerifiedProductDataApi();
              print("value>>>>>>>>>>>>>>$value");
            });
          }

          // controller.getAddToCartApi(body, searchProduct.storeId).then((value) {
          //   CommonSnackBar.showToast('Added to Cart', context);
          //   controller.qtyTextControllerList[index].clear();
          //   controller.qtyList[index].value = 0;

          //   controller.finalQTYList[index].value = 0;
          //   controller.freeQTYList[index].value = 0;
          //   controller.buyQTYList[index].value = 0;
          //   controller.update();
          //   final cartController = Get.put(CartController());
          //   cartController.getVerifiedProductDataApi();
          //   print("value>>>>>>>>>>>>>>$value");
          // });
        }
      },
      child: Container(
        height: 32,
        width: 134,
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: ColorsConst.primaryColor),
        child: const CommonText(
            content: "Add to Cart",
            textColor: ColorsConst.appWhite,
            textSize: 14,
            boldNess: FontWeight.w500),
      ),
    );
  }

//
  favouriteNameDialog({double? width, double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff2F394B), Color(0xff090F1A)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: CommonText(
                      content: "Favourites ",
                      boldNess: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextField(
                        content: "Drug License",
                        hintText: "Type name here....",
                        controller: controller.favouriteNameController.value,
                        contentColor: ColorsConst.textColor,
                        titleShow: false,
                      ),
                      SizedBox(height: height! * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: ColorsConst.redColor),
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: CommonText(
                                      content: "Cancel",
                                      textSize: width! * 0.035,
                                      textColor: ColorsConst.redColor,
                                      boldNess: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: ColorsConst.greenButtonColor,
                                ),
                                onPressed: () {
                                  if (controller.favouriteNameController.value
                                      .text.isEmpty) {
                                    CommonSnackBar.showError(
                                        "Please Enter Name");
                                  } else if (controller.getFavoriteNameList
                                      .contains(controller
                                          .favouriteNameController
                                          .value
                                          .text)) {
                                    CommonSnackBar.showError("Same Name Use");
                                  } else {
                                    controller.getFavoriteNameList.add(
                                        controller
                                            .favouriteNameController.value.text
                                            .trim()
                                            .toString());
                                    controller.favouriteSelect.value =
                                        controller
                                            .favouriteNameController.value.text
                                            .trim();
                                    setState(() {});
                                    print(controller.getFavoriteNameList);
                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: CommonText(
                                    content: "Save",
                                    textSize: width * 0.035,
                                    textColor: Colors.white,
                                    boldNess: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension BoldSubString on Text {
  Text boldSubString(String target) {
    final textSpans = List.empty(growable: true);
    final escapedTarget = RegExp.escape(target);
    final pattern = RegExp(escapedTarget, caseSensitive: false);
    final matches = pattern.allMatches(data!);

    int currentIndex = 0;
    for (final match in matches) {
      final beforeMatch = data!.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        textSpans.add(TextSpan(text: beforeMatch));
      }

      final matchedText = data!.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: matchedText,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 139, 3, 1)),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < data!.length) {
      final remainingText = data!.substring(currentIndex);
      textSpans.add(TextSpan(
        text: remainingText,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Color.fromRGBO(65, 65, 65, 1)),
      ));
    }

    return Text.rich(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      TextSpan(
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
        children: <TextSpan>[...textSpans],
      ),
    );
  }
}
