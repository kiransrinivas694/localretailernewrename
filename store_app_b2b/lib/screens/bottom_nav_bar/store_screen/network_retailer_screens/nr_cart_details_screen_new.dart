import 'dart:convert';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_buy_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_cart_controller_new.dart';
import 'package:store_app_b2b/model/cart_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/widget/time_check_new.dart';

class NrCartDetailsScreen extends StatefulWidget {
  NrCartDetailsScreen({
    Key? key,
    required this.items,
    required this.cartController,
    required this.storeName,
    required this.storeId,
    required this.cartId,
    required this.storeIndex,
  }) : super(key: key);

  final List<Item> items;
  final String storeName;
  final String storeId;
  final String cartId;
  final NrCartController cartController;
  final int storeIndex;

  @override
  State<NrCartDetailsScreen> createState() => _NrCartDetailsScreenState();
}

class _NrCartDetailsScreenState extends State<NrCartDetailsScreen> {
  final buyController = Get.put(NrBuyController());

  final gmcController = Get.find<GlobalMainController>();

  @override
  void initState() {
    widget.cartController.freeQTYList.clear();
    widget.cartController.finalQTYList.clear();
    widget.cartController.buyQTYList.clear();
    widget.cartController.qtyTextControllerList.clear();
    widget.cartController.isEditableQTYList.clear();
    widget.items.forEach((element) {
      widget.cartController.freeQTYList
          .add(RxDouble(double.parse('${element.freeQuantity}')));
      widget.cartController.buyQTYList
          .add(RxDouble(double.parse('${element.buyQuantity}')));
      widget.cartController.finalQTYList
          .add(RxDouble(double.parse('${element.finalQuantity}')));
      widget.cartController.qtyTextControllerList.add(TextEditingController(
        text: '${element.quantity.toStringAsFixed(0)}',
      ));
      widget.cartController.isEditableQTYList.add(false.obs);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<NrCartController>(
      builder: (cartController) {
        // log("logging buy quantity inside of detals after update");
        // log('${cartController.cartListModel?.storeVo[0].items[0].buyQuantity}');
        // log("logging buy quantity values of the list after update - ${cartController.buyQTYList}");
        return Scaffold(
            backgroundColor: ColorsConst.greyBgColor,
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "Cart",
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
            body: (widget.cartController.cartListModel!.storeVo.isEmpty)
                ? Center(
                    child: CommonText(
                    content: 'Cart is empty',
                    textSize: 18,
                    boldNess: FontWeight.w500,
                    textColor: ColorsConst.textColor,
                  ))
                : StatefulBuilder(
                    builder: (context, setState) {
                      widget.cartController.totalPriceGet(cartController
                              .cartListModel
                              ?.storeVo[widget.storeIndex]
                              .items ??
                          []);
                      return Column(
                        children: [
                          SizedBox(height: height * 0.02),
                          Center(
                            child: CommonText(
                              content: "Listed items from ${widget.storeName}",
                              textColor: ColorsConst.notificationTextColor,
                              textSize: width * 0.035,
                              boldNess: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: cartController.cartListModel!
                                  .storeVo[widget.storeIndex].items.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      padding: const EdgeInsets.all(10),
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
                                                child: CommonText(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  content: cartController
                                                          .cartListModel!
                                                          .storeVo[
                                                              widget.storeIndex]
                                                          .items[index]
                                                          .productName ??
                                                      '',
                                                  boldNess: FontWeight.w600,
                                                  textColor:
                                                      ColorsConst.textColor,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  widget.cartController
                                                      .getSingleItemDeleteFromCartApi(
                                                          storeId:
                                                              widget.storeId,
                                                          cartId: widget.cartId,
                                                          index: index,
                                                          skuId: cartController
                                                                  .cartListModel!
                                                                  .storeVo[widget
                                                                      .storeIndex]
                                                                  .items[index]
                                                                  .skuId ??
                                                              '')
                                                      .then((value) {
                                                    print(
                                                        "printing the return response after the delete --> ${value}");

                                                    // widget.cartController
                                                    //     .qtyTextControllerList
                                                    //     .removeAt(index);

                                                    // widget.cartController
                                                    //     .update();

                                                    // widget.cartController
                                                    //     .freeQTYList
                                                    //     .removeAt(index);
                                                    // widget.cartController
                                                    //     .buyQTYList
                                                    //     .removeAt(index);
                                                    // widget.cartController
                                                    //     .finalQTYList
                                                    //     .removeAt(index);
                                                    // widget.cartController
                                                    //     .isEditableQTYList
                                                    //     .removeAt(index);

                                                    // widget.cartController
                                                    //     .getVerifiedProductDataApi();

                                                    print(
                                                        "printing before products call");
                                                    // await cartController
                                                    //     .getVerifiedProductDataApi();
                                                    print(
                                                        "printing after products call");
                                                    print(
                                                        "set state is called");
                                                    setState(() {});
                                                  });
                                                },
                                                child: Image.asset(
                                                    'assets/icons/delete_icon.png',
                                                    scale: 4,
                                                    fit: BoxFit.cover,
                                                    package: 'store_app_b2b'),
                                              ),
                                            ],
                                          ),
                                          CommonText(
                                              content:
                                                  '${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].manufacturer ?? ''}',
                                              textSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                              textColor: ColorsConst
                                                  .notificationTextColor,
                                              boldNess: FontWeight.w600),
                                          SizedBox(height: height * 0.01),
                                          if (cartController
                                                      .cartListModel!
                                                      .storeVo[
                                                          widget.storeIndex]
                                                      .items[index]
                                                      .schemeId !=
                                                  null &&
                                              cartController
                                                  .cartListModel!
                                                  .storeVo[widget.storeIndex]
                                                  .items[index]
                                                  .schemeId!
                                                  .isNotEmpty &&
                                              cartController
                                                      .cartListModel!
                                                      .storeVo[
                                                          widget.storeIndex]
                                                      .items[index]
                                                      .schemeName !=
                                                  null &&
                                              cartController
                                                  .cartListModel!
                                                  .storeVo[widget.storeIndex]
                                                  .items[index]
                                                  .schemeName!
                                                  .isNotEmpty)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/offer.png",
                                                  scale: 4,
                                                  package: 'store_app_b2b',
                                                ),
                                                SizedBox(width: width * 0.01),
                                                Expanded(
                                                  child: CommonText(
                                                    content:
                                                        "${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName ?? ''}",
                                                    textSize: 12,
                                                    boldNess: FontWeight.w600,
                                                    textColor:
                                                        ColorsConst.textColor,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                (cartController
                                                                .cartListModel!
                                                                .storeVo[widget
                                                                    .storeIndex]
                                                                .items[index]
                                                                .schemeId !=
                                                            null &&
                                                        cartController
                                                            .cartListModel!
                                                            .storeVo[widget
                                                                .storeIndex]
                                                            .items[index]
                                                            .schemeId!
                                                            .isNotEmpty &&
                                                        cartController
                                                                .cartListModel!
                                                                .storeVo[widget
                                                                    .storeIndex]
                                                                .items[index]
                                                                .schemeName !=
                                                            null &&
                                                        cartController
                                                            .cartListModel!
                                                            .storeVo[widget
                                                                .storeIndex]
                                                            .items[index]
                                                            .schemeName!
                                                            .isNotEmpty)
                                                    ? Obx(
                                                        () => CommonText(
                                                          content:
                                                              'Qty: ${(widget.cartController.finalQTYList[index].value).toStringAsFixed(0)}',
                                                          boldNess:
                                                              FontWeight.w500,
                                                          textColor: ColorsConst
                                                              .greyTextColor,
                                                          textSize:
                                                              width * 0.036,
                                                        ),
                                                      )
                                                    : CommonText(
                                                        content:
                                                            'Qty: ${((cartController.cartListModel!.storeVo[widget.storeIndex].items[index].quantity)).toStringAsFixed(0)}',
                                                        boldNess:
                                                            FontWeight.w500,
                                                        textColor: ColorsConst
                                                            .greyTextColor,
                                                        textSize: width * 0.036,
                                                      ),
                                                if (cartController
                                                            .cartListModel!
                                                            .storeVo[widget
                                                                .storeIndex]
                                                            .items[index]
                                                            .schemeId !=
                                                        null &&
                                                    cartController
                                                        .cartListModel!
                                                        .storeVo[
                                                            widget.storeIndex]
                                                        .items[index]
                                                        .schemeId!
                                                        .isNotEmpty)
                                                  Obx(
                                                    () => CommonText(
                                                      content:
                                                          '(${((widget.cartController.buyQTYList[index].value)).toStringAsFixed(2)} + ',
                                                      boldNess: FontWeight.w500,
                                                      textColor: ColorsConst
                                                          .greyTextColor,
                                                      textSize: width * 0.036,
                                                    ),
                                                  ),
                                                if (cartController
                                                            .cartListModel!
                                                            .storeVo[widget
                                                                .storeIndex]
                                                            .items[index]
                                                            .schemeId !=
                                                        null &&
                                                    cartController
                                                        .cartListModel!
                                                        .storeVo[
                                                            widget.storeIndex]
                                                        .items[index]
                                                        .schemeId!
                                                        .isNotEmpty)
                                                  Obx(
                                                    () => CommonText(
                                                      content:
                                                          '${((widget.cartController.freeQTYList[index].value)).toStringAsFixed(2)})',
                                                      boldNess: FontWeight.w500,
                                                      textColor: ColorsConst
                                                          .greyTextColor,
                                                      textSize: width * 0.036,
                                                    ),
                                                  )
                                              ],
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
                                                        CommonText(
                                                          content: "MRP",
                                                          textColor: ColorsConst
                                                              .notificationTextColor,
                                                          textSize: 14,
                                                          boldNess:
                                                              FontWeight.w600,
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                width * 0.015),
                                                        CommonText(
                                                          content:
                                                              "₹${(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].mrp ?? 0).toStringAsFixed(2)}",
                                                          textSize: 14,
                                                          boldNess:
                                                              FontWeight.w500,
                                                          textColor: ColorsConst
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
                                                              FontWeight.w600,
                                                          textSize: 14,
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                width * 0.015),
                                                        CommonText(
                                                          content:
                                                              "₹${(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].price ?? 0).toStringAsFixed(2)}",
                                                          textSize: 14,
                                                          boldNess:
                                                              FontWeight.w500,
                                                          textColor: ColorsConst
                                                              .notificationTextColor,
                                                        ),
                                                      ],
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
                                                            width:
                                                                width * 0.01),
                                                        CommonText(
                                                          content:
                                                              // "₹${((widget.items[index].price ?? 0) * (widget.items[index].buyQuantity ?? 0)).toStringAsFixed(2)}",
                                                              "₹${((cartController.cartListModel!.storeVo[widget.storeIndex].items[index].price ?? 0) * (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].buyQuantity)).toStringAsFixed(2)}",
                                                          textSize: 14,
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor: ColorsConst
                                                              .primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        CommonText(
                                                            content: "*",
                                                            // "${widget.cartController.cartListModel!.storeVo[0].items[index].stockAvailable}",
                                                            textSize: 14,
                                                            boldNess:
                                                                FontWeight.w600,
                                                            textColor:
                                                                // ColorsConst.primaryColor,
                                                                getStockStatusStarColor(cartController
                                                                        .cartListModel!
                                                                        .storeVo[widget
                                                                            .storeIndex]
                                                                        .items[
                                                                            index]
                                                                        .stockAvailable ??
                                                                    "")),
                                                        CommonText(
                                                            content:
                                                                // "₹${((widget.items[index].price ?? 0) * (widget.items[index].buyQuantity ?? 0)).toStringAsFixed(2)}",
                                                                getStockStatusText(cartController
                                                                        .cartListModel!
                                                                        .storeVo[widget
                                                                            .storeIndex]
                                                                        .items[
                                                                            index]
                                                                        .stockAvailable ??
                                                                    ""),
                                                            // "${widget.cartController.cartListModel!.storeVo[0].items[index].stockAvailable}",
                                                            textSize: 14,
                                                            boldNess:
                                                                FontWeight.w600,
                                                            textColor:
                                                                // ColorsConst.primaryColor,
                                                                getStockStatusTextColor(cartController
                                                                        .cartListModel!
                                                                        .storeVo[widget
                                                                            .storeIndex]
                                                                        .items[
                                                                            index]
                                                                        .stockAvailable ??
                                                                    "")),
                                                      ],
                                                    ),
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
                                              Obx(() => Expanded(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                        child: CommonText(
                                                            content: 'Qty:',
                                                            textColor: ColorsConst
                                                                .notificationTextColor,
                                                            textSize: 14,
                                                            boldNess: FontWeight
                                                                .w500),
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.02),
                                                      Container(
                                                        width: 59,
                                                        height: 21,
                                                        child: TextField(
                                                          onSubmitted:
                                                              (value) async {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            if (widget
                                                                .cartController
                                                                .isEditableQTYList[
                                                                    index]
                                                                .value) {
                                                              if (widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text
                                                                          .trim() !=
                                                                      '0' &&
                                                                  widget
                                                                      .cartController
                                                                      .qtyTextControllerList[
                                                                          index]
                                                                      .text
                                                                      .trim()
                                                                      .isNotEmpty) {
                                                                if (widget
                                                                    .cartController
                                                                    .isEditableQTYList[
                                                                        index]
                                                                    .value) {
                                                                  bool isProductHasScheme = (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null &&
                                                                      cartController
                                                                          .cartListModel!
                                                                          .storeVo[widget
                                                                              .storeIndex]
                                                                          .items[
                                                                              index]
                                                                          .schemeId!
                                                                          .isNotEmpty &&
                                                                      cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget
                                                                                  .storeIndex]
                                                                              .items[
                                                                                  index]
                                                                              .schemeName !=
                                                                          null &&
                                                                      cartController
                                                                          .cartListModel!
                                                                          .storeVo[widget
                                                                              .storeIndex]
                                                                          .items[
                                                                              index]
                                                                          .schemeName!
                                                                          .isNotEmpty);

                                                                  // Max Order Quantity Check Starts here
                                                                  if (gmcController
                                                                      .maxOrderQuantityCheckProductLevel
                                                                      .value) {
                                                                    if (isProductHasScheme) {
                                                                      if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity != null &&
                                                                          cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity !=
                                                                              0 &&
                                                                          widget.cartController.qtyTextControllerList[index].value !=
                                                                              "0" &&
                                                                          widget.cartController.finalQTYList[index].value >
                                                                              cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!) {
                                                                        CommonSnackBar.showError(
                                                                            "Max order quantity for this product is ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!.toStringAsFixed(0)}");
                                                                        return;
                                                                      }
                                                                    } else {
                                                                      if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity != null &&
                                                                          cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity !=
                                                                              0 &&
                                                                          widget.cartController.qtyTextControllerList[index].value !=
                                                                              "0" &&
                                                                          widget
                                                                              .cartController
                                                                              .qtyTextControllerList[
                                                                                  index]
                                                                              .text
                                                                              .trim()
                                                                              .isNotEmpty &&
                                                                          num.parse(widget.cartController.qtyTextControllerList[index].text.trim()) >
                                                                              cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!) {
                                                                        CommonSnackBar.showError(
                                                                            "Max order quantity for this product is ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!.toStringAsFixed(0)}");
                                                                        return;
                                                                      }
                                                                    }
                                                                  }
                                                                  // Max Order Quantity Check Ends here

                                                                  //to open popups enable this code - starts here
                                                                  if (cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget
                                                                                  .storeIndex]
                                                                              .items[
                                                                                  index]
                                                                              .stockAvailable ==
                                                                          "1" ||
                                                                      cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget.storeIndex]
                                                                              .items[index]
                                                                              .stockAvailable ==
                                                                          "2") {
                                                                    dynamic data = await buyController.checkProductQuantityAvailable(
                                                                        skuId: cartController.cartListModel!.storeVo[widget.storeIndex].items[index].skuId ??
                                                                            "",
                                                                        storeId: cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget.storeIndex]
                                                                            .storeId);

                                                                    num currentQuantity = (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId ==
                                                                            null)
                                                                        // ? widget
                                                                        //     .cartController
                                                                        //     .buyQTYList[
                                                                        //         index]
                                                                        //     .value
                                                                        ? num.parse(widget
                                                                            .cartController
                                                                            .qtyTextControllerList[
                                                                                index]
                                                                            .text)
                                                                        : widget
                                                                            .cartController
                                                                            .finalQTYList[index]
                                                                            .value;

                                                                    if (data ==
                                                                            null ||
                                                                        data["quantity"] ==
                                                                            null) {
                                                                      CommonSnackBar
                                                                          .showError(
                                                                              "Something went wrong");
                                                                      return;
                                                                    }

                                                                    if (currentQuantity >
                                                                        data[
                                                                            "quantity"]) {
                                                                      print(
                                                                          "avail qauntity checkProductQuantityAvailableData --> ${data["quantity"]}");
                                                                      if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId !=
                                                                              null &&
                                                                          cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget.storeIndex]
                                                                              .items[index]
                                                                              .schemeId!
                                                                              .isNotEmpty) {
                                                                        CommonSnackBar.showError(
                                                                            "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                                                                        return;
                                                                      } else {
                                                                        CommonSnackBar.showError(
                                                                            "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                                                                        return;
                                                                      }

                                                                      //scheme calculation starts here

                                                                      num totalQuantityToBeAllowed =
                                                                          0;
                                                                      num maxFreeQuantityToBeAllowed =
                                                                          0;
                                                                      num maxQuantityToBeAllowed =
                                                                          0;
                                                                      bool
                                                                          isAtleastOneFullSchemeAvailable =
                                                                          false;

                                                                      if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId !=
                                                                              null &&
                                                                          cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget.storeIndex]
                                                                              .items[index]
                                                                              .schemeId!
                                                                              .isNotEmpty) {
                                                                        print(
                                                                            "scheme calculation current quantity -> $currentQuantity");

                                                                        print(
                                                                            "scheme calculation scheme -> ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName}");

                                                                        String input = cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget.storeIndex]
                                                                            .items[index]
                                                                            .schemeName!;
                                                                        List<String>
                                                                            parts =
                                                                            input.split(" + ");
                                                                        int buyScheme =
                                                                            0;
                                                                        int freeScheme =
                                                                            0;

                                                                        if (parts.length ==
                                                                            2) {
                                                                          buyScheme =
                                                                              int.parse(parts[0]);
                                                                          freeScheme =
                                                                              int.parse(parts[1]);
                                                                        } else {
                                                                          print(
                                                                              "scheme calculation Invalid input format");
                                                                        }
                                                                        print(
                                                                            "scheme calculation scheme input -> ${parts}");
                                                                        print(
                                                                            "scheme calculation scheme buyScheme -> ${buyScheme}");
                                                                        print(
                                                                            "scheme calculation scheme freeScheme-> ${freeScheme}");

                                                                        num totalScheme =
                                                                            buyScheme +
                                                                                freeScheme;
                                                                        print(
                                                                            "scheme calculation total scheme -> ${parts}");

                                                                        print(
                                                                            "scheme calculation available quantity -> ${data["quantity"]}");

                                                                        num availableFullSchemeAdjustment =
                                                                            data["quantity"] /
                                                                                totalScheme;

                                                                        if (availableFullSchemeAdjustment <
                                                                            1) {
                                                                          isAtleastOneFullSchemeAvailable =
                                                                              false;
                                                                        } else {
                                                                          isAtleastOneFullSchemeAvailable =
                                                                              true;
                                                                        }

                                                                        print(
                                                                            "scheme calculation availableFullSchemeAdjustment -> ${availableFullSchemeAdjustment}");

                                                                        maxQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                                                                            ? availableFullSchemeAdjustment.floor() *
                                                                                buyScheme
                                                                            : 0;

                                                                        maxFreeQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                                                                            ? availableFullSchemeAdjustment.floor() *
                                                                                freeScheme
                                                                            : 0;

                                                                        totalQuantityToBeAllowed =
                                                                            maxFreeQuantityToBeAllowed +
                                                                                maxQuantityToBeAllowed;

                                                                        num quantityRemainingAfterFullSchemes =
                                                                            data["quantity"] -
                                                                                totalQuantityToBeAllowed;

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

                                                                        num calculatedHalfScheme =
                                                                            (buyScheme + freeScheme) /
                                                                                2;

                                                                        num convertedCalculatedHalfScheme =
                                                                            calculatedHalfScheme.ceil();

                                                                        bool
                                                                            isHalfSchemeApplicable =
                                                                            quantityRemainingAfterFullSchemes >=
                                                                                convertedCalculatedHalfScheme;

                                                                        if (isAtleastOneFullSchemeAvailable ==
                                                                                false &&
                                                                            isHalfSchemeApplicable) {
                                                                          isAtleastOneFullSchemeAvailable =
                                                                              true;
                                                                        }

                                                                        if (isHalfSchemeApplicable) {
                                                                          totalQuantityToBeAllowed =
                                                                              totalQuantityToBeAllowed + convertedCalculatedHalfScheme;

                                                                          maxQuantityToBeAllowed =
                                                                              maxQuantityToBeAllowed + (calculatedHalfScheme < convertedCalculatedHalfScheme ? (buyScheme / 2) + 0.5 : buyScheme / 2);

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

                                                                      bool
                                                                          isMaxTimeStopNeeded =
                                                                          API.needMaxTimeStopFunctionality;
                                                                      bool isTimePassed = isMaxTimeStopNeeded
                                                                          ? await isAfterDynamicTime()
                                                                          : false;

                                                                      print(
                                                                          "printing is time passed or not --> $isTimePassed");

                                                                      Get.dialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        WillPopScope(
                                                                          onWillPop:
                                                                              () async {
                                                                            buyController.partialOrLaterDelivery =
                                                                                "";
                                                                            buyController.update();
                                                                            return true;
                                                                          },
                                                                          child:
                                                                              Dialog(
                                                                            insetPadding:
                                                                                EdgeInsets.all(0),
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            shape:
                                                                                const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            backgroundColor:
                                                                                AppColors.appWhite,
                                                                            child:
                                                                                Container(
                                                                              width: double.infinity,
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: GetBuilder<NrBuyController>(
                                                                                builder: (controller) {
                                                                                  bool isSchemeProduct = (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty);
                                                                                  if (isSchemeProduct && !isAtleastOneFullSchemeAvailable && !gmcController.popup2ndOptionNeededB2B) {
                                                                                    return SingleChildScrollView(
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          CommonText(
                                                                                            content: gmcController.atleastOneSchemeNotApplicableCartText,
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
                                                                                            content: cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty
                                                                                                ? isAtleastOneFullSchemeAvailable
                                                                                                    ? "Choose delivery option"
                                                                                                    : ""
                                                                                                //? "The requested quantity exceeds available stock (${data["quantity"].round()}). Please adjust the quantity within the available limit to get delivery today or you can choose full delivery tomorrow option"
                                                                                                : "Choose delivery option",
                                                                                            textSize: width * 0.04,
                                                                                            textColor: AppColors.appblack,
                                                                                            boldNess: FontWeight.w500,
                                                                                            textAlign: TextAlign.center,
                                                                                          ),
                                                                                        ),
                                                                                        cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty
                                                                                            ? isAtleastOneFullSchemeAvailable
                                                                                                ? SizedBox(height: height * 0.03)
                                                                                                : SizedBox()
                                                                                            : (isSchemeProduct ? totalQuantityToBeAllowed < 1 : data["quantity"] < 1)
                                                                                                ? SizedBox()
                                                                                                : SizedBox(
                                                                                                    height: height * 0.03,
                                                                                                  ),
                                                                                        // if (!isTimePassed)
                                                                                        cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && !isAtleastOneFullSchemeAvailable
                                                                                            ? SizedBox()
                                                                                            : (isSchemeProduct ? totalQuantityToBeAllowed < 1 : data["quantity"] < 1)
                                                                                                ? SizedBox()
                                                                                                : GestureDetector(
                                                                                                    onTap: () {
                                                                                                      // if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty) {
                                                                                                      //   controller.partialOrLaterDelivery = "N";
                                                                                                      // } else {
                                                                                                      //   controller.partialOrLaterDelivery = "P";
                                                                                                      // }

                                                                                                      controller.partialOrLaterDelivery = "N";

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
                                                                                                              color: controller.partialOrLaterDelivery == "P" || controller.partialOrLaterDelivery == "N" ? AppColors.appblack : AppColors.appWhite,
                                                                                                              shape: BoxShape.circle,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 10,
                                                                                                        ),
                                                                                                        Expanded(
                                                                                                          child: CommonText(
                                                                                                            content: (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty)
                                                                                                                ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                                                                                                // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                                                                                                : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                                                                                            textSize: width * 0.035,
                                                                                                            textColor: AppColors.appblack,
                                                                                                            boldNess: FontWeight.w500,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                        if (gmcController.popup2ndOptionNeededB2B)
                                                                                          cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && !isAtleastOneFullSchemeAvailable
                                                                                              ? SizedBox()
                                                                                              : SizedBox(
                                                                                                  height: 20,
                                                                                                ),
                                                                                        if (gmcController.popup2ndOptionNeededB2B)
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              controller.partialOrLaterDelivery = "Y";
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
                                                                                                      color: controller.partialOrLaterDelivery == "Y" ? AppColors.appblack : AppColors.appWhite,
                                                                                                      shape: BoxShape.circle,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: CommonText(
                                                                                                    content: (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty) ? '${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${(widget.cartController.finalQTYList[index].value).toStringAsFixed(0)} (${((widget.cartController.buyQTYList[index].value)).toStringAsFixed(2)} + ${((widget.cartController.freeQTYList[index].value)).toStringAsFixed(2)}) Quantity' : "${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${widget.cartController.qtyTextControllerList[index].text} Quantity",
                                                                                                    textSize: width * 0.035,
                                                                                                    textColor: AppColors.appblack,
                                                                                                    boldNess: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        SizedBox(height: height * 0.03),
                                                                                        Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent, side: const BorderSide(color: AppColors.appblack)),
                                                                                                onPressed: () {
                                                                                                  controller.partialOrLaterDelivery = "";
                                                                                                  controller.update();
                                                                                                  // Get.back();

                                                                                                  for (int i = 0; i < 4; i++) {
                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      print("printing get currrent loop -> $i");
                                                                                                      Get.back();
                                                                                                    }
                                                                                                  }
                                                                                                },
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                                                                                  if (controller.partialOrLaterDelivery == "") {
                                                                                                    CommonSnackBar.showError("Please select the option to proceed");
                                                                                                    return;
                                                                                                  }

                                                                                                  // body[0]["laterDelivery"] = controller.partialOrLaterDelivery;

                                                                                                  // print("printing body in get dialog ---> ${body}");

                                                                                                  // controller.getAddToCartApi(body, searchProduct.storeId).then(
                                                                                                  //   (value) {
                                                                                                  //     print("printing getAddToCartApi return value ---> $value");
                                                                                                  //     CommonSnackBar.showToast('Added to Cart', context);
                                                                                                  //     controller.qtyTextControllerList[index].clear();
                                                                                                  //     controller.qtyList[index].value = 0;

                                                                                                  //     controller.finalQTYList[index].value = 0;
                                                                                                  //     controller.freeQTYList[index].value = 0;
                                                                                                  //     controller.buyQTYList[index].value = 0;
                                                                                                  //     controller.update();
                                                                                                  //     final cartController = Get.put(CartController());
                                                                                                  //     cartController.getVerifiedProductDataApi();
                                                                                                  //     print("value>>>>>>>>>>>>>>$value");
                                                                                                  //   },
                                                                                                  // );

                                                                                                  cartController.cartListModel?.storeVo[0].items[index].quantity = double.parse(widget.cartController.qtyTextControllerList[index].text);
                                                                                                  // cartController.finalQTYList[index].value = double.parse(widget.cartController.qtyTextControllerList[index].text);
                                                                                                  cartController.update();
                                                                                                  setState(() {});

                                                                                                  if (cartController.cartListModel?.storeVo[0].items[index].schemeId != null && widget.items[index].schemeId!.isNotEmpty && widget.items[index].schemeName != null && widget.items[index].schemeName!.isNotEmpty && controller.partialOrLaterDelivery == "N") {
                                                                                                    await widget.cartController.getSchemeQty(index: index, schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ?? "", schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ?? "", addBuyQty: maxQuantityToBeAllowed, quantity: maxQuantityToBeAllowed, addFreeQty: maxFreeQuantityToBeAllowed, addFinalQty: 0);
                                                                                                    widget.cartController.qtyTextControllerList[index].text = '${maxQuantityToBeAllowed.floor()}';
                                                                                                    widget.cartController.buyQTYList[index].value = maxQuantityToBeAllowed.toDouble();
                                                                                                  }

                                                                                                  if (!(cartController.cartListModel?.storeVo[0].items[index].schemeId != null && widget.items[index].schemeId!.isNotEmpty && widget.items[index].schemeName != null && widget.items[index].schemeName!.isNotEmpty) && controller.partialOrLaterDelivery == "N") {
                                                                                                    // await widget.cartController.getSchemeQty(index: index, schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ?? "", schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ?? "", addBuyQty: widget.cartController.buyQTYList[index].value, quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty) ? 0 : num.parse(widget.cartController.qtyTextControllerList[index].text), addFreeQty: widget.cartController.freeQTYList[index].value, addFinalQty: widget.cartController.finalQTYList[index].value);

                                                                                                    widget.cartController.qtyTextControllerList[index].text = '${data["quantity"].toStringAsFixed(0)}';
                                                                                                  }

                                                                                                  if (widget.cartController.userId.value.isNotEmpty) {
                                                                                                    var bodyMap = {
                                                                                                      "userId": widget.cartController.userId.value,
                                                                                                      "productId": cartController.cartListModel!.storeVo[widget.storeIndex].items[index].productId ?? '',
                                                                                                      "skuId": cartController.cartListModel!.storeVo[widget.storeIndex].items[index].skuId,
                                                                                                      "storeId": widget.storeId,
                                                                                                      // "schemeId":widget.items[index].schemeId,
                                                                                                      // "schemeName":widget.items[index].schemeName,
                                                                                                      "buyQuantity": (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty)
                                                                                                          ? widget.cartController.buyQTYList[index].value
                                                                                                          : controller.partialOrLaterDelivery == "N"
                                                                                                              ? data["quantity"].toInt()
                                                                                                              : widget.cartController.qtyTextControllerList[index].text,
                                                                                                      "quantity": !(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty) && controller.partialOrLaterDelivery == "N" ? data["quantity"].toInt() : int.tryParse(widget.cartController.qtyTextControllerList[index].text),
                                                                                                      "finalQuantity": !(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty) ? 0.0 : widget.cartController.finalQTYList[index].value,
                                                                                                      "freeQuantity": widget.cartController.freeQTYList[index].value,
                                                                                                      "laterDelivery": buyController.partialOrLaterDelivery == "" ? "N" : buyController.partialOrLaterDelivery,
                                                                                                      "timePassed": isTimePassed ? "Y" : "N"
                                                                                                    };
                                                                                                    print('update qty param tick --> ${jsonEncode(bodyMap)}');

                                                                                                    await widget.cartController.getQtyPlushAddToCartApi(bodyMap);
                                                                                                    widget.cartController.isEditableQTYList[index].value = false;
                                                                                                    // widget
                                                                                                    //     .cartController
                                                                                                    //     .totalPriceGet(cartController
                                                                                                    //             .cartListModel
                                                                                                    //             ?.storeVo[
                                                                                                    //                 0]
                                                                                                    //             .items ??
                                                                                                    //         []);

                                                                                                    await widget.cartController.getVerifiedProductDataApi();

                                                                                                    widget.cartController.totalPriceGet(cartController.cartListModel?.storeVo[0].items ?? []);

                                                                                                    CommonSnackBar.showToast('QTY Updated', context);
                                                                                                  } else if (!Get.isDialogOpen!) {
                                                                                                    Get.dialog(const LoginDialog());
                                                                                                  }

                                                                                                  for (int i = 0; i < 4; i++) {
                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      print("printing get currrent loop -> $i");
                                                                                                      Get.back();
                                                                                                    }
                                                                                                  }

                                                                                                  // Get.back();
                                                                                                },
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                                                                                  child: CommonText(
                                                                                                    // content: "Add To Cart in tick",
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
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );

                                                                      buyController
                                                                          .partialOrLaterDelivery = "";
                                                                      buyController
                                                                          .update();
                                                                      return;
                                                                    }
                                                                  }
                                                                  //to open popups enable this code - starts here

                                                                  cartController
                                                                          .cartListModel
                                                                          ?.storeVo[
                                                                              0]
                                                                          .items[
                                                                              index]
                                                                          .quantity =
                                                                      double.parse(widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text);
                                                                  cartController
                                                                      .update();
                                                                  widget
                                                                          .items[
                                                                              index]
                                                                          .quantity =
                                                                      double.parse(widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text);
                                                                  cartController
                                                                          .finalQTYList[
                                                                              index]
                                                                          .value =
                                                                      double.parse(widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text);
                                                                  cartController
                                                                      .update();
                                                                  setState(
                                                                      () {});

                                                                  // if (widget.items[index].schemeId != null &&
                                                                  //     widget
                                                                  //         .items[
                                                                  //             index]
                                                                  //         .schemeId!
                                                                  //         .isNotEmpty &&
                                                                  //     widget.items[index].schemeName !=
                                                                  //         null &&
                                                                  //     widget
                                                                  //         .items[
                                                                  //             index]
                                                                  //         .schemeName!
                                                                  //         .isNotEmpty) {
                                                                  //   await widget.cartController.getSchemeQty(
                                                                  //       index:
                                                                  //           index,
                                                                  //       schemeId: widget.items[index].schemeId ??
                                                                  //           "",
                                                                  //       schemeName: widget.items[index].schemeName ??
                                                                  //           "",
                                                                  //       addBuyQty: widget
                                                                  //           .cartController
                                                                  //           .buyQTYList[
                                                                  //               index]
                                                                  //           .value,
                                                                  //       quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty)
                                                                  //           ? 0
                                                                  //           : num.parse(widget
                                                                  //               .cartController
                                                                  //               .qtyTextControllerList[
                                                                  //                   index]
                                                                  //               .text),
                                                                  //       addFreeQty: widget
                                                                  //           .cartController
                                                                  //           .freeQTYList[
                                                                  //               index]
                                                                  //           .value,
                                                                  //       addFinalQty: widget
                                                                  //           .cartController
                                                                  //           .finalQTYList[index]
                                                                  //           .value);
                                                                  // }
                                                                  if (cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget
                                                                                  .storeIndex]
                                                                              .items[
                                                                                  index]
                                                                              .schemeId !=
                                                                          null &&
                                                                      cartController
                                                                          .cartListModel!
                                                                          .storeVo[widget
                                                                              .storeIndex]
                                                                          .items[
                                                                              index]
                                                                          .schemeId!
                                                                          .isNotEmpty &&
                                                                      cartController
                                                                              .cartListModel
                                                                              ?.storeVo[
                                                                                  0]
                                                                              .items[
                                                                                  index]
                                                                              .schemeName !=
                                                                          null &&
                                                                      cartController
                                                                          .cartListModel!
                                                                          .storeVo[widget
                                                                              .storeIndex]
                                                                          .items[
                                                                              index]
                                                                          .schemeName!
                                                                          .isNotEmpty) {
                                                                    await widget.cartController.getSchemeQty(
                                                                        index:
                                                                            index,
                                                                        schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ??
                                                                            "",
                                                                        schemeName:
                                                                            cartController.cartListModel?.storeVo[0].items[index].schemeName ??
                                                                                "",
                                                                        addBuyQty: widget
                                                                            .cartController
                                                                            .buyQTYList[
                                                                                index]
                                                                            .value,
                                                                        quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty)
                                                                            ? 0
                                                                            : num.parse(widget
                                                                                .cartController
                                                                                .qtyTextControllerList[
                                                                                    index]
                                                                                .text),
                                                                        addFreeQty: widget
                                                                            .cartController
                                                                            .freeQTYList[
                                                                                index]
                                                                            .value,
                                                                        addFinalQty: widget
                                                                            .cartController
                                                                            .finalQTYList[index]
                                                                            .value);
                                                                  }
                                                                  if (widget
                                                                      .cartController
                                                                      .userId
                                                                      .value
                                                                      .isNotEmpty) {
                                                                    bool
                                                                        isMaxTimeStopNeededInMain =
                                                                        API.needMaxTimeStopFunctionality;
                                                                    bool
                                                                        isTimePassedInMain =
                                                                        isMaxTimeStopNeededInMain
                                                                            ? await isAfterDynamicTime()
                                                                            : false;
                                                                    var bodyMap =
                                                                        {
                                                                      "userId": widget
                                                                          .cartController
                                                                          .userId
                                                                          .value,
                                                                      "productId": cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget.storeIndex]
                                                                              .items[index]
                                                                              .productId ??
                                                                          '',
                                                                      "skuId": cartController
                                                                          .cartListModel!
                                                                          .storeVo[widget
                                                                              .storeIndex]
                                                                          .items[
                                                                              index]
                                                                          .skuId,
                                                                      "storeId":
                                                                          widget
                                                                              .storeId,
                                                                      // "schemeId":widget.items[index].schemeId,
                                                                      // "schemeName":widget.items[index].schemeName,
                                                                      "buyQuantity": (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty)
                                                                          ? widget
                                                                              .cartController
                                                                              .buyQTYList[
                                                                                  index]
                                                                              .value
                                                                          : widget
                                                                              .cartController
                                                                              .qtyTextControllerList[index]
                                                                              .text,
                                                                      "quantity": widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text,
                                                                      "finalQuantity": widget
                                                                          .cartController
                                                                          .finalQTYList[
                                                                              index]
                                                                          .value,
                                                                      "freeQuantity": widget
                                                                          .cartController
                                                                          .freeQTYList[
                                                                              index]
                                                                          .value,
                                                                      "laterDelivery": cartController.cartListModel!.storeVo[widget.storeIndex].items[index].stockAvailable ==
                                                                              "1"
                                                                          ? "N"
                                                                          : "Y",
                                                                      // isTimePassedInMain
                                                                      //     ? "Y"
                                                                      //     : "N",
                                                                      "timePassed":
                                                                          isTimePassedInMain
                                                                              ? "Y"
                                                                              : "N"
                                                                    };
                                                                    print(
                                                                        'update qty param --> ${jsonEncode(bodyMap)}');
                                                                    await widget
                                                                        .cartController
                                                                        .getQtyPlushAddToCartApi(
                                                                            bodyMap);
                                                                    widget
                                                                        .cartController
                                                                        .isEditableQTYList[
                                                                            index]
                                                                        .value = false;
                                                                    // widget
                                                                    //     .cartController
                                                                    //     .totalPriceGet(cartController
                                                                    //             .cartListModel
                                                                    //             ?.storeVo[
                                                                    //                 0]
                                                                    //             .items ??
                                                                    //         []);

                                                                    await widget
                                                                        .cartController
                                                                        .getVerifiedProductDataApi();

                                                                    widget.cartController.totalPriceGet(cartController
                                                                            .cartListModel
                                                                            ?.storeVo[0]
                                                                            .items ??
                                                                        []);

                                                                    CommonSnackBar.showToast(
                                                                        'QTY Updated',
                                                                        context);
                                                                  } else if (!Get
                                                                      .isDialogOpen!) {
                                                                    Get.dialog(
                                                                        const LoginDialog());
                                                                  }
                                                                }
                                                              } else if (widget
                                                                      .cartController
                                                                      .qtyTextControllerList[
                                                                          index]
                                                                      .text
                                                                      .trim() ==
                                                                  '0') {
                                                                CommonSnackBar
                                                                    .showToast(
                                                                  'Quantity should not be 0',
                                                                  context,
                                                                  showTickMark:
                                                                      false,
                                                                  width: 220,
                                                                );
                                                              } else if (widget
                                                                  .cartController
                                                                  .qtyTextControllerList[
                                                                      index]
                                                                  .text
                                                                  .trim()
                                                                  .isEmpty) {
                                                                CommonSnackBar
                                                                    .showToast(
                                                                  'Please enter quantity',
                                                                  context,
                                                                  showTickMark:
                                                                      false,
                                                                  width: 200,
                                                                );
                                                              }
                                                            } else {
                                                              widget
                                                                  .cartController
                                                                  .isEditableQTYList[
                                                                      index]
                                                                  .value = true;
                                                            }
                                                          },
                                                          enabled: widget
                                                              .cartController
                                                              .isEditableQTYList[
                                                                  index]
                                                              .value,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLength: 4,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.04),
                                                          controller: widget
                                                                  .cartController
                                                                  .qtyTextControllerList[
                                                              index],
                                                          onChanged:
                                                              (value) async {
                                                            if (cartController
                                                                        .cartListModel
                                                                        ?.storeVo[
                                                                            0]
                                                                        .items[
                                                                            index]
                                                                        .schemeId !=
                                                                    null &&
                                                                widget
                                                                    .items[
                                                                        index]
                                                                    .schemeId!
                                                                    .isNotEmpty &&
                                                                widget
                                                                        .items[
                                                                            index]
                                                                        .schemeName !=
                                                                    null &&
                                                                widget
                                                                    .items[
                                                                        index]
                                                                    .schemeName!
                                                                    .isNotEmpty) {
                                                              await widget.cartController.getSchemeQty(
                                                                  index: index,
                                                                  schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ??
                                                                      "",
                                                                  schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ??
                                                                      "",
                                                                  addBuyQty: widget
                                                                      .cartController
                                                                      .buyQTYList[
                                                                          index]
                                                                      .value,
                                                                  quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty)
                                                                      ? 0
                                                                      : num.parse(widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text),
                                                                  addFreeQty: widget
                                                                      .cartController
                                                                      .freeQTYList[
                                                                          index]
                                                                      .value,
                                                                  addFinalQty: widget
                                                                      .cartController
                                                                      .finalQTYList[index]
                                                                      .value);
                                                            }
                                                            ;
                                                          },
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: ''
                                                                '',
                                                            border:
                                                                UnderlineInputBorder(),
                                                            hintStyle:
                                                                GoogleFonts
                                                                    .poppins(
                                                              color: ColorsConst
                                                                  .semiGreyColor,
                                                            ),
                                                            hintText:
                                                                "Quantity",
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    top: 2,
                                                                    bottom: 10),
                                                            disabledBorder:
                                                                const UnderlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.02),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          print(
                                                              "this is called when button clicked");

                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          if (widget
                                                              .cartController
                                                              .isEditableQTYList[
                                                                  index]
                                                              .value) {
                                                            if (widget
                                                                        .cartController
                                                                        .qtyTextControllerList[
                                                                            index]
                                                                        .text
                                                                        .trim() !=
                                                                    '0' &&
                                                                widget
                                                                    .cartController
                                                                    .qtyTextControllerList[
                                                                        index]
                                                                    .text
                                                                    .trim()
                                                                    .isNotEmpty) {
                                                              if (widget
                                                                  .cartController
                                                                  .isEditableQTYList[
                                                                      index]
                                                                  .value) {
                                                                print(
                                                                    "submit clicked inside");

                                                                bool isProductHasScheme = (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null &&
                                                                    cartController
                                                                        .cartListModel!
                                                                        .storeVo[widget
                                                                            .storeIndex]
                                                                        .items[
                                                                            index]
                                                                        .schemeId!
                                                                        .isNotEmpty &&
                                                                    cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget
                                                                                .storeIndex]
                                                                            .items[
                                                                                index]
                                                                            .schemeName !=
                                                                        null &&
                                                                    cartController
                                                                        .cartListModel!
                                                                        .storeVo[widget
                                                                            .storeIndex]
                                                                        .items[
                                                                            index]
                                                                        .schemeName!
                                                                        .isNotEmpty);

                                                                // Max Order Quantity Check Starts here
                                                                if (gmcController
                                                                    .maxOrderQuantityCheckProductLevel
                                                                    .value) {
                                                                  if (isProductHasScheme) {
                                                                    if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity != null &&
                                                                        cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity !=
                                                                            0 &&
                                                                        widget.cartController.qtyTextControllerList[index].value !=
                                                                            "0" &&
                                                                        widget.cartController.finalQTYList[index].value >
                                                                            cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!) {
                                                                      CommonSnackBar
                                                                          .showError(
                                                                              "Max order quantity for this product is ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!.toStringAsFixed(0)}");
                                                                      return;
                                                                    }
                                                                  } else {
                                                                    if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity != null &&
                                                                        cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity !=
                                                                            0 &&
                                                                        widget.cartController.qtyTextControllerList[index].value !=
                                                                            "0" &&
                                                                        widget
                                                                            .cartController
                                                                            .qtyTextControllerList[
                                                                                index]
                                                                            .text
                                                                            .trim()
                                                                            .isNotEmpty &&
                                                                        num.parse(widget.cartController.qtyTextControllerList[index].text.trim()) >
                                                                            cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!) {
                                                                      CommonSnackBar
                                                                          .showError(
                                                                              "Max order quantity for this product is ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].maxOrderQuantity!.toStringAsFixed(0)}");
                                                                      return;
                                                                    }
                                                                  }
                                                                }
                                                                // Max Order Quantity Check Ends here

                                                                //to open popups enable this code - starts here
                                                                if (cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget
                                                                                .storeIndex]
                                                                            .items[
                                                                                index]
                                                                            .stockAvailable ==
                                                                        "1" ||
                                                                    cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget.storeIndex]
                                                                            .items[index]
                                                                            .stockAvailable ==
                                                                        "2") {
                                                                  dynamic data = await buyController.checkProductQuantityAvailable(
                                                                      skuId: cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget
                                                                                  .storeIndex]
                                                                              .items[
                                                                                  index]
                                                                              .skuId ??
                                                                          "",
                                                                      storeId: cartController
                                                                          .cartListModel!
                                                                          .storeVo[
                                                                              widget.storeIndex]
                                                                          .storeId);

                                                                  num currentQuantity = (cartController
                                                                              .cartListModel!
                                                                              .storeVo[widget
                                                                                  .storeIndex]
                                                                              .items[
                                                                                  index]
                                                                              .schemeId ==
                                                                          null)
                                                                      // ? widget
                                                                      //     .cartController
                                                                      //     .buyQTYList[
                                                                      //         index]
                                                                      //     .value
                                                                      ? num.parse(widget
                                                                          .cartController
                                                                          .qtyTextControllerList[
                                                                              index]
                                                                          .text)
                                                                      : widget
                                                                          .cartController
                                                                          .finalQTYList[
                                                                              index]
                                                                          .value;

                                                                  if (data ==
                                                                          null ||
                                                                      data["quantity"] ==
                                                                          null) {
                                                                    CommonSnackBar
                                                                        .showError(
                                                                            "Something went wrong");
                                                                    return;
                                                                  }

                                                                  if (currentQuantity >
                                                                      data[
                                                                          "quantity"]) {
                                                                    print(
                                                                        "avail qauntity checkProductQuantityAvailableData --> ${data["quantity"]}");
                                                                    if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId !=
                                                                            null &&
                                                                        cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget.storeIndex]
                                                                            .items[index]
                                                                            .schemeId!
                                                                            .isNotEmpty) {
                                                                      CommonSnackBar
                                                                          .showError(
                                                                              "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                                                                      return;
                                                                    } else {
                                                                      CommonSnackBar
                                                                          .showError(
                                                                              "Maximum allowed quantity for this product is ${data["quantity"].round()}");

                                                                      return;
                                                                    }

                                                                    //scheme calculation starts here

                                                                    num totalQuantityToBeAllowed =
                                                                        0;
                                                                    num maxFreeQuantityToBeAllowed =
                                                                        0;
                                                                    num maxQuantityToBeAllowed =
                                                                        0;
                                                                    bool
                                                                        isAtleastOneFullSchemeAvailable =
                                                                        false;

                                                                    if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId !=
                                                                            null &&
                                                                        cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget.storeIndex]
                                                                            .items[index]
                                                                            .schemeId!
                                                                            .isNotEmpty) {
                                                                      print(
                                                                          "scheme calculation current quantity -> $currentQuantity");

                                                                      print(
                                                                          "scheme calculation scheme -> ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName}");

                                                                      String input = cartController
                                                                          .cartListModel!
                                                                          .storeVo[widget
                                                                              .storeIndex]
                                                                          .items[
                                                                              index]
                                                                          .schemeName!;
                                                                      List<String>
                                                                          parts =
                                                                          input.split(
                                                                              " + ");
                                                                      int buyScheme =
                                                                          0;
                                                                      int freeScheme =
                                                                          0;

                                                                      if (parts
                                                                              .length ==
                                                                          2) {
                                                                        buyScheme =
                                                                            int.parse(parts[0]);
                                                                        freeScheme =
                                                                            int.parse(parts[1]);
                                                                      } else {
                                                                        print(
                                                                            "scheme calculation Invalid input format");
                                                                      }
                                                                      print(
                                                                          "scheme calculation scheme input -> ${parts}");
                                                                      print(
                                                                          "scheme calculation scheme buyScheme -> ${buyScheme}");
                                                                      print(
                                                                          "scheme calculation scheme freeScheme-> ${freeScheme}");

                                                                      num totalScheme =
                                                                          buyScheme +
                                                                              freeScheme;
                                                                      print(
                                                                          "scheme calculation total scheme -> ${parts}");

                                                                      print(
                                                                          "scheme calculation available quantity -> ${data["quantity"]}");

                                                                      num availableFullSchemeAdjustment =
                                                                          data["quantity"] /
                                                                              totalScheme;

                                                                      if (availableFullSchemeAdjustment <
                                                                          1) {
                                                                        isAtleastOneFullSchemeAvailable =
                                                                            false;
                                                                      } else {
                                                                        isAtleastOneFullSchemeAvailable =
                                                                            true;
                                                                      }

                                                                      print(
                                                                          "scheme calculation availableFullSchemeAdjustment -> ${availableFullSchemeAdjustment}");

                                                                      maxQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                                                                          ? availableFullSchemeAdjustment.floor() *
                                                                              buyScheme
                                                                          : 0;

                                                                      maxFreeQuantityToBeAllowed = isAtleastOneFullSchemeAvailable
                                                                          ? availableFullSchemeAdjustment.floor() *
                                                                              freeScheme
                                                                          : 0;

                                                                      totalQuantityToBeAllowed =
                                                                          maxFreeQuantityToBeAllowed +
                                                                              maxQuantityToBeAllowed;

                                                                      num quantityRemainingAfterFullSchemes =
                                                                          data["quantity"] -
                                                                              totalQuantityToBeAllowed;

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

                                                                      num calculatedHalfScheme =
                                                                          (buyScheme + freeScheme) /
                                                                              2;

                                                                      num convertedCalculatedHalfScheme =
                                                                          calculatedHalfScheme
                                                                              .ceil();

                                                                      bool
                                                                          isHalfSchemeApplicable =
                                                                          quantityRemainingAfterFullSchemes >=
                                                                              convertedCalculatedHalfScheme;

                                                                      if (isAtleastOneFullSchemeAvailable ==
                                                                              false &&
                                                                          isHalfSchemeApplicable) {
                                                                        isAtleastOneFullSchemeAvailable =
                                                                            true;
                                                                      }

                                                                      if (isHalfSchemeApplicable) {
                                                                        totalQuantityToBeAllowed =
                                                                            totalQuantityToBeAllowed +
                                                                                convertedCalculatedHalfScheme;

                                                                        maxQuantityToBeAllowed = maxQuantityToBeAllowed +
                                                                            (calculatedHalfScheme < convertedCalculatedHalfScheme
                                                                                ? (buyScheme / 2) + 0.5
                                                                                : buyScheme / 2);

                                                                        maxFreeQuantityToBeAllowed =
                                                                            maxFreeQuantityToBeAllowed +
                                                                                (freeScheme / 2);
                                                                      }

                                                                      print(
                                                                          "scheme calculation isHalfSchemeApplicable -> ${isHalfSchemeApplicable}");

                                                                      print(
                                                                          "scheme calculation calculatedHalfScheme -> ${calculatedHalfScheme}");

                                                                      print(
                                                                          "scheme calculation convertedCalculatedHalfScheme -> ${convertedCalculatedHalfScheme}");
                                                                    }

                                                                    //scheme calculation ends here

                                                                    bool
                                                                        isMaxTimeStopNeeded =
                                                                        API.needMaxTimeStopFunctionality;
                                                                    bool
                                                                        isTimePassed =
                                                                        isMaxTimeStopNeeded
                                                                            ? await isAfterDynamicTime()
                                                                            : false;

                                                                    print(
                                                                        "printing is time passed or not --> $isTimePassed");

                                                                    Get.dialog(
                                                                      barrierDismissible:
                                                                          false,
                                                                      WillPopScope(
                                                                        onWillPop:
                                                                            () async {
                                                                          buyController.partialOrLaterDelivery =
                                                                              "";
                                                                          buyController
                                                                              .update();
                                                                          return true;
                                                                        },
                                                                        child:
                                                                            Dialog(
                                                                          shape:
                                                                              const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(10),
                                                                            ),
                                                                          ),
                                                                          insetPadding:
                                                                              EdgeInsets.all(0),
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          backgroundColor:
                                                                              AppColors.appWhite,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            child:
                                                                                GetBuilder<NrBuyController>(
                                                                              builder: (controller) {
                                                                                bool isSchemeProduct = (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty);
                                                                                print("printing data quanitty -> ${data["quantity"]} , ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId}  ${cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId} ");

                                                                                if (isSchemeProduct && !isAtleastOneFullSchemeAvailable && !gmcController.popup2ndOptionNeededB2B) {
                                                                                  return SingleChildScrollView(
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        CommonText(
                                                                                          content: gmcController.atleastOneSchemeNotApplicableCartText,
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
                                                                                          content: cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty
                                                                                              ? isAtleastOneFullSchemeAvailable
                                                                                                  ? "Choose delivery option"
                                                                                                  : ""
                                                                                              //? "The requested quantity exceeds available stock (${data["quantity"].round()}). Please adjust the quantity within the available limit to get delivery today or you can choose full delivery tomorrow option"
                                                                                              : "Choose delivery option",
                                                                                          textSize: width * 0.04,
                                                                                          textColor: AppColors.appblack,
                                                                                          boldNess: FontWeight.w500,
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                      cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty
                                                                                          ? isAtleastOneFullSchemeAvailable
                                                                                              ? SizedBox(height: height * 0.03)
                                                                                              : SizedBox()
                                                                                          : (isSchemeProduct ? totalQuantityToBeAllowed < 1 : data["quantity"] < 1)
                                                                                              ? SizedBox()
                                                                                              : SizedBox(
                                                                                                  height: height * 0.03,
                                                                                                ),
                                                                                      // if (!isTimePassed)
                                                                                      cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && !isAtleastOneFullSchemeAvailable && data["quantity"] > 1
                                                                                          ? SizedBox()
                                                                                          : (isSchemeProduct ? totalQuantityToBeAllowed < 1 : data["quantity"] < 1)
                                                                                              ? SizedBox()
                                                                                              : GestureDetector(
                                                                                                  onTap: () {
                                                                                                    // if (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty) {
                                                                                                    //   controller.partialOrLaterDelivery = "N";
                                                                                                    // } else {
                                                                                                    //   controller.partialOrLaterDelivery = "P";
                                                                                                    // }

                                                                                                    controller.partialOrLaterDelivery = "N";

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
                                                                                                            color: controller.partialOrLaterDelivery == "P" || controller.partialOrLaterDelivery == "N" ? AppColors.appblack : AppColors.appWhite,
                                                                                                            shape: BoxShape.circle,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 10,
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                        child: CommonText(
                                                                                                          content: (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty)
                                                                                                              ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                                                                                              // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                                                                                              : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                                                                                          textSize: width * 0.035,
                                                                                                          textColor: AppColors.appblack,
                                                                                                          boldNess: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                      if (gmcController.popup2ndOptionNeededB2B)
                                                                                        cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && !isAtleastOneFullSchemeAvailable
                                                                                            ? SizedBox()
                                                                                            : SizedBox(
                                                                                                height: 20,
                                                                                              ),
                                                                                      if (gmcController.popup2ndOptionNeededB2B)
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            controller.partialOrLaterDelivery = "Y";
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
                                                                                                    color: controller.partialOrLaterDelivery == "Y" ? AppColors.appblack : AppColors.appWhite,
                                                                                                    shape: BoxShape.circle,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 10,
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: CommonText(
                                                                                                  content: (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty) ? '${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${(widget.cartController.finalQTYList[index].value).toStringAsFixed(0)} (${((widget.cartController.buyQTYList[index].value)).toStringAsFixed(2)} + ${((widget.cartController.freeQTYList[index].value)).toStringAsFixed(2)}) Quantity' : "${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${widget.cartController.qtyTextControllerList[index].text} Quantity",
                                                                                                  textSize: width * 0.035,
                                                                                                  textColor: AppColors.appblack,
                                                                                                  boldNess: FontWeight.w500,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      SizedBox(height: height * 0.03),
                                                                                      Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent, side: const BorderSide(color: AppColors.appblack)),
                                                                                              onPressed: () {
                                                                                                controller.partialOrLaterDelivery = "";
                                                                                                controller.update();
                                                                                                // Get.back();

                                                                                                for (int i = 0; i < 4; i++) {
                                                                                                  if (Get.isDialogOpen!) {
                                                                                                    print("printing get currrent loop -> $i");
                                                                                                    Get.back();
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                                                                                if (controller.partialOrLaterDelivery == "") {
                                                                                                  CommonSnackBar.showError("Please select the option to proceed");
                                                                                                  return;
                                                                                                }

                                                                                                // body[0]["laterDelivery"] = controller.partialOrLaterDelivery;

                                                                                                // print("printing body in get dialog ---> ${body}");

                                                                                                // controller.getAddToCartApi(body, searchProduct.storeId).then(
                                                                                                //   (value) {
                                                                                                //     print("printing getAddToCartApi return value ---> $value");
                                                                                                //     CommonSnackBar.showToast('Added to Cart', context);
                                                                                                //     controller.qtyTextControllerList[index].clear();
                                                                                                //     controller.qtyList[index].value = 0;

                                                                                                //     controller.finalQTYList[index].value = 0;
                                                                                                //     controller.freeQTYList[index].value = 0;
                                                                                                //     controller.buyQTYList[index].value = 0;
                                                                                                //     controller.update();
                                                                                                //     final cartController = Get.put(CartController());
                                                                                                //     cartController.getVerifiedProductDataApi();
                                                                                                //     print("value>>>>>>>>>>>>>>$value");
                                                                                                //   },
                                                                                                // );

                                                                                                cartController.cartListModel?.storeVo[0].items[index].quantity = double.parse(widget.cartController.qtyTextControllerList[index].text);
                                                                                                // cartController.finalQTYList[index].value = double.parse(widget.cartController.qtyTextControllerList[index].text);
                                                                                                cartController.update();
                                                                                                setState(() {});

                                                                                                if (cartController.cartListModel?.storeVo[0].items[index].schemeId != null && widget.items[index].schemeId!.isNotEmpty && widget.items[index].schemeName != null && widget.items[index].schemeName!.isNotEmpty && controller.partialOrLaterDelivery == "N") {
                                                                                                  // await widget.cartController.getSchemeQty(index: index, schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ?? "", schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ?? "", addBuyQty: widget.cartController.buyQTYList[index].value, quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty) ? 0 : num.parse(widget.cartController.qtyTextControllerList[index].text), addFreeQty: widget.cartController.freeQTYList[index].value, addFinalQty: widget.cartController.finalQTYList[index].value);
                                                                                                  await widget.cartController.getSchemeQty(index: index, schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ?? "", schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ?? "", addBuyQty: maxQuantityToBeAllowed, quantity: maxQuantityToBeAllowed, addFreeQty: maxFreeQuantityToBeAllowed, addFinalQty: 0);
                                                                                                  widget.cartController.qtyTextControllerList[index].text = '${maxQuantityToBeAllowed.floor()}';
                                                                                                  widget.cartController.buyQTYList[index].value = maxQuantityToBeAllowed.toDouble();
                                                                                                }

                                                                                                if (!(cartController.cartListModel?.storeVo[0].items[index].schemeId != null && widget.items[index].schemeId!.isNotEmpty && widget.items[index].schemeName != null && widget.items[index].schemeName!.isNotEmpty) && controller.partialOrLaterDelivery == "N") {
                                                                                                  // await widget.cartController.getSchemeQty(index: index, schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ?? "", schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ?? "", addBuyQty: widget.cartController.buyQTYList[index].value, quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty) ? 0 : num.parse(widget.cartController.qtyTextControllerList[index].text), addFreeQty: widget.cartController.freeQTYList[index].value, addFinalQty: widget.cartController.finalQTYList[index].value);

                                                                                                  widget.cartController.qtyTextControllerList[index].text = '${data["quantity"].toStringAsFixed(0)}';
                                                                                                }

                                                                                                if (widget.cartController.userId.value.isNotEmpty) {
                                                                                                  var bodyMap = {
                                                                                                    "userId": widget.cartController.userId.value,
                                                                                                    "productId": cartController.cartListModel!.storeVo[widget.storeIndex].items[index].productId ?? '',
                                                                                                    "skuId": cartController.cartListModel!.storeVo[widget.storeIndex].items[index].skuId,
                                                                                                    "storeId": widget.storeId,
                                                                                                    // "schemeId":widget.items[index].schemeId,
                                                                                                    // "schemeName":widget.items[index].schemeName,
                                                                                                    "buyQuantity": (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty)
                                                                                                        ? widget.cartController.buyQTYList[index].value
                                                                                                        : controller.partialOrLaterDelivery == "N"
                                                                                                            ? data["quantity"].toInt()
                                                                                                            : widget.cartController.qtyTextControllerList[index].text,
                                                                                                    "quantity": !(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty) && controller.partialOrLaterDelivery == "N" ? data["quantity"].toInt() : int.tryParse(widget.cartController.qtyTextControllerList[index].text),
                                                                                                    "finalQuantity": !(cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty) ? 0.0 : widget.cartController.finalQTYList[index].value,
                                                                                                    "freeQuantity": widget.cartController.freeQTYList[index].value,
                                                                                                    "laterDelivery": buyController.partialOrLaterDelivery == "" ? "N" : buyController.partialOrLaterDelivery,
                                                                                                    "timePassed": isTimePassed ? "Y" : "N"
                                                                                                  };
                                                                                                  print('update qty param button --> ${jsonEncode(bodyMap)}');

                                                                                                  // return;
                                                                                                  await widget.cartController.getQtyPlushAddToCartApi(bodyMap);
                                                                                                  widget.cartController.isEditableQTYList[index].value = false;

                                                                                                  // widget
                                                                                                  //     .cartController
                                                                                                  //     .totalPriceGet(cartController
                                                                                                  //             .cartListModel
                                                                                                  //             ?.storeVo[
                                                                                                  //                 0]
                                                                                                  //             .items ??
                                                                                                  //         []);

                                                                                                  await widget.cartController.getVerifiedProductDataApi();

                                                                                                  widget.cartController.totalPriceGet(cartController.cartListModel?.storeVo[0].items ?? []);

                                                                                                  CommonSnackBar.showToast('QTY Updated', context);
                                                                                                } else if (!Get.isDialogOpen!) {
                                                                                                  Get.dialog(const LoginDialog());
                                                                                                }

                                                                                                // Get.back();
                                                                                                for (int i = 0; i < 4; i++) {
                                                                                                  if (Get.isDialogOpen!) {
                                                                                                    print("printing get currrent loop -> $i");
                                                                                                    Get.back();
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                                                                                child: CommonText(
                                                                                                  // content: "Add To Cart in button",
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
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );

                                                                    buyController
                                                                        .partialOrLaterDelivery = "";
                                                                    buyController
                                                                        .update();
                                                                    return;
                                                                  }
                                                                }
                                                                //to open popups enable this code - ends here

                                                                cartController
                                                                        .cartListModel
                                                                        ?.storeVo[0]
                                                                        .items[
                                                                            index]
                                                                        .quantity =
                                                                    double.parse(widget
                                                                        .cartController
                                                                        .qtyTextControllerList[
                                                                            index]
                                                                        .text);
                                                                cartController
                                                                        .finalQTYList[
                                                                            index]
                                                                        .value =
                                                                    double.parse(widget
                                                                        .cartController
                                                                        .qtyTextControllerList[
                                                                            index]
                                                                        .text);
                                                                cartController
                                                                    .update();
                                                                setState(() {});

                                                                if (cartController
                                                                            .cartListModel
                                                                            ?.storeVo[
                                                                                0]
                                                                            .items[
                                                                                index]
                                                                            .schemeId !=
                                                                        null &&
                                                                    widget
                                                                        .items[
                                                                            index]
                                                                        .schemeId!
                                                                        .isNotEmpty &&
                                                                    widget
                                                                            .items[
                                                                                index]
                                                                            .schemeName !=
                                                                        null &&
                                                                    widget
                                                                        .items[
                                                                            index]
                                                                        .schemeName!
                                                                        .isNotEmpty) {
                                                                  await widget.cartController.getSchemeQty(
                                                                      index:
                                                                          index,
                                                                      schemeId: cartController.cartListModel?.storeVo[0].items[index].schemeId ??
                                                                          "",
                                                                      schemeName: cartController.cartListModel?.storeVo[0].items[index].schemeName ??
                                                                          "",
                                                                      addBuyQty: widget
                                                                          .cartController
                                                                          .buyQTYList[
                                                                              index]
                                                                          .value,
                                                                      quantity: (widget.cartController.qtyTextControllerList[index].text.trim().isEmpty)
                                                                          ? 0
                                                                          : num.parse(widget
                                                                              .cartController
                                                                              .qtyTextControllerList[
                                                                                  index]
                                                                              .text),
                                                                      addFreeQty: widget
                                                                          .cartController
                                                                          .freeQTYList[
                                                                              index]
                                                                          .value,
                                                                      addFinalQty: widget
                                                                          .cartController
                                                                          .finalQTYList[index]
                                                                          .value);
                                                                }
                                                                if (widget
                                                                    .cartController
                                                                    .userId
                                                                    .value
                                                                    .isNotEmpty) {
                                                                  bool
                                                                      isMaxTimeStopNeededInMain =
                                                                      API.needMaxTimeStopFunctionality;
                                                                  bool
                                                                      isTimePassedInMain =
                                                                      isMaxTimeStopNeededInMain
                                                                          ? await isAfterDynamicTime()
                                                                          : false;
                                                                  var bodyMap =
                                                                      {
                                                                    "userId": widget
                                                                        .cartController
                                                                        .userId
                                                                        .value,
                                                                    "productId": cartController
                                                                            .cartListModel!
                                                                            .storeVo[widget.storeIndex]
                                                                            .items[index]
                                                                            .productId ??
                                                                        '',
                                                                    "skuId": cartController
                                                                        .cartListModel!
                                                                        .storeVo[widget
                                                                            .storeIndex]
                                                                        .items[
                                                                            index]
                                                                        .skuId,
                                                                    "storeId":
                                                                        widget
                                                                            .storeId,
                                                                    // "schemeId":widget.items[index].schemeId,
                                                                    // "schemeName":widget.items[index].schemeName,
                                                                    "buyQuantity": (cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeId!.isNotEmpty && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName != null && cartController.cartListModel!.storeVo[widget.storeIndex].items[index].schemeName!.isNotEmpty)
                                                                        ? widget
                                                                            .cartController
                                                                            .buyQTYList[
                                                                                index]
                                                                            .value
                                                                        : widget
                                                                            .cartController
                                                                            .qtyTextControllerList[index]
                                                                            .text,
                                                                    "quantity": widget
                                                                        .cartController
                                                                        .qtyTextControllerList[
                                                                            index]
                                                                        .text,
                                                                    "finalQuantity": widget
                                                                        .cartController
                                                                        .finalQTYList[
                                                                            index]
                                                                        .value,
                                                                    "freeQuantity": widget
                                                                        .cartController
                                                                        .freeQTYList[
                                                                            index]
                                                                        .value,
                                                                    "laterDelivery":
                                                                        cartController.cartListModel!.storeVo[widget.storeIndex].items[index].stockAvailable ==
                                                                                "1"
                                                                            ? "N"
                                                                            : "Y",
                                                                    // isTimePassedInMain
                                                                    // ? "Y"
                                                                    // : "N",
                                                                    'timePassed':
                                                                        isTimePassedInMain
                                                                            ? "Y"
                                                                            : "N"
                                                                  };
                                                                  print(
                                                                      'update qty param --> ${jsonEncode(bodyMap)}');
                                                                  await widget
                                                                      .cartController
                                                                      .getQtyPlushAddToCartApi(
                                                                          bodyMap);
                                                                  widget
                                                                      .cartController
                                                                      .isEditableQTYList[
                                                                          index]
                                                                      .value = false;
                                                                  // widget
                                                                  //     .cartController
                                                                  //     .totalPriceGet(cartController
                                                                  //             .cartListModel
                                                                  //             ?.storeVo[
                                                                  //                 0]
                                                                  //             .items ??
                                                                  //         []);

                                                                  await widget
                                                                      .cartController
                                                                      .getVerifiedProductDataApi();

                                                                  widget.cartController.totalPriceGet(cartController
                                                                          .cartListModel
                                                                          ?.storeVo[
                                                                              0]
                                                                          .items ??
                                                                      []);

                                                                  CommonSnackBar
                                                                      .showToast(
                                                                          'QTY Updated',
                                                                          context);
                                                                } else if (!Get
                                                                    .isDialogOpen!) {
                                                                  Get.dialog(
                                                                      const LoginDialog());
                                                                }
                                                              }
                                                            } else if (widget
                                                                    .cartController
                                                                    .qtyTextControllerList[
                                                                        index]
                                                                    .text
                                                                    .trim() ==
                                                                '0') {
                                                              CommonSnackBar
                                                                  .showToast(
                                                                'Quantity should not be 0',
                                                                context,
                                                                showTickMark:
                                                                    false,
                                                                width: 220,
                                                              );
                                                            } else if (widget
                                                                .cartController
                                                                .qtyTextControllerList[
                                                                    index]
                                                                .text
                                                                .trim()
                                                                .isEmpty) {
                                                              CommonSnackBar
                                                                  .showToast(
                                                                'Please enter quantity',
                                                                context,
                                                                showTickMark:
                                                                    false,
                                                                width: 200,
                                                              );
                                                            }
                                                          } else {
                                                            widget
                                                                .cartController
                                                                .isEditableQTYList[
                                                                    index]
                                                                .value = true;
                                                          }
                                                        },
                                                        child: Image.asset(
                                                            'assets/icons/edit_icon.png',
                                                            package:
                                                                'store_app_b2b',
                                                            scale: 4,
                                                            color: (widget
                                                                    .cartController
                                                                    .isEditableQTYList[
                                                                        index]
                                                                    .value)
                                                                ? ColorsConst
                                                                    .primaryColor
                                                                : null,
                                                            fit: BoxFit.cover),
                                                      )
                                                    ],
                                                  ))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            width: width,
                            color: Color(0xffE5E5E5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          content:
                                              "Today, ${DateFormat('dd MMM yy').format(DateTime.now())}",
                                          textColor: Colors.black,
                                          textSize: width * 0.035,
                                          boldNess: FontWeight.w600,
                                        ),
                                        SizedBox(height: height * 0.001),
                                        CommonText(
                                          content:
                                              "Products : ${widget.items.length}",
                                          textSize: width * 0.035,
                                          textColor: ColorsConst.textColor,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CommonText(
                                          content: "Total :",
                                          textSize: width * 0.048,
                                          textColor: ColorsConst.textColor,
                                        ),
                                        Obx(() => CommonText(
                                              content:
                                                  "₹${widget.cartController.itemViewTotal.value.toStringAsFixed(2)}",
                                              textSize: width * 0.048,
                                              textColor: Colors.black,
                                              boldNess: FontWeight.w600,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ));
      },
    );
  }

  String getStockStatusText(String stockAvailable) {
    if (gmcController.popup2ndOptionNeededB2B == false &&
        stockAvailable == "3") {
      return 'Not Available';
    }

    switch (stockAvailable) {
      case "1":
        return "Available";
      case "2":
        return "Low Stock";
      case "3":
        return "Delivery Tomorrow";
      default:
        return "Available";
    }
  }

  Color getStockStatusTextColor(String stockAvailable) {
    if (gmcController.popup2ndOptionNeededB2B == false &&
        stockAvailable == "3") {
      return Colors.red;
    }

    switch (stockAvailable) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Color getStockStatusStarColor(String stockAvailable) {
    switch (stockAvailable) {
      case "1":
        return Colors.green;
      case "2":
        return Colors.orange;
      case "3":
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
