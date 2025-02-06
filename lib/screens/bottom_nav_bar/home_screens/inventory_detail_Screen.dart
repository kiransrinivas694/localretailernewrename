import 'dart:developer';

import 'package:b2c/components/inventory_dialog.dart';
import 'package:b2c/components/update_inventory_dialog.dart';
import 'package:b2c/controllers/GetHelperController.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/accept_decline_controller.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/controller/new_order_screen_controller.dart';
import 'package:b2c/service/api_service.dart';
import 'package:b2c/utils/commonWidgets.dart';
import 'package:b2c/utils/snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';

import 'controller/inventory_controller.dart';

class InventoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> inventoryDetail;
  InventoryDetailScreen({required this.inventoryDetail});

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    log(widget.inventoryDetail.toString(), name: 'inventoryDetail');
    InventoryListController.to
        .productListApi(productId: '${widget.inventoryDetail['id'] ?? '--'}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.orderData['prescAdded'] = true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "INVENTORY",
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          CommonText(
                            content: "Sub-Category",
                            textSize: width * 0.04,
                            textColor: AppColors.textColor,
                            boldNess: FontWeight.w400,
                          ),
                          CommonText(
                            content:
                                " ${widget.inventoryDetail['subCategory'] ?? '--'}",
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
                              color: AppColors.dividerColor, width: 1),
                          right: BorderSide(
                              color: AppColors.dividerColor, width: 1),
                          left: BorderSide(
                              color: AppColors.dividerColor, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          reviewDetails(
                              width: width,
                              title: "Product Name",
                              subTitle:
                                  '${widget.inventoryDetail['productName'] ?? '--'}'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Product Id",
                              subTitle:
                                  '${widget.inventoryDetail['id'] ?? '--'}'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Brand name",
                              subTitle:
                                  "${widget.inventoryDetail['brandName'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Manufacturer",
                              subTitle:
                                  "${widget.inventoryDetail['manufacturer'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Medicine Type",
                              subTitle:
                                  "${widget.inventoryDetail['medicneType'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Tablets per strip",
                              subTitle:
                                  "${widget.inventoryDetail['tabletsPerStrip'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "MFD",
                              subTitle:
                                  "${widget.inventoryDetail['mfd'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Expiry date",
                              subTitle:
                                  "${widget.inventoryDetail['expDate'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Product Description",
                              subTitle:
                                  "${widget.inventoryDetail['productDescription'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Notes & How to use",
                              subTitle:
                                  "${widget.inventoryDetail['note'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Alternatives",
                              subTitle:
                                  "${widget.inventoryDetail['alternative'] ?? '--'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                                color: AppColors.dividerColor,
                                thickness: 1,
                                height: 1),
                          ),
                          reviewDetails(
                              width: width,
                              title: "Prescription required",
                              subTitle:
                                  "${(widget.inventoryDetail['prescriptionIsRequired'] ?? false) ? 'Yes' : 'No'}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: Size(width, 45),
                ),
                onPressed: () {
                  Get.dialog(InventoryDialog(
                    productID: widget.inventoryDetail['id'],
                    title: widget.inventoryDetail['productName'] ?? '--',
                    type: widget.inventoryDetail['category'] ?? '--',
                    contentId: '',
                    date: '',
                    invoiceID: '',
                    mrp: '',
                    ptr: '',
                    qty: "",
                  ));
                },
                child: CommonText(
                  content: "Add New",
                  textSize: width * 0.04,
                  textColor: Colors.black,
                  boldNess: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.02),
              /*   ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: Size(width, 45),
                ),
                onPressed: () {
                  Get.dialog(UpdateInventoryDialog(
                    productID: widget.inventoryDetail['id'],
                    title: widget.inventoryDetail['productName'] ?? '--',
                    type: widget.inventoryDetail['category'] ?? '--',
                    startDate: '',
                    endDate: '',
                    mrp: widget.inventoryDetail['mrp'].toString(),
                    ptr: widget.inventoryDetail['ptr'].toString(),
                    disType: '',
                    disValue: '',
                    discount: '',
                    finalValue: '',
                  ));
                },
                child: CommonText(
                  content: "Update",
                  textSize: width * 0.04,
                  textColor: Colors.black,
                  boldNess: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.02),*/
              Obx(() {
                return InventoryListController.to.getInvoiceRes.isEmpty
                    ? Align(
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : Column(children: [
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(),
                            1: FixedColumnWidth(95),
                            2: FixedColumnWidth(65),
                            3: FixedColumnWidth(65)
                          },
                          border:
                              TableBorder.all(color: const Color(0xffD8D5D5)),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CommonText(
                                    content: "INVOICE ID",
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
                                    content: "Stock",
                                    textSize: width * 0.035,
                                    textColor: Colors.white,
                                    boldNess: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CommonText(
                                    content: "",
                                    textSize: width * 0.035,
                                    textColor: Colors.white,
                                    boldNess: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(),
                            1: FixedColumnWidth(95),
                            2: FixedColumnWidth(65),
                            3: FixedColumnWidth(65),
                          },
                          border:
                              TableBorder.all(color: const Color(0xffD8D5D5)),
                          children: List.generate(
                            InventoryListController
                                .to.getInvoiceRes['content'].length,
                            (index) => TableRow(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            content:
                                                '${InventoryListController.to.getInvoiceRes['content']?[index]?['invoiceId'] ?? '--'}',
                                            textSize: width * 0.035,
                                            textColor: AppColors.textColor,
                                            boldNess: FontWeight.w500,
                                          ),
                                          CommonText(
                                            content:
                                                "Date :${'${'${InventoryListController.to.getInvoiceRes['content']?[index]?['invoiceDate'] ?? '--'}'}'}",
                                            textSize: width * 0.03,
                                            textColor: AppColors.borderColor,
                                            boldNess: FontWeight.w400,
                                          ),
                                        ],
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
                                              "MRP : ₹ ${'${InventoryListController.to.getInvoiceRes['content']?[index]?['mrp'] ?? '--'}'}",
                                          textSize: width * 0.035,
                                          textColor: AppColors.textColor,
                                          boldNess: FontWeight.w500,
                                        ),
                                        CommonText(
                                          content:
                                              "PTR : ₹ ${'${InventoryListController.to.getInvoiceRes['content']?[index]?['ptr'] ?? '--'}'}",
                                          textSize: width * 0.03,
                                          textColor: AppColors.borderColor,
                                          boldNess: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        content:
                                            "${InventoryListController.to.getInvoiceRes['content']?[index]?['quantity'] ?? '--'}",
                                        textSize: width * 0.035,
                                        textColor: AppColors.textColor,
                                        boldNess: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.dialog(InventoryDialog(
                                        productID: widget.inventoryDetail['id'],
                                        title: widget.inventoryDetail[
                                                'productName'] ??
                                            '--',
                                        type: widget
                                                .inventoryDetail['category'] ??
                                            '--',
                                        contentId:
                                            '${InventoryListController.to.getInvoiceRes['content']?[index]?['id'] ?? '--'}',
                                        date:
                                            '${InventoryListController.to.getInvoiceRes['content']?[index]?['invoiceDate'] ?? '--'}',
                                        invoiceID:
                                            '${InventoryListController.to.getInvoiceRes['content']?[index]?['invoiceId'] ?? '--'}',
                                        mrp:
                                            '${InventoryListController.to.getInvoiceRes['content']?[index]?['mrp'] ?? '--'}',
                                        ptr:
                                            '${InventoryListController.to.getInvoiceRes['content']?[index]?['ptr'] ?? '--'}',
                                        qty:
                                            "${InventoryListController.to.getInvoiceRes['content']?[index]?['quantity'] ?? '--'}",
                                      ));
                                    },
                                    child: Image.asset(
                                      "assets/icons/edit.png",
                                      scale: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]);
              }),
              SizedBox(
                height: 12,
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

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
            child: Html(
              data: subTitle,
              // textSize: width * 0.032,
              // textColor: AppColors.textColor,
              // boldNess: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
