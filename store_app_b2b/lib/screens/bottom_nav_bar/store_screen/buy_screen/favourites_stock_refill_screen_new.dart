import 'dart:convert';
import 'dart:developer';

import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/model/favourite_item_model_new.dart';

class FavouritesStockRefill extends StatefulWidget {
  const FavouritesStockRefill(
      {Key? key,
      required this.favList,
      required this.title,
      required this.controller,
      required this.index})
      : super(key: key);

  final List<FavList> favList;
  final FavouriteItemModel title;
  final int index;
  final BuyController controller;

  @override
  State<FavouritesStockRefill> createState() => _FavouritesStockRefillState();
}

class _FavouritesStockRefillState extends State<FavouritesStockRefill> {
  List<List<RxNum>> finalQTYList = [];
  List<List<RxNum>> freeQTYList = [];
  List<List<RxNum>> buyQTYList = [];
  List<List<RxNum>> qtyList = [];

  RxList<RxList<TextEditingController>> textFieldList =
      <RxList<TextEditingController>>[].obs;

  @override
  void initState() {
    for (int i = 0; i < widget.favList.length; i++) {
      if (widget.favList[i].items.isNotEmpty) {
        RxList<TextEditingController> controllerList =
            <TextEditingController>[].obs;
        List<RxNum> tmpBuyQtyList = [];
        List<RxNum> tmpQtyList = [];
        List<RxNum> tmpFreeQTyList = [];
        List<RxNum> tmpFinalQTyList = [];
        for (int j = 0; j < widget.favList[i].items.length; j++) {
          logs('fav product ---> ${widget.favList[i].items[j].toJson()}');
          tmpBuyQtyList.add(RxNum(widget.favList[i].items[j].quantity ?? 0.0));
          tmpQtyList.add(RxNum(widget.favList[i].items[j].quantity ?? 0.0));
          tmpFreeQTyList
              .add(RxNum(widget.favList[i].items[j].freeQuanity ?? 0.0));
          tmpFinalQTyList
              .add(RxNum(widget.favList[i].items[j].quantity ?? 0.0));
          controllerList.add(TextEditingController(
              text:
                  '${(widget.favList[i].items[j].quantity != null ? widget.favList[i].items[j].quantity!.toStringAsFixed(0) : '')}'));
          textFieldList.add(controllerList);
          buyQTYList.add(tmpBuyQtyList);
          qtyList.add(tmpQtyList);
          freeQTYList.add(tmpFreeQTyList);
          finalQTYList.add(tmpFinalQTyList);
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "${widget.title.favName ?? ""}",
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
      backgroundColor: ColorsConst.greyBgColor,
      body: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffE5E5E5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CommonText(
                          content: "Created Date : ",
                          textSize: width * 0.028,
                          boldNess: FontWeight.w400,
                          textColor: ColorsConst.hintColor,
                        ),
                        CommonText(
                          content: "${widget.title.createdDt ?? ''}",
                          textSize: width * 0.032,
                          boldNess: FontWeight.w600,
                          textColor: ColorsConst.textColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CommonText(
                          content: "Items : ",
                          textSize: width * 0.028,
                          boldNess: FontWeight.w400,
                          textColor: ColorsConst.hintColor,
                        ),
                        CommonText(
                          content: "${widget.favList.length}",
                          textSize: width * 0.032,
                          boldNess: FontWeight.w600,
                          textColor: ColorsConst.textColor,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        await widget.controller
                            .getDeleteFavoriteApi(widget.title.id ?? '')
                            .then((data) async {
                          if (data != null) {
                            Get.back();
                            await widget.controller.getFavouriteList
                                .removeAt(widget.index);
                            setState(() {});
                          }
                        });
                      },
                      child: Image.asset(
                        "assets/icons/delete_icon.png",
                        scale: 4,
                        package: 'store_app_b2b',
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  itemCount: widget.favList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, favIndex) {
                    log('item ---> ${widget.favList[favIndex].items.length}');
                    return Column(
                      children: List.generate(
                          widget.favList[favIndex].items.length, (itemIndex) {
                        Item item = widget.favList[favIndex].items[itemIndex];
                        return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: ColorsConst.semiGreyColor),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CommonText(
                                        content: item.productName ?? "",
                                        boldNess: FontWeight.w600,
                                        textColor: ColorsConst.textColor,
                                        textSize: 16,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        logs('id --> ${item.id ?? ''}');
                                        await widget.controller
                                            .getDeleteFavoriteItemApi(
                                                widget.title.id ?? '', item.id)
                                            .then((data) async {
                                          if (data != null &&
                                              jsonDecode(data)['status'] ==
                                                  true) {
                                            widget.favList[favIndex].items
                                                .removeAt(itemIndex);
                                            if (widget.favList.isEmpty) {
                                              Get.back();
                                            }
                                            setState(() {});
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        "assets/icons/delete_icon.png",
                                        scale: 4.5,
                                        package: 'store_app_b2b',
                                      ),
                                    )
                                  ],
                                ),
                                CommonText(
                                  content: item.manufacturer ?? '',
                                  boldNess: FontWeight.w400,
                                  textColor: ColorsConst.textColor,
                                  textSize: 12,
                                ),
                                if (item.schemeName != null &&
                                    item.schemeName!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Obx(
                                        () => CommonText(
                                          content:
                                              'Qty: ${(finalQTYList[favIndex][itemIndex].value).toStringAsFixed(2)}',
                                          boldNess: FontWeight.w500,
                                          textColor: ColorsConst.greyTextColor,
                                          textSize: width * 0.036,
                                        ),
                                      ),
                                      Obx(
                                        () => CommonText(
                                          content:
                                              '(${((qtyList[favIndex][itemIndex].value)).toStringAsFixed(2)} + ',
                                          boldNess: FontWeight.w500,
                                          textColor: ColorsConst.greyTextColor,
                                          textSize: width * 0.036,
                                        ),
                                      ),
                                      Obx(
                                        () => CommonText(
                                          content:
                                              '${((freeQTYList[favIndex][itemIndex].value)).toStringAsFixed(2)})',
                                          boldNess: FontWeight.w500,
                                          textColor: ColorsConst.greyTextColor,
                                          textSize: width * 0.036,
                                        ),
                                      )
                                    ],
                                  ),
                                if (item.schemeName != null &&
                                    item.schemeName!.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/icons/offer_icon.png",
                                        scale: 6,
                                        package: 'store_app_b2b',
                                      ),
                                      CommonText(
                                        content: "${item.schemeName ?? ''}",
                                        boldNess: FontWeight.w600,
                                        textColor: ColorsConst.textColor,
                                        textSize: 12,
                                      ),
                                    ],
                                  ),
                                SizedBox(height: Get.height * 0.01),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CommonText(
                                                content: "MRP",
                                                boldNess: FontWeight.w600,
                                                textColor:
                                                    ColorsConst.greyTextColor,
                                                textSize: 14,
                                              ),
                                              const SizedBox(width: 5),
                                              CommonText(
                                                content:
                                                    "₹${num.parse((item.mrp ?? "0").toString()).toStringAsFixed(2)}",
                                                boldNess: FontWeight.w500,
                                                textColor:
                                                    ColorsConst.greyTextColor,
                                                textSize: 14,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              CommonText(
                                                content: "PTR",
                                                boldNess: FontWeight.w600,
                                                textColor:
                                                    ColorsConst.greyTextColor,
                                                textSize: 14,
                                              ),
                                              const SizedBox(width: 5),
                                              CommonText(
                                                content:
                                                    "₹${num.parse((item.ptr ?? "0").toString()).toStringAsFixed(2)}",
                                                boldNess: FontWeight.w500,
                                                textColor:
                                                    ColorsConst.greyTextColor,
                                                textSize: 14,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              CommonText(
                                                content: "Total",
                                                boldNess: FontWeight.w600,
                                                textColor:
                                                    ColorsConst.primaryColor,
                                                textSize: 14,
                                              ),
                                              const SizedBox(width: 5),
                                              CommonText(
                                                content:
                                                    "₹${num.parse((item.totalValue ?? "0").toString()).toStringAsFixed(2)}",
                                                boldNess: FontWeight.w500,
                                                textColor:
                                                    ColorsConst.primaryColor,
                                                textSize: 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          addFavTextField(
                                              item, favIndex, itemIndex),
                                          SizedBox(height: 10),
                                          addToCartButton(
                                              item, favIndex, itemIndex)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CommonText(
            //   content: "Draft value : ₹ ${widget.title.draftValue ?? ''}",
            //   boldNess: FontWeight.w600,
            //   textColor: ColorsConst.textColor,
            //   textSize: width * 0.04,
            // ),
            SizedBox(height: height * 0.01),
            GestureDetector(
              onTap: () async {
                await widget.controller
                    .getAddFavListToCart(widget.title.id ?? '')
                    .then((data) {
                  if (data != null) {
                    Get.back();
                    CommonSnackBar.showSuccess(jsonDecode(data)['message']);
                  }
                });
              },
              child: Container(
                height: 42,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: ColorsConst.appGradientColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: CommonText(
                    content: "Add to cart",
                    textSize: width * 0.038,
                    textColor: Colors.white,
                    boldNess: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addFavTextField(Item item, favIndex, int itemIndex) {
    return Obx(() => SizedBox(
          height: 30,
          child: TextField(
            controller: textFieldList[favIndex][itemIndex],
            textAlign: TextAlign.center,
            maxLength: 4,
            style: TextStyle(
              color: ColorsConst.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            // onTap: () {
            //   if(textFieldList[favIndex][itemIndex].text.isEmpty){
            //     textFieldList[favIndex][itemIndex].text = '1';
            //     qtyList[favIndex][itemIndex].value = int.parse('1');
            //     if (item.schemeName != null && item.schemeName!.isNotEmpty) {
            //       widget.controller
            //           .getSchemeQty(
            //           index: itemIndex,
            //           schemeId: '',
            //           schemeName: item.schemeName ?? '',
            //           addBuyQty: qtyList[favIndex][itemIndex].value,
            //           addFreeQty: 0,
            //           finalQty: finalQTYList[favIndex][itemIndex].value)
            //           .then((value) {
            //         freeQTYList[favIndex][itemIndex].value = value['freeQuantity'];
            //         finalQTYList[favIndex][itemIndex].value = value['finalQuantity'];
            //         buyQTYList[favIndex][itemIndex].value = value['buyQuantity'];
            //       });
            //     }
            //   }
            // },
            onChanged: (value) {
              if (value.isNotEmpty) {
                qtyList[favIndex][itemIndex].value = int.parse(value);
              } else {
                textFieldList[favIndex][itemIndex].clear();
                FocusScope.of(context).unfocus();
                qtyList[favIndex][itemIndex].value = 0;
              }
              if (item.schemeName != null && item.schemeName!.isNotEmpty) {
                widget.controller
                    .getSchemeQty(
                        index: itemIndex,
                        schemeId: '',
                        quantity:
                            int.parse('${qtyList[favIndex][itemIndex].value}'),
                        schemeName: item.schemeName ?? '',
                        addBuyQty: qtyList[favIndex][itemIndex].value,
                        addFreeQty: 0,
                        finalQty: finalQTYList[favIndex][itemIndex].value)
                    .then((value) {
                  freeQTYList[favIndex][itemIndex].value =
                      value['freeQuantity'];
                  finalQTYList[favIndex][itemIndex].value =
                      value['finalQuantity'];
                  buyQTYList[favIndex][itemIndex].value = value['buyQuantity'];
                });
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                qtyList[favIndex][itemIndex].value = int.parse(value);
              } else {
                qtyList[favIndex][itemIndex].value = 0;
              }
              if (item.schemeName != null && item.schemeName!.isNotEmpty) {
                widget.controller
                    .getSchemeQty(
                        quantity:
                            int.parse('${qtyList[favIndex][itemIndex].value}'),
                        index: itemIndex,
                        schemeId: '',
                        schemeName: item.schemeName ?? '',
                        addBuyQty: qtyList[favIndex][itemIndex].value,
                        addFreeQty: 0,
                        finalQty: finalQTYList[favIndex][itemIndex].value)
                    .then((value) {
                  freeQTYList[favIndex][itemIndex].value =
                      value['freeQuantity'];
                  finalQTYList[favIndex][itemIndex].value =
                      value['finalQuantity'];
                  buyQTYList[favIndex][itemIndex].value = value['buyQuantity'];
                });
              }
            },
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                counterText: '',
                hintText: 'Add',
                hintStyle: TextStyle(
                  color: ColorsConst.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.only(top: 5, bottom: 0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor))),
          ),
        ));
  }

  addToCartButton(Item item, favIndex, int itemIndex) {
    return InkWell(
      onTap: () async {
        FocusManager.instance.primaryFocus!.unfocus();
        if (qtyList[favIndex][itemIndex].value == 0) {
          CommonSnackBar.showError('Please Enter Qty');
        } else {
          var body = [
            {
              "productId": item.id,
              "productName": item.productName,
              "mesuare": "",
              "schemeName": item.schemeName,
              // "schemeId":
              // item
              //     .sc,
              "manufacturer": item.manufacturer,
              "quantity":
                  (item.schemeName != null && item.schemeName!.isNotEmpty)
                      ? buyQTYList[favIndex][itemIndex].value
                      : qtyList[favIndex][itemIndex].value,
              "buyQuantity":
                  (item.schemeName != null && item.schemeName!.isNotEmpty)
                      ? buyQTYList[favIndex][itemIndex].value
                      : qtyList[favIndex][itemIndex].value,
              "finalQuantity": finalQTYList[favIndex][itemIndex].value,
              "freeQuantity": freeQTYList[favIndex][itemIndex].value,
              "price": item.ptr,
              "skuId": item.skuId,
              "productUrl": "",
              "storeName": item.storeName,
              "tabletsPerStrip": "",
              "categoryName": "",
              "mrp": item.mrp,
              "prescriptionIsRequired": true
            }
          ];
          logs('Body --> $body');
          widget.controller.getAddToCartApi(body, item.storeId).then((value) {
            CommonSnackBar.showToast('Added to Cart', context);
            textFieldList[favIndex][itemIndex].clear();
            qtyList[favIndex][itemIndex].value = 0;
            if (item.schemeName != null && item.schemeName!.isNotEmpty) {
              freeQTYList[favIndex][itemIndex].value = 0;
              finalQTYList[favIndex][itemIndex].value = 0;
            }
            final cartController = Get.put(CartController());
            cartController.getVerifiedProductDataApi();
            print("value>>>>>>>>>>>>>>$value");
          });
        }
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: ColorsConst.primaryColor),
            borderRadius: BorderRadius.circular(4)),
        alignment: Alignment.center,
        child: CommonText(
            content: 'Move to Cart',
            boldNess: FontWeight.w500,
            textColor: ColorsConst.primaryColor,
            textSize: 14),
      ),
    );
  }
}
