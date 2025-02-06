import 'dart:convert';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/new_order_screen.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/model/product_details_model_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';
import 'package:store_app_b2b/utils/color_extension_new.dart';
import 'package:store_app_b2b/utils/shar_preferences_new.dart';
import 'package:store_app_b2b/widget/time_check_new.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String storeId;
  final bool schemeAvailable;
  final dynamic schemeName;
  final dynamic schemeId;
  final int index;
  final num maxOrderQuantity;

  const ProductDetailsScreen(
      {super.key,
      required this.productId,
      required this.storeId,
      required this.index,
      required this.schemeName,
      required this.schemeAvailable,
      required this.schemeId,
      required this.maxOrderQuantity});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  ProductDetailsModel? productDetailsModel;
  final CarouselController _carouselController = CarouselController();
  TabController? tabController;

  final BuyController buyController = Get.put(BuyController());

  final GlobalMainController gmcController = Get.put(GlobalMainController());

  int currentIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyController>(
      init: BuyController(),
      initState: (state) async {
        productDetailsModel = await buyController.getProductDetailsApi(
            productId: widget.productId, storeId: widget.storeId);
      },
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
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
              centerTitle: true,
              title: CommonText(
                content: 'Product details',
                boldNess: FontWeight.w600,
              ),
            ),
            body: Stack(
              children: [
                if (productDetailsModel != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: CarouselSlider(
                                  items: productDetailsModel!.imageIds
                                      .map(
                                          (e) => Image.network(e.imageId ?? ''))
                                      .toList(),
                                  carouselController: _carouselController,
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    aspectRatio: 1.2,
                                    onPageChanged: (index, reason) {
                                      currentIndex = index;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Wrap(
                                    children: List.generate(
                                      productDetailsModel?.imageIds.length ?? 0,
                                      (index) => Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: GestureDetector(
                                          onTap: () => _carouselController
                                              .animateToPage(index),
                                          child: Image.network(
                                            productDetailsModel
                                                    ?.imageIds[index].imageId ??
                                                "",
                                            height: 18,
                                            width: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      productDetailsModel?.imageIds.length ?? 0,
                                      (index) => Container(
                                        width: currentIndex == index ? 15 : 6,
                                        height: 6.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              (Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : ColorsConst.textColor)
                                                  .withOpacity(
                                            currentIndex == index ? 0.8 : 0.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              titleView(),
                              Divider(
                                  color: ColorsConst.hintColor, height: 2.0),
                              detailsView(),
                            ],
                          ),
                        ),
                      ),
                      gmcController.popup2ndOptionNeededB2B == false &&
                              productDetailsModel?.stockAvailable == "3"
                          ? SizedBox()
                          : bottomButtonsView(productDetailsModel)
                    ],
                  ),
                Obx(() =>
                    controller.isLoading.value ? AppLoader() : SizedBox()),
                if (productDetailsModel != null &&
                    productDetailsModel!.discount != null &&
                    productDetailsModel!.discount != 0)
                  Positioned(
                    top: 0,
                    right: 20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 2, 8, 8),
                          // color: Colors.red,
                          child: Image.asset(
                            'assets/icons/offer_tag.png',
                            package: 'store_app_b2b',
                            // fit: BoxFit.cover,
                            height: 64,
                            width: 34,
                          ),
                        ),
                        Positioned(
                            bottom: 14,
                            child: CommonText(
                              content:
                                  "${productDetailsModel!.discount}${productDetailsModel!.discountType == "%" ? "%" : "₹"} on\nPTR",
                              textSize: productDetailsModel!.discount! > 99
                                  ? 6
                                  : productDetailsModel!.discount! > 9
                                      ? 7
                                      : 7,
                              textAlign: TextAlign.center,
                              boldNess: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  titleView() {
    print(
        "printing stockAvailable in details screen ---> ${productDetailsModel?.stockAvailable}");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText(
                  content: productDetailsModel?.productName.toString() ?? '',
                  textSize: 16,
                  maxLines: 2,
                  textColor: ColorsConst.textColor,
                  boldNess: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 5),
              if (productDetailsModel?.tabletsPerStrip != null &&
                  productDetailsModel!.tabletsPerStrip!.isNotEmpty)
                CommonText(
                  content:
                      '${productDetailsModel?.tabletsPerStrip.toString() ?? ''}',
                  textSize: 10,
                  textColor: HexColor("#949292"),
                  boldNess: FontWeight.w400,
                ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText(
                  content: productDetailsModel?.manufacturer.toString() ?? '',
                  textSize: 10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textColor: HexColor("#949292"),
                  boldNess: FontWeight.w400,
                ),
              ),
              SizedBox(width: 10),
              if (widget.schemeId != null && widget.schemeId != "")
                Row(
                  children: [
                    // Image.asset(
                    //   "assets/icons/offer.png",
                    //   scale: 4,
                    //   package: 'store_app_b2b',
                    // ),
                    Container(
                      height: 40,
                      width: 30,
                      child: Lottie.asset('assets/icons/offer_animation.json',
                          fit: BoxFit.cover,
                          // height: 20,
                          package: 'store_app_b2b'),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    CommonText(
                      content: "${widget.schemeName}",
                      textSize: 12,
                      boldNess: FontWeight.w600,
                      textColor: ColorsConst.textColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
            ],
          ),
          // CommonText(
          //   content: productDetailsModel?.manufacturer.toString() ?? '',
          //   textSize: 10,
          //   textColor: HexColor("#949292"),
          //   boldNess: FontWeight.w400,
          // ),
          const SizedBox(height: 8),
          CommonText(
            content: productDetailsModel?.weight ?? '',
            textSize: 9,
            textColor: HexColor("#949292"),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonText(
                          content: 'MRP: ',
                          textSize: 17,
                          boldNess: FontWeight.w500,
                          textColor: ColorsConst.textColor),
                      CommonText(
                        content: "₹",
                        textSize: 18,
                        textColor: ColorsConst.textColor,
                      ),
                      CommonText(
                          content:
                              // '${(productDetailsModel?.mrp == null) ? '0' : double.parse(productDetailsModel?.mrp.toString() ?? '').round()}',
                              '${(productDetailsModel?.mrp == null) ? '0' : productDetailsModel?.mrp.toString()}',
                          textSize: 18,
                          textColor: ColorsConst.textColor),
                      // const Spacer(),
                      // if (productDetailsModel?.medicalProduct == 'Y')
                      //   CommonText(
                      //     "Prescription Required: ${(widget.productDetailsModel?.prescriptionIsRequired == true) ? 'YES' : 'NO'}",
                      //     style: regularPoppins.copyWith(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w400
                      //     ),
                      //   )
                    ],
                  ),
                  Row(
                    children: [
                      CommonText(
                          content: 'PTR: ',
                          textSize: 17,
                          boldNess: FontWeight.w500,
                          textColor: ColorsConst.textColor),
                      CommonText(
                        content: "₹",
                        textSize: 18,
                        textColor: ColorsConst.textColor,
                      ),
                      CommonText(
                          content:
                              // '${double.parse(productDetailsModel?.price.toString() ?? '').round()}',
                              '${productDetailsModel?.price.toString()}',
                          textSize: 18,
                          textColor: ColorsConst.textColor),
                      // const Spacer(),
                      // if (productDetailsModel?.medicalProduct == 'Y')
                      //   CommonText(
                      //     "Prescription Required: ${(widget.productDetailsModel?.prescriptionIsRequired == true) ? 'YES' : 'NO'}",
                      //     style: regularPoppins.copyWith(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w400
                      //     ),
                      //   )
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  if (productDetailsModel?.discount != null &&
                      productDetailsModel?.discount != 0)
                    CommonText(
                      content:
                          "Discount ${productDetailsModel?.discount}${productDetailsModel?.discountType == "%" ? "%" : "₹"} on PTR",
                      textColor: AppColors.primaryColor,
                      boldNess: FontWeight.bold,
                      textSize: 14,
                    ),
                  CommonText(
                    content:
                        "${getStockStatusText(productDetailsModel?.stockAvailable ?? "")}",
                    textSize: 15,
                    boldNess: FontWeight.w600,
                    textAlign: TextAlign.center,
                    textColor: productDetailsModel?.stockAvailable == null
                        ? Colors.green
                        : getStockStatusTextColor(
                            productDetailsModel?.stockAvailable ?? ""),
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
                  //           "NET ₹${(productDetailsModel!.discount == 0 || productDetailsModel!.discount == null ? (productDetailsModel!.price ?? 0) : productDetailsModel!.discountType == "%" ? (productDetailsModel!.price ?? 0) - ((productDetailsModel!.price ?? 0) * (productDetailsModel!.discount! / 100)) : ((productDetailsModel!.price ?? 0) - productDetailsModel!.discount!)).toStringAsFixed(2)}",
                  //       textSize: 16,
                  //       boldNess: FontWeight.w600,
                  //       textColor: ColorsConst.primaryColor,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              // productDetailsModel?.stockAvailable != "3"
              // ?
              // Spacer(),
              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Expanded(
              //         child: CommonText(
              //           content:
              //               "${getStockStatusText(productDetailsModel?.stockAvailable ?? "")}",
              //           textSize: 15,
              //           boldNess: FontWeight.w600,
              //           textAlign: TextAlign.center,
              //           textColor: productDetailsModel?.stockAvailable == null
              //               ? Colors.green
              //               : getStockStatusTextColor(
              //                   productDetailsModel?.stockAvailable ?? ""),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // CommonText(
              //   content:
              //       "${getStockStatusText(productDetailsModel?.stockAvailable ?? "")}",
              //   textSize: 15,
              //   boldNess: FontWeight.w600,
              //   textColor: productDetailsModel?.stockAvailable == null
              //       ? Colors.green
              //       : getStockStatusTextColor(
              //           productDetailsModel?.stockAvailable ?? ""),
              // )
              // : SizedBox()
            ],
          ),
        ],
      ),
    );
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
    // bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
    // bool isTimePassedInMain =
    //     isMaxTimeStopNeededInMain ? isAfterDynamicTimeSystemCheck() : false;
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
    // bool isMaxTimeStopNeededInMain = API.needMaxTimeStopFunctionality;
    // bool isTimePassedInMain =
    //     isMaxTimeStopNeededInMain ? isAfterDynamicTimeSystemCheck() : false;
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

  Widget detailsView() {
    return Column(
      children: [
        DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Material(
              color: Colors.white,
              child: TabBar(
                controller: tabController,
                indicatorColor: ColorsConst.primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 0,
                indicator: const MD2Indicator(
                  indicatorSize: MD2IndicatorSize.normal,
                  indicatorHeight: 3.0,
                  indicatorColor: Colors.orange,
                ),
                onTap: (value) {
                  tabController!.index = value;
                  setState(() {});
                },
                tabs: const [
                  Tab(
                    child: CommonText(
                      content: "Details",
                      textColor: Colors.black,
                      boldNess: FontWeight.w600,
                    ),
                  ),
                  Tab(
                    child: CommonText(
                      content: "Salt Composition",
                      textColor: Colors.black,
                      boldNess: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        if (tabController!.index == 0)
          Html(
            data: productDetailsModel?.productDescription.toString() ?? '',
            style: {
              "body": Style(
                fontSize: FontSize(0.04 * Get.width),
              ),
            },
          ),
        if (tabController!.index == 1)
          Html(
            data: productDetailsModel?.specs.toString() ?? '',
            style: {
              "body": Style(
                fontSize: FontSize(0.04 * Get.width),
              ),
            },
          ),
      ],
    );
  }

  Widget bottomButtonsView(ProductDetailsModel? productDetailsModel) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (productDetailsModel != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            )
          ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if (widget.schemeId.isNotEmpty)
                    // if (widget.schemeId != null && widget.schemeId != "")
                    //   Row(
                    //     children: [
                    //       Image.asset(
                    //         "assets/icons/offer.png",
                    //         scale: 4,
                    //         package: 'store_app_b2b',
                    //       ),
                    //       SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.01),
                    //       CommonText(
                    //         content: "${widget.schemeName}",
                    //         textSize: 12,
                    //         boldNess: FontWeight.w600,
                    //         textColor: ColorsConst.textColor,
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ],
                    //   ),

                    Obx(
                      () => buyController.qtyList[widget.index].value > 0
                          ? Text(
                              'Total : ₹${(productDetailsModel.price * (widget.schemeId != null && widget.schemeId != "" ? buyController.buyQTYList[widget.index].value : buyController.qtyList[widget.index].value)).toStringAsFixed(2)}/-',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#FF8B03'),
                              ),
                            )
                          : SizedBox(),
                    ),

                    // if (widget.schemeId.isNotEmpty)

                    if (widget.schemeId != null || widget.schemeId != "")
                      buyController.freeQTYList[widget.index].value > 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Obx(
                                  () => CommonText(
                                    content:
                                        'Qty: ${(buyController.finalQTYList[widget.index].value).toStringAsFixed(0)}',
                                    boldNess: FontWeight.w500,
                                    textColor: ColorsConst.greyTextColor,
                                    textSize:
                                        MediaQuery.of(context).size.width *
                                            0.036,
                                  ),
                                ),
                                Obx(
                                  () => CommonText(
                                    content:
                                        '(${((buyController.buyQTYList[widget.index].value)).toStringAsFixed(2)} + ',
                                    boldNess: FontWeight.w500,
                                    textColor: ColorsConst.greyTextColor,
                                    textSize:
                                        MediaQuery.of(context).size.width *
                                            0.036,
                                  ),
                                ),
                                Obx(
                                  () => CommonText(
                                    content:
                                        '${((buyController.freeQTYList[widget.index].value)).toStringAsFixed(2)})',
                                    boldNess: FontWeight.w500,
                                    textColor: ColorsConst.greyTextColor,
                                    textSize:
                                        MediaQuery.of(context).size.width *
                                            0.036,
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                  ],
                ),
              ),
              // productDetailsModel.stockAvailable != "3"
              // ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        String userId = await SharPreferences.getString(
                                SharPreferences.loginId) ??
                            '';

                        if (userId.isEmpty) {
                          Get.dialog(const LoginDialog());
                          return;
                        }

                        if (buyController.qtyList[widget.index].value == 0) {
                          CommonSnackBar.showToast('Please Enter Qty', context,
                              showTickMark: false);
                        } else {
                          if (!gmcController.popup2ndOptionNeededB2B &&
                              productDetailsModel.stockAvailable == "0") {
                            CommonSnackBar.showError("Product not available");
                            return;
                          }
                          bool isMaxTimeStopNeededInMain =
                              API.needMaxTimeStopFunctionality;
                          bool isTimePassedInMain = isMaxTimeStopNeededInMain
                              ? await isAfterDynamicTime()
                              : false;
                          var body = [
                            {
                              "productId": productDetailsModel.id,
                              "productName": productDetailsModel.productName,
                              "mesuare": "",
                              "schemeName": widget.schemeName,
                              "schemeId": widget.schemeId,
                              "manufacturer": productDetailsModel.manufacturer,
                              "quantity":
                                  buyController.qtyList[widget.index].value,
                              "finalQuantity": buyController
                                  .finalQTYList[widget.index].value,
                              "freeQuantity":
                                  buyController.freeQTYList[widget.index].value,
                              "buyQuantity": (widget.schemeAvailable)
                                  ? buyController.buyQTYList[widget.index].value
                                  : buyController.qtyList[widget.index].value,
                              "price": productDetailsModel.price,
                              "mrp":
                                  productDetailsModel.mrp?.toStringAsFixed(2) ??
                                      productDetailsModel.mrp,
                              "skuId": widget.productId,
                              "productUrl": "",
                              "storeName": productDetailsModel.storeName,
                              "tabletsPerStrip": "",
                              "categoryName": "",
                              "prescriptionIsRequired": true,
                              "checkOutStatus": "N",
                              "priceWithGst": productDetailsModel.priceWithGst,
                              "timePassed": isTimePassedInMain ? "Y" : "N",
                              //to open popups enable this code - starts here
                              // "laterDelivery": isTimePassedInMain ? "Y" : "N",
                              //to open popups enable this code - ends here
                            }
                          ];
                          logs('Body --> $body');
                          // buyController
                          //     .getAddToCartApi(body, widget.storeId)
                          //     .then((value) {
                          //   CommonSnackBar.showToast(
                          //       'Added to Cart', context);
                          //   buyController
                          //       .qtyTextControllerList[widget.index]
                          //       .clear();
                          //   buyController
                          //       .qtyList[widget.index].value = 0;

                          //   buyController
                          //       .finalQTYList[widget.index].value = 0;
                          //   buyController
                          //       .freeQTYList[widget.index].value = 0;
                          //   buyController
                          //       .buyQTYList[widget.index].value = 0;
                          //   buyController.update();
                          //   final cartController =
                          //       Get.put(CartController());
                          //   cartController
                          //       .getVerifiedProductDataApi();
                          //   print("value>>>>>>>>>>>>>>$value");
                          //   setState(() {});
                          // });
                          final cartController = Get.put(CartController());
                          if (cartController.cartId != "") {
                            buyController
                                .checkProductAvailableInCart(
                                    cartId: cartController.cartId,
                                    skuId: widget.productId,
                                    storeId: widget.storeId)
                                .then((value) async {
                              if (value != null) {
                                if (value["status"]) {
                                  CommonSnackBar.showError(value["message"]);
                                } else {
                                  // Max Order Quantity Check Starts here
                                  if (gmcController
                                      .maxOrderQuantityCheckProductLevel
                                      .value) {
                                    if (widget.schemeAvailable) {
                                      if (widget.maxOrderQuantity != 0 &&
                                          buyController
                                                  .finalQTYList[widget.index]
                                                  .value >
                                              widget.maxOrderQuantity) {
                                        CommonSnackBar.showError(
                                            "Max order quantity for this product is ${widget.maxOrderQuantity.toStringAsFixed(0)}");
                                        return;
                                      }
                                    } else {
                                      if (widget.maxOrderQuantity != 0 &&
                                          buyController
                                                  .qtyList[widget.index].value >
                                              widget.maxOrderQuantity) {
                                        CommonSnackBar.showError(
                                            "Max order quantity for this product is ${widget.maxOrderQuantity.toStringAsFixed(0)}");
                                        return;
                                      }
                                    }
                                  }
                                  // Max Order Quantity Check Ends here

                                  //to open popups enable this code - starts here
                                  if (productDetailsModel.stockAvailable ==
                                          "1" ||
                                      productDetailsModel.stockAvailable ==
                                          "2") {
                                    dynamic data = await buyController
                                        .checkProductQuantityAvailable(
                                            skuId: widget.productId,
                                            storeId: widget.storeId);

                                    num currentQuantity =
                                        (widget.schemeAvailable)
                                            ? buyController
                                                .finalQTYList[widget.index]
                                                .value
                                            : buyController
                                                .qtyList[widget.index].value;

                                    if (data == null ||
                                        data["quantity"] == null) {
                                      CommonSnackBar.showError(
                                          "Something went wrong");
                                      return;
                                    }

                                    if (currentQuantity > data["quantity"]) {
                                      print(
                                          "checkProductQuantityAvailableData --> $data");
                                      //   if (widget.schemeAvailable) {
                                      //     CommonSnackBar.showError(
                                      //         "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                                      //   } else {
                                      //     CommonSnackBar.showError(
                                      //         "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                                      //   }

                                      //scheme calculation starts here

                                      num totalQuantityToBeAllowed = 0;
                                      num maxFreeQuantityToBeAllowed = 0;
                                      num maxQuantityToBeAllowed = 0;
                                      bool isAtleastOneFullSchemeAvailable =
                                          false;

                                      if (widget.schemeAvailable) {
                                        print(
                                            "scheme calculation current quantity -> $currentQuantity");

                                        print(
                                            "scheme calculation scheme -> ${widget.schemeName}");

                                        String input = widget.schemeName!;
                                        List<String> parts = input.split(" + ");
                                        int buyScheme = 0;
                                        int freeScheme = 0;

                                        if (parts.length == 2) {
                                          buyScheme = int.parse(parts[0]);
                                          freeScheme = int.parse(parts[1]);
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
                                            buyScheme + freeScheme;
                                        print(
                                            "scheme calculation total scheme -> ${parts}");

                                        print(
                                            "scheme calculation available quantity -> ${data["quantity"]}");

                                        num availableFullSchemeAdjustment =
                                            data["quantity"] / totalScheme;

                                        if (availableFullSchemeAdjustment < 1) {
                                          isAtleastOneFullSchemeAvailable =
                                              false;
                                        } else {
                                          isAtleastOneFullSchemeAvailable =
                                              true;
                                        }

                                        print(
                                            "scheme calculation availableFullSchemeAdjustment -> ${availableFullSchemeAdjustment}");

                                        maxQuantityToBeAllowed =
                                            isAtleastOneFullSchemeAvailable
                                                ? availableFullSchemeAdjustment
                                                        .floor() *
                                                    buyScheme
                                                : 0;

                                        maxFreeQuantityToBeAllowed =
                                            isAtleastOneFullSchemeAvailable
                                                ? availableFullSchemeAdjustment
                                                        .floor() *
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
                                            (buyScheme + freeScheme) / 2;

                                        num convertedCalculatedHalfScheme =
                                            calculatedHalfScheme.ceil();

                                        bool isHalfSchemeApplicable =
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

                                          maxQuantityToBeAllowed =
                                              maxQuantityToBeAllowed +
                                                  (calculatedHalfScheme <
                                                          convertedCalculatedHalfScheme
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

                                      bool isMaxTimeStopNeeded =
                                          API.needMaxTimeStopFunctionality;
                                      bool isTimePassed = isMaxTimeStopNeeded
                                          ? await isAfterDynamicTime()
                                          : false;

                                      print(
                                          "printing is time passed or not --> $isTimePassed");

                                      Get.dialog(
                                        barrierDismissible: false,
                                        WillPopScope(
                                          onWillPop: () async {
                                            buyController
                                                .partialOrLaterDelivery = "";
                                            buyController.update();

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
                                            backgroundColor: AppColors.appWhite,
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(15),
                                              child: GetBuilder<BuyController>(
                                                builder: (controller) {
                                                  if (widget.schemeAvailable &&
                                                      !isAtleastOneFullSchemeAvailable &&
                                                      !gmcController
                                                          .popup2ndOptionNeededB2B) {
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CommonText(
                                                            content: gmcController
                                                                .atleastOneSchemeNotApplicableText,
                                                            textColor: AppColors
                                                                .appblack,
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: width,
                                                          child: CommonText(
                                                            // content:
                                                            //     "The requested quantity exceeds available stock. This product will be delivered tomorrow. Are you sure you want to proceed?",
                                                            // textSize: width * 0.04,
                                                            content: widget
                                                                    .schemeAvailable
                                                                ? isAtleastOneFullSchemeAvailable
                                                                    // ? "Maximum quantity you can get today is ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed)"
                                                                    ? "Choose Delivery Option"
                                                                    : ""
                                                                //? "The requested quantity exceeds available stock (${data["quantity"].round()}). Please adjust the quantity within the available limit to get delivery today or you can choose full delivery tomorrow option"
                                                                // : "The requested quantity exceeds available stock. Please choose any one of the below options to proceed.",
                                                                : "Choose delivery option",
                                                            textSize:
                                                                width * 0.04,
                                                            textColor: AppColors
                                                                .appblack,
                                                            boldNess:
                                                                FontWeight.w500,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        widget.schemeAvailable
                                                            ? isAtleastOneFullSchemeAvailable
                                                                ? SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.03)
                                                                : SizedBox()
                                                            : (widget.schemeAvailable
                                                                    ? totalQuantityToBeAllowed <
                                                                        1
                                                                    : data["quantity"] <
                                                                        1)
                                                                ? SizedBox()
                                                                : SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.03,
                                                                  ),
                                                        // if (!isTimePassed)
                                                        widget.schemeAvailable &&
                                                                !isAtleastOneFullSchemeAvailable
                                                            ? SizedBox()
                                                            : (widget.schemeAvailable
                                                                    ? totalQuantityToBeAllowed <
                                                                        1
                                                                    : data["quantity"] <
                                                                        1)
                                                                ? SizedBox()
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      // if (widget
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

                                                                      controller
                                                                          .update();
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: AppColors.appblack,
                                                                              )),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            padding:
                                                                                EdgeInsets.all(10),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: controller.partialOrLaterDelivery == "P" || controller.partialOrLaterDelivery == "N" ? AppColors.appblack : AppColors.appWhite,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              CommonText(
                                                                            content: widget.schemeAvailable
                                                                                ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                                                                // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                                                                : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                                                            textSize:
                                                                                width * 0.035,
                                                                            textColor:
                                                                                AppColors.appblack,
                                                                            boldNess:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                        if (gmcController
                                                            .popup2ndOptionNeededB2B)
                                                          widget.schemeAvailable &&
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
                                                                      .partialOrLaterDelivery =
                                                                  "Y";
                                                              controller
                                                                  .update();
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                AppColors.appblack,
                                                                          )),
                                                                  child:
                                                                      Container(
                                                                    height: 15,
                                                                    width: 15,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      // color: AppColors.appblack,
                                                                      color: controller.partialOrLaterDelivery ==
                                                                              "Y"
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
                                                                  child:
                                                                      CommonText(
                                                                    content: widget
                                                                            .schemeAvailable
                                                                        ? '${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${(controller.finalQTYList[widget.index].value).toStringAsFixed(0)} (${((controller.buyQTYList[widget.index].value)).toStringAsFixed(2)} + ${((controller.freeQTYList[widget.index].value)).toStringAsFixed(2)}) Quantity'
                                                                        : "${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${controller.qtyTextControllerList[widget.index].text} Quantity",
                                                                    textSize:
                                                                        width *
                                                                            0.035,
                                                                    textColor:
                                                                        AppColors
                                                                            .appblack,
                                                                    boldNess:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.03),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    side: const BorderSide(
                                                                        color: AppColors
                                                                            .appblack)),
                                                                onPressed: () {
                                                                  controller
                                                                      .partialOrLaterDelivery = "";
                                                                  controller
                                                                      .update();
                                                                  // Get.back();

                                                                  for (int i =
                                                                          0;
                                                                      i < 4;
                                                                      i++) {
                                                                    if (Get
                                                                        .isDialogOpen!) {
                                                                      print(
                                                                          "printing get currrent loop -> $i");
                                                                      Get.back();
                                                                    }
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          0),
                                                                  child:
                                                                      CommonText(
                                                                    content:
                                                                        "Back",
                                                                    textSize:
                                                                        width *
                                                                            0.035,
                                                                    textColor:
                                                                        AppColors
                                                                            .appblack,
                                                                    boldNess:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            // SizedBox(width: 10),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  elevation: 0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  if (controller
                                                                          .partialOrLaterDelivery ==
                                                                      "") {
                                                                    CommonSnackBar
                                                                        .showError(
                                                                            "Please select the option to proceed");
                                                                    return;
                                                                  }

                                                                  if (widget
                                                                          .schemeAvailable &&
                                                                      controller
                                                                              .partialOrLaterDelivery ==
                                                                          "N") {
                                                                    await controller
                                                                        .getSchemeQty(
                                                                      schemeId:
                                                                          widget.schemeId ??
                                                                              "",
                                                                      schemeName:
                                                                          widget.schemeName ??
                                                                              "",
                                                                      addBuyQty:
                                                                          maxQuantityToBeAllowed,
                                                                      addFreeQty:
                                                                          maxFreeQuantityToBeAllowed,
                                                                      finalQty:
                                                                          0,
                                                                      quantity:
                                                                          maxQuantityToBeAllowed
                                                                              .toInt(),
                                                                      index: widget
                                                                          .index,
                                                                    );

                                                                    controller
                                                                        .qtyTextControllerList[
                                                                            widget.index]
                                                                        .text = '${maxQuantityToBeAllowed.floor()}';
                                                                    controller
                                                                            .qtyList[widget
                                                                                .index]
                                                                            .value =
                                                                        maxQuantityToBeAllowed
                                                                            .floor();
                                                                  }

                                                                  body = [
                                                                    {
                                                                      "productId":
                                                                          productDetailsModel
                                                                              .id,
                                                                      "productName":
                                                                          productDetailsModel
                                                                              .productName,
                                                                      "mesuare":
                                                                          "",
                                                                      "schemeName":
                                                                          widget
                                                                              .schemeName,
                                                                      "schemeId":
                                                                          widget
                                                                              .schemeId,
                                                                      "manufacturer":
                                                                          productDetailsModel
                                                                              .manufacturer,
                                                                      "quantity": !widget.schemeAvailable &&
                                                                              controller.partialOrLaterDelivery ==
                                                                                  "N"
                                                                          ? data["quantity"]
                                                                              .toInt()
                                                                          : controller
                                                                              .qtyList[widget.index]
                                                                              .value,
                                                                      "finalQuantity": controller
                                                                          .finalQTYList[
                                                                              widget.index]
                                                                          .value,
                                                                      "freeQuantity": controller
                                                                          .freeQTYList[
                                                                              widget.index]
                                                                          .value,
                                                                      "buyQuantity": (widget
                                                                              .schemeAvailable)
                                                                          ? controller
                                                                              .buyQTYList[widget.index]
                                                                              .value
                                                                          : controller.partialOrLaterDelivery == "N"
                                                                              ? data["quantity"].toInt()
                                                                              : controller.qtyList[widget.index].value,
                                                                      "price":
                                                                          productDetailsModel
                                                                              .price,
                                                                      "mrp": productDetailsModel
                                                                              .mrp
                                                                              ?.toStringAsFixed(2) ??
                                                                          productDetailsModel.mrp,
                                                                      "skuId":
                                                                          widget
                                                                              .productId,
                                                                      "productUrl":
                                                                          "",
                                                                      "storeName":
                                                                          productDetailsModel
                                                                              .storeName,
                                                                      "tabletsPerStrip":
                                                                          "",
                                                                      "categoryName":
                                                                          "",
                                                                      "prescriptionIsRequired":
                                                                          true,
                                                                      "checkOutStatus":
                                                                          "N",
                                                                      "priceWithGst":
                                                                          productDetailsModel
                                                                              .priceWithGst,
                                                                      "timePassed": isTimePassedInMain
                                                                          ? "Y"
                                                                          : "N",
                                                                    }
                                                                  ];

                                                                  body[0]["laterDelivery"] =
                                                                      controller
                                                                          .partialOrLaterDelivery;

                                                                  print(
                                                                      "printing body in get dialog ---> ${body}");

                                                                  controller
                                                                      .getAddToCartApi(
                                                                          body,
                                                                          widget
                                                                              .storeId)
                                                                      .then(
                                                                    (value) {
                                                                      dynamic
                                                                          val =
                                                                          jsonDecode(
                                                                              value);

                                                                      if (val is Map<
                                                                              String,
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
                                                                        CommonSnackBar.showError(
                                                                            val["message"]);
                                                                      }

                                                                      if (val is! Map<
                                                                              String,
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
                                                                      buyController
                                                                          .qtyTextControllerList[
                                                                              widget.index]
                                                                          .clear();
                                                                      buyController
                                                                          .qtyList[
                                                                              widget.index]
                                                                          .value = 0;

                                                                      buyController
                                                                          .finalQTYList[
                                                                              widget.index]
                                                                          .value = 0;
                                                                      buyController
                                                                          .freeQTYList[
                                                                              widget.index]
                                                                          .value = 0;
                                                                      buyController
                                                                          .buyQTYList[
                                                                              widget.index]
                                                                          .value = 0;
                                                                      buyController
                                                                          .update();
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
                                                                  controller
                                                                      .update();
                                                                  // Get.back();
                                                                  for (int i =
                                                                          0;
                                                                      i < 4;
                                                                      i++) {
                                                                    if (Get
                                                                        .isDialogOpen!) {
                                                                      print(
                                                                          "printing get currrent loop -> $i");
                                                                      Get.back();
                                                                    }
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          0),
                                                                  child:
                                                                      CommonText(
                                                                    // content:
                                                                    // "Add To Cart in if",
                                                                    content:
                                                                        "Add To Cart",
                                                                    textSize:
                                                                        width *
                                                                            0.035,
                                                                    textColor:
                                                                        AppColors
                                                                            .appWhite,
                                                                    boldNess:
                                                                        FontWeight
                                                                            .w500,
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
                                        // Dialog(
                                        //   shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(10),
                                        //     ),
                                        //   ),
                                        //   backgroundColor:
                                        //       AppColors.primaryColor,
                                        //   child: Container(
                                        //     padding: const EdgeInsets.all(15),
                                        //     child: Column(
                                        //       mainAxisSize: MainAxisSize.min,
                                        //       children: [
                                        //         SizedBox(
                                        //           width: width,
                                        //           child: CommonText(
                                        //             content:
                                        //                 "The requested quantity exceeds available stock. This product will be delivered tomorrow. Are you sure you want to proceed?",
                                        //             textSize: width * 0.04,
                                        //             textColor: Colors.white,
                                        //             boldNess: FontWeight.w500,
                                        //             textAlign: TextAlign.center,
                                        //           ),
                                        //         ),
                                        //         SizedBox(height: height * 0.03),
                                        //         Row(
                                        //           children: [
                                        //             Expanded(
                                        //               child: ElevatedButton(
                                        //                 style: ElevatedButton.styleFrom(
                                        //                     elevation: 0,
                                        //                     backgroundColor:
                                        //                         Colors
                                        //                             .transparent,
                                        //                     side: const BorderSide(
                                        //                         color: AppColors
                                        //                             .appWhite)),
                                        //                 onPressed: () {
                                        //                   Get.back();
                                        //                 },
                                        //                 child: Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                               .symmetric(
                                        //                           horizontal:
                                        //                               0),
                                        //                   child: CommonText(
                                        //                     content: "Back",
                                        //                     textSize:
                                        //                         width * 0.035,
                                        //                     textColor: AppColors
                                        //                         .appWhite,
                                        //                     boldNess:
                                        //                         FontWeight.w500,
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(width: 10),
                                        //             Expanded(
                                        //               child: ElevatedButton(
                                        //                 style: ElevatedButton
                                        //                     .styleFrom(
                                        //                   elevation: 0,
                                        //                   backgroundColor:
                                        //                       Colors.white,
                                        //                 ),
                                        //                 onPressed: () async {
                                        //                   body[0]["laterDelivery"] =
                                        //                       "Y";
                                        //                   buyController
                                        //                       .getAddToCartApi(
                                        //                           body,
                                        //                           widget
                                        //                               .storeId)
                                        //                       .then((value) {
                                        //                     CommonSnackBar
                                        //                         .showToast(
                                        //                             'Added to Cart',
                                        //                             context);
                                        //                     buyController
                                        //                         .qtyTextControllerList[
                                        //                             widget
                                        //                                 .index]
                                        //                         .clear();
                                        //                     buyController
                                        //                         .qtyList[widget
                                        //                             .index]
                                        //                         .value = 0;

                                        //                     buyController
                                        //                         .finalQTYList[
                                        //                             widget
                                        //                                 .index]
                                        //                         .value = 0;
                                        //                     buyController
                                        //                         .freeQTYList[
                                        //                             widget
                                        //                                 .index]
                                        //                         .value = 0;
                                        //                     buyController
                                        //                         .buyQTYList[
                                        //                             widget
                                        //                                 .index]
                                        //                         .value = 0;
                                        //                     buyController
                                        //                         .update();
                                        //                     final cartController =
                                        //                         Get.put(
                                        //                             CartController());
                                        //                     cartController
                                        //                         .getVerifiedProductDataApi();
                                        //                     print(
                                        //                         "value>>>>>>>>>>>>>>$value");
                                        //                   });
                                        //                   Get.back();
                                        //                 },
                                        //                 child: Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                               .symmetric(
                                        //                           horizontal:
                                        //                               0),
                                        //                   child: CommonText(
                                        //                     content:
                                        //                         "Add To Cart",
                                        //                     textSize:
                                        //                         width * 0.035,
                                        //                     textColor: AppColors
                                        //                         .primaryColor,
                                        //                     boldNess:
                                        //                         FontWeight.w500,
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             )
                                        //           ],
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      );

                                      return;
                                    }
                                  }

                                  //to open popups enable this code - starts here
                                  body[0]["laterDelivery"] =
                                      productDetailsModel.stockAvailable == "1"
                                          ? "N"
                                          : "Y";
                                  //to open popups enable this code - ends here

                                  await buyController
                                      .getAddToCartApi(body, widget.storeId)
                                      .then((value) {
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

                                    CommonSnackBar.showToast(
                                        'Added to Cart', context);
                                    buyController
                                        .qtyTextControllerList[widget.index]
                                        .clear();
                                    buyController.qtyList[widget.index].value =
                                        0;

                                    buyController
                                        .finalQTYList[widget.index].value = 0;
                                    buyController
                                        .freeQTYList[widget.index].value = 0;
                                    buyController
                                        .buyQTYList[widget.index].value = 0;
                                    buyController.update();
                                    final cartController =
                                        Get.put(CartController());
                                    cartController.getVerifiedProductDataApi();
                                    print("value>>>>>>>>>>>>>>$value");
                                  });
                                }
                              }
                            });
                          } else {
                            print("else is called");

                            // Max Order Quantity Check Starts here
                            if (gmcController
                                .maxOrderQuantityCheckProductLevel.value) {
                              if (widget.schemeAvailable) {
                                if (widget.maxOrderQuantity != 0 &&
                                    buyController
                                            .finalQTYList[widget.index].value >
                                        widget.maxOrderQuantity) {
                                  CommonSnackBar.showError(
                                      "Max order quantity for this product is ${widget.maxOrderQuantity.toStringAsFixed(0)}");
                                  return;
                                }
                              } else {
                                if (widget.maxOrderQuantity != 0 &&
                                    buyController.qtyList[widget.index].value >
                                        widget.maxOrderQuantity) {
                                  CommonSnackBar.showError(
                                      "Max order quantity for this product is ${widget.maxOrderQuantity.toStringAsFixed(0)}");
                                  return;
                                }
                              }
                            }
                            // Max Order Quantity Check Ends here

                            //to open popups enable this code - starts here
                            if (productDetailsModel.stockAvailable == "1" ||
                                productDetailsModel.stockAvailable == "2") {
                              dynamic data = await buyController
                                  .checkProductQuantityAvailable(
                                      skuId: widget.productId,
                                      storeId: widget.storeId);

                              num currentQuantity = (widget.schemeAvailable)
                                  ? buyController
                                      .finalQTYList[widget.index].value
                                  : buyController.qtyList[widget.index].value;

                              if (data == null || data["quantity"] == null) {
                                CommonSnackBar.showError(
                                    "Something went wrong");
                                return;
                              }

                              if (currentQuantity > data["quantity"]) {
                                print(
                                    "checkProductQuantityAvailableData --> $data");
                                //   if (widget.schemeAvailable) {
                                //     CommonSnackBar.showError(
                                //         "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                                //   } else {
                                //     CommonSnackBar.showError(
                                //         "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                                //   }

                                //scheme calculation starts here

                                num totalQuantityToBeAllowed = 0;
                                num maxFreeQuantityToBeAllowed = 0;
                                num maxQuantityToBeAllowed = 0;
                                bool isAtleastOneFullSchemeAvailable = false;

                                if (widget.schemeAvailable) {
                                  print(
                                      "scheme calculation current quantity -> $currentQuantity");

                                  print(
                                      "scheme calculation scheme -> ${widget.schemeName}");

                                  String input = widget.schemeName!;
                                  List<String> parts = input.split(" + ");
                                  int buyScheme = 0;
                                  int freeScheme = 0;

                                  if (parts.length == 2) {
                                    buyScheme = int.parse(parts[0]);
                                    freeScheme = int.parse(parts[1]);
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

                                  num totalScheme = buyScheme + freeScheme;
                                  print(
                                      "scheme calculation total scheme -> ${parts}");

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

                                  maxQuantityToBeAllowed =
                                      isAtleastOneFullSchemeAvailable
                                          ? availableFullSchemeAdjustment
                                                  .floor() *
                                              buyScheme
                                          : 0;

                                  maxFreeQuantityToBeAllowed =
                                      isAtleastOneFullSchemeAvailable
                                          ? availableFullSchemeAdjustment
                                                  .floor() *
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
                                      (buyScheme + freeScheme) / 2;

                                  num convertedCalculatedHalfScheme =
                                      calculatedHalfScheme.ceil();

                                  bool isHalfSchemeApplicable =
                                      quantityRemainingAfterFullSchemes >=
                                          convertedCalculatedHalfScheme;

                                  if (isAtleastOneFullSchemeAvailable ==
                                          false &&
                                      isHalfSchemeApplicable) {
                                    isAtleastOneFullSchemeAvailable = true;
                                  }

                                  if (isHalfSchemeApplicable) {
                                    totalQuantityToBeAllowed =
                                        totalQuantityToBeAllowed +
                                            convertedCalculatedHalfScheme;

                                    maxQuantityToBeAllowed =
                                        maxQuantityToBeAllowed +
                                            (calculatedHalfScheme <
                                                    convertedCalculatedHalfScheme
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

                                bool isMaxTimeStopNeeded =
                                    API.needMaxTimeStopFunctionality;
                                bool isTimePassed = isMaxTimeStopNeeded
                                    ? await isAfterDynamicTime()
                                    : false;

                                print(
                                    "printing is time passed or not --> $isTimePassed");

                                Get.dialog(
                                  barrierDismissible: false,
                                  WillPopScope(
                                    onWillPop: () async {
                                      buyController.partialOrLaterDelivery = "";
                                      buyController.update();
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
                                      backgroundColor: AppColors.appWhite,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        child: GetBuilder<BuyController>(
                                          builder: (controller) {
                                            if (widget.schemeAvailable &&
                                                !isAtleastOneFullSchemeAvailable &&
                                                !gmcController
                                                    .popup2ndOptionNeededB2B) {
                                              return SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CommonText(
                                                      content: gmcController
                                                          .atleastOneSchemeNotApplicableText,
                                                      textColor:
                                                          AppColors.appblack,
                                                      boldNess: FontWeight.w500,
                                                      textAlign:
                                                          TextAlign.center,
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
                                                      content: widget
                                                              .schemeAvailable
                                                          ? isAtleastOneFullSchemeAvailable
                                                              // ? "Maximum quantity you can get today is ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed)"
                                                              ? "Choose Delivery Option"
                                                              : ""
                                                          //? "The requested quantity exceeds available stock (${data["quantity"].round()}). Please adjust the quantity within the available limit to get delivery today or you can choose full delivery tomorrow option"
                                                          // : "The requested quantity exceeds available stock. Please choose any one of the below options to proceed.",
                                                          : "Choose delivery option",
                                                      textSize: width * 0.04,
                                                      textColor:
                                                          AppColors.appblack,
                                                      boldNess: FontWeight.w500,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  // if (!isTimePassed)
                                                  widget.schemeAvailable
                                                      ? isAtleastOneFullSchemeAvailable
                                                          ? SizedBox(
                                                              height:
                                                                  height * 0.02)
                                                          : SizedBox()
                                                      : (widget.schemeAvailable
                                                              ? totalQuantityToBeAllowed <
                                                                  1
                                                              : data["quantity"] <
                                                                  1)
                                                          ? SizedBox()
                                                          : SizedBox(
                                                              height:
                                                                  height * 0.02,
                                                            ),
                                                  widget.schemeAvailable &&
                                                          !isAtleastOneFullSchemeAvailable
                                                      ? SizedBox()
                                                      : (widget.schemeAvailable
                                                              ? totalQuantityToBeAllowed <
                                                                  1
                                                              : data["quantity"] <
                                                                  1)
                                                          ? SizedBox()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                // if (widget
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

                                                                controller
                                                                    .update();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: 20,
                                                                    width: 20,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border: Border.all(
                                                                              color: AppColors.appblack,
                                                                            )),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: controller.partialOrLaterDelivery == "P" ||
                                                                                controller.partialOrLaterDelivery == "N"
                                                                            ? AppColors.appblack
                                                                            : AppColors.appWhite,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        CommonText(
                                                                      content: widget
                                                                              .schemeAvailable
                                                                          ? "${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${totalQuantityToBeAllowed}($maxQuantityToBeAllowed + $maxFreeQuantityToBeAllowed) Quantity"
                                                                          // : "Partial Delivery ( ${(data["quantity"]).toStringAsFixed(0)} will be delivered today , ${(currentQuantity - data["quantity"]).toStringAsFixed(0)} will be delivered tomorrow )",
                                                                          : '${isTimePassed ? "Available, Tomorrow Delivery" : "Today Delivery"} : ${data["quantity"].toStringAsFixed(0)} Quantity',
                                                                      textSize:
                                                                          width *
                                                                              0.035,
                                                                      textColor:
                                                                          AppColors
                                                                              .appblack,
                                                                      boldNess:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                  if (gmcController
                                                      .popup2ndOptionNeededB2B)
                                                    widget.schemeAvailable &&
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
                                                                .partialOrLaterDelivery =
                                                            "Y";
                                                        controller.update();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 20,
                                                            width: 20,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColors
                                                                          .appblack,
                                                                    )),
                                                            child: Container(
                                                              height: 15,
                                                              width: 15,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                // color: AppColors.appblack,
                                                                color: controller
                                                                            .partialOrLaterDelivery ==
                                                                        "Y"
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
                                                              content: widget
                                                                      .schemeAvailable
                                                                  ? '${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${(controller.finalQTYList[widget.index].value).toStringAsFixed(0)} (${((controller.buyQTYList[widget.index].value)).toStringAsFixed(2)} + ${((controller.freeQTYList[widget.index].value)).toStringAsFixed(2)}) Quantity'
                                                                  : "${isTimePassed ? "Later delivery" : "Tomorrow Delivery"} : ${controller.qtyTextControllerList[widget.index].text} Quantity",
                                                              textSize:
                                                                  width * 0.035,
                                                              textColor:
                                                                  AppColors
                                                                      .appblack,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  SizedBox(
                                                      height: height * 0.03),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              side: const BorderSide(
                                                                  color: AppColors
                                                                      .appblack)),
                                                          onPressed: () {
                                                            controller
                                                                .partialOrLaterDelivery = "";
                                                            controller.update();
                                                            // Get.back();
                                                            for (int i = 0;
                                                                i < 4;
                                                                i++) {
                                                              if (Get
                                                                  .isDialogOpen!) {
                                                                print(
                                                                    "printing get currrent loop -> $i");
                                                                Get.back();
                                                              }
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            child: CommonText(
                                                              content: "Back",
                                                              textSize:
                                                                  width * 0.035,
                                                              textColor:
                                                                  AppColors
                                                                      .appblack,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      // SizedBox(width: 10),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                Colors.black,
                                                          ),
                                                          onPressed: () async {
                                                            if (controller
                                                                    .partialOrLaterDelivery ==
                                                                "") {
                                                              CommonSnackBar
                                                                  .showError(
                                                                      "Please select the option to proceed");
                                                              return;
                                                            }

                                                            if (widget
                                                                    .schemeAvailable &&
                                                                controller
                                                                        .partialOrLaterDelivery ==
                                                                    "N") {
                                                              await controller
                                                                  .getSchemeQty(
                                                                schemeId: widget
                                                                        .schemeId ??
                                                                    "",
                                                                schemeName:
                                                                    widget.schemeName ??
                                                                        "",
                                                                addBuyQty:
                                                                    maxQuantityToBeAllowed,
                                                                addFreeQty:
                                                                    maxFreeQuantityToBeAllowed,
                                                                finalQty: 0,
                                                                quantity:
                                                                    maxQuantityToBeAllowed
                                                                        .toInt(),
                                                                index: widget
                                                                    .index,
                                                              );

                                                              controller
                                                                  .qtyTextControllerList[
                                                                      widget
                                                                          .index]
                                                                  .text = '${maxQuantityToBeAllowed.floor()}';
                                                              controller
                                                                      .qtyList[
                                                                          widget
                                                                              .index]
                                                                      .value =
                                                                  maxQuantityToBeAllowed
                                                                      .floor();
                                                            }

                                                            body = [
                                                              {
                                                                "productId":
                                                                    productDetailsModel
                                                                        .id,
                                                                "productName":
                                                                    productDetailsModel
                                                                        .productName,
                                                                "mesuare": "",
                                                                "schemeName": widget
                                                                    .schemeName,
                                                                "schemeId": widget
                                                                    .schemeId,
                                                                "manufacturer":
                                                                    productDetailsModel
                                                                        .manufacturer,
                                                                "quantity": !widget
                                                                            .schemeAvailable &&
                                                                        controller.partialOrLaterDelivery ==
                                                                            "N"
                                                                    ? data["quantity"]
                                                                        .toInt()
                                                                    : controller
                                                                        .qtyList[
                                                                            widget.index]
                                                                        .value,
                                                                "finalQuantity":
                                                                    controller
                                                                        .finalQTYList[
                                                                            widget.index]
                                                                        .value,
                                                                "freeQuantity":
                                                                    controller
                                                                        .freeQTYList[
                                                                            widget.index]
                                                                        .value,
                                                                "buyQuantity": (widget
                                                                        .schemeAvailable)
                                                                    ? controller
                                                                        .buyQTYList[widget
                                                                            .index]
                                                                        .value
                                                                    : controller.partialOrLaterDelivery ==
                                                                            "N"
                                                                        ? data["quantity"]
                                                                            .toInt()
                                                                        : controller
                                                                            .qtyList[widget.index]
                                                                            .value,
                                                                "price":
                                                                    productDetailsModel
                                                                        .price,
                                                                "mrp": productDetailsModel
                                                                        .mrp
                                                                        ?.toStringAsFixed(
                                                                            2) ??
                                                                    productDetailsModel
                                                                        .mrp,
                                                                "skuId": widget
                                                                    .productId,
                                                                "productUrl":
                                                                    "",
                                                                "storeName":
                                                                    productDetailsModel
                                                                        .storeName,
                                                                "tabletsPerStrip":
                                                                    "",
                                                                "categoryName":
                                                                    "",
                                                                "prescriptionIsRequired":
                                                                    true,
                                                                "checkOutStatus":
                                                                    "N",
                                                                "priceWithGst":
                                                                    productDetailsModel
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

                                                            controller
                                                                .getAddToCartApi(
                                                                    body,
                                                                    widget
                                                                        .storeId)
                                                                .then(
                                                              (value) {
                                                                dynamic val =
                                                                    jsonDecode(
                                                                        value);

                                                                if (val is Map<
                                                                        String,
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

                                                                if (val is! Map<
                                                                        String,
                                                                        dynamic> ||
                                                                    !val.containsKey(
                                                                        "id")) {
                                                                  return;
                                                                }

                                                                print(
                                                                    "printing getAddToCartApi return value ---> $value");
                                                                CommonSnackBar
                                                                    .showToast(
                                                                        'Added to Cart',
                                                                        context);
                                                                buyController
                                                                    .qtyTextControllerList[
                                                                        widget
                                                                            .index]
                                                                    .clear();
                                                                buyController
                                                                    .qtyList[widget
                                                                        .index]
                                                                    .value = 0;

                                                                buyController
                                                                    .finalQTYList[
                                                                        widget
                                                                            .index]
                                                                    .value = 0;
                                                                buyController
                                                                    .freeQTYList[
                                                                        widget
                                                                            .index]
                                                                    .value = 0;
                                                                buyController
                                                                    .buyQTYList[
                                                                        widget
                                                                            .index]
                                                                    .value = 0;
                                                                buyController
                                                                    .update();
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

                                                            // Get.back();
                                                            for (int i = 0;
                                                                i < 4;
                                                                i++) {
                                                              if (Get
                                                                  .isDialogOpen!) {
                                                                print(
                                                                    "printing get currrent loop -> $i");
                                                                Get.back();
                                                              }
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            child: CommonText(
                                                              // content:
                                                              //     "Add To Cart in else",
                                                              content:
                                                                  "Add To Cart",
                                                              textSize:
                                                                  width * 0.035,
                                                              textColor:
                                                                  AppColors
                                                                      .appWhite,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
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

                            //to open popups enable this code - starts here
                            body[0]["laterDelivery"] =
                                productDetailsModel.stockAvailable == "1"
                                    ? "N"
                                    : "Y";
                            //to open popups enable this code - starts here
                            buyController
                                .getAddToCartApi(body, widget.storeId)
                                .then((value) {
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

                              if (value != null) {
                                CommonSnackBar.showToast(
                                    'Added to Cart', context);
                              }

                              buyController.qtyTextControllerList[widget.index]
                                  .clear();
                              buyController.qtyList[widget.index].value = 0;

                              buyController.finalQTYList[widget.index].value =
                                  0;
                              buyController.freeQTYList[widget.index].value = 0;
                              buyController.buyQTYList[widget.index].value = 0;
                              buyController.update();
                              final cartController = Get.put(CartController());
                              cartController.getVerifiedProductDataApi();
                              print("value>>>>>>>>>>>>>>$value");
                            });
                          }
                        }
                        ;
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
                    ),
                  ),

                  // Obx(() => Expanded(
                  //       child: OutlinedButton(
                  //         style: OutlinedButton.styleFrom(
                  //           minimumSize: const Size.fromHeight(32),
                  //           side: BorderSide(
                  //               color: HexColor('#FF8B03'),
                  //               width: 1.0,
                  //               style: BorderStyle.solid),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(5.0),
                  //           ),
                  //         ),
                  //         onPressed: () async {
                  //           if (buyController
                  //                   .qtyList[widget.index].value ==
                  //               0) {
                  //             CommonSnackBar.showToast(
                  //                 'Please Enter Qty', context,
                  //                 showTickMark: false);
                  //           } else {
                  //             var body = [
                  //               {
                  //                 "productId": productDetailsModel.id,
                  //                 "productName":
                  //                     productDetailsModel.productName,
                  //                 "mesuare": "",
                  //                 "schemeName": widget.schemeName,
                  //                 "schemeId": widget.schemeId,
                  //                 "manufacturer":
                  //                     productDetailsModel.manufacturer,
                  //                 "quantity": buyController
                  //                     .qtyList[widget.index].value,
                  //                 "finalQuantity": buyController
                  //                     .finalQTYList[widget.index].value,
                  //                 "freeQuantity": buyController
                  //                     .freeQTYList[widget.index].value,
                  //                 "buyQuantity": (widget.schemeAvailable)
                  //                     ? buyController
                  //                         .buyQTYList[widget.index].value
                  //                     : buyController
                  //                         .qtyList[widget.index].value,
                  //                 "price": productDetailsModel.price,
                  //                 "mrp": productDetailsModel.mrp
                  //                         ?.toStringAsFixed(2) ??
                  //                     productDetailsModel.mrp,
                  //                 "skuId": widget.productId,
                  //                 "productUrl": "",
                  //                 "storeName":
                  //                     productDetailsModel.storeName,
                  //                 "tabletsPerStrip": "",
                  //                 "categoryName": "",
                  //                 "prescriptionIsRequired": true
                  //               }
                  //             ];
                  //             logs('Body --> $body');
                  //             // buyController
                  //             //     .getAddToCartApi(body, widget.storeId)
                  //             //     .then((value) {
                  //             //   CommonSnackBar.showToast(
                  //             //       'Added to Cart', context);
                  //             //   buyController
                  //             //       .qtyTextControllerList[widget.index]
                  //             //       .clear();
                  //             //   buyController
                  //             //       .qtyList[widget.index].value = 0;

                  //             //   buyController
                  //             //       .finalQTYList[widget.index].value = 0;
                  //             //   buyController
                  //             //       .freeQTYList[widget.index].value = 0;
                  //             //   buyController
                  //             //       .buyQTYList[widget.index].value = 0;
                  //             //   buyController.update();
                  //             //   final cartController =
                  //             //       Get.put(CartController());
                  //             //   cartController
                  //             //       .getVerifiedProductDataApi();
                  //             //   print("value>>>>>>>>>>>>>>$value");
                  //             //   setState(() {});
                  //             // });
                  //             final cartController =
                  //                 Get.put(CartController());
                  //             if (cartController.cartId != "") {
                  //               buyController
                  //                   .checkProductAvailableInCart(
                  //                       cartId: cartController.cartId,
                  //                       skuId: widget.productId,
                  //                       storeId: widget.storeId)
                  //                   .then((value) async {
                  //                 if (value != null) {
                  //                   if (value["status"]) {
                  //                     CommonSnackBar.showError(
                  //                         value["message"]);
                  //                   } else {
                  //                     dynamic data = await buyController
                  //                         .checkProductQuantityAvailable(
                  //                             skuId: widget.productId,
                  //                             storeId: widget.storeId);

                  //                     num currentQuantity = (widget
                  //                             .schemeAvailable)
                  //                         ? buyController
                  //                             .finalQTYList[widget.index]
                  //                             .value
                  //                         : buyController
                  //                             .qtyList[widget.index]
                  //                             .value;

                  //                     if (data == null ||
                  //                         data["quantity"] == null) {
                  //                       CommonSnackBar.showError(
                  //                           "Something went wrong");
                  //                       return;
                  //                     }

                  //                     if (currentQuantity >
                  //                         data["quantity"]) {
                  //                       if (widget.schemeAvailable) {
                  //                         CommonSnackBar.showError(
                  //                             "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                  //                       } else {
                  //                         CommonSnackBar.showError(
                  //                             "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                  //                       }

                  //                       return;
                  //                     }

                  //                     buyController
                  //                         .getAddToCartApi(
                  //                             body, widget.storeId)
                  //                         .then((value) {
                  //                       CommonSnackBar.showToast(
                  //                           'Added to Cart', context);
                  //                       buyController
                  //                           .qtyTextControllerList[
                  //                               widget.index]
                  //                           .clear();
                  //                       buyController
                  //                           .qtyList[widget.index]
                  //                           .value = 0;

                  //                       buyController
                  //                           .finalQTYList[widget.index]
                  //                           .value = 0;
                  //                       buyController
                  //                           .freeQTYList[widget.index]
                  //                           .value = 0;
                  //                       buyController
                  //                           .buyQTYList[widget.index]
                  //                           .value = 0;
                  //                       buyController.update();
                  //                       final cartController =
                  //                           Get.put(CartController());
                  //                       cartController
                  //                           .getVerifiedProductDataApi();
                  //                       print(
                  //                           "value>>>>>>>>>>>>>>$value");
                  //                     });
                  //                   }
                  //                 }
                  //               });
                  //             } else {
                  //               print("else is called");
                  //               dynamic data = await buyController
                  //                   .checkProductQuantityAvailable(
                  //                       skuId: widget.productId,
                  //                       storeId: widget.storeId);

                  //               num currentQuantity =
                  //                   (widget.schemeAvailable)
                  //                       ? buyController
                  //                           .finalQTYList[widget.index]
                  //                           .value
                  //                       : buyController
                  //                           .qtyList[widget.index].value;

                  //               if (data == null ||
                  //                   data["quantity"] == null) {
                  //                 CommonSnackBar.showError(
                  //                     "Something went wrong");
                  //                 return;
                  //               }

                  //               if (currentQuantity > data["quantity"]) {
                  //                 if (widget.schemeAvailable) {
                  //                   CommonSnackBar.showError(
                  //                       "Maximum allowed quantity is ${data["quantity"].round()}...you are placing ${currentQuantity.round()} quantity");
                  //                 } else {
                  //                   CommonSnackBar.showError(
                  //                       "Maximum allowed quantity for this product is ${data["quantity"].round()}");
                  //                 }

                  //                 return;
                  //               }

                  //               buyController
                  //                   .getAddToCartApi(body, widget.storeId)
                  //                   .then((value) {
                  //                 if (value != null) {
                  //                   CommonSnackBar.showToast(
                  //                       'Added to Cart', context);
                  //                 }

                  //                 buyController
                  //                     .qtyTextControllerList[widget.index]
                  //                     .clear();
                  //                 buyController
                  //                     .qtyList[widget.index].value = 0;

                  //                 buyController.finalQTYList[widget.index]
                  //                     .value = 0;
                  //                 buyController.freeQTYList[widget.index]
                  //                     .value = 0;
                  //                 buyController
                  //                     .buyQTYList[widget.index].value = 0;
                  //                 buyController.update();
                  //                 final cartController =
                  //                     Get.put(CartController());
                  //                 cartController
                  //                     .getVerifiedProductDataApi();
                  //                 print("value>>>>>>>>>>>>>>$value");
                  //               });
                  //             }
                  //           }
                  //           ;
                  //         },
                  //         child: Text(
                  //           '₹${(productDetailsModel.price * (buyController.qtyList[widget.index].value)).toStringAsFixed(2)}/-',
                  //           style: TextStyle(
                  //             fontSize: 12.5,
                  //             fontWeight: FontWeight.w500,
                  //             color: HexColor('#FF8B03'),
                  //           ),
                  //         ),
                  //       ),
                  //     )),
                  SizedBox(width: 20),
                  // Obx(
                  // () => buyController.qtyList[widget.index].value != 0 ?
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (buyController.qtyList[widget.index].value > 0) {
                              buyController.qtyList[widget.index].value--;
                              if (buyController.qtyList[widget.index].value ==
                                  0) {
                                buyController
                                    .qtyTextControllerList[widget.index]
                                    .clear();
                              } else {
                                buyController
                                        .qtyTextControllerList[widget.index]
                                        .text =
                                    '${buyController.qtyList[widget.index]}';
                              }
                              if (widget.schemeAvailable) {
                                buyController.getSchemeQty(
                                    quantity: buyController
                                        .qtyList[widget.index].value,
                                    index: widget.index,
                                    schemeId: widget.schemeId ?? '',
                                    schemeName: widget.schemeName ?? '',
                                    addBuyQty: buyController
                                        .qtyList[widget.index].value,
                                    addFreeQty: 0,
                                    finalQty: buyController
                                        .finalQTYList[widget.index].value);
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: HexColor('#FF8B03'),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        addProductTextField(
                          controller: buyController,
                          index: widget.index,
                          prodcutDetailsModel: productDetailsModel,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (buyController.qtyList[widget.index].value <=
                                1000) {
                              buyController.qtyList[widget.index].value++;
                              logs(
                                  'qty ==> ${buyController.qtyList[widget.index].value}');
                              buyController.qtyTextControllerList[widget.index]
                                      .text =
                                  '${buyController.qtyList[widget.index].value}';
                              if (widget.schemeAvailable) {
                                buyController.getSchemeQty(
                                    quantity: buyController
                                        .qtyList[widget.index].value,
                                    index: widget.index,
                                    schemeId: widget.schemeId,
                                    schemeName: widget.schemeName,
                                    addBuyQty: buyController
                                        .qtyList[widget.index].value,
                                    addFreeQty: 0,
                                    finalQty: buyController
                                        .finalQTYList[widget.index].value);
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: HexColor('#FF8B03'),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child:
                                Icon(Icons.add, color: Colors.white, size: 25),
                          ),
                        )
                      ],
                    ),
                  )
                  // : Expanded(
                  //     child: OutlinedButton(
                  //       style: OutlinedButton.styleFrom(
                  //         backgroundColor: HexColor('#FF8B03'),
                  //         minimumSize: const Size.fromHeight(45),
                  //         side: BorderSide(
                  //             color: HexColor('#FF8B03'),
                  //             width: 1.0,
                  //             style: BorderStyle.solid),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(5.0),
                  //         ),
                  //       ),
                  //       onPressed: () async {
                  //         buyController
                  //             .qtyList[widget.index].value++;
                  //         logs(
                  //             'qty ==> ${buyController.qtyList[widget.index].value}');
                  //         buyController
                  //                 .qtyTextControllerList[widget.index]
                  //                 .text =
                  //             '${buyController.qtyList[widget.index].value}';
                  //         if (widget.schemeAvailable) {
                  //           buyController.getSchemeQty(
                  //               quantity: buyController
                  //                   .qtyList[widget.index].value,
                  //               index: widget.index,
                  //               schemeId: widget.schemeId,
                  //               schemeName: widget.schemeName,
                  //               addBuyQty: buyController
                  //                   .qtyList[widget.index].value,
                  //               addFreeQty: 0,
                  //               finalQty: buyController
                  //                   .finalQTYList[widget.index]
                  //                   .value);
                  //         }
                  //       },
                  //       child: CommonText(
                  //         content: "Add",
                  //         textSize: 12.5,
                  //         textColor: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              )
              //
              // : CommonText(
              //     content:
              //         "${getStockStatusText(productDetailsModel.stockAvailable ?? "")}",
              //     textSize: 18,
              //     boldNess: FontWeight.w600,
              //     textColor: productDetailsModel.stockAvailable == null
              //         ? Colors.green
              //         : getStockStatusTextColor(
              //             productDetailsModel.stockAvailable ?? ""),
              //   ),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }

//
  addProductTextField(
      {required BuyController controller,
      required int index,
      required ProductDetailsModel prodcutDetailsModel}) {
    return Obx(() => Expanded(
          child: Container(
            height: 32,
            margin: EdgeInsets.symmetric(horizontal: 5),
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
                if (widget.schemeId != null && widget.schemeId.isNotEmpty) {
                  controller.getSchemeQty(
                      quantity: controller.qtyList[index].value,
                      index: index,
                      schemeId: widget.schemeId ?? '',
                      schemeName: widget.schemeName ?? '',
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
                if (widget.schemeId != null && widget.schemeId.isNotEmpty) {
                  controller.getSchemeQty(
                      quantity: controller.qtyList[index].value,
                      index: index,
                      schemeId: widget.schemeId ?? '',
                      schemeName: widget.schemeName ?? '',
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
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsConst.primaryColor)),
              ),
            ),
          ),
        ));
  }
}
