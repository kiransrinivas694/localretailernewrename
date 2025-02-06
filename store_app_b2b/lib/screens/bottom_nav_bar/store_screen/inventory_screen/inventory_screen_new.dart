import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_search_field_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/inventory_controller/inventory_controller_new.dart';

class InventoryScreen extends StatefulWidget {
  InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryController inventoryController =
      Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder(
      init: InventoryController(),
      initState: (state) {
        Future.delayed(
          Duration(microseconds: 300),
          () async {
            InventoryController controller = Get.find<InventoryController>();
            controller.quantityTextControllerList.clear();
            controller.quantityList.clear();
            controller.scrollController.addListener(controller.scrollListener);
            await controller.getInventory();
          },
        );
      },
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "Inventory",
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
            body: Obx(() => (controller.isLoading.value)
                ? AppLoader()
                : (controller.inventoryList.isEmpty)
                    ? Center(
                        child: CommonText(
                          content: 'No inventory',
                          textColor: Colors.black,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.02),
                            CommonSearchField(
                                showCloseIcon: inventoryController
                                    .searchController.text.isNotEmpty,
                                closeOnTap: () {
                                  inventoryController.searchController.clear();
                                },
                                controller:
                                    inventoryController.searchController),
                            SizedBox(height: height * 0.02),
                            Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.inventoryList.length,
                                controller: controller.scrollController,
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: ColorsConst.hintColor,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> inventoryContent =
                                      controller.inventoryList[index];
                                  Map<String, dynamic>? inventoryPrice =
                                      controller.inventoryList[index]['price']
                                          [controller.storeId];
                                  return inventoryCard(inventoryContent,
                                      inventoryPrice, height, width, index);
                                },
                              ),
                            ),
                            Obx(() => (controller.isLoadMore.value)
                                ? Center(
                                    child: CupertinoActivityIndicator(
                                      color: ColorsConst.primaryColor,
                                    ),
                                  )
                                : SizedBox())
                          ],
                        ),
                      )),
          ),
        );
      },
    );
  }

  inventoryCard(
      Map<String, dynamic> inventoryContent,
      Map<String, dynamic>? inventoryPrice,
      double height,
      double width,
      int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 0, left: 0),
      child: GestureDetector(
        // onTap: () {
        //   Get.dialog(InventoryDialog());
        // },
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonText(
                      content: inventoryContent['productName'] ?? '',
                      textColor: ColorsConst.textColor,
                      boldNess: FontWeight.w500,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonText(
                        content: 'In Stock:',
                        boldNess: FontWeight.w500,
                        textSize: 14,
                        textColor: ColorsConst.textColor,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30,
                            child: CommonText(
                              content: (inventoryPrice != null &&
                                      inventoryPrice['quantity'] != null)
                                  ? '${inventoryPrice['quantity'].toStringAsFixed(0)}'
                                  : '0',
                              textColor: Colors.black,
                              boldNess: FontWeight.w500,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                              height: 1,
                              color: ColorsConst.hintColor,
                              width: width / 13),
                        ],
                      ),
                      // Image.asset(
                      //   'assets/icons/edit_icon.png',
                      //   package: 'store_app_b2b',
                      //   fit: BoxFit.contain,
                      //   height: 18,
                      //   width: 18,
                      // ),
                    ],
                  )),
                ],
              ),
              SizedBox(height: height * 0.003),
              CommonText(
                content: inventoryContent['manufacturer'] ?? '',
                textColor: ColorsConst.notificationTextColor,
              ),
              SizedBox(height: height * 0.003),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CommonText(
                            content: "MRP",
                            textSize: width * 0.035,
                            textColor: ColorsConst.notificationTextColor,
                            boldNess: FontWeight.w600,
                          ),
                          CommonText(
                            content: (inventoryPrice != null &&
                                    inventoryPrice['mrp'] != null)
                                ? ' ₹${double.parse(inventoryPrice['mrp'].toString()).toStringAsFixed(2)}'
                                : '0.00',
                            textSize: width * 0.035,
                            textColor: ColorsConst.hintColor,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CommonText(
                            content: "PTR :",
                            textSize: width * 0.035,
                            textColor: ColorsConst.notificationTextColor,
                            boldNess: FontWeight.w600,
                          ),
                          CommonText(
                            content: (inventoryPrice != null &&
                                    inventoryPrice['ptr'] != null)
                                ? ' ₹${double.parse(inventoryPrice['ptr'].toString()).toStringAsFixed(2)}'
                                : '0.00',
                            textSize: width * 0.035,
                            textColor: ColorsConst.hintColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Container(
                  //   height: 32,
                  //   width: 134,
                  //   padding: const EdgeInsets.symmetric(vertical: 3),
                  //   decoration: BoxDecoration(
                  //       color: ColorsConst.appWhite,
                  //       borderRadius: BorderRadius.circular(4),
                  //       border: Border.all(color: ColorsConst.primaryColor)),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       decreaseInventoryButton(index),
                  //       const SizedBox(width: 8),
                  //       addInventoryTextField(
                  //         index,
                  //         context,
                  //       ),
                  //       const SizedBox(width: 8),
                  //       increaseInventoryButton(index),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addInventoryTextField(int index, BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: inventoryController.quantityTextControllerList[index],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorsConst.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ],
        onChanged: (value) {
          // if (value.trim().isNotEmpty) {
          //   controller.qtyList[index].value = int.parse(value);
          // } else {
          //   controller.qtyTextControllerList[index].clear();
          //   FocusScope.of(context).unfocus();
          //   controller.qtyList[index].value = 0;
          // }
          // if (searchProduct.schemeAvailable) {
          //   controller.getSchemeQty(
          //       index: index,
          //       quantity: controller.qtyList[index].value,
          //       schemeId: searchProduct.schemeId ?? '',
          //       schemeName: searchProduct.schemeName ?? '',
          //       addBuyQty: controller.qtyList[index].value,
          //       addFreeQty: 0,
          //       finalQty: controller.finalQTYList[index].value);
          // }
        },
        onSubmitted: (value) {
          // if (value.trim().isNotEmpty) {
          //   controller.qtyList[index].value = int.parse(value);
          // } else {
          //   controller.qtyList[index].value = 0;
          // }
          // if (searchProduct.schemeAvailable) {
          //   controller.getSchemeQty(
          //       index: index,
          //       quantity: controller.qtyList[index].value,
          //       schemeId: searchProduct.schemeId ?? '',
          //       schemeName: searchProduct.schemeName ?? '',
          //       addBuyQty: controller.qtyList[index].value,
          //       addFreeQty: 0,
          //       finalQty: controller.finalQTYList[index].value);
          // }
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
            contentPadding: EdgeInsets.only(top: 5, bottom: 0),
            border: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  decreaseInventoryButton(int index) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // if (controller
        //     .qtyList[index]
        //     .value >
        //     0) {
        //   controller
        //       .qtyList[index]
        //       .value--;
        //   if (controller
        //       .qtyList[index]
        //       .value ==
        //       0) {
        //     controller
        //         .qtyTextControllerList[
        //     index]
        //         .clear();
        //   } else {
        //     controller
        //         .qtyTextControllerList[
        //     index]
        //         .text =
        //     '${controller.qtyList[index]}';
        //   }
        //   if (searchProduct
        //       .schemeAvailable) {
        //     controller.getSchemeQty(
        //         quantity: controller.qtyList[index].value,
        //         index: index,
        //         schemeId:
        //         searchProduct
        //             .schemeId ??
        //             '',
        //         schemeName:
        //         searchProduct
        //             .schemeName ??
        //             '',
        //         addBuyQty:
        //         controller
        //             .qtyList[
        //         index]
        //             .value,
        //         addFreeQty: 0,
        //         finalQty: controller
        //             .finalQTYList[
        //         index]
        //             .value);
        //   }
        // }
        inventoryController.quantityList[index].value--;
        inventoryController.quantityTextControllerList[index].text =
            '${inventoryController.quantityList[index].value}';
      },
      child: Icon(Icons.remove, color: ColorsConst.primaryColor, size: 20),
    );
  }

  increaseInventoryButton(int index) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        inventoryController.quantityList[index].value++;
        inventoryController.quantityTextControllerList[index].text =
            '${inventoryController.quantityList[index].value}';
      },
      child: Icon(Icons.add, color: ColorsConst.primaryColor, size: 20),
    );
  }
}
