import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_search_field.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/components/common_text_field.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller.dart';
import 'package:store_app_b2b/model/search_supplier_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/product_details_screen.dart';

import '../controllers/bottom_controller/store_controller/buy_controller/buy_controller.dart';
import '../controllers/home_controller.dart';

class BySupplierTab extends StatefulWidget {
  const BySupplierTab(
      {Key? key,
      required this.onTapSupplier,
      required this.controller,
      required this.categoryId})
      : super(key: key);

  final VoidCallback onTapSupplier;
  final BuyController controller;
  final categoryId;

  @override
  State<BySupplierTab> createState() => _BySupplierTabState();
}

class _BySupplierTabState extends State<BySupplierTab> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.onTapSupplier,
                      child: SizedBox(
                        width: width * 0.28,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: ColorsConst.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Flexible(
                                        child: CommonText(
                                          content: (widget
                                                  .controller
                                                  .suppliersSelect
                                                  .value
                                                  .isNotEmpty)
                                              ? widget.controller
                                                  .suppliersSelect.value
                                              : "Supplier",
                                          overflow: TextOverflow.ellipsis,
                                          textSize: width * 0.035,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Image.asset(
                                      "assets/icons/down_arrow_icon.png",
                                      scale: 3,
                                      package: 'store_app_b2b',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => Expanded(
                          child: CommonSearchField(
                            showCloseIcon: widget.controller
                                .searchSupplierController.value.text.isNotEmpty,
                            controller: widget
                                .controller.searchSupplierController.value,
                            closeOnTap: () {
                              print("onclose is called in supplier");
                              widget.controller.searchSupplierController.value
                                  .clear();
                              widget.controller.getBuyBySuppliersDataApi(
                                search: "a",
                                categoryId: widget.categoryId,
                                supplierId: widget.controller.suppliersId.value,
                              );
                            },
                            onChanged: (p0) async {
                              logs(
                                  'SupplierId --> ${widget.controller.suppliersId.value}');
                              if (p0.isNotEmpty) {
                                widget.controller.getBuyBySuppliersDataApi(
                                  search: p0.trim(),
                                  categoryId: widget.categoryId,
                                  supplierId:
                                      widget.controller.suppliersId.value,
                                );
                                logs(
                                    'bySuppliersList --> ${widget.controller.bySuppliersList}');
                                print(
                                    'bySuppliersList --> ${widget.controller.bySuppliersList}');
                              } else {
                                logs('p0------->$p0');
                                widget.controller.isLoading(true);
                                widget.controller.bySuppliersList.clear();
                                widget.controller.getBuyBySuppliersDataApi(
                                  search: "a",
                                  categoryId: widget.categoryId,
                                  supplierId:
                                      widget.controller.suppliersId.value,
                                );
                                widget.controller.isLoading(false);
                              }
                            },
                          ),
                        )),
                  ],
                ),
                SizedBox(height: height * 0.02),
                widget.controller.bySuppliersList.isNotEmpty
                    ? Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: widget.controller.bySuppliersList.length,
                            padding: const EdgeInsets.only(bottom: 40),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              SearchSupplier searchSupplier =
                                  widget.controller.bySuppliersList[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => ProductDetailsScreen(
                                        maxOrderQuantity: 0,
                                        productId: searchSupplier.skuId ?? '',
                                        storeId: searchSupplier.storeId ?? '',
                                        index: index,
                                        schemeId: searchSupplier.schemeId,
                                        schemeAvailable:
                                            searchSupplier.schemeAvailable ??
                                                false,
                                        schemeName: searchSupplier.schemeName),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
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
                                              overflow: TextOverflow.ellipsis,
                                              content:
                                                  "${searchSupplier.productName ?? ''}",
                                              boldNess: FontWeight.w600,
                                              textColor: ColorsConst.textColor,
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     widget.controller
                                          //         .getFavoriteNameDataApi()
                                          //         .then((value) {
                                          //       if (value != null) {
                                          //         Get.dialog(favouriteDialog(
                                          //             width, height, searchSupplier));
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
                                      CommonText(
                                          content:
                                              '${searchSupplier.manufacturer ?? ''}',
                                          textSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          textColor:
                                              ColorsConst.notificationTextColor,
                                          boldNess: FontWeight.w500),
                                      CommonText(
                                          content:
                                              '${searchSupplier.specs ?? ''}',
                                          textSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textColor:
                                              ColorsConst.notificationTextColor,
                                          boldNess: FontWeight.w500),
                                      if (searchSupplier.schemeId != null &&
                                          searchSupplier.schemeId!.isNotEmpty)
                                        widget.controller.freeQTYList[index]
                                                    .value >
                                                0
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Obx(
                                                    () => CommonText(
                                                      content:
                                                          'Qty: ${(widget.controller.finalQTYList[index].value).toStringAsFixed(0)}',
                                                      boldNess: FontWeight.w500,
                                                      textColor: ColorsConst
                                                          .greyTextColor,
                                                      textSize: width * 0.036,
                                                    ),
                                                  ),
                                                  Obx(
                                                    () => CommonText(
                                                      content:
                                                          '(${((widget.controller.buyQTYList[index].value)).toStringAsFixed(2)} + ',
                                                      boldNess: FontWeight.w500,
                                                      textColor: ColorsConst
                                                          .greyTextColor,
                                                      textSize: width * 0.036,
                                                    ),
                                                  ),
                                                  Obx(
                                                    () => CommonText(
                                                      content:
                                                          '${((widget.controller.freeQTYList[index].value)).toStringAsFixed(2)})',
                                                      boldNess: FontWeight.w500,
                                                      textColor: ColorsConst
                                                          .greyTextColor,
                                                      textSize: width * 0.036,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : const SizedBox(),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
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
                                                              width: width *
                                                                  0.015),
                                                          CommonText(
                                                            content:
                                                                "₹${(searchSupplier.mrp ?? 0).toStringAsFixed(2)}",
                                                            textSize: 14,
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textColor:
                                                                ColorsConst
                                                                    .textColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
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
                                                              width: width *
                                                                  0.015),
                                                          CommonText(
                                                            content:
                                                                "₹${(searchSupplier.price ?? 0).toStringAsFixed(2)}",
                                                            textSize: 14,
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textColor: ColorsConst
                                                                .notificationTextColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                searchSupplier.stockAvailable !=
                                                        "3"
                                                    ? CommonText(
                                                        content:
                                                            "*${getStockStatusText(searchSupplier.stockAvailable ?? "")}",
                                                        textSize: 12,
                                                        boldNess:
                                                            FontWeight.w600,
                                                        textColor: searchSupplier
                                                                    .stockAvailable ==
                                                                null
                                                            ? Colors.green
                                                            : getStockStatusTextColor(
                                                                searchSupplier
                                                                    .stockAvailable!),
                                                      )
                                                    : SizedBox(),
                                                if (searchSupplier.schemeId !=
                                                        null &&
                                                    searchSupplier
                                                        .schemeId!.isNotEmpty)
                                                  Row(
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
                                                              "${searchSupplier.schemeName ?? ''}",
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
                                                  ),
                                              ],
                                            ),
                                          ),
                                          searchSupplier.stockAvailable == "3"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: CommonText(
                                                    content: "Out Of Stock",
                                                    textSize: 12,
                                                    boldNess: FontWeight.w600,
                                                    textColor: searchSupplier
                                                                .stockAvailable ==
                                                            null
                                                        ? Colors.green
                                                        : getStockStatusTextColor(
                                                            searchSupplier
                                                                .stockAvailable!),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Column(
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      width: 134,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3),
                                                      decoration: BoxDecoration(
                                                          color: ColorsConst
                                                              .appWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color: ColorsConst
                                                                  .primaryColor)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          decreaseSupplierButton(
                                                              index,
                                                              searchSupplier),
                                                          const SizedBox(
                                                              width: 8),
                                                          addSupplierTextField(
                                                              index,
                                                              searchSupplier),
                                                          const SizedBox(
                                                              width: 8),
                                                          increaseSupplierButton(
                                                              index,
                                                              searchSupplier)
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    addToCartButton(
                                                        index, searchSupplier)
                                                  ],
                                                )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: (widget.controller.searchSupplierController
                                  .value.text.isEmpty)
                              ? const Text(
                                  'Search for products',
                                  style: TextStyle(fontSize: 17),
                                )
                              : const Text(
                                  'No product found',
                                  style: TextStyle(fontSize: 17),
                                ),
                        ),
                      ),
              ],
            ),
            if (widget.controller.isSupplierTabLoading.value) const AppLoader()
          ],
        ));
  }

  String getStockStatusText(String stockAvailable) {
    switch (stockAvailable) {
      case "1":
        return "Available";
      case "2":
        return "Low Stock";
      case "3":
        return "Out of Stock";
      default:
        return "Available";
    }
  }

  Color getStockStatusTextColor(String stockAvailable) {
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

  favouriteDialog(width, height, SearchSupplier item) {
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
                                  widget
                                      .controller.favouriteNameController.value
                                      .clear();
                                  Get.dialog(favouriteNameDialog(
                                          width: width, height: height))
                                      .then((value) {
                                    setState(() {});
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
                              widget.controller.getFavoriteNameList.length,
                              (index) => Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    widget.controller.favouriteSelect.value =
                                        widget.controller
                                            .getFavoriteNameList[index];
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
                                          content: widget.controller
                                              .getFavoriteNameList[index],
                                          boldNess: FontWeight.w500,
                                          textColor: ColorsConst.textColor,
                                          textSize: width * 0.04,
                                        ),
                                        widget.controller.favouriteSelect
                                                    .value !=
                                                widget.controller
                                                    .getFavoriteNameList[index]
                                            ? const SizedBox()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      ColorsConst.primaryColor,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(1),
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
                            if (widget.controller.favouriteSelect == "") {
                              CommonSnackBar.showError(
                                  "Please Select Favourite Product");
                            } else {
                              String id = "";
                              for (int i = 0;
                                  i <
                                      widget.controller.getFavoriteNameList
                                          .length;
                                  i++) {
                                if (widget.controller.getFavoriteNameList[i] ==
                                    widget.controller.favouriteSelect.value) {
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
                                "quantity": (widget
                                        .controller
                                        .qtyAddToCartController
                                        .value
                                        .text
                                        .isEmpty)
                                    ? 0
                                    : int.parse(widget.controller
                                        .qtyAddToCartController.value.text),
                              };
                              if (widget.controller.userId.value.isNotEmpty) {
                                Map<String, dynamic> bodyMap = {
                                  "userId": widget.controller.userId.value,
                                  "favName":
                                      widget.controller.favouriteSelect.value,
                                  "favList": [
                                    {
                                      "items": [itemMap]
                                    }
                                  ],
                                  'createdDt': DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                };
                                widget.controller
                                    .getAddFavoriteApi(bodyMap)
                                    .then((value) {
                                  if (value != null) {
                                    Get.back();
                                    widget.controller.favouriteSelect.value =
                                        "";
                                  }
                                });
                              } else if (!Get.isDialogOpen!) {
                                Get.dialog(const LoginDialog());
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: widget.controller.isSaveFavLoading.value
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

  addSupplierTextField(int index, SearchSupplier searchSupplier) {
    return Obx(() => SizedBox(
          width: 60,
          child: TextField(
            controller: widget.controller.qtyTextControllerList[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorsConst.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            // onTap: () {
            //   if(controller.qtyTextControllerList[index].text.isEmpty){
            //     controller.qtyTextControllerList[index].text = '1';
            //     controller.qtyList[index].value = int.parse('1');
            //     if (searchSupplier.schemeAvailable!) {
            //       controller.getSchemeQty(
            //           index: index,
            //           schemeId: searchSupplier.schemeId ?? '',
            //           schemeName: searchSupplier.schemeName ?? '',
            //           addBuyQty: controller.qtyList[index].value,
            //           addFreeQty: 0,
            //           finalQty: controller.finalQTYList[index].value);
            //     }
            //   }
            // },
            onChanged: (value) {
              if (value.isNotEmpty) {
                widget.controller.qtyList[index].value = int.parse(value);
              } else {
                widget.controller.qtyTextControllerList[index].clear();
                FocusScope.of(context).unfocus();
                widget.controller.qtyList[index].value = 0;
              }
              if (searchSupplier.schemeAvailable != null &&
                  searchSupplier.schemeAvailable!) {
                widget.controller.getSchemeQty(
                    quantity: widget.controller.qtyList[index].value,
                    index: index,
                    schemeId: searchSupplier.schemeId ?? '',
                    schemeName: searchSupplier.schemeName ?? '',
                    addBuyQty: widget.controller.qtyList[index].value,
                    addFreeQty: 0,
                    finalQty: widget.controller.finalQTYList[index].value);
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.controller.qtyList[index].value = int.parse(value);
              } else {
                widget.controller.qtyList[index].value = 0;
              }
              if (searchSupplier.schemeAvailable != null &&
                  searchSupplier.schemeAvailable!) {
                widget.controller.getSchemeQty(
                    quantity: widget.controller.qtyList[index].value,
                    index: index,
                    schemeId: searchSupplier.schemeId ?? '',
                    schemeName: searchSupplier.schemeName ?? '',
                    addBuyQty: widget.controller.qtyList[index].value,
                    addFreeQty: 0,
                    finalQty: widget.controller.finalQTYList[index].value);
              }
            },
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                hintText: 'Add',
                hintStyle: TextStyle(
                  color: ColorsConst.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.only(top: 5, bottom: 0),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ));
  }

  increaseSupplierButton(int index, SearchSupplier searchSupplier) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (widget.controller.qtyList[index].value <= 1000) {
            widget.controller.qtyList[index].value++;
            logs('qty ==> ${widget.controller.qtyList[index].value}');
            widget.controller.qtyTextControllerList[index].text =
                '${widget.controller.qtyList[index].value}';
            if (searchSupplier.schemeAvailable != null &&
                searchSupplier.schemeAvailable!) {
              widget.controller.getSchemeQty(
                  index: index,
                  quantity: widget.controller.qtyList[index].value,
                  schemeId: searchSupplier.schemeId ?? '',
                  schemeName: searchSupplier.schemeName ?? '',
                  addBuyQty: widget.controller.qtyList[index].value,
                  addFreeQty: 0,
                  finalQty: widget.controller.finalQTYList[index].value);
            }
          }
        },
        child: Icon(Icons.add, color: ColorsConst.primaryColor, size: 20));
  }

  decreaseSupplierButton(int index, SearchSupplier searchSupplier) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (widget.controller.qtyList[index].value > 0) {
          widget.controller.qtyList[index].value--;
          if (widget.controller.qtyList[index].value == 0) {
            widget.controller.qtyTextControllerList[index].clear();
          } else {
            widget.controller.qtyTextControllerList[index].text =
                '${widget.controller.qtyList[index]}';
          }
          if (searchSupplier.schemeAvailable != null &&
              searchSupplier.schemeAvailable!) {
            widget.controller.getSchemeQty(
                index: index,
                quantity: widget.controller.qtyList[index].value,
                schemeId: searchSupplier.schemeId ?? '',
                schemeName: searchSupplier.schemeName ?? '',
                addBuyQty: widget.controller.qtyList[index].value,
                addFreeQty: 0,
                finalQty: widget.controller.finalQTYList[index].value);
          }
        }
      },
      child: Icon(Icons.remove, color: ColorsConst.primaryColor, size: 20),
    );
  }

  addToCartButton(int index, SearchSupplier searchSupplier) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        if (widget.controller.qtyList[index].value == 0) {
          CommonSnackBar.showToast('Please Enter Qty', context,
              showTickMark: false);
        } else {
          var body = [
            {
              "productId": searchSupplier.id,
              "productName": searchSupplier.productName,
              "mesuare": "",
              "schemeName": searchSupplier.schemeName,
              "schemeId": searchSupplier.schemeId,
              "manufacturer": searchSupplier.manufacturer,
              "quantity": widget.controller.qtyList[index].value,
              "buyQuantity": (searchSupplier.schemeAvailable!)
                  ? widget.controller.buyQTYList[index].value
                  : widget.controller.qtyList[index].value,
              "finalQuantity": widget.controller.finalQTYList[index].value,
              "freeQuantity": widget.controller.freeQTYList[index].value,
              "price": searchSupplier.price,
              "mrp":
                  searchSupplier.mrp?.toStringAsFixed(2) ?? searchSupplier.mrp,
              "skuId": searchSupplier.skuId,
              "productUrl": "",
              "storeName": searchSupplier.storeName,
              "tabletsPerStrip": "",
              "categoryName": "",
              "prescriptionIsRequired": true
            }
          ];
          logs('Body --> $body');
          widget.controller
              .getAddToCartApi(body, searchSupplier.storeId)
              .then((value) {
            CommonSnackBar.showToast('Added to Cart', context);
            widget.controller.qtyTextControllerList[index].clear();
            widget.controller.qtyList[index].value = 0;
            widget.controller.finalQTYList[index].value = 0;
            widget.controller.freeQTYList[index].value = 0;
            print("value>>>>>>>>>>>>>>$value");
            setState(() {});
          });
        }
      },
      child: Container(
        height: 32,
        width: 134,
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
                        controller:
                            widget.controller.favouriteNameController.value,
                        contentColor: ColorsConst.textColor,
                        titleShow: false,
                      ),
                      SizedBox(height: height! * 0.01),
                      Row(
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
                                if (widget.controller.favouriteNameController
                                    .value.text.isEmpty) {
                                  CommonSnackBar.showError("Please Enter Name");
                                } else if (widget.controller.getFavoriteNameList
                                    .contains(widget.controller
                                        .favouriteNameController.value.text)) {
                                  CommonSnackBar.showError("Same Name Use");
                                } else {
                                  widget.controller.getFavoriteNameList.add(
                                      widget.controller.favouriteNameController
                                          .value.text
                                          .trim()
                                          .toString());
                                  setState(() {});
                                  print(widget.controller.getFavoriteNameList);
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
                                    boldNess: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
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
