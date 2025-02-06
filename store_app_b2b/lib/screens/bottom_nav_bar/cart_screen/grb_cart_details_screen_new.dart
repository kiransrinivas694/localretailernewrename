import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/model/cart_grb_model/cart_grb_model_new.dart';
import 'package:store_app_b2b/model/grb_cart_model_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/grb_module/grb_scheme_return_screen_new.dart';

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

class GrbCartDetailsScreen extends StatefulWidget {
  const GrbCartDetailsScreen({super.key});

  @override
  State<GrbCartDetailsScreen> createState() => _GrbCartDetailsScreenState();
}

class _GrbCartDetailsScreenState extends State<GrbCartDetailsScreen> {
  final controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<CartController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsConst.greyBgColor,
        appBar: AppBar(
          centerTitle: false,
          title: CommonText(
            content: "GRB Cart",
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
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: controller.grbCartDetails == null ||
                          controller.grbCartDetails!.storeVo![0].items ==
                              null ||
                          controller
                                  .grbCartDetails!.storeVo![0].items!.length ==
                              0
                      ? Center(
                          child: CommonText(
                          content: "No GRB Items in cart",
                          textColor: AppColors.appblack,
                        ))
                      : ListView.builder(
                          // controller: controller.scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          // itemCount: controller.grbReturnOrdersList.length,
                          itemCount: controller
                              .grbCartDetails!.storeVo![0].items!.length,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          // padding: EdgeInsets.only(
                          //     bottom: height * 0.1),
                          itemBuilder: (context, index) {
                            GrbItemModel searchProduct = controller
                                .grbCartDetails!.storeVo![0].items![index];
                            return Container(
                              margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                              decoration: BoxDecoration(
                                color: ColorsConst.appWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: CommonText(
                                                content:
                                                    '${searchProduct.productName == null ? '' : searchProduct.productName}',
                                                // "product name",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                boldNess: FontWeight.w600,
                                                textColor:
                                                    ColorsConst.textColor,
                                              ),
                                            ),
                                            CommonText(
                                                content:
                                                    'Batch No. ${searchProduct.batchNumber == null ? '' : searchProduct.batchNumber}',
                                                // 'Batch No. random',
                                                textSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          var body = {
                                            // "invoiceId":
                                            //     searchProduct.invoiceId,
                                            // "orderId": searchProduct.orderId,
                                            // "orderItemId": searchProduct.id,
                                            // "productId":
                                            //     searchProduct.productId,
                                            // "returnBuyQty": 0,
                                            // "returnFreeQty": 0,
                                            // "storeId": controller
                                            //         .grbCartDetails!.storeId ??
                                            //     "",
                                            // "userId": controller
                                            //         .grbCartDetails!.userId ??
                                            //     ""
                                          };

                                          controller
                                              .singleItemDeleteFromGrbCart(
                                                  storeId: controller
                                                          .grbCartDetails!
                                                          .storeVo![0]
                                                          .storeId ??
                                                      '',
                                                  itemId: controller
                                                          .grbCartDetails!
                                                          .storeVo![0]
                                                          .items![index]
                                                          .itemId ??
                                                      '',
                                                  orderId: controller
                                                          .grbCartDetails!
                                                          .storeVo![0]
                                                          .items![index]
                                                          .orderId ??
                                                      '',
                                                  cartId: controller
                                                          .grbCartDetails!.id ??
                                                      '');

                                          // controller
                                          //     .addGrbOrderToCart(body)
                                          //     .then((value) {
                                          //   print(
                                          //       "pritning value in grb cart -> $value");

                                          //   if (value != null) {
                                          //     CommonSnackBar.showError(
                                          //         "Removed from Grb Cart");
                                          //     controller.getGRBCart();
                                          //   }
                                          // });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              'assets/icons/delete_icon.png',
                                              scale: 4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Expanded(
                                      //   child: Column(
                                      //     children: [
                                      //       CommonText(
                                      //           content: 'Ordered',
                                      //           textSize: 12,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.bold),
                                      //       CommonText(
                                      //           content:
                                      //               '${searchProduct.quantity == null ? '' : formatNumber(searchProduct.quantity!.toString())}',
                                      //           // "qty",
                                      //           textSize: 14,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.w500),
                                      //     ],
                                      //   ),
                                      // ),

                                      // Expanded(
                                      //   child: Column(
                                      //     children: [
                                      //       CommonText(
                                      //           content: 'PTR',
                                      //           textSize: 12,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.bold),
                                      //       CommonText(
                                      //           content:
                                      //               '₹ ${searchProduct.finalPtr == null ? '' : searchProduct.finalPtr}',
                                      //           // "qty",
                                      //           textSize: 14,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.w500),
                                      //     ],
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            CommonText(
                                                content: 'MRP',
                                                textSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.bold),
                                            CommonText(
                                                content:
                                                    '₹ ${searchProduct.mrp == null ? '' : searchProduct.mrp}',
                                                // "qty",
                                                textSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            CommonText(
                                                content: 'PTR',
                                                textSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.bold),
                                            CommonText(
                                                content:
                                                    '₹ ${searchProduct.finalPtr == null ? '' : searchProduct.finalPtr}',
                                                // "qty",
                                                textSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            CommonText(
                                                content: 'NET RATE',
                                                textSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.bold),
                                            CommonText(
                                              content:
                                                  '₹ ${searchProduct.netRate == null ? '' : searchProduct.netRate}',
                                              // "qty",
                                              textSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              textColor: ColorsConst
                                                  .notificationTextColor,
                                              boldNess: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //   child: Column(
                                      //     children: [
                                      //       CommonText(
                                      //           content: 'Free',
                                      //           textSize: 12,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.bold),
                                      //       CommonText(
                                      //           content:
                                      //               '${searchProduct.freeQuantity == null ? '' : formatNumber(searchProduct.freeQuantity!.toString())}',
                                      //           // "qty",
                                      //           textSize: 14,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.w500),
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            CommonText(
                                                content: 'Confirmed',
                                                textSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.bold),
                                            CommonText(
                                                content:
                                                    '${searchProduct.orderedQuantity == null ? '' : formatNumber(searchProduct.orderedQuantity!.toString())}',
                                                // "qty",
                                                textSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            CommonText(
                                                content: 'Return',
                                                textSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.bold),
                                            CommonText(
                                                content:
                                                    '${searchProduct.buyQuantity == null ? '' : formatNumber(searchProduct.buyQuantity!.toString())}',
                                                // "qty",
                                                textSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: ColorsConst
                                                    .notificationTextColor,
                                                boldNess: FontWeight.w500),
                                          ],
                                        ),
                                      ),

                                      // Expanded(
                                      //   child: Column(
                                      //     children: [
                                      //       CommonText(
                                      //           content: 'Confirmed',
                                      //           textSize: 12,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.bold),
                                      //       CommonText(
                                      //           content:
                                      //               '${searchProduct.orderedQuantity == null ? '' : formatNumber(searchProduct.orderedQuantity!.toString())}',
                                      //           // "qty",
                                      //           textSize: 14,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor: ColorsConst
                                      //               .notificationTextColor,
                                      //           boldNess: FontWeight.w500),
                                      //     ],
                                      //   ),
                                      // ),
                                      // Expanded(
                                      //   child: Column(
                                      //     children: [
                                      //       CommonText(
                                      //           content: 'Final',
                                      //           textSize: 12,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor:
                                      //               ColorsConst.notificationTextColor,
                                      //           boldNess: FontWeight.bold),
                                      //       CommonText(
                                      //           content:
                                      //               // '${searchProduct.finalQuantity == null ? '' : formatNumber(searchProduct.finalQuantity!.toString())}',
                                      //               "qty",
                                      //           textSize: 14,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textColor:
                                      //               ColorsConst.notificationTextColor,
                                      //           boldNess: FontWeight.w500),
                                      //     ],
                                      //   ),
                                      // ),
                                      Expanded(child: SizedBox())
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
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
                                      searchProduct.schemeName != null &&
                                              searchProduct.schemeName != ""
                                          ? Expanded(
                                              child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/offer.png",
                                                  scale: 3.5,
                                                  package: 'store_app_b2b',
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                CommonText(
                                                    content:
                                                        '${searchProduct.schemeName == null || searchProduct.schemeName == "" ? '--' : searchProduct.schemeName}',
                                                    // "qty",
                                                    textSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textColor: ColorsConst
                                                        .notificationTextColor,
                                                    boldNess: FontWeight.bold),
                                              ],
                                            ))
                                          : Expanded(child: SizedBox()),
                                      Expanded(
                                          child: addToCartButton(
                                              index, searchProduct)),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                )),

                //bottom total container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  width: width,
                  color: Color(0xffE5E5E5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     CommonText(
                          //       content:
                          //           // "Today, ${DateFormat('dd MMM yy').format(DateTime.now())}",
                          //           "Today, date",
                          //       textColor: Colors.black,
                          //       textSize: width * 0.035,
                          //       boldNess: FontWeight.w600,
                          //     ),
                          //     SizedBox(height: height * 0.001),
                          //     CommonText(
                          //       content: "Products : count",
                          //       textSize: width * 0.035,
                          //       textColor: ColorsConst.textColor,
                          //     ),
                          //   ],
                          // ),
                          Row(
                            children: [
                              CommonText(
                                content: "Total : ",
                                textSize: width * 0.048,
                                textColor: ColorsConst.textColor,
                              ),
                              CommonText(
                                content:
                                    "₹ ${controller.grbCartDetails == null ? "0" : num.parse(controller.grbCartDetails!.storeVo![0].totalPriceByStore!.toStringAsFixed(2))}",
                                // "total value",
                                // "₹ ${controller.grbCartDetails == null ? "0" : controller.totalGrbAmount.round().toStringAsFixed(0)}",
                                textSize: width * 0.048,
                                textColor: Colors.black,
                                boldNess: FontWeight.w600,
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() =>
                controller.grbUpdateLoading.value ? AppLoader() : SizedBox())
          ],
        ),
      );
    });
  }

  addToCartButton(int index, GrbItemModel searchProduct) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GrbSchemeReturnScreen(
              schemeName: searchProduct.schemeName ?? '',
              itemId: searchProduct.itemId ?? '',
              orderId: searchProduct.orderId ?? "",
              productId: searchProduct.productId ?? "",
              isEdit: true,
              isFromScreen: searchProduct.screenDisplay ?? 'grb',
              editableBatchNo: searchProduct.batchNumber,
              confirmedQuantity: searchProduct.orderedQuantity ?? 0,
              freeQuantity: searchProduct.freeQuantity,
              returnQuantity: searchProduct.buyQuantity,
              orderedQuantity: searchProduct.quantity,
              returnReason: searchProduct.returnReason,
            ));
        return;

        // FocusManager.instance.primaryFocus!.unfocus();

        var body = {
          // "invoiceId": searchProduct.invoiceId,
          // "orderId": searchProduct.orderId,
          // "orderItemId": searchProduct.id,
          // "productId": searchProduct.productId,
          // "returnBuyQty": 0,
          // "returnFreeQty": 0,
          // "storeId": controller.grbCartDetails!.storeId ?? "",
          // "userId": controller.grbCartDetails!.userId ?? ""
        };

        // logs('$body');
        // controller.buyQuantityDialogController.text =
        //     formatNumber(searchProduct.buyQuantity!.toString());

        // controller.freeQuantityDialogController.text =
        //     formatNumber(searchProduct.freeQuantity!.toString());

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
                  CommonText(
                    content: searchProduct.orderId!,
                    // content: 'order id static',
                    textColor: AppColors.primaryColor,
                    boldNess: FontWeight.bold,
                  ),
                  CommonText(
                    content: searchProduct.productName!,
                    // content: 'product name static',
                    textColor: AppColors.appblack,
                    boldNess: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CommonText(
                        content: "Scheme Name : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                      CommonText(
                        content: searchProduct.schemeName == null ||
                                searchProduct.schemeName == ""
                            ? '--'
                            : searchProduct.schemeName!,
                        // content: 'scheme name',
                        textColor: AppColors.appblack,
                        boldNess: FontWeight.w600,
                      ),
                    ],
                  ),

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
                        // 'sdfjksdb',
                        textColor: AppColors.appblack,
                        boldNess: FontWeight.w600,
                      ),
                    ],
                  ),

                  //buy
                  Row(
                    children: [
                      CommonText(
                        content: "Return : ",
                        textColor: AppColors.appblack,
                        // boldNess: FontWeight.w600,
                      ),
                      CommonText(
                        content:
                            '${searchProduct.buyQuantity == null ? 0 : formatNumber(searchProduct.buyQuantity!.toString())}',
                        // 'sdjgffj',
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
                        // 'sjkfgdsjfsd',
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
                            '${searchProduct.finalQuantity == null ? 0 : formatNumber(searchProduct.finalQuantity!.toString())}',
                        // 'sdljkhgdfjguhdfjkg',
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
                      content: "Return Qty",
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
                      hintText: "Enter Buy Qty",
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
                        if (controller.buyQuantityDialogController.text == "") {
                          CommonSnackBar.showError("Buy qty must not be empty");
                          return;
                        }

                        if (searchProduct.schemeName != "" &&
                            searchProduct.schemeName != null) {
                          if (controller.freeQuantityDialogController.text ==
                              "") {
                            CommonSnackBar.showError(
                                "Free qty must not be empty");
                            return;
                          }
                        }

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
                          print("pritning value in grb cart -> $value");

                          if (value) {
                            CommonSnackBar.showError("Added to Grb Cart");
                            controller.getGRBCart();
                            Get.back();
                          }
                        });
                      },
                      child: Container(
                        width: 134,
                        height: 40,
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
            'Edit',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: ColorsConst.appWhite,
          ),
        ),
      ),
    );
  }
}
