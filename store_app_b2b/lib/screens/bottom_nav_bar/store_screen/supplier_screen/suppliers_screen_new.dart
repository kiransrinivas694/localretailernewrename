import 'dart:developer';

import 'package:b2c/components/login_dialog_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_search_field_new.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/supplier_controller/supplier_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';

class SuppliersScreen extends StatelessWidget {
  SuppliersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetX<SupplierController>(
        initState: (state) async {
          await state.controller!.getUserId();
          await state.controller!.getLinkedSuppliersApi();
          await state.controller!.getAllSuppliersApi();
        },
        init: SupplierController(),
        builder: (supplierController) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: CommonText(
                  content: "Suppliers",
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
              body: Column(
                children: [
                  DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: Material(
                        color: Colors.white,
                        child: TabBar(
                          controller: supplierController.controller,
                          indicatorColor: ColorsConst.primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 0,
                          indicator: MD2Indicator(
                            indicatorSize: MD2IndicatorSize.normal,
                            indicatorHeight: 3.0,
                            indicatorColor: Colors.orange,
                          ),
                          onTap: (value) {
                            supplierController.getLinkedSuppliersApi();
                            supplierController.getAllSuppliersApi();
                          },
                          tabs: const [
                            Tab(
                              child: CommonText(
                                content: "Linked Suppliers",
                                textColor: Colors.black,
                                boldNess: FontWeight.w600,
                              ),
                            ),
                            Tab(
                              child: CommonText(
                                content: "All Suppliers",
                                textColor: Colors.black,
                                boldNess: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: supplierController.controller,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              CommonSearchField(
                                showCloseIcon: supplierController
                                    .searchController.value.text.isNotEmpty,
                                closeOnTap: () {
                                  supplierController.searchController.value
                                      .clear();
                                },
                                controller:
                                    supplierController.searchController.value,
                              ),
                              SizedBox(height: height * 0.02),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: supplierController
                                      .linkedSuppliersList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        supplierController.linkedSuppliersList[
                                                    index]["linkStatus"] ==
                                                "Y"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonText(
                                                          content: supplierController
                                                                          .linkedSuppliersList[
                                                                      index][
                                                                  'supplierName'] ??
                                                              "",
                                                          boldNess:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.black,
                                                        ),
                                                        CommonText(
                                                          textSize:
                                                              width * 0.035,
                                                          content: supplierController
                                                                          .linkedSuppliersList[
                                                                      index][
                                                                  'addressLine1'] ??
                                                              "",
                                                          textColor:
                                                              Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(
                                                        () => GestureDetector(
                                                          onTap: () async {
                                                            if (supplierController
                                                                            .linkedSuppliersList[
                                                                        index][
                                                                    'linkStatus'] ==
                                                                "M") {
                                                              if (supplierController
                                                                  .userId
                                                                  .value
                                                                  .isNotEmpty) {
                                                                var body = {
                                                                  "retailerId":
                                                                      supplierController
                                                                          .userId
                                                                          .value,
                                                                  "supplierId":
                                                                      supplierController
                                                                              .linkedSuppliersList[index]
                                                                          [
                                                                          'supplierId'],
                                                                  "linkStatus":
                                                                      "Y"
                                                                };

                                                                await supplierController
                                                                    .getConnectApi(
                                                                        body)
                                                                    .then(
                                                                        (value) async {
                                                                  if (value[
                                                                          'status'] ==
                                                                      true) {
                                                                    supplierController
                                                                            .linkedSuppliersList[index]
                                                                        [
                                                                        'linkStatus'] = "Y";
                                                                    CommonSnackBar
                                                                        .showSuccess(
                                                                            value['message']);
                                                                  }
                                                                });
                                                              } else if (!Get
                                                                  .isDialogOpen!) {
                                                                Get.dialog(
                                                                    const LoginDialog());
                                                              }
                                                            } else {
                                                              if (supplierController
                                                                  .userId
                                                                  .value
                                                                  .isNotEmpty) {
                                                                var body = {
                                                                  "retailerId":
                                                                      supplierController
                                                                          .userId
                                                                          .value,
                                                                  "supplierId":
                                                                      supplierController
                                                                              .linkedSuppliersList[index]
                                                                          [
                                                                          'supplierId'],
                                                                  "linkStatus":
                                                                      "M"
                                                                };

                                                                await supplierController
                                                                    .getConnectApi(
                                                                        body)
                                                                    .then(
                                                                        (value) async {
                                                                  if (value[
                                                                          'status'] ==
                                                                      true) {
                                                                    supplierController
                                                                            .linkedSuppliersList[index]
                                                                        [
                                                                        'linkStatus'] = "M";
                                                                    CommonSnackBar
                                                                        .showSuccess(
                                                                            "UnLinked");

                                                                    supplierController
                                                                        .connectIdAllList
                                                                        .remove(
                                                                      supplierController
                                                                              .linkedSuppliersList[index]
                                                                          [
                                                                          'supplierId'],
                                                                    );
                                                                    log("supplier removed");
                                                                    log('${supplierController.connectIdAllList}');
                                                                  }
                                                                });
                                                              } else if (!Get
                                                                  .isDialogOpen!) {
                                                                Get.dialog(
                                                                    const LoginDialog());
                                                              }
                                                            }
                                                            await supplierController
                                                                .getLinkedSuppliersApi();
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: width / 4,
                                                            decoration: supplierController
                                                                            .linkedSuppliersList[index]
                                                                        [
                                                                        'linkStatus'] ==
                                                                    "M"
                                                                ? BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            child: Center(
                                                              child: CommonText(
                                                                textColor: supplierController.linkedSuppliersList[index]
                                                                            [
                                                                            'linkStatus'] ==
                                                                        "Y"
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                content: supplierController.linkedSuppliersList[index]
                                                                            [
                                                                            'linkStatus'] ==
                                                                        "Y"
                                                                    ? "Disconnect"
                                                                    : "Connect",
                                                                textSize:
                                                                    width *
                                                                        0.035,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.02),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.dialog(
                                                            contactInfoDialog(
                                                                height,
                                                                width,
                                                                supplierController
                                                                        .linkedSuppliersList[
                                                                    index]),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            color: Colors.white,
                                                          ),
                                                          child:
                                                              Icon(Icons.phone),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  // Row(
                                                  //   children: [
                                                  //     GestureDetector(
                                                  //       onTap: () {
                                                  //         if (supplierController
                                                  //                 .isConnect.value ==
                                                  //             false) {
                                                  //           supplierController
                                                  //               .isConnect
                                                  //               .value = true;
                                                  //         } else {
                                                  //           supplierController
                                                  //               .isConnect
                                                  //               .value = false;
                                                  //         }
                                                  //       },
                                                  //       child: Obx(
                                                  //         () => Container(
                                                  //           height: 35,
                                                  //           width: width / 4,
                                                  //           decoration:
                                                  //               supplierController
                                                  //                           .isConnect
                                                  //                           .value ==
                                                  //                       true
                                                  //                   ? BoxDecoration(
                                                  //                       borderRadius:
                                                  //                           BorderRadius
                                                  //                               .circular(
                                                  //                                   5),
                                                  //                       color: Colors
                                                  //                           .black,
                                                  //                     )
                                                  //                   : BoxDecoration(
                                                  //                       borderRadius:
                                                  //                           BorderRadius
                                                  //                               .circular(
                                                  //                                   5),
                                                  //                       border: Border.all(
                                                  //                           color: Colors
                                                  //                               .black),
                                                  //                       color: Colors
                                                  //                           .white,
                                                  //                     ),
                                                  //           child: Center(
                                                  //             child: CommonText(
                                                  //               textColor: supplierController
                                                  //                           .isConnect
                                                  //                           .value ==
                                                  //                       false
                                                  //                   ? Colors.black
                                                  //                   : Colors.white,
                                                  //               content: supplierController
                                                  //                           .isConnect
                                                  //                           .value ==
                                                  //                       false
                                                  //                   ? "Disconnect"
                                                  //                   : "Connect",
                                                  //               textSize:
                                                  //                   width * 0.035,
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(width: width * 0.02),
                                                  //     GestureDetector(
                                                  //       onTap: () {
                                                  //         // Get.dialog(
                                                  //         //   contactInfoDialog(
                                                  //         //     height,
                                                  //         //     width,
                                                  //         //
                                                  //         //   ),
                                                  //         // );
                                                  //       },
                                                  //       child: Container(
                                                  //         height: 35,
                                                  //         width: 35,
                                                  //         decoration: BoxDecoration(
                                                  //           borderRadius:
                                                  //               BorderRadius.circular(
                                                  //                   5),
                                                  //           border: Border.all(
                                                  //               color: Colors.black),
                                                  //           color: Colors.white,
                                                  //         ),
                                                  //         child: Icon(Icons.phone),
                                                  //       ),
                                                  //     )
                                                  //   ],
                                                  // ),
                                                ],
                                              )
                                            : Container(),
                                        supplierController.linkedSuppliersList[
                                                    index]["linkStatus"] ==
                                                "Y"
                                            ? Divider(
                                                color:
                                                    ColorsConst.semiGreyColor)
                                            : Container(),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              CommonSearchField(
                                  showCloseIcon: supplierController
                                      .searchController.value.text.isNotEmpty,
                                  closeOnTap: () {
                                    supplierController.searchController.value
                                        .clear();
                                  },
                                  controller: supplierController
                                      .searchController.value),
                              SizedBox(height: height * 0.02),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: supplierController
                                      .allSuppliersList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    content: supplierController
                                                                .allSuppliersList[
                                                            index]['storeName'] ??
                                                        "",
                                                    boldNess: FontWeight.w600,
                                                    textColor: Colors.black,
                                                  ),
                                                  CommonText(
                                                    textSize: width * 0.035,
                                                    content: supplierController
                                                                    .allSuppliersList[
                                                                index]
                                                            ['shortAddress'] ??
                                                        "",
                                                    textColor: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (!supplierController
                                                        .connectIdAllList
                                                        .contains(supplierController
                                                                .allSuppliersList[
                                                            index]['supplierId'])) {
                                                      if (supplierController
                                                          .userId
                                                          .value
                                                          .isNotEmpty) {
                                                        var body = {
                                                          "retailerId":
                                                              supplierController
                                                                  .userId.value,
                                                          "supplierId":
                                                              supplierController
                                                                          .allSuppliersList[
                                                                      index][
                                                                  'supplierId'],
                                                          "linkStatus": "Y"
                                                        };

                                                        supplierController
                                                            .getConnectApi(body)
                                                            .then(
                                                                (value) async {
                                                          if (value['status'] ==
                                                              true) {
                                                            supplierController
                                                                .connectIdAllList
                                                                .add(supplierController
                                                                            .allSuppliersList[
                                                                        index][
                                                                    'supplierId']);
                                                            CommonSnackBar
                                                                .showSuccess(value[
                                                                    'message']);
                                                          }
                                                        });
                                                      } else if (!Get
                                                          .isDialogOpen!) {
                                                        Get.dialog(
                                                            const LoginDialog());
                                                      }
                                                    } else {
                                                      if (supplierController
                                                          .userId
                                                          .value
                                                          .isNotEmpty) {
                                                        var body = {
                                                          "retailerId":
                                                              supplierController
                                                                  .userId.value,
                                                          "supplierId":
                                                              supplierController
                                                                          .allSuppliersList[
                                                                      index][
                                                                  'supplierId'],
                                                          "linkStatus": "M"
                                                        };

                                                        supplierController
                                                            .getConnectApi(body)
                                                            .then(
                                                                (value) async {
                                                          if (value['status'] ==
                                                              true) {
                                                            supplierController
                                                                .connectIdAllList
                                                                .remove(supplierController
                                                                            .allSuppliersList[
                                                                        index][
                                                                    'supplierId']);
                                                            CommonSnackBar
                                                                .showSuccess(
                                                                    "UnLinked");
                                                          }
                                                        });
                                                      } else if (!Get
                                                          .isDialogOpen!) {
                                                        Get.dialog(
                                                            const LoginDialog());
                                                      }
                                                    }
                                                  },
                                                  child: Obx(
                                                    () => Container(
                                                      height: 35,
                                                      width: width / 4,
                                                      decoration: supplierController
                                                              .connectIdAllList
                                                              .contains(supplierController
                                                                          .allSuppliersList[
                                                                      index][
                                                                  'supplierId'])
                                                          ? BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      child: Center(
                                                        child: CommonText(
                                                          textColor: !supplierController
                                                                  .connectIdAllList
                                                                  .contains(supplierController
                                                                              .allSuppliersList[
                                                                          index]
                                                                      [
                                                                      'supplierId'])
                                                              ? Colors.white
                                                              : Colors.black,
                                                          content: !supplierController
                                                                  .connectIdAllList
                                                                  .contains(supplierController
                                                                              .allSuppliersList[
                                                                          index]
                                                                      [
                                                                      'supplierId'])
                                                              ? "Connect"
                                                              : "Disconnect",
                                                          textSize:
                                                              width * 0.035,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.02),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.dialog(
                                                      contactInfoDialog(
                                                          height,
                                                          width,
                                                          supplierController
                                                                  .allSuppliersList[
                                                              index]),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(Icons.phone),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                            color: ColorsConst.semiGreyColor),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ClipRRect contactInfoDialog(double height, double width, Map data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    content: "Contact Info",
                    textColor: ColorsConst.primaryColor,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: "Supplier name :",
                    textSize: width * 0.035,
                    textColor: ColorsConst.textColor,
                  ),
                  Flexible(
                    child: CommonText(
                      content: data['storeName'],
                      textSize: width * 0.035,
                      boldNess: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: "Owner Name : ",
                    textSize: width * 0.035,
                    textColor: ColorsConst.textColor,
                  ),
                  Flexible(
                    child: CommonText(
                      content: data['ownerName'],
                      textSize: width * 0.035,
                      boldNess: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: "Contact number : ",
                    textSize: width * 0.035,
                    textColor: ColorsConst.textColor,
                  ),
                  Flexible(
                    child: CommonText(
                      content: data['storeNumber'],
                      textSize: width * 0.035,
                      boldNess: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    content: "Email : ",
                    textSize: width * 0.035,
                    textColor: ColorsConst.textColor,
                  ),
                  Flexible(
                    child: CommonText(
                      content: data['email'],
                      textSize: width * 0.035,
                      boldNess: FontWeight.w600,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      CommonSnackBar.copyText(
                          "Supplier name : ${data['storeName']}\nOwner Name : ${data['ownerName']}\nContact number : ${data['storeNumber']}\nEmail : ${data['email']}");
                    },
                    child: Icon(
                      Icons.copy,
                      size: 22,
                      color: ColorsConst.primaryColor,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.03),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
