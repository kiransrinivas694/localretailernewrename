import 'dart:developer';

import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/accept_decline_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/new_order_screen_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/invoicecontroller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/invoicescreen.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/view_prescription_screen.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/utils/commonWidgets.dart';
import 'package:b2c/utils/snack.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/bottom_controller/order_controller/review_order_controller.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:photo_view/photo_view.dart';
import 'package:b2c/utils/custom_date_utils.dart';
import 'package:photo_view/photo_view_gallery.dart';
import "package:flutter_cached_pdfview/src/pdf.dart";
import 'package:flutter_cached_pdfview/src/pdf_view_types.dart';

import '../controller/assign_delivery_controller.dart';

class ReviewOrderScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final String? orderStatus;
  final String? orderStatusText;

  ReviewOrderScreen(
      {Key? key,
      required this.orderData,
      this.orderStatus,
      this.orderStatusText})
      : super(key: key);

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  /*final ReviewOrderController reviewController =
      Get.put(ReviewOrderController());*/

  RxList productID = [].obs;

  RxDouble subTotal = 0.0.obs;
  RxDouble refundTotal = 0.0.obs;
  RxDouble deliveryCharges = 0.0.obs;
  RxDouble serviceCharges = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble productTotalDiscount = 0.0.obs;

  RxList items = [].obs;
  RxList removedItems = [].obs;

  RxString orderStatus = ''.obs;
  RxString orderStatusText = "".obs;
  RxString employeeProfileId = ''.obs;
  int selectedIndex = -1;

  RxBool needNewOrderTabLoad = false.obs;

  ///Text Controller
  TextEditingController cashReward = TextEditingController();

  @override
  void initState() {
    AssignDeliveryController.to.getRiderApi();
    orderStatus.value = widget.orderStatus ?? '';
    orderStatusText.value = widget.orderStatusText ?? "";
    // TODO: implement initState

    print("printing order status text ---> ${orderStatus.value}");
    log(widget.orderData.toString(), name: 'ORDER Status');
    items.clear();
    removedItems.clear();
    deliveryCharges.value =
        double.parse((widget.orderData['deliveryCharges'] ?? '0').toString());
    serviceCharges.value =
        double.parse((widget.orderData['serviceCharges'] ?? '0').toString());
    discount.value =
        double.parse((widget.orderData['discounts'] ?? '0').toString());
    // items.addAll(widget.orderData['items']);

    // widget.orderData["items"].forEach((element) {
    //   if (element["status"] == "0") {
    //     removedItems.add(element);
    //   } else {
    //     items.add(element);
    //   }
    // });

    log(widget.orderData['items'].length.toString(), name: 'ITEM BY API');
    log(items.length.toString(), name: 'items');
    // subTotal.value = 0.0;
    // items.forEach((element) {
    //   element['isSelected'] = true.obs;
    //   productID.add(element['productId']);
    //   double itemSubTotal = double.parse((element['mrp'] ?? '0').toString()) *
    //       double.parse((element['quantity'] ?? '0').toString());
    //   subTotal.value += itemSubTotal;
    // });

    print(
        "printing storeId value ---> ${GetHelperController.storeID.value.isNotEmpty}");

    if (GetHelperController.storeID.value.isNotEmpty) {
      NewOrderScreenController.to.getStoreProduct(data: {
        "storeId": GetHelperController.storeID.value,
        "productId": productID,
      });
    } else {
      if (!Get.isDialogOpen!) {
        Get.dialog(const LoginDialog());
      }
    }
    // Future.delayed(
    //   const Duration(milliseconds: 300),
    //   () {
    //     if (!Get.isDialogOpen!) {
    //       Get.dialog(const LoginDialog());
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("printing status value inside build -> ${orderStatus.value}");
    // widget.orderData['prescAdded'] = true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<NewOrderScreenController>(
        init: NewOrderScreenController(),
        initState: (state) {
          Future.delayed(
            Duration(microseconds: 300),
            () async {
              final controller = Get.find<NewOrderScreenController>();
              await controller.getOrderDetails(widget.orderData["id"]);
              if (controller.singleOrderDetail.isNotEmpty) {
                if (controller.singleOrderDetail["orderAssignedStatus"] ==
                    "1") {
                  orderStatus.value = "Delivery In Process";
                }
                if (controller.singleOrderDetail["deliveryStatus"] == "1") {
                  orderStatus.value = "Order Done";
                }
                if (controller.singleOrderDetail["orderStatus"] == "0") {
                  items.clear();
                  removedItems.clear();
                  items.addAll(widget.orderData['items']);
                  subTotal.value = 0.0;
                  refundTotal.value = 0.0;
                  productTotalDiscount.value = 0.0;

                  items.forEach((element) {
                    element['isSelected'] = true.obs;
                    productID.add(element['productId']);
                    double itemSubTotal = double.parse(
                            (element['mrp'] ?? '0').toString()) *
                        double.parse((element['quantity'] ?? '0').toString());

                    double productDiscountSubTotal = double.parse(
                            (element['price'] ?? '0').toString()) *
                        double.parse((element['quantity'] ?? '0').toString());

                    subTotal.value += itemSubTotal;
                    productTotalDiscount.value += double.parse(
                        (itemSubTotal - productDiscountSubTotal)
                            .toStringAsFixed(2));
                  });
                } else {
                  items.clear();
                  removedItems.clear();

                  controller.singleOrderDetail["items"].forEach((element) {
                    if (element["status"] == "0") {
                      removedItems.add(element);
                    } else {
                      items.add(element);
                    }
                    subTotal.value = 0.0;
                    refundTotal.value = 0.0;
                    removedItems.forEach((element) {
                      element['isSelected'] = false.obs;
                      productID.add(element['productId']);
                      double itemSubTotal = double.parse(
                              (element['price'] ?? '0').toString()) *
                          double.parse((element['quantity'] ?? '0').toString());
                      print(
                          "printing itemSubTotal each --> ${itemSubTotal} , ${double.parse((element['mrp'] ?? '0').toString())} ,${double.parse((element['quantity'] ?? '0').toString())}");
                      refundTotal.value += itemSubTotal;
                    });

                    productTotalDiscount.value = 0.0;

                    items.forEach((element) {
                      element['isSelected'] = true.obs;
                      productID.add(element['productId']);
                      double itemSubTotal = double.parse(
                              (element['mrp'] ?? '0').toString()) *
                          double.parse((element['quantity'] ?? '0').toString());

                      double productDiscountSubTotal = double.parse(
                              (element['price'] ?? '0').toString()) *
                          double.parse((element['quantity'] ?? '0').toString());

                      productTotalDiscount.value += double.parse(
                          (itemSubTotal - productDiscountSubTotal)
                              .toStringAsFixed(2));
                      subTotal.value += itemSubTotal;
                    });

                    removedItems.forEach((element) {
                      element['isSelected'] = false.obs;
                      // productID.add(element['productId']);
                    });
                  });
                }
              }
            },
          );
        },
        builder: (controller) {
          print("printing createdAt -> ${widget.orderData['createdAt']}");
          return WillPopScope(
            onWillPop: () async {
              Get.back(result: needNewOrderTabLoad.value ? "true" : "false");

              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: CommonText(
                  content: "Review Order",
                  boldNess: FontWeight.w600,
                  textSize: width * 0.047,
                ),
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.appGradientColor,
                    ),
                  ),
                ),
              ),
              body: controller.isOrderLoading
                  ? Center(child: CircularProgressIndicator())
                  : controller.singleOrderDetail.isEmpty &&
                          controller.isOrderLoading != true
                      ? Center(
                          child: CommonText(
                            content:
                                "We are currently experiencing a high volume of requests. Please try again in a moment. Thank you for your patience.",
                            textColor: Colors.black,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      CommonText(
                                        content: "Status : ",
                                        textSize: width * 0.035,
                                        textColor: AppColors.textColor,
                                        boldNess: FontWeight.w500,
                                      ),
                                      CommonText(
                                        content: orderStatusText.value ==
                                                'Delivered'
                                            ? 'Delivered'
                                            : orderStatusText.value ==
                                                    'Cancelled'
                                                ? 'Cancelled'
                                                : orderStatusText.value ==
                                                        'Rejected'
                                                    ? 'Rejected'
                                                    : orderStatusText.value ==
                                                            'All'
                                                        ? 'Order Detail'
                                                        : orderStatusText
                                                                    .value ==
                                                                'Delivery In Process'
                                                            ? 'Delivery In Process'
                                                            : orderStatusText
                                                                        .value ==
                                                                    'Partially Accepted'
                                                                ? 'Partially Accepted'
                                                                : orderStatusText
                                                                            .value ==
                                                                        'Accepted'
                                                                    ? 'Accepted'
                                                                    : "New Order",
                                        textSize: width * 0.035,
                                        textColor: (orderStatus.value ==
                                                    'Cancelled' ||
                                                orderStatus.value == 'Rejected')
                                            ? AppColors.redColor
                                            : (orderStatus.value ==
                                                    'Delivery In Process')
                                                ? AppColors.primaryColor
                                                : AppColors.greenColor,
                                        boldNess: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(vertical: 5),
                                //   child: Row(
                                //     children: [
                                //       CommonText(
                                //         content: "Status : ",
                                //         textSize: width * 0.035,
                                //         textColor: AppColors.textColor,
                                //         boldNess: FontWeight.w500,
                                //       ),
                                //       CommonText(
                                //         content: orderStatus.value ==
                                //                 'Delivered'
                                //             ? 'Delivered'
                                //             : orderStatus.value == 'Cancelled'
                                //                 ? 'Cancelled'
                                //                 : orderStatus.value ==
                                //                         'Rejected'
                                //                     ? 'Rejected'
                                //                     : orderStatus.value == 'All'
                                //                         ? 'Order Detail'
                                //                         : orderStatus.value ==
                                //                                 'Delivery In Process'
                                //                             ? 'Delivery In Process'
                                //                             : orderStatus
                                //                                         .value ==
                                //                                     'Accepted'
                                //                                 ? 'Accepted'
                                //                                 : "New Order",
                                //         textSize: width * 0.035,
                                //         textColor: (orderStatus.value ==
                                //                     'Cancelled' ||
                                //                 orderStatus.value == 'Rejected')
                                //             ? AppColors.redColor
                                //             : (orderStatus.value ==
                                //                     'Delivery In Process')
                                //                 ? AppColors.primaryColor
                                //                 : AppColors.greenColor,
                                //         boldNess: FontWeight.w500,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xffF5F5F5)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          children: [
                                            CommonText(
                                              content: "Order No : ",
                                              textSize: width * 0.04,
                                              textColor: AppColors.textColor,
                                              boldNess: FontWeight.w400,
                                            ),
                                            CommonText(
                                              content:
                                                  "${widget.orderData['id']}",
                                              textSize: width * 0.04,
                                              textColor: AppColors.textColor,
                                              boldNess: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                            right: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                            left: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            reviewDetails(
                                                width: width,
                                                title: "Customer name",
                                                subTitle:
                                                    "${widget.orderData['userName'] ?? ''}"),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            reviewDetails(
                                                width: width,
                                                title: "User Order Count",
                                                subTitle:
                                                    "${widget.orderData['items'].length}"),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            reviewDetails(
                                                width: width,
                                                title: "Contact Number",
                                                subTitle:
                                                    "${widget.orderData['mobileNumber']}"),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           horizontal: 6),
                                            //   child: Divider(
                                            //       color: AppColors.dividerColor,
                                            //       thickness: 1,
                                            //       height: 1),
                                            // ),
                                            // reviewDetails(
                                            //   width: width,
                                            //   title: "Transaction Id",
                                            //   subTitle:
                                            //       // "${widget.orderData['paymentTrasactionId'] ?? '--'}"),
                                            //       controller.singleOrderDetail[
                                            //               "paymentTrasactionId"] ??
                                            //           "",
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            reviewDetails(
                                              width: width,
                                              title: "Placed on",
                                              subTitle:
                                                  // "${widget.orderData['createdAt'] ?? '--'}"),
                                                  (controller.singleOrderDetail[
                                                                  "createdAt"] ==
                                                              null ||
                                                          controller.singleOrderDetail[
                                                                  "createdAt"] ==
                                                              "")
                                                      ? ""
                                                      : customDateSubstringFormat(
                                                          controller
                                                                  .singleOrderDetail[
                                                              "deliveryDate"]),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            reviewDetails(
                                                width: width,
                                                title: "Shipping Area",
                                                subTitle:
                                                    "${widget.orderData['deliveryAddress']?['addressLine1'] ?? '--'}"),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            reviewDetails(
                                                width: width,
                                                title: "Delivery On",
                                                subTitle:
                                                    // "${widget.orderData['deliveryDate']} ${widget.orderData['slot']}"),
                                                    "${(controller.singleOrderDetail["deliveryDate"] == null || controller.singleOrderDetail["deliveryDate"] == "") ? "" : customDateSubstringFormat(controller.singleOrderDetail["deliveryDate"])} ${widget.orderData['slot']}"),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            reviewDetails(
                                                width: width,
                                                title: "Delivery Type",
                                                subTitle:
                                                    "${widget.orderData['isExpressDelivery']}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                /* CommonText(
                      content: "Delivery Details :",
                      textSize: width * 0.038,
                      textColor: const Color(0xff979797),
                      boldNess: FontWeight.w400,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.18,
                          child: CommonText(
                            content: "Date",
                            textSize: width * 0.038,
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                          child: CommonText(
                            content: ":",
                            textSize: width * 0.038,
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w400,
                          ),
                        ),
                        CommonText(
                          content: "22 Feb 2022",
                          textSize: width * 0.038,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w400,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.18,
                          child: CommonText(
                            content: "Slot",
                            textSize: width * 0.038,
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                          child: CommonText(
                            content: ":",
                            textSize: width * 0.038,
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w400,
                          ),
                        ),
                        CommonText(
                          content: "7 am - 10 am",
                          textSize: width * 0.038,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w400,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.18,
                          child: CommonText(
                            content: "Type",
                            textSize: width * 0.038,
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                          child: CommonText(
                            content: ":",
                            textSize: width * 0.038,
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w400,
                          ),
                        ),
                        CommonText(
                          content: "Instant",
                          textSize: width * 0.038,
                          textColor: ColorsConst.textColor,
                          boldNess: FontWeight.w400,
                        ),
                      ],
                    ),*/
                                SizedBox(height: height * 0.02),
                                Table(
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: FlexColumnWidth(),
                                    1: FixedColumnWidth(100),
                                    2: FixedColumnWidth(70),
                                  },
                                  border: TableBorder.all(
                                      color: const Color(0xffD8D5D5)),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CommonText(
                                            content: "Items (${items.length})",
                                            textSize: width * 0.035,
                                            textColor: Colors.white,
                                            boldNess: FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CommonText(
                                            content: "Price",
                                            textSize: width * 0.035,
                                            textColor: Colors.white,
                                            boldNess: FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CommonText(
                                            content: "Total",
                                            textSize: width * 0.035,
                                            textColor: Colors.white,
                                            boldNess: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  return Table(
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FlexColumnWidth(),
                                      1: FixedColumnWidth(100),
                                      2: FixedColumnWidth(70),
                                    },
                                    border: TableBorder.all(
                                        color: const Color(0xffD8D5D5)),
                                    children: List.generate(
                                      items.length,
                                      (index) => TableRow(
                                        children: [
                                          Row(
                                            children: [
                                              Obx(() {
                                                return !(orderStatus.value ==
                                                        '')
                                                    ? const SizedBox()
                                                    : commonCheckBox(
                                                        value: items[index][
                                                                'isSelected'] ??
                                                            true,
                                                        onChanged: (val) {
                                                          if (items[index]
                                                                  ['isSelected']
                                                              .value) {
                                                            removedItems.add(
                                                                items[index]);
                                                            items.removeAt(
                                                                index);
                                                          }
                                                          subTotal.value = 0.0;
                                                          productTotalDiscount
                                                              .value = 0.0;
                                                          items.forEach(
                                                              (element) {
                                                            element['isSelected'] =
                                                                true.obs;
                                                            productID.add(element[
                                                                'productId']);
                                                            double itemSubTotal = double.parse(
                                                                    (element['mrp'] ??
                                                                            '0')
                                                                        .toString()) *
                                                                double.parse(
                                                                    (element['quantity'] ??
                                                                            '0')
                                                                        .toString());
                                                            double productDiscountSubTotal = double.parse(
                                                                    (element['price'] ??
                                                                            '0')
                                                                        .toString()) *
                                                                double.parse(
                                                                    (element['quantity'] ??
                                                                            '0')
                                                                        .toString());
                                                            subTotal.value +=
                                                                itemSubTotal;
                                                            productTotalDiscount
                                                                    .value +=
                                                                double.parse(
                                                                    (itemSubTotal -
                                                                            productDiscountSubTotal)
                                                                        .toStringAsFixed(
                                                                            2));
                                                          });

                                                          refundTotal.value =
                                                              0.0;
                                                          removedItems.forEach(
                                                              (element) {
                                                            element['isSelected'] =
                                                                true.obs;
                                                            productID.add(element[
                                                                'productId']);
                                                            double itemSubTotal = double.parse(
                                                                    (element['price'] ??
                                                                            '0')
                                                                        .toString()) *
                                                                double.parse(
                                                                    (element['quantity'] ??
                                                                            '0')
                                                                        .toString());
                                                            refundTotal.value +=
                                                                itemSubTotal;
                                                          });
                                                          items.refresh();
                                                          removedItems
                                                              .refresh();
                                                        });
                                              }),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CommonText(
                                                        content: items[index]
                                                            ['productName'],
                                                        textSize: width * 0.035,
                                                        textColor:
                                                            AppColors.textColor,
                                                        boldNess:
                                                            FontWeight.w500,
                                                        // overflow: TextOverflow.ellipsis,
                                                      ),
                                                      CommonText(
                                                        content:
                                                            "${items[index]['manufacturer'] ?? ''}",
                                                        textSize: width * 0.03,
                                                        textColor: AppColors
                                                            .borderColor,
                                                        boldNess:
                                                            FontWeight.w400,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  content:
                                                      // "Price : ₹ ${double.parse(items[index]['price'].toString()).round()}",
                                                      "Price : ₹ ${double.parse(items[index]['price'].toString())}",
                                                  textSize: width * 0.035,
                                                  textColor:
                                                      AppColors.textColor,
                                                  boldNess: FontWeight.w500,
                                                ),
                                                StreamBuilder(
                                                    stream:
                                                        NewOrderScreenController
                                                            .to
                                                            .getStoreProductRes
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return CommonText(
                                                        // content:
                                                        //     "MRP    :  ₹ ${NewOrderScreenController.to.getStoreProductRes.isEmpty ? '0' : (double.parse((NewOrderScreenController.to.getStoreProductRes[items[index]['productId'].toString()]?['mrp'] ?? 0).toString()).round() ?? '-').toString()}",
                                                        content:
                                                            // "MRP    :  ₹ ${double.parse(items[index]['mrp'].toString()).round()}",
                                                            "MRP    :  ₹ ${double.parse((items[index]['mrp'] ?? 0).toStringAsFixed(2))}",
                                                        textSize: width * 0.03,
                                                        textColor: AppColors
                                                            .borderColor,
                                                        boldNess:
                                                            FontWeight.w400,
                                                      );
                                                    }),
                                                StreamBuilder(
                                                    stream:
                                                        NewOrderScreenController
                                                            .to
                                                            .getStoreProductRes
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Row(
                                                        children: [
                                                          CommonText(
                                                            content:
                                                                "Qty    :  ",
                                                            textSize:
                                                                width * 0.03,
                                                            textColor: AppColors
                                                                .borderColor,
                                                            boldNess:
                                                                FontWeight.w400,
                                                          ),
                                                          CommonText(
                                                            content:
                                                                "${items[index]['quantity']}",
                                                            textSize:
                                                                width * 0.03,
                                                            textColor: (NewOrderScreenController.to.getStoreProductRes[items[index]['productId']]
                                                                            ?[
                                                                            'quantity'] ??
                                                                        0) <
                                                                    items[index]
                                                                        [
                                                                        'quantity']
                                                                ? AppColors
                                                                    .redColor
                                                                : AppColors
                                                                    .greenColor,
                                                            boldNess:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StreamBuilder(
                                                    stream:
                                                        NewOrderScreenController
                                                            .to
                                                            .getStoreProductRes
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return CommonText(
                                                        content:
                                                            // "₹ ${(double.parse((items[index]['price'] ?? '0').toString()) * double.parse((items[index]['quantity'] ?? '0').toString())).toStringAsFixed(0)}",
                                                            "₹ ${(double.parse((items[index]['price'] ?? '0').toString()) * double.parse((items[index]['quantity'] ?? '0').toString())).toStringAsFixed(2)}",
                                                        textSize: width * 0.035,
                                                        textColor:
                                                            AppColors.textColor,
                                                        boldNess:
                                                            FontWeight.w500,
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 12,
                                ),
                                Obx(() {
                                  return Table(
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FlexColumnWidth(),
                                      1: FixedColumnWidth(100),
                                      2: FixedColumnWidth(70),
                                    },
                                    border: TableBorder.all(
                                        color: const Color(0xffD8D5D5)),
                                    children: List.generate(
                                      removedItems.length,
                                      (index) => TableRow(
                                        children: [
                                          Row(
                                            children: [
                                              Obx(() {
                                                return !(orderStatus.value ==
                                                        '')
                                                    ? const SizedBox()
                                                    : commonCheckBox(
                                                        value: false.obs,
                                                        onChanged: (val) {
                                                          //   if (!removedItems[index]['isSelected']
                                                          //       .value) {
                                                          print(
                                                              "checkbox is called");
                                                          items.add(
                                                              removedItems[
                                                                  index]);
                                                          removedItems
                                                              .removeAt(index);
                                                          productTotalDiscount
                                                              .value = 0.0;
                                                          subTotal.value = 0.0;
                                                          items.forEach(
                                                              (element) {
                                                            element['isSelected'] =
                                                                true.obs;
                                                            productID.add(element[
                                                                'productId']);
                                                            double itemSubTotal = double.parse(
                                                                    (element['mrp'] ??
                                                                            '0')
                                                                        .toString()) *
                                                                double.parse(
                                                                    (element['quantity'] ??
                                                                            '0')
                                                                        .toString());
                                                            subTotal.value +=
                                                                itemSubTotal;
                                                            double productDiscountSubTotal = double.parse(
                                                                    (element['price'] ??
                                                                            '0')
                                                                        .toString()) *
                                                                double.parse(
                                                                    (element['quantity'] ??
                                                                            '0')
                                                                        .toString());

                                                            productTotalDiscount
                                                                    .value +=
                                                                double.parse(
                                                                    (itemSubTotal -
                                                                            productDiscountSubTotal)
                                                                        .toStringAsFixed(
                                                                            2));
                                                          });

                                                          refundTotal.value =
                                                              0.0;
                                                          removedItems.forEach(
                                                              (element) {
                                                            element['isSelected'] =
                                                                true.obs;
                                                            productID.add(element[
                                                                'productId']);
                                                            double itemSubTotal = double.parse(
                                                                    (element['price'] ??
                                                                            '0')
                                                                        .toString()) *
                                                                double.parse(
                                                                    (element['quantity'] ??
                                                                            '0')
                                                                        .toString());
                                                            refundTotal.value +=
                                                                itemSubTotal;
                                                          });
                                                          //   }
                                                          //   removedItems[index]['isSelected'].value =
                                                          //       !removedItems[index]['isSelected'].value;
                                                          //
                                                          items.refresh();
                                                          removedItems
                                                              .refresh();
                                                        });
                                              }),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CommonText(
                                                        content:
                                                            removedItems[index]
                                                                ['productName'],
                                                        textSize: width * 0.035,
                                                        textColor: AppColors
                                                            .borderColor,
                                                        boldNess:
                                                            FontWeight.w500,
                                                      ),
                                                      CommonText(
                                                        content:
                                                            "${removedItems[index]['manufacturer'] ?? ''}",
                                                        textSize: width * 0.03,
                                                        textColor: AppColors
                                                            .borderColor,
                                                        boldNess:
                                                            FontWeight.w400,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content:
                                                        "Price : ₹ ${removedItems[index]['price']}",
                                                    textSize: width * 0.035,
                                                    textColor:
                                                        AppColors.borderColor,
                                                    boldNess: FontWeight.w500,
                                                  ),
                                                  StreamBuilder(
                                                      stream:
                                                          NewOrderScreenController
                                                              .to
                                                              .getStoreProductRes
                                                              .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return CommonText(
                                                          // content:
                                                          //     "MRP    :  ₹ ${NewOrderScreenController.to.getStoreProductRes.isEmpty ? '0' : (NewOrderScreenController.to.getStoreProductRes[removedItems[index]['productId'].toString()]?['mrp'] ?? '-').toString()}",
                                                          content:
                                                              // "MRP    :  ₹ ${double.parse(removedItems[index]['mrp'].toString()).round()}",
                                                              "MRP    :  ₹ ${double.parse((removedItems[index]['mrp'] ?? 0).toStringAsFixed(2))}",
                                                          textSize:
                                                              width * 0.03,
                                                          textColor: AppColors
                                                              .borderColor,
                                                          boldNess:
                                                              FontWeight.w400,
                                                        );
                                                      }),
                                                  StreamBuilder(
                                                      stream:
                                                          NewOrderScreenController
                                                              .to
                                                              .getStoreProductRes
                                                              .stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Row(
                                                          children: [
                                                            CommonText(
                                                              content:
                                                                  "Qty    :  ",
                                                              textSize:
                                                                  width * 0.03,
                                                              textColor: AppColors
                                                                  .borderColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            CommonText(
                                                              content:
                                                                  "${removedItems[index]['quantity']}",
                                                              textSize:
                                                                  width * 0.03,
                                                              textColor: (NewOrderScreenController.to.getStoreProductRes[removedItems[index]['productId']]
                                                                              ?[
                                                                              'quantity'] ??
                                                                          0) <
                                                                      removedItems[
                                                                              index]
                                                                          [
                                                                          'quantity']
                                                                  ? AppColors
                                                                      .redColor
                                                                  : AppColors
                                                                      .greenColor,
                                                              boldNess:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StreamBuilder(
                                                    stream:
                                                        NewOrderScreenController
                                                            .to
                                                            .getStoreProductRes
                                                            .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return CommonText(
                                                        content:
                                                            // "₹ ${(double.parse((removedItems[index]['price'] ?? '0').toString()) * double.parse((removedItems[index]['quantity'] ?? '0').toString())).toStringAsFixed(0)}",
                                                            "₹ ${(double.parse((removedItems[index]['price'] ?? '0').toString()) * double.parse((removedItems[index]['quantity'] ?? '0').toString())).toStringAsFixed(2)}",
                                                        textSize: width * 0.035,
                                                        textColor:
                                                            AppColors.textColor,
                                                        boldNess:
                                                            FontWeight.w500,
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(height: height * 0.04),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF5F5F5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: CommonText(
                                          content: "Total Details",
                                          textSize: width * 0.04,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                            right: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                            left: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            totalDetails(
                                              width: width,
                                              title: "Coupon Code",
                                              subTitle:
                                                  "${controller.singleOrderDetail["couponInfo"] == null || controller.singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? "---" : controller.singleOrderDetail["couponInfo"]["couponCode"] ?? ""}",
                                              titleColor:
                                                  const Color(0xff6B6666),
                                            ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           horizontal: 6),
                                            //   child: Divider(
                                            //     color: AppColors.dividerColor,
                                            //     thickness: 1,
                                            //     height: 1,
                                            //   ),
                                            // ),
                                            // totalDetails(
                                            //   width: width,
                                            //   title: "Coupon Type",
                                            //   subTitle: "",
                                            //   titleColor:
                                            //       const Color(0xff6B6666),
                                            // ),
                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(horizontal: 6),
                                            //   child: Divider(
                                            //       color: AppColors.dividerColor,
                                            //       thickness: 1,
                                            //       height: 1),
                                            // ),
                                            // totalDetails(
                                            //   width: width,
                                            //   title: "Mode of Payment",
                                            //   subTitle: "${widget.orderData['paymentMode']}",
                                            //   titleColor: const Color(0xff6B6666),
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),

                                            Obx(() => totalDetails(
                                                  width: width,
                                                  title: "Total Order Value",
                                                  subTitle:
                                                      // "₹ ${subTotal.value.round()}",
                                                      "₹ ${subTotal.value.toStringAsFixed(2)}",
                                                  titleColor:
                                                      const Color(0xff6B6666),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            Obx(
                                              () => totalDetails(
                                                  width: width,
                                                  title: "Product Discount",
                                                  subTitle:
                                                      // "₹ ${(controller.singleOrderDetail["totalProductDiscount"] ?? 0).toString()}",
                                                      "${productTotalDiscount.value}",
                                                  titleColor:
                                                      const Color(0xff6B6666)),
                                            ),

                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(horizontal: 6),
                                            //   child: Divider(
                                            //       color: AppColors.dividerColor,
                                            //       thickness: 1,
                                            //       height: 1),
                                            // ),
                                            // totalDetails(
                                            //   width: width,
                                            //   title: "Delivery Charges",
                                            //   subTitle: "₹ ${deliveryCharges.value.round()}",
                                            //   titleColor: const Color(0xff6B6666),
                                            // ),
                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(horizontal: 6),
                                            //   child: Divider(
                                            //       color: AppColors.dividerColor,
                                            //       thickness: 1,
                                            //       height: 1),
                                            // ),
                                            // totalDetails(
                                            //   width: width,
                                            //   title: "Service Charges",
                                            //   subTitle: "₹ ${serviceCharges.value.round()}",
                                            //   titleColor: const Color(0xff6B6666),
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            Obx(
                                              () => totalDetails(
                                                  width: width,
                                                  title:
                                                      "After Product Discount",
                                                  subTitle:
                                                      "₹ ${(subTotal.value - productTotalDiscount.value).toStringAsFixed(2)}",
                                                  titleColor:
                                                      const Color(0xff6B6666)),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            totalDetails(
                                              width: width,
                                              title: "Coupon Value (-)",
                                              // subTitle:
                                              //     "₹ ${discount.value.round()}",
                                              subTitle:
                                                  "₹ ${controller.singleOrderDetail["couponInfo"] == null || controller.singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? "0" : controller.singleOrderDetail["couponInfo"]["couponValue"] ?? "0"}",
                                              titleColor:
                                                  const Color(0xff6B6666),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            Obx(
                                              () => totalDetails(
                                                width: width,
                                                title: "Total Discount",
                                                // subTitle:
                                                //     "₹ ${discount.value.round()}",
                                                subTitle:
                                                    "₹ ${(controller.singleOrderDetail["couponInfo"] == null || controller.singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? 0 : controller.singleOrderDetail["couponInfo"]["couponValue"] ?? 0) + productTotalDiscount.value}",
                                                titleColor:
                                                    const Color(0xff6B6666),
                                              ),
                                            ),

                                            (controller.singleOrderDetail[
                                                            "orderStatus"] ==
                                                        "1" ||
                                                    controller.singleOrderDetail[
                                                            "orderStatus"] ==
                                                        "2")
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 6),
                                                    child: Divider(
                                                        color: AppColors
                                                            .dividerColor,
                                                        thickness: 1,
                                                        height: 1),
                                                  )
                                                : const SizedBox(),

                                            // () => (AcceptDeclineController.to
                                            //                 .addCashRewardPointsRes[
                                            //             'status'] ??
                                            //         false)
                                            (controller.singleOrderDetail[
                                                                "orderStatus"] ==
                                                            "1" ||
                                                        controller.singleOrderDetail[
                                                                "orderStatus"] ==
                                                            "2") &&
                                                    controller.singleOrderDetail[
                                                            "rewardPoints"] !=
                                                        null
                                                ? totalDetails(
                                                    width: width,
                                                    title:
                                                        "Discount to the customer",
                                                    subTitle:
                                                        "₹ ${controller.singleOrderDetail["rewardPoints"]}",
                                                    titleColor:
                                                        const Color(0xff6B6666),
                                                  )
                                                : (controller.singleOrderDetail[
                                                                    "orderStatus"] ==
                                                                "1" ||
                                                            controller
                                                                        .singleOrderDetail[
                                                                    "orderStatus"] ==
                                                                "2") &&
                                                        controller
                                                                    .singleOrderDetail[
                                                                "rewardPoints"] ==
                                                            null
                                                    ? totalDetails(
                                                        width: width,
                                                        title:
                                                            "Discount to the Customer",
                                                        titleColor: const Color(
                                                            0xff6B6666),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  width * 0.2,
                                                              height: 28,
                                                              child: TextField(
                                                                controller:
                                                                    cashReward,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                decoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            "₹ 0",
                                                                        hintStyle:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xff979797),
                                                                        ),
                                                                        hintTextDirection:
                                                                            TextDirection
                                                                                .rtl,
                                                                        contentPadding:
                                                                            const EdgeInsets.all(
                                                                                5),
                                                                        border: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: AppColors.dividerColor)),
                                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.dividerColor)),
                                                                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.dividerColor))),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.02),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Get.dialog(
                                                                  Dialog(
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10),
                                                                      ),
                                                                    ),
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .primaryColor,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              15),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                width / 2,
                                                                            child:
                                                                                CommonText(
                                                                              content: "Cash Reward",
                                                                              textSize: width * 0.04,
                                                                              textColor: Colors.white,
                                                                              boldNess: FontWeight.w600,
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: height * 0.03),
                                                                          TextField(
                                                                            controller:
                                                                                cashReward,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            inputFormatters: [
                                                                              FilteringTextInputFormatter.digitsOnly
                                                                            ],
                                                                            decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: AppColors.appWhite,
                                                                                hintText: "₹ 0",
                                                                                hintStyle: const TextStyle(
                                                                                  color: Color(0xff979797),
                                                                                ),
                                                                                hintTextDirection: TextDirection.rtl,
                                                                                contentPadding: const EdgeInsets.all(5),
                                                                                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.dividerColor)),
                                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.dividerColor)),
                                                                                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.dividerColor))),
                                                                          ),
                                                                          SizedBox(
                                                                              height: height * 0.03),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              MaterialButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                },
                                                                                color: Colors.white,
                                                                                child: CommonText(
                                                                                  content: 'Cancel',
                                                                                  textColor: AppColors.primaryColor,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              MaterialButton(
                                                                                onPressed: () async {
                                                                                  if (GetHelperController.storeID.value.isNotEmpty) {
                                                                                    if ((subTotal.value - productTotalDiscount.value - (controller.singleOrderDetail["couponInfo"] == null || controller.singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? 0 : controller.singleOrderDetail["couponInfo"]["couponValue"] ?? 0)) < double.parse(cashReward.text)) {
                                                                                      "Rewards should be less than Net Receivable amount".showError();
                                                                                      return;
                                                                                    }

                                                                                    await AcceptDeclineController.to.cashRewardPointsApi(
                                                                                        // data: {
                                                                                        //   "creditDate": DateTime.now().toString(),
                                                                                        //   "giverId": GetHelperController.storeID.value,
                                                                                        //   "orderId": widget.orderData['id'],
                                                                                        //   "receiverId": widget.orderData['userId'],
                                                                                        //   "rewardPoints": cashReward.text,
                                                                                        //   "validTillDate": DateTime.now().toString(),
                                                                                        // },
                                                                                        data: {
                                                                                          "creditDate": DateTime.now().toString(),
                                                                                          "giverId": widget.orderData['userId'],
                                                                                          "orderId": widget.orderData['id'],
                                                                                          "receiverId": GetHelperController.storeID.value,
                                                                                          "rewardPoints": cashReward.text,
                                                                                          "rewardType": "cashback",
                                                                                          "transactionType": "CR",
                                                                                          "validTillDate": DateTime.now().toString(),
                                                                                        },
                                                                                        success: () {
                                                                                          log("cashRewardPointsApi SUCESS");
                                                                                          // Get.back();
                                                                                          // Get.dialog(
                                                                                          //   Dialog(
                                                                                          //     shape: const RoundedRectangleBorder(
                                                                                          //       borderRadius: BorderRadius.all(
                                                                                          //         Radius.circular(10),
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //     backgroundColor: AppColors.primaryColor,
                                                                                          //     child: Container(
                                                                                          //       padding: const EdgeInsets.all(15),
                                                                                          //       child: Column(
                                                                                          //         mainAxisSize: MainAxisSize.min,
                                                                                          //         children: [
                                                                                          //           SizedBox(
                                                                                          //             width: width / 2,
                                                                                          //             child: CommonText(
                                                                                          //               content: "Cash Reward Point Added Successfully...",
                                                                                          //               textSize: width * 0.04,
                                                                                          //               textColor: Colors.white,
                                                                                          //               boldNess: FontWeight.w500,
                                                                                          //               textAlign: TextAlign.center,
                                                                                          //             ),
                                                                                          //           ),
                                                                                          //           SizedBox(height: height * 0.03),
                                                                                          //           ElevatedButton(
                                                                                          //             style: ElevatedButton.styleFrom(
                                                                                          //               elevation: 0,
                                                                                          //               backgroundColor: Colors.white,
                                                                                          //             ),
                                                                                          //             onPressed: () {
                                                                                          //               Get.back();
                                                                                          //             },
                                                                                          //             child: Padding(
                                                                                          //               padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                                          //               child: CommonText(
                                                                                          //                 content: "OK",
                                                                                          //                 textSize: width * 0.035,
                                                                                          //                 textColor: AppColors.primaryColor,
                                                                                          //                 boldNess: FontWeight.w500,
                                                                                          //               ),
                                                                                          //             ),
                                                                                          //           ),
                                                                                          //         ],
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //   ),
                                                                                          // );
                                                                                        });
                                                                                    await AcceptDeclineController.to.addCashRewardPointsApi(
                                                                                      data: {
                                                                                        "orderId": widget.orderData['id'],
                                                                                        'rewardPoints': cashReward.text,
                                                                                        'validTillDate': DateTime.now().toString(),
                                                                                      },
                                                                                      success: () {
                                                                                        Get.back();
                                                                                        Get.dialog(
                                                                                          Dialog(
                                                                                            shape: const RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                Radius.circular(10),
                                                                                              ),
                                                                                            ),
                                                                                            backgroundColor: AppColors.primaryColor,
                                                                                            child: Container(
                                                                                              padding: const EdgeInsets.all(15),
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    width: width / 2,
                                                                                                    child: CommonText(
                                                                                                      content: "Cash Reward Point Added Successfully...",
                                                                                                      textSize: width * 0.04,
                                                                                                      textColor: Colors.white,
                                                                                                      boldNess: FontWeight.w500,
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(height: height * 0.03),
                                                                                                  ElevatedButton(
                                                                                                    style: ElevatedButton.styleFrom(
                                                                                                      elevation: 0,
                                                                                                      backgroundColor: Colors.white,
                                                                                                    ),
                                                                                                    onPressed: () {
                                                                                                      Get.back();
                                                                                                    },
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                                                      child: CommonText(
                                                                                                        content: "OK",
                                                                                                        textSize: width * 0.035,
                                                                                                        textColor: AppColors.primaryColor,
                                                                                                        boldNess: FontWeight.w500,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                        /* showSnackBar(
                                                                                      title: ApiConfig.success,
                                                                                      message: 'Cash Reward Added Successfully...');*/
                                                                                      },
                                                                                    );
                                                                                    controller.getOrderDetails(widget.orderData["id"]);
                                                                                  } else if (!Get.isDialogOpen!) {
                                                                                    Get.dialog(const LoginDialog());
                                                                                  }
                                                                                },
                                                                                color: Colors.green,
                                                                                child: const CommonText(
                                                                                  content: 'Approve',
                                                                                  textColor: AppColors.appWhite,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        3),
                                                                child:
                                                                    CommonText(
                                                                  content:
                                                                      "Send",
                                                                  textSize:
                                                                      width *
                                                                          0.032,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  boldNess:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ))
                                                    : const SizedBox(),

                                            /*Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Divider(
                                      color: ColorsConst.dividerColor,
                                      thickness: 1,
                                      height: 1),
                                ),
                                totalDetails(
                                  width: width,
                                  title: "Coupon  Discounts",
                                  subTitle: "₹ 0",
                                  titleColor: const Color(0xff6B6666),
                                ),*/
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width / 2.7,
                                                    child: CommonText(
                                                      content: "Refund",
                                                      textSize: width * 0.032,
                                                      textColor:
                                                          AppColors.textColor,
                                                      boldNess: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.06,
                                                    child: CommonText(
                                                      content: ":",
                                                      textSize: width * 0.032,
                                                      textColor:
                                                          AppColors.textColor,
                                                      boldNess: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Obx(() {
                                                        return CommonText(
                                                          content:
                                                              // "₹ ${(subTotal.value - (controller.singleOrderDetail["totalProductDiscount"] ?? 0) - (controller.singleOrderDetail["couponInfo"] == null ? 0 : controller.singleOrderDetail["couponInfo"]["couponValue"] ?? 0) - ((AcceptDeclineController.to.addCashRewardPointsRes['status'] ?? false) ? double.parse(cashReward.text) : 0)).toStringAsFixed(0)}",
                                                              "₹ ${refundTotal.value.toStringAsFixed(2)}",
                                                          textSize:
                                                              width * 0.032,
                                                          textColor: AppColors
                                                              .textColor,
                                                          boldNess:
                                                              FontWeight.w500,
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Divider(
                                                  color: AppColors.dividerColor,
                                                  thickness: 1,
                                                  height: 1),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width / 2.7,
                                                    child: CommonText(
                                                      content: "Net Receivable",
                                                      textSize: width * 0.032,
                                                      textColor:
                                                          AppColors.textColor,
                                                      boldNess: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.06,
                                                    child: CommonText(
                                                      content: ":",
                                                      textSize: width * 0.032,
                                                      textColor:
                                                          AppColors.textColor,
                                                      boldNess: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Obx(() {
                                                        return CommonText(
                                                          content:
                                                              // "₹ ${(subTotal.value - (controller.singleOrderDetail["totalProductDiscount"] ?? 0) - (controller.singleOrderDetail["couponInfo"] == null ? 0 : controller.singleOrderDetail["couponInfo"]["couponValue"] ?? 0) - ((AcceptDeclineController.to.addCashRewardPointsRes['status'] ?? false) ? double.parse(cashReward.text) : 0)).toStringAsFixed(0)}",
                                                              "₹ ${(subTotal.value - productTotalDiscount.value - (controller.singleOrderDetail["couponInfo"] == null || controller.singleOrderDetail["couponInfo"]["providedByAdmin"] == "Y" ? 0 : controller.singleOrderDetail["couponInfo"]["couponValue"] ?? 0)).toStringAsFixed(2)}",
                                                          textSize:
                                                              width * 0.032,
                                                          textColor: AppColors
                                                              .textColor,
                                                          boldNess:
                                                              FontWeight.w500,
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                controller.singleOrderDetail[
                                                "consultationCompleted"] ==
                                            "N" &&
                                        controller.singleOrderDetail[
                                                "consultDoctor"] ==
                                            true
                                    ? CommonText(
                                        content:
                                            "Doctor consultation is in progress",
                                        textColor: AppColors.greenColor,
                                      )
                                    : SizedBox(),
                                controller.singleOrderDetail["prescImgs"] !=
                                            null &&
                                        controller
                                                .singleOrderDetail["prescImgs"]
                                                .length !=
                                            0
                                    ? SizedBox(height: height * 0.02)
                                    : SizedBox(),

                                controller.singleOrderDetail[
                                                "consultationCompleted"] ==
                                            "Y" &&
                                        controller.singleOrderDetail[
                                                "consultDoctor"] ==
                                            true
                                    ? CommonText(
                                        content:
                                            "Doctor consultation is completed",
                                        textColor: AppColors.greenColor,
                                      )
                                    : SizedBox(),
                                controller.singleOrderDetail["prescImgs"] !=
                                            null &&
                                        controller
                                                .singleOrderDetail["prescImgs"]
                                                .length !=
                                            0
                                    ? SizedBox(height: height * 0.02)
                                    : SizedBox(),
                                // (widget.orderData['prescAdded'] ?? false)
                                controller.singleOrderDetail["prescImgs"] !=
                                            null &&
                                        controller
                                                .singleOrderDetail["prescImgs"]
                                                .length !=
                                            0
                                    ? Row(children: [
                                        controller.singleOrderDetail[
                                                "prescVerified"]
                                            ? Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: CommonText(
                                                        content:
                                                            "Prescription Verified",
                                                        textSize: 12,
                                                        textColor: AppColors
                                                            .greenColor,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.check_circle,
                                                      color:
                                                          AppColors.greenColor,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.white,
                                                    side: BorderSide(
                                                        color: AppColors
                                                            .greenColor),
                                                  ),
                                                  onPressed: () async {
                                                    // setState(() {
                                                    //   widget.orderData[
                                                    //       'prescAdded'] = false;
                                                    // });
                                                    // await controller
                                                    //     .verifyPresc(widget
                                                    //         .orderData["id"]);
                                                    // controller.getOrderDetails(
                                                    //     widget.orderData["id"]);
                                                    Get.dialog(
                                                      Dialog(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            AppColors
                                                                .primaryColor,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    width / 2,
                                                                child:
                                                                    CommonText(
                                                                  content:
                                                                      "Are you sure you want to verify this prescription?",
                                                                  textSize:
                                                                      width *
                                                                          0.04,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  boldNess:
                                                                      FontWeight
                                                                          .w500,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.03),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          elevation:
                                                                              0,
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          side:
                                                                              const BorderSide(color: AppColors.appWhite)),
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 0),
                                                                        child:
                                                                            CommonText(
                                                                          content:
                                                                              "Back",
                                                                          textSize:
                                                                              width * 0.035,
                                                                          textColor:
                                                                              AppColors.appWhite,
                                                                          boldNess:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        elevation:
                                                                            0,
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          widget.orderData['prescAdded'] =
                                                                              false;
                                                                        });
                                                                        await controller
                                                                            .verifyPresc(widget.orderData["id"]);
                                                                        controller
                                                                            .getOrderDetails(widget.orderData["id"]);
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 0),
                                                                        child:
                                                                            CommonText(
                                                                          content:
                                                                              "Verify",
                                                                          textSize:
                                                                              width * 0.035,
                                                                          textColor:
                                                                              AppColors.primaryColor,
                                                                          boldNess:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                    // Get.back();
                                                    // Get.dialog(
                                                    //   Dialog(
                                                    //     shape: const RoundedRectangleBorder(
                                                    //       borderRadius: BorderRadius.all(
                                                    //         Radius.circular(10),
                                                    //       ),
                                                    //     ),

                                                    //     // backgroundColor: AppColors.primaryColor,
                                                    //     child: Container(
                                                    //       // color: Colors.blue,
                                                    //       // padding: const EdgeInsets.all(15),
                                                    //       child: Column(
                                                    //         mainAxisSize: MainAxisSize.min,
                                                    //         children: [
                                                    //           Container(
                                                    //             height: 400,
                                                    //             width: double.infinity,
                                                    //             // color: Colors.red,
                                                    //             // alignment: Alignment.center,
                                                    //             // child: CarouselSlider(
                                                    //             //   items: (widget.orderData[
                                                    //             //                   'prescImgs']
                                                    //             //               as List<dynamic>?)
                                                    //             //           ?.map((dynamic imageUrl) {
                                                    //             //         if (imageUrl is String) {
                                                    //             //           return Image.network(
                                                    //             //               imageUrl);
                                                    //             //         } else {
                                                    //             //           // Handle other cases if needed
                                                    //             //           return Container(); // Placeholder widget or null, depending on your requirements
                                                    //             //         }
                                                    //             //       }).toList() ??
                                                    //             //       [],
                                                    //             //   // items: [
                                                    //             //   //   Image.network(
                                                    //             //   //     widget.orderData['prescImgs'][0],
                                                    //             //   //   ),
                                                    //             //   // ],
                                                    //             //   // carouselController: _carouselController,
                                                    //             //   options: CarouselOptions(
                                                    //             //     enlargeCenterPage: true,
                                                    //             //     aspectRatio: 0.5,

                                                    //             //     enableInfiniteScroll: false,
                                                    //             //     // autoPlay: false,

                                                    //             //     // onPageChanged: (index, reason) {
                                                    //             //     //   currentIndex = index;
                                                    //             //     //   setState(() {});
                                                    //             //     // },
                                                    //             //   ),
                                                    //             // ),
                                                    //             child: CarouselSlider.builder(
                                                    //               itemCount: (widget.orderData[
                                                    //                               'prescImgs']
                                                    //                           as List<dynamic>?)
                                                    //                       ?.length ??
                                                    //                   0,
                                                    //               options: CarouselOptions(
                                                    //                 enlargeCenterPage: true,
                                                    //                 aspectRatio: 1,
                                                    //                 enableInfiniteScroll: false,
                                                    //               ),
                                                    //               itemBuilder: (context, index,
                                                    //                   realIndex) {
                                                    //                 final imageUrl = (widget
                                                    //                                 .orderData[
                                                    //                             'prescImgs']
                                                    //                         as List<dynamic>)[
                                                    //                     index];
                                                    //                 if (imageUrl
                                                    //                     .endsWith('.pdf')) {
                                                    //                   return buildPdfWidget(
                                                    //                       imageUrl);
                                                    //                 }
                                                    //                 return PhotoViewGallery
                                                    //                     .builder(
                                                    //                   itemCount: 1,
                                                    //                   builder:
                                                    //                       (context, index) {
                                                    //                     return PhotoViewGalleryPageOptions(
                                                    //                       imageProvider:
                                                    //                           NetworkImage(
                                                    //                               imageUrl),
                                                    //                       minScale:
                                                    //                           PhotoViewComputedScale
                                                    //                               .covered,
                                                    //                       maxScale:
                                                    //                           PhotoViewComputedScale
                                                    //                                   .covered *
                                                    //                               2,
                                                    //                     );
                                                    //                   },
                                                    //                   scrollPhysics:
                                                    //                       BouncingScrollPhysics(),
                                                    //                   backgroundDecoration:
                                                    //                       BoxDecoration(
                                                    //                     color: Colors.white,
                                                    //                   ),
                                                    //                 );
                                                    //               },
                                                    //             ),
                                                    //           ),
                                                    //           // Image.network(
                                                    //           //     '${widget.orderData['prescImgs'][0]}',
                                                    //           //     height: height / 1.5,
                                                    //           //     width: width / 1.5),
                                                    //           SizedBox(height: height * 0.01),
                                                    //           controller.singleOrderDetail[
                                                    //                   "prescVerified"]
                                                    //               ? SizedBox()
                                                    //               : Row(
                                                    //                   mainAxisAlignment:
                                                    //                       MainAxisAlignment
                                                    //                           .spaceAround,
                                                    //                   children: [
                                                    //                     ElevatedButton(
                                                    //                       style: ElevatedButton
                                                    //                           .styleFrom(
                                                    //                         elevation: 0,
                                                    //                         backgroundColor:
                                                    //                             Colors.white,
                                                    //                       ),
                                                    //                       onPressed: () {
                                                    //                         Get.back();
                                                    //                       },
                                                    //                       child: Padding(
                                                    //                         padding:
                                                    //                             const EdgeInsets
                                                    //                                     .symmetric(
                                                    //                                 horizontal:
                                                    //                                     20),
                                                    //                         child: CommonText(
                                                    //                           content: "Close",
                                                    //                           textSize:
                                                    //                               width * 0.035,
                                                    //                           textColor: AppColors
                                                    //                               .primaryColor,
                                                    //                           boldNess:
                                                    //                               FontWeight
                                                    //                                   .w500,
                                                    //                         ),
                                                    //                       ),
                                                    //                     ),
                                                    //                     ElevatedButton(
                                                    //                       style: ElevatedButton
                                                    //                           .styleFrom(
                                                    //                         elevation: 0,
                                                    //                         backgroundColor:
                                                    //                             Colors.blue,
                                                    //                       ),
                                                    //                       onPressed: () async {
                                                    //                         setState(() {
                                                    //                           widget.orderData[
                                                    //                                   'prescAdded'] =
                                                    //                               false;
                                                    //                         });
                                                    //                         await controller
                                                    //                             .verifyPresc(
                                                    //                                 widget.orderData[
                                                    //                                     "id"]);
                                                    //                         controller
                                                    //                             .getOrderDetails(
                                                    //                                 widget.orderData[
                                                    //                                     "id"]);
                                                    //                         Get.back();
                                                    //                       },
                                                    //                       child: Padding(
                                                    //                         padding:
                                                    //                             const EdgeInsets
                                                    //                                     .symmetric(
                                                    //                                 horizontal:
                                                    //                                     20),
                                                    //                         child: CommonText(
                                                    //                           content: "Accept",
                                                    //                           textSize:
                                                    //                               width * 0.035,
                                                    //                           textColor:
                                                    //                               Colors.white,
                                                    //                           boldNess:
                                                    //                               FontWeight
                                                    //                                   .w500,
                                                    //                         ),
                                                    //                       ),
                                                    //                     ),
                                                    //                   ],
                                                    //                 )
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12),
                                                    child: CommonText(
                                                      content:
                                                          "Verify Prescription",
                                                      textSize: width * 0.035,
                                                      textColor:
                                                          AppColors.greenColor,
                                                      boldNess: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              side: BorderSide(
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                            onPressed: () {
                                              // Get.dialog(
                                              //   Dialog(
                                              //     shape: const RoundedRectangleBorder(
                                              //       borderRadius: BorderRadius.all(
                                              //         Radius.circular(10),
                                              //       ),
                                              //     ),

                                              //     // backgroundColor: AppColors.primaryColor,
                                              //     child: Container(
                                              //       // color: Colors.blue,
                                              //       // padding: const EdgeInsets.all(15),
                                              //       child: Column(
                                              //         mainAxisSize: MainAxisSize.min,
                                              //         children: [
                                              //           Container(
                                              //             height: 400,
                                              //             width: double.infinity,
                                              //             // color: Colors.red,
                                              //             // alignment: Alignment.center,
                                              //             // child: CarouselSlider(
                                              //             //   items: (widget.orderData[
                                              //             //                   'prescImgs']
                                              //             //               as List<dynamic>?)
                                              //             //           ?.map((dynamic imageUrl) {
                                              //             //         if (imageUrl is String) {
                                              //             //           return Image.network(
                                              //             //               imageUrl);
                                              //             //         } else {
                                              //             //           // Handle other cases if needed
                                              //             //           return Container(); // Placeholder widget or null, depending on your requirements
                                              //             //         }
                                              //             //       }).toList() ??
                                              //             //       [],
                                              //             //   // items: [
                                              //             //   //   Image.network(
                                              //             //   //     widget.orderData['prescImgs'][0],
                                              //             //   //   ),
                                              //             //   // ],
                                              //             //   // carouselController: _carouselController,
                                              //             //   options: CarouselOptions(
                                              //             //     enlargeCenterPage: true,
                                              //             //     aspectRatio: 0.5,

                                              //             //     enableInfiniteScroll: false,
                                              //             //     // autoPlay: false,

                                              //             //     // onPageChanged: (index, reason) {
                                              //             //     //   currentIndex = index;
                                              //             //     //   setState(() {});
                                              //             //     // },
                                              //             //   ),
                                              //             // ),
                                              //             child: CarouselSlider.builder(
                                              //               itemCount: (widget.orderData[
                                              //                               'prescImgs']
                                              //                           as List<dynamic>?)
                                              //                       ?.length ??
                                              //                   0,
                                              //               options: CarouselOptions(
                                              //                 enlargeCenterPage: true,
                                              //                 aspectRatio: 1,
                                              //                 enableInfiniteScroll: false,
                                              //               ),
                                              //               itemBuilder: (context, index,
                                              //                   realIndex) {
                                              //                 final imageUrl = (widget
                                              //                                 .orderData[
                                              //                             'prescImgs']
                                              //                         as List<dynamic>)[
                                              //                     index];
                                              //                 if (imageUrl
                                              //                     .endsWith('.pdf')) {
                                              //                   return buildPdfWidget(
                                              //                       imageUrl);
                                              //                 }
                                              //                 return PhotoViewGallery
                                              //                     .builder(
                                              //                   itemCount: 1,
                                              //                   builder:
                                              //                       (context, index) {
                                              //                     return PhotoViewGalleryPageOptions(
                                              //                       imageProvider:
                                              //                           NetworkImage(
                                              //                               imageUrl),
                                              //                       minScale:
                                              //                           PhotoViewComputedScale
                                              //                               .covered,
                                              //                       maxScale:
                                              //                           PhotoViewComputedScale
                                              //                                   .covered *
                                              //                               2,
                                              //                     );
                                              //                   },
                                              //                   scrollPhysics:
                                              //                       BouncingScrollPhysics(),
                                              //                   backgroundDecoration:
                                              //                       BoxDecoration(
                                              //                     color: Colors.white,
                                              //                   ),
                                              //                 );
                                              //               },
                                              //             ),
                                              //           ),
                                              //           // Image.network(
                                              //           //     '${widget.orderData['prescImgs'][0]}',
                                              //           //     height: height / 1.5,
                                              //           //     width: width / 1.5),
                                              //           SizedBox(height: height * 0.01),
                                              //           controller.singleOrderDetail[
                                              //                   "prescVerified"]
                                              //               ? SizedBox()
                                              //               : Row(
                                              //                   mainAxisAlignment:
                                              //                       MainAxisAlignment
                                              //                           .spaceAround,
                                              //                   children: [
                                              //                     ElevatedButton(
                                              //                       style: ElevatedButton
                                              //                           .styleFrom(
                                              //                         elevation: 0,
                                              //                         backgroundColor:
                                              //                             Colors.white,
                                              //                       ),
                                              //                       onPressed: () {
                                              //                         Get.back();
                                              //                       },
                                              //                       child: Padding(
                                              //                         padding:
                                              //                             const EdgeInsets
                                              //                                     .symmetric(
                                              //                                 horizontal:
                                              //                                     20),
                                              //                         child: CommonText(
                                              //                           content: "Close",
                                              //                           textSize:
                                              //                               width * 0.035,
                                              //                           textColor: AppColors
                                              //                               .primaryColor,
                                              //                           boldNess:
                                              //                               FontWeight
                                              //                                   .w500,
                                              //                         ),
                                              //                       ),
                                              //                     ),
                                              //                     ElevatedButton(
                                              //                       style: ElevatedButton
                                              //                           .styleFrom(
                                              //                         elevation: 0,
                                              //                         backgroundColor:
                                              //                             Colors.blue,
                                              //                       ),
                                              //                       onPressed: () async {
                                              //                         setState(() {
                                              //                           widget.orderData[
                                              //                                   'prescAdded'] =
                                              //                               false;
                                              //                         });
                                              //                         await controller
                                              //                             .verifyPresc(
                                              //                                 widget.orderData[
                                              //                                     "id"]);
                                              //                         controller
                                              //                             .getOrderDetails(
                                              //                                 widget.orderData[
                                              //                                     "id"]);
                                              //                         Get.back();
                                              //                       },
                                              //                       child: Padding(
                                              //                         padding:
                                              //                             const EdgeInsets
                                              //                                     .symmetric(
                                              //                                 horizontal:
                                              //                                     20),
                                              //                         child: CommonText(
                                              //                           content: "Accept",
                                              //                           textSize:
                                              //                               width * 0.035,
                                              //                           textColor:
                                              //                               Colors.white,
                                              //                           boldNess:
                                              //                               FontWeight
                                              //                                   .w500,
                                              //                         ),
                                              //                       ),
                                              //                     ),
                                              //                   ],
                                              //                 )
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ),
                                              // );
                                              Get.to(
                                                  () => ViewPrescriptionScreen(
                                                        images: controller
                                                                .singleOrderDetail[
                                                            'prescImgs'],
                                                      ));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: CommonText(
                                                content: "View Prescription",
                                                textSize: width * 0.035,
                                                textColor:
                                                    AppColors.primaryColor,
                                                boldNess: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])
                                    : SizedBox(),
                                // : const SizedBox(),
                                SizedBox(height: height * 0.02),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF5F5F5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: CommonText(
                                          content: "Shipment Address",
                                          textSize: width * 0.04,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                            right: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                            left: BorderSide(
                                                color: AppColors.dividerColor,
                                                width: 1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Column(
                                            children: [
                                              /*   Row(
                                    children: [
                                      CommonText(
                                        content: "Slot time : ",
                                        textSize: width * 0.032,
                                        textColor: Color(0xff6B6666),
                                        boldNess: FontWeight.w600,
                                      ),
                                      CommonText(
                                        content: "Morning slot 9am-12pm",
                                        textSize: width * 0.032,
                                        textColor: Color(0xff979797),
                                        boldNess: FontWeight.w500,
                                      ),
                                    ],
                                  ),*/
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: "Address : ",
                                                    textSize: width * 0.032,
                                                    textColor:
                                                        const Color(0xff6B6666),
                                                    boldNess: FontWeight.w600,
                                                  ),
                                                  Expanded(
                                                    child: CommonText(
                                                      // maxLines: 2,
                                                      // overflow:
                                                      // TextOverflow.ellipsis,
                                                      content:
                                                          "${widget.orderData['deliveryAddress']?['addressLine1'] ?? '--'}",
                                                      textSize: width * 0.032,
                                                      textColor: const Color(
                                                          0xff979797),
                                                      boldNess: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.05),
                                Obx(() {
                                  return (orderStatus.value == 'Delivered' ||
                                          orderStatus.value == 'Cancelled' ||
                                          orderStatus.value == 'Rejected' ||
                                          orderStatus.value == 'All')
                                      ? const SizedBox()
                                      : controller.singleOrderDetail[
                                                      "consultationCompleted"] ==
                                                  "N" &&
                                              controller.singleOrderDetail[
                                                      "consultDoctor"] ==
                                                  true
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                Obx(() {
                                                  return orderStatus.value == ''
                                                      ? Expanded(
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              side: BorderSide(
                                                                  color: AppColors
                                                                      .redColor),
                                                            ),
                                                            onPressed:
                                                                (widget.orderData[
                                                                            'prescAdded'] ??
                                                                        false)
                                                                    ? null
                                                                    : () {
                                                                        Get.dialog(
                                                                          Dialog(
                                                                            shape:
                                                                                const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            backgroundColor:
                                                                                AppColors.primaryColor,
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: width / 2,
                                                                                    child: CommonText(
                                                                                      content: "Are you sure you want to reject this order ?",
                                                                                      textSize: width * 0.04,
                                                                                      textColor: Colors.white,
                                                                                      boldNess: FontWeight.w500,
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: height * 0.03),
                                                                                  Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent, side: const BorderSide(color: AppColors.appWhite)),
                                                                                          onPressed: () {
                                                                                            Get.back();
                                                                                          },
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                                                                            child: CommonText(
                                                                                              content: "Back",
                                                                                              textSize: width * 0.035,
                                                                                              textColor: AppColors.appWhite,
                                                                                              boldNess: FontWeight.w500,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: 10),
                                                                                      Expanded(
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            elevation: 0,
                                                                                            backgroundColor: Colors.white,
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            List productAndStore = [];
                                                                                            items.forEach((element) {
                                                                                              productAndStore.add({
                                                                                                'productId': element['productId'],
                                                                                                'itemAcceptStatus': "0"
                                                                                              });
                                                                                            });

                                                                                            log(productAndStore.toString(), name: 'productAndStore 3');
                                                                                            AcceptDeclineController.to.acceptOrderApi(
                                                                                                type: '3',
                                                                                                data: {
                                                                                                  'id': "${widget.orderData['id']}",
                                                                                                  'productAndStore': productAndStore,
                                                                                                  'storeId': GetHelperController.storeID.value
                                                                                                },
                                                                                                error: (e) {},
                                                                                                success: () {
                                                                                                  needNewOrderTabLoad.value = true;
                                                                                                  Get.back();
                                                                                                  Get.back(result: needNewOrderTabLoad.value ? "true" : "false");
                                                                                                  Get.dialog(
                                                                                                    Dialog(
                                                                                                      shape: const RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.all(
                                                                                                          Radius.circular(10),
                                                                                                        ),
                                                                                                      ),
                                                                                                      backgroundColor: AppColors.primaryColor,
                                                                                                      child: Container(
                                                                                                        padding: const EdgeInsets.all(15),
                                                                                                        child: Column(
                                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              width: width / 2,
                                                                                                              child: CommonText(
                                                                                                                content: "The Order id ${widget.orderData['id']} has been rejected",
                                                                                                                textSize: width * 0.04,
                                                                                                                textColor: Colors.white,
                                                                                                                boldNess: FontWeight.w500,
                                                                                                                textAlign: TextAlign.center,
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(height: height * 0.03),
                                                                                                            ElevatedButton(
                                                                                                              style: ElevatedButton.styleFrom(
                                                                                                                elevation: 0,
                                                                                                                backgroundColor: Colors.white,
                                                                                                              ),
                                                                                                              onPressed: () {
                                                                                                                Get.back();
                                                                                                              },
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                                                                child: CommonText(
                                                                                                                  content: "OK",
                                                                                                                  textSize: width * 0.035,
                                                                                                                  textColor: AppColors.primaryColor,
                                                                                                                  boldNess: FontWeight.w500,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                });
                                                                                          },
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                                                                            child: CommonText(
                                                                                              content: "Reject",
                                                                                              textSize: width * 0.035,
                                                                                              textColor: AppColors.primaryColor,
                                                                                              boldNess: FontWeight.w500,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );

                                                                        // List
                                                                        //     productAndStore =
                                                                        //     [];
                                                                        // items.forEach(
                                                                        //     (element) {
                                                                        //   productAndStore
                                                                        //       .add({
                                                                        //     'productId':
                                                                        //         element['productId'],
                                                                        //     'itemAcceptStatus':
                                                                        //         "0"
                                                                        //   });
                                                                        // });

                                                                        // log(productAndStore.toString(),
                                                                        //     name:
                                                                        //         'productAndStore 3');
                                                                        // AcceptDeclineController.to.acceptOrderApi(
                                                                        //     type: '3',
                                                                        //     data: {
                                                                        //       'id': "${widget.orderData['id']}",
                                                                        //       'productAndStore': productAndStore,
                                                                        //       'storeId': GetHelperController.storeID.value
                                                                        //     },
                                                                        //     error: (e) {},
                                                                        //     success: () {
                                                                        //       needNewOrderTabLoad.value = true;
                                                                        //       // Get.back();
                                                                        //       Get.back(result: needNewOrderTabLoad.value ? "true" : "false");
                                                                        //       Get.dialog(
                                                                        //         Dialog(
                                                                        //           shape: const RoundedRectangleBorder(
                                                                        //             borderRadius: BorderRadius.all(
                                                                        //               Radius.circular(10),
                                                                        //             ),
                                                                        //           ),
                                                                        //           backgroundColor: AppColors.primaryColor,
                                                                        //           child: Container(
                                                                        //             padding: const EdgeInsets.all(15),
                                                                        //             child: Column(
                                                                        //               mainAxisSize: MainAxisSize.min,
                                                                        //               children: [
                                                                        //                 SizedBox(
                                                                        //                   width: width / 2,
                                                                        //                   child: CommonText(
                                                                        //                     content: "The Order id ${widget.orderData['id']} has been rejected",
                                                                        //                     textSize: width * 0.04,
                                                                        //                     textColor: Colors.white,
                                                                        //                     boldNess: FontWeight.w500,
                                                                        //                     textAlign: TextAlign.center,
                                                                        //                   ),
                                                                        //                 ),
                                                                        //                 SizedBox(height: height * 0.03),
                                                                        //                 ElevatedButton(
                                                                        //                   style: ElevatedButton.styleFrom(
                                                                        //                     elevation: 0,
                                                                        //                     backgroundColor: Colors.white,
                                                                        //                   ),
                                                                        //                   onPressed: () {
                                                                        //                     Get.back();
                                                                        //                   },
                                                                        //                   child: Padding(
                                                                        //                     padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                        //                     child: CommonText(
                                                                        //                       content: "OK",
                                                                        //                       textSize: width * 0.035,
                                                                        //                       textColor: AppColors.primaryColor,
                                                                        //                       boldNess: FontWeight.w500,
                                                                        //                     ),
                                                                        //                   ),
                                                                        //                 ),
                                                                        //               ],
                                                                        //             ),
                                                                        //           ),
                                                                        //         ),
                                                                        //       );
                                                                        //     });
                                                                      },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12),
                                                              child: CommonText(
                                                                content:
                                                                    "Reject Order",
                                                                textSize:
                                                                    width *
                                                                        0.034,
                                                                textColor:
                                                                    AppColors
                                                                        .redColor,
                                                                boldNess:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                }),
                                                items.length < 1
                                                    ? SizedBox()
                                                    : SizedBox(
                                                        width: width * 0.02),
                                                items.length < 1
                                                    ? SizedBox()
                                                    : Expanded(
                                                        child: Obx(() {
                                                          print(
                                                              "printing status in obx outside button -> ${orderStatus.value}");
                                                          return ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0,
                                                              backgroundColor: orderStatus
                                                                          .value ==
                                                                      "Order Done"
                                                                  ? AppColors
                                                                      .textBlackColor
                                                                  : const Color(
                                                                      0xff049337),
                                                            ),
                                                            // onPressed: (controller
                                                            //                 .singleOrderDetail[
                                                            //             'prescAdded'] ??
                                                            //         false)
                                                            //     ? () {
                                                            //         print(
                                                            //             "accept is clicked -> ${controller.singleOrderDetail['prescAdded']}");
                                                            //       }
                                                            onPressed:
                                                                () async {
                                                              if (orderStatus
                                                                      .value ==
                                                                  '') {
                                                                if (controller.singleOrderDetail[
                                                                            "prescVerified"] ==
                                                                        false &&
                                                                    controller.singleOrderDetail[
                                                                            "prescImgs"] !=
                                                                        null &&
                                                                    controller
                                                                            .singleOrderDetail["prescImgs"]
                                                                            .length !=
                                                                        0) {
                                                                  "Please verify Prescription"
                                                                      .showError();
                                                                  return;
                                                                }
                                                                log(
                                                                    (items.length ==
                                                                            widget.orderData['items'].length)
                                                                        .toString(),
                                                                    name: 'CHECK LENGTH');
                                                                log(
                                                                    (removedItems
                                                                            .length)
                                                                        .toString(),
                                                                    name:
                                                                        'removedItems LENGTH');
                                                                log(
                                                                    (items.length)
                                                                        .toString(),
                                                                    name:
                                                                        'items LENGTH');
                                                                if (removedItems
                                                                    .isEmpty) {
                                                                  List
                                                                      productAndStore =
                                                                      [];
                                                                  items.forEach(
                                                                      (element) {
                                                                    productAndStore
                                                                        .add({
                                                                      'productId':
                                                                          element[
                                                                              'productId'],
                                                                      'itemAcceptStatus':
                                                                          "1"
                                                                    });
                                                                  });
                                                                  log(
                                                                      productAndStore
                                                                          .toString(),
                                                                      name:
                                                                          'productAndStore 1');

                                                                  await AcceptDeclineController
                                                                      .to
                                                                      .acceptOrderApi(
                                                                          type:
                                                                              '1',
                                                                          data: {
                                                                            'id':
                                                                                "${widget.orderData['id']}",
                                                                            'productAndStore':
                                                                                productAndStore,
                                                                            'storeId':
                                                                                GetHelperController.storeID.value
                                                                          },
                                                                          success:
                                                                              () {
                                                                            orderStatus.value =
                                                                                'Accepted';
                                                                            orderStatusText.value =
                                                                                'Accepted';
                                                                            needNewOrderTabLoad.value =
                                                                                true;
                                                                            Get.dialog(
                                                                              Dialog(
                                                                                shape: const RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                backgroundColor: AppColors.primaryColor,
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(15),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: width / 2,
                                                                                        child: CommonText(
                                                                                          content: "Order Is Accepted Successfully...",
                                                                                          textSize: width * 0.04,
                                                                                          textColor: Colors.white,
                                                                                          boldNess: FontWeight.w500,
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: height * 0.03),
                                                                                      ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.white,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                                          child: CommonText(
                                                                                            content: "OK",
                                                                                            textSize: width * 0.035,
                                                                                            textColor: AppColors.primaryColor,
                                                                                            boldNess: FontWeight.w500,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                            /* showSnackBar(
                                                                title:
                                                                    ApiConfig.success,
                                                                message:
                                                                    'Order Is Accepted Successfully...');*/
                                                                          },
                                                                          error:
                                                                              (e) {});
                                                                  controller.getOrderDetails(
                                                                      widget.orderData[
                                                                          "id"]);
                                                                } else {
                                                                  if (controller.singleOrderDetail["prescVerified"] == false &&
                                                                      controller.singleOrderDetail[
                                                                              "prescImgs"] !=
                                                                          null &&
                                                                      controller
                                                                              .singleOrderDetail["prescImgs"]
                                                                              .length !=
                                                                          0) {
                                                                    "Please verify Prescription"
                                                                        .showError();
                                                                    return;
                                                                  }
                                                                  List
                                                                      productAndStore =
                                                                      [];
                                                                  items.forEach(
                                                                      (element) {
                                                                    productAndStore
                                                                        .add({
                                                                      'productId':
                                                                          element[
                                                                              'productId'],
                                                                      'itemAcceptStatus':
                                                                          "1"
                                                                    });
                                                                  });
                                                                  removedItems
                                                                      .forEach(
                                                                          (element) {
                                                                    productAndStore
                                                                        .add({
                                                                      'productId':
                                                                          element[
                                                                              'productId'],
                                                                      'itemAcceptStatus':
                                                                          "0"
                                                                    });
                                                                  });
                                                                  log(
                                                                      productAndStore
                                                                          .toString(),
                                                                      name:
                                                                          'productAndStore 2');

                                                                  await AcceptDeclineController
                                                                      .to
                                                                      .acceptOrderApi(
                                                                          type:
                                                                              '2',
                                                                          data: {
                                                                            'id':
                                                                                "${widget.orderData['id']}",
                                                                            'productAndStore':
                                                                                productAndStore,
                                                                            'storeId':
                                                                                GetHelperController.storeID.value
                                                                          },
                                                                          success:
                                                                              () {
                                                                            orderStatus.value =
                                                                                'Accepted';
                                                                            orderStatusText.value =
                                                                                'Partially Accepted';
                                                                            needNewOrderTabLoad.value =
                                                                                true;
                                                                            Get.dialog(
                                                                              Dialog(
                                                                                shape: const RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                backgroundColor: AppColors.primaryColor,
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(15),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: width / 2,
                                                                                        child: CommonText(
                                                                                          content: "Order Is Accepted Successfully...",
                                                                                          textSize: width * 0.04,
                                                                                          textColor: Colors.white,
                                                                                          boldNess: FontWeight.w500,
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: height * 0.03),
                                                                                      ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.white,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                                          child: CommonText(
                                                                                            content: "OK",
                                                                                            textSize: width * 0.035,
                                                                                            textColor: AppColors.primaryColor,
                                                                                            boldNess: FontWeight.w500,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          error:
                                                                              (e) {});
                                                                  controller.getOrderDetails(
                                                                      widget.orderData[
                                                                          "id"]);
                                                                }
                                                              } else if (orderStatus
                                                                          .value ==
                                                                      'Accepted' ||
                                                                  orderStatus
                                                                          .value ==
                                                                      "Delivery In Process") {
                                                                employeeProfileId
                                                                    .value = '';
                                                                Get.defaultDialog(
                                                                    title: 'Assign Order',
                                                                    content: SizedBox(
                                                                      width:
                                                                          width,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CommonText(
                                                                            content:
                                                                                'Own Delivery',
                                                                            textSize:
                                                                                width * 0.04,
                                                                            boldNess:
                                                                                FontWeight.w500,
                                                                            textColor:
                                                                                AppColors.appblack,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                            child: Divider(
                                                                                color: AppColors.dividerColor,
                                                                                thickness: 1,
                                                                                height: 1),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: CommonText(
                                                                                  content: 'Rider',
                                                                                  textSize: width * 0.035,
                                                                                  boldNess: FontWeight.w500,
                                                                                  textColor: AppColors.appblack,
                                                                                ),
                                                                              ),
                                                                              // CommonText(
                                                                              //   content:
                                                                              //       'Current Location',
                                                                              //   textSize:
                                                                              //       width * 0.035,
                                                                              //   boldNess:
                                                                              //       FontWeight.w500,
                                                                              //   textColor: AppColors
                                                                              //       .appblack,
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                          AssignDeliveryController.to.getRiderResponse.isEmpty
                                                                              ? Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: CommonText(
                                                                                    content: 'No Agent Found',
                                                                                    textSize: width * 0.035,
                                                                                    textColor: Colors.red,
                                                                                    boldNess: FontWeight.w500,
                                                                                  ),
                                                                                )
                                                                              : SizedBox(
                                                                                  height: Get.height * 0.35,
                                                                                  child: SingleChildScrollView(
                                                                                    child: Column(
                                                                                      children: List.generate(
                                                                                          AssignDeliveryController.to.getRiderResponse.length,
                                                                                          (index) => Row(
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Obx(() {
                                                                                                          return Radio<String>(
                                                                                                            value: AssignDeliveryController.to.getRiderResponse[index]['employeeProfileId'],
                                                                                                            groupValue: employeeProfileId.value,
                                                                                                            onChanged: (value) {
                                                                                                              employeeProfileId.value = value.toString();
                                                                                                              selectedIndex = index;
                                                                                                            },
                                                                                                            activeColor: AppColors.primaryColor,
                                                                                                          );
                                                                                                        }),
                                                                                                        Expanded(
                                                                                                          flex: 3,
                                                                                                          child: InkWell(
                                                                                                            onTap: () {
                                                                                                              // Tap on the text to select the radio option
                                                                                                              employeeProfileId.value = AssignDeliveryController.to.getRiderResponse[index]['employeeProfileId'];
                                                                                                              selectedIndex = index;
                                                                                                            },
                                                                                                            child: CommonText(
                                                                                                              maxLines: 2,
                                                                                                              content: AssignDeliveryController.to.getRiderResponse[index]['empName'],
                                                                                                              textSize: width * 0.035,
                                                                                                              boldNess: FontWeight.w500,
                                                                                                              textColor: AppColors.appblack,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  // Expanded(
                                                                                                  //   child: CommonText(
                                                                                                  //     maxLines: 2,
                                                                                                  //     overflow: TextOverflow.ellipsis,
                                                                                                  //     content: AssignDeliveryController.to.getRiderResponse[index]['delivaryArea'],
                                                                                                  //     textSize: width * 0.035,
                                                                                                  //     boldNess: FontWeight.w500,
                                                                                                  //     textColor: AppColors.appblack,
                                                                                                  //   ),
                                                                                                  // ),
                                                                                                ],
                                                                                              )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                            child: Divider(
                                                                                color: AppColors.dividerColor,
                                                                                thickness: 1,
                                                                                height: 1),
                                                                          ),
                                                                          CommonText(
                                                                            content:
                                                                                '"If you lack delivery person, Don’t worry, we will support your customer service. Please select an option below."',
                                                                            textSize:
                                                                                width * 0.035,
                                                                            boldNess:
                                                                                FontWeight.w500,
                                                                            textColor:
                                                                                AppColors.appblack,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Obx(() {
                                                                                return Radio<String>(
                                                                                  value: 'local',
                                                                                  groupValue: employeeProfileId.value,
                                                                                  onChanged: (value) {
                                                                                    employeeProfileId.value = value.toString();
                                                                                  },
                                                                                  activeColor: AppColors.primaryColor,
                                                                                );
                                                                              }),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  employeeProfileId.value = 'local';
                                                                                },
                                                                                child: CommonText(
                                                                                  content: 'Acintyo Local Delivery',
                                                                                  textSize: width * 0.035,
                                                                                  boldNess: FontWeight.w500,
                                                                                  textColor: AppColors.appblack,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                height * 0.08,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      elevation: 0,
                                                                                      backgroundColor: Colors.white,
                                                                                      side: BorderSide(color: AppColors.redColor),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                      child: CommonText(
                                                                                        content: "Cancel",
                                                                                        textSize: width * 0.035,
                                                                                        textColor: AppColors.redColor,
                                                                                        boldNess: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: width * 0.03),
                                                                                Expanded(
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      elevation: 0,
                                                                                      backgroundColor: const Color(0xff049337),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      if (employeeProfileId.value == '') {
                                                                                        showSnackBar(title: ApiConfig.error, message: 'Select Rider first...');
                                                                                      } else {
                                                                                        logs("loggign riderid value on clicking ---> ${employeeProfileId.value} ");
                                                                                        AssignDeliveryController.to.assignDeliveryApi(
                                                                                            riderId: employeeProfileId.value,
                                                                                            data: employeeProfileId.value != "local"
                                                                                                ? {
                                                                                                    "orderId": widget.orderData['id'],
                                                                                                    "riderId": employeeProfileId.value,
                                                                                                    "storeId": GetHelperController.storeID.value,
                                                                                                    "riderName": AssignDeliveryController.to.getRiderResponse[selectedIndex]['empName'],
                                                                                                    "riderPhoeNumber": AssignDeliveryController.to.getRiderResponse[selectedIndex]['phoneNumber']
                                                                                                  }
                                                                                                : {
                                                                                                    "orderId": widget.orderData['id'],
                                                                                                    "riderId": employeeProfileId.value,
                                                                                                    "storeId": GetHelperController.storeID.value,
                                                                                                  },
                                                                                            success: () {
                                                                                              orderStatus.value = 'Delivery In Process';

                                                                                              Get.back();
                                                                                              Get.dialog(
                                                                                                Dialog(
                                                                                                  shape: const RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                      Radius.circular(10),
                                                                                                    ),
                                                                                                  ),
                                                                                                  backgroundColor: AppColors.primaryColor,
                                                                                                  child: Container(
                                                                                                    padding: const EdgeInsets.all(15),
                                                                                                    child: Column(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          width: width / 2,
                                                                                                          child: CommonText(
                                                                                                            content: "Delivery Assigned Successfully..",
                                                                                                            textSize: width * 0.04,
                                                                                                            textColor: Colors.white,
                                                                                                            boldNess: FontWeight.w500,
                                                                                                            textAlign: TextAlign.center,
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(height: height * 0.03),
                                                                                                        ElevatedButton(
                                                                                                          style: ElevatedButton.styleFrom(
                                                                                                            elevation: 0,
                                                                                                            backgroundColor: Colors.white,
                                                                                                          ),
                                                                                                          onPressed: () {
                                                                                                            Get.back();
                                                                                                          },
                                                                                                          child: Padding(
                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 40),
                                                                                                            child: CommonText(
                                                                                                              content: "OK",
                                                                                                              textSize: width * 0.035,
                                                                                                              textColor: AppColors.primaryColor,
                                                                                                              boldNess: FontWeight.w500,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                              showSnackBar(title: ApiConfig.success, message: 'Delivery Assigned Successfully..');
                                                                                            },
                                                                                            error: (e) {});
                                                                                      }
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                      child: CommonText(
                                                                                        content: 'Submit',
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
                                                                    ));
                                                              } else if (orderStatus
                                                                      .value ==
                                                                  "Order Done") {
                                                                final invoiceController =
                                                                    Get.put(
                                                                        InvoiceController());
                                                                final imageByteData =
                                                                    await rootBundle
                                                                        .load(
                                                                            'assets/image/retailer.png');
                                                                // Convert ByteData to Uint8List
                                                                final imageUint8List = imageByteData
                                                                    .buffer
                                                                    .asUint8List(
                                                                        imageByteData
                                                                            .offsetInBytes,
                                                                        imageByteData
                                                                            .lengthInBytes);
                                                                invoiceController
                                                                    .redirectToInvoice(
                                                                        context,
                                                                        imageUint8List,
                                                                        controller
                                                                            .singleOrderDetail);
                                                                log('GO TO INVOICE ');
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12),
                                                              child: Obx(() {
                                                                print(
                                                                    "printing order status in obx button -> ${orderStatus.value}");
                                                                return CommonText(
                                                                  content: orderStatus
                                                                              .value ==
                                                                          "Order Done"
                                                                      ? 'Print Invoice'
                                                                      : orderStatus.value ==
                                                                              "Delivery In Process"
                                                                          ? 'Re-Assign Delivery'
                                                                          : orderStatus.value == 'Accepted'
                                                                              ? 'Assign Delivery'
                                                                              : removedItems.isEmpty
                                                                                  ? "Accept Order"
                                                                                  : 'Accept Partial Order',
                                                                  textSize:
                                                                      width *
                                                                          0.034,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  boldNess:
                                                                      FontWeight
                                                                          .w500,
                                                                );
                                                              }),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                              ],
                                            );
                                }),
                                SizedBox(height: height * 0.03),
                              ],
                            ),
                          ),
                        ),
            ),
          );
        });
  }

  // getDiscountValue() {
  //   final value = 0.0;
  //   items.forEach((element) {
  //     value += element[];
  //   });
  // }

  reviewDetails(
      {double? width, String? title, String? subTitle, Color? titleColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width! / 3.2,
            child: CommonText(
              content: title,
              textSize: width * 0.032,
              textColor: titleColor ?? AppColors.textColor,
              boldNess: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: width * 0.06,
            child: CommonText(
              content: ":",
              textSize: width * 0.032,
              textColor: AppColors.textColor,
              boldNess: FontWeight.w400,
            ),
          ),
          Expanded(
            child: CommonText(
              content: subTitle,
              textSize: width * 0.032,
              textColor: AppColors.textColor,
              boldNess: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPdfWidget(String pdfUrl) {
    // return PDFView(
    //   filePath: pdfUrl,
    //   autoSpacing: true,
    //   pageSnap: true,
    //   swipeHorizontal: true,
    // );
    return PDF(enableSwipe: false).cachedFromUrl(
      pdfUrl,
      placeholder: (progress) => Center(child: Text('$progress %')),
      errorWidget: (error) => Center(child: Text(error.toString())),
    );
  }

  totalDetails(
      {double? width,
      String? title,
      String? subTitle,
      Color? titleColor,
      Widget? child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width! / 2.7,
            child: CommonText(
              content: title,
              textSize: width * 0.032,
              textColor: titleColor ?? AppColors.textColor,
              boldNess: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: width * 0.06,
            child: CommonText(
              content: ":",
              textSize: width * 0.032,
              textColor: AppColors.textColor,
              boldNess: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: child ??
                  CommonText(
                    content: subTitle,
                    textSize: width * 0.032,
                    textColor: const Color(0xff979797),
                    boldNess: FontWeight.w400,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
