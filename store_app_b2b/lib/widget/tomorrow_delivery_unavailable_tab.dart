import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller.dart';
import 'package:store_app_b2b/model/cart_model.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class TomorrowDeliveryUnavailableTab extends StatelessWidget {
  const TomorrowDeliveryUnavailableTab({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<CartController>(
        init: CartController(),
        builder: (cartController) {
          // print(
          //     "printing laterDeliveryData Length --> ${cartController.laterDeliveryData[0].storeVo[0].items.length}");

          return Container(
              width: double.infinity,
              height: double.infinity,
              child: cartController.isLaterDeliveryLoading
                  ? Center(child: CircularProgressIndicator())
                  : cartController.laterDeliveryData.isEmpty
                      // ? Center(
                      //     child: CommonText(
                      //       content: "Later Delivery Items not Available",
                      //       textColor: Colors.black,
                      //       boldNess: FontWeight.w500,
                      //       textSize: 16,
                      //     ),
                      //   )
                      ? Center(
                          child: Container(
                          width: double.infinity,
                          height: 400,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/laterDeliveryNoOrders.png",
                                scale: 4,
                                package: 'store_app_b2b',
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: CommonText(
                                  content: "Later Delivery Items not Available",
                                  textColor: Colors.black,
                                  boldNess: FontWeight.w500,
                                  textSize: 16,
                                ),
                              )
                            ],
                          ),
                        ))
                      : ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  itemCount: cartController.laterDeliveryData[0]
                                      .storeVo[0].items.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Item item = cartController
                                        .laterDeliveryData[0]
                                        .storeVo[0]
                                        .items[index];

                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: ColorsConst.appWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: CommonText(
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // content: cartController
                                                      //         .cartListModel!
                                                      //         .storeVo[widget.storeIndex]
                                                      //         .items[index]
                                                      //         .productName ??
                                                      //     '',
                                                      content:
                                                          item.productName ??
                                                              "",
                                                      boldNess: FontWeight.w600,
                                                      textColor:
                                                          ColorsConst.textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CommonText(
                                                  content:
                                                      // '${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].manufacturer ?? ''}',
                                                      item.manufacturer ?? "",
                                                  textSize: 12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textColor: ColorsConst
                                                      .notificationTextColor,
                                                  boldNess: FontWeight.w600),
                                              SizedBox(height: height * 0.01),
                                              Row(
                                                children: [
                                                  item.schemeId != null &&
                                                          item.schemeId!
                                                              .isNotEmpty &&
                                                          item.schemeName !=
                                                              null &&
                                                          item.schemeName!
                                                              .isNotEmpty
                                                      ? Expanded(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/offer.png",
                                                                scale: 4,
                                                                package:
                                                                    'store_app_b2b',
                                                              ),
                                                              SizedBox(
                                                                  width: width *
                                                                      0.01),
                                                              CommonText(
                                                                content:
                                                                    "${item.schemeName ?? ''}",
                                                                // "5 + 1",
                                                                textSize: 12,
                                                                boldNess:
                                                                    FontWeight
                                                                        .w600,
                                                                textColor:
                                                                    ColorsConst
                                                                        .textColor,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Spacer(),
                                                  CommonText(
                                                    content:
                                                        // 'Qty: ${(widget.cartController.finalQTYList[index].value).toStringAsFixed(0)}',
                                                        "Qty: ${item.finalQuantity}(${item.buyQuantity} + ${item.freeQuantity})",
                                                    boldNess: FontWeight.w500,
                                                    textColor: ColorsConst
                                                        .greyTextColor,
                                                    textSize: width * 0.036,
                                                  ),
                                                ],
                                              ),
                                              // if (item.schemeId != null &&
                                              //     item.schemeId!.isNotEmpty &&
                                              //     item.schemeName != null &&
                                              //     item.schemeName!.isNotEmpty)
                                              //   Row(
                                              //     crossAxisAlignment:
                                              //         CrossAxisAlignment.start,
                                              //     children: [
                                              //       Image.asset(
                                              //         "assets/icons/offer.png",
                                              //         scale: 4,
                                              //         package: 'store_app_b2b',
                                              //       ),
                                              //       SizedBox(
                                              //           width: width * 0.01),
                                              //       Expanded(
                                              //         child: CommonText(
                                              //           content:
                                              //               "${item.schemeName ?? ''}",
                                              //           // "5 + 1",
                                              //           textSize: 12,
                                              //           boldNess:
                                              //               FontWeight.w600,
                                              //           textColor: ColorsConst
                                              //               .textColor,
                                              //           maxLines: 1,
                                              //           overflow: TextOverflow
                                              //               .ellipsis,
                                              //         ),
                                              //       ),
                                              //       // (cartController
                                              //       //                 .cartListModel!
                                              //       //                 .storeVo[widget.storeIndex]
                                              //       //                 .items[index]
                                              //       //                 .schemeId !=
                                              //       //             null &&
                                              //       //         cartController
                                              //       //             .cartListModel!
                                              //       //             .storeVo[widget.storeIndex]
                                              //       //             .items[index]
                                              //       //             .schemeId!
                                              //       //             .isNotEmpty &&
                                              //       //         cartController
                                              //       //                 .cartListModel!
                                              //       //                 .storeVo[widget.storeIndex]
                                              //       //                 .items[index]
                                              //       //                 .schemeName !=
                                              //       //             null &&
                                              //       //         cartController
                                              //       //             .cartListModel!
                                              //       //             .storeVo[widget.storeIndex]
                                              //       //             .items[index]
                                              //       //             .schemeName!
                                              //       //             .isNotEmpty)
                                              //       //     ? Obx(
                                              //       // () =>
                                              //       CommonText(
                                              //         content:
                                              //             // 'Qty: ${(widget.cartController.finalQTYList[index].value).toStringAsFixed(0)}',
                                              //             "Qty: ${item.finalQuantity}(${item.buyQuantity} + ${item.freeQuantity})",
                                              //         boldNess: FontWeight.w500,
                                              //         textColor: ColorsConst
                                              //             .greyTextColor,
                                              //         textSize: width * 0.036,
                                              //       ),

                                              //       // : CommonText(
                                              //       //   content:
                                              //       //       'Qty: ${((cartController.cartListModel!.storeVo[widget.storeIndex].items[index].quantity)).toStringAsFixed(0)}',
                                              //       //   boldNess: FontWeight.w500,
                                              //       //   textColor: ColorsConst.greyTextColor,
                                              //       //   textSize: width * 0.036,
                                              //       // ),
                                              //     ],
                                              //   ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
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
                                                                  // "₹${(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].mrp ?? 0).toStringAsFixed(2)}",
                                                                  "₹ ${item.mrp}",
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
                                                        Row(
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
                                                            SizedBox(
                                                                width: width *
                                                                    0.015),
                                                            CommonText(
                                                              content:
                                                                  // "₹${(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].price ?? 0).toStringAsFixed(2)}",
                                                                  "₹ ${item.price}",
                                                              textSize: 14,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: ColorsConst
                                                                  .notificationTextColor,
                                                            ),
                                                          ],
                                                        ),

                                                        // Row(
                                                        //   children: [
                                                        //     CommonText(
                                                        //       content: "Total",
                                                        //       textColor: ColorsConst.primaryColor,
                                                        //       textSize: 14,
                                                        //       boldNess: FontWeight.w600,
                                                        //     ),
                                                        //     SizedBox(width: width * 0.01),
                                                        //     CommonText(
                                                        //       content:
                                                        //           // "₹${((widget.items[index].price ?? 0) * (widget.items[index].buyQuantity ?? 0)).toStringAsFixed(2)}",
                                                        //           // "₹${((cartController.cartListModel!.storeVo[widget.storeIndex].items[index].price ?? 0) * (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].buyQuantity)).toStringAsFixed(2)}",
                                                        //           "₹ 24.00",
                                                        //       textSize: 14,
                                                        //       boldNess: FontWeight.w600,
                                                        //       textColor: ColorsConst.primaryColor,
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   children: [
                                                        //     CommonText(
                                                        //         content: "*",
                                                        //         // "${widget.cartController.cartListModel!.storeVo[0].items[index].stockAvailable}",
                                                        //         textSize: 14,
                                                        //         boldNess: FontWeight.w600,
                                                        //         textColor:
                                                        //             // ColorsConst.primaryColor,
                                                        //             getStockStatusStarColor(cartController
                                                        //                     .cartListModel!
                                                        //                     .storeVo[widget.storeIndex]
                                                        //                     .items[index]
                                                        //                     .stockAvailable ??
                                                        //                 "")),
                                                        //     CommonText(
                                                        //         content:
                                                        //             // "₹${((widget.items[index].price ?? 0) * (widget.items[index].buyQuantity ?? 0)).toStringAsFixed(2)}",
                                                        //             getStockStatusText(cartController
                                                        //                     .cartListModel!
                                                        //                     .storeVo[widget.storeIndex]
                                                        //                     .items[index]
                                                        //                     .stockAvailable ??
                                                        //                 ""),
                                                        //         // "${widget.cartController.cartListModel!.storeVo[0].items[index].stockAvailable}",
                                                        //         textSize: 14,
                                                        //         boldNess: FontWeight.w600,
                                                        //         textColor:
                                                        //             // ColorsConst.primaryColor,
                                                        //             getStockStatusTextColor(cartController
                                                        //                     .cartListModel!
                                                        //                     .storeVo[widget.storeIndex]
                                                        //                     .items[index]
                                                        //                     .stockAvailable ??
                                                        //                 "")),
                                                        //   ],
                                                        // ),
                                                        // CommonText(
                                                        //     content:
                                                        //         // "₹${((widget.items[index].price ?? 0) * (widget.items[index].buyQuantity ?? 0)).toStringAsFixed(2)}",
                                                        //         getStockStatusText(cartController
                                                        //                 .cartListModel!
                                                        //                 .storeVo[widget
                                                        //                     .storeIndex]
                                                        //                 .items[
                                                        //                     index]
                                                        //                 .stockAvailable ??
                                                        //             ""),
                                                        //     // "${widget.cartController.cartListModel!.storeVo[0].items[index].stockAvailable}",
                                                        //     textSize: 14,
                                                        //     boldNess:
                                                        //         FontWeight.w600,
                                                        //     textColor:
                                                        //         // ColorsConst.primaryColor,
                                                        //         getStockStatusTextColor(cartController
                                                        //                 .cartListModel!
                                                        //                 .storeVo[widget
                                                        //                     .storeIndex]
                                                        //                 .items[
                                                        //                     index]
                                                        //                 .stockAvailable ??
                                                        //             "")),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      CommonText(
                                                        content: "Total",
                                                        textColor: ColorsConst
                                                            .primaryColor,
                                                        textSize: 14,
                                                        boldNess:
                                                            FontWeight.w600,
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.01),
                                                      CommonText(
                                                        content:
                                                            // "₹${((widget.items[index].price ?? 0) * (widget.items[index].buyQuantity ?? 0)).toStringAsFixed(2)}",
                                                            "₹${((item.price ?? 0) * (item.buyQuantity)).toStringAsFixed(2)}",
                                                        // "₹ 24.00",
                                                        textSize: 14,
                                                        boldNess:
                                                            FontWeight.w600,
                                                        textColor: ColorsConst
                                                            .primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              CommonText(
                                                content:
                                                    "*Unavailable in the market",
                                                textColor: ColorsConst.redColor,
                                                textSize: 14,
                                                boldNess: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ));
        });
  }
}
