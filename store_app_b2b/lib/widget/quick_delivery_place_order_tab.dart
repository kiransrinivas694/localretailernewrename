import 'package:b2c/components/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_radio_button.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller.dart';
import 'package:store_app_b2b/model/quick_suppliers_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/add_quick_prodcut_screen/add_quick_prodcut_screen.dart';

class QuickDeliveryPlaceOrderTab extends StatelessWidget {
  final QuickDeliveryController controller;

  const QuickDeliveryPlaceOrderTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuickDeliveryController>(
      init: QuickDeliveryController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Obx(() => GestureDetector(
                              onTap: () async {
                                await controller
                                    .getQuickSuppliersDialogListApi()
                                    .then((value) {
                                  if (value != null) {
                                    Get.dialog(
                                      supplierDialog(controller),
                                    );
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: ColorsConst.appBorderGrey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: CommonText(
                                        content: (controller.selectStoreName
                                                .value.isNotEmpty)
                                            ? controller.selectStoreName.value
                                            : "Supplier",
                                        textSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        boldNess: FontWeight.w500,
                                        textColor: ((controller.selectStoreName
                                                .value.isNotEmpty))
                                            ? ColorsConst.primaryColor
                                            : ColorsConst.greyTextColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                        "assets/icons/down_arrow_icon.png",
                                        scale: 2,
                                        package: 'store_app_b2b',
                                        color: ColorsConst.greyTextColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        const SizedBox(height: 10),
                        controller.selectedSupplier != null
                            ? orderCardView(controller.selectedSupplier!)
                            : Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Image.asset(
                                  "assets/image/place_quick_order_empty.png",
                                  // width: 100,
                                  // scale: 0.2,
                                  // height: 250,
                                  package: 'store_app_b2b',
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ],
                    ),
                  ),
                  (controller.isShowAddProductButton == null)
                      ? nextButton(context)
                      : (controller.isShowAddProductButton!.value)
                          ? nextButton(context)
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: CommonText(
                                  content: 'Store is not open',
                                  textColor: ColorsConst.textColor,
                                  textSize: 18,
                                  boldNess: FontWeight.w500),
                            ),
                ],
              ),
              Obx(() => (controller.isLoading.value)
                  ? AppLoader(color: ColorsConst.primaryColor)
                  : SizedBox())
            ],
          ),
        );
      },
    );
  }

  Widget nextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.selectStoreName.isEmpty) {
          CommonSnackBar.showToast(
            'Please select supplier',
            context,
            showTickMark: false,
            width: double.infinity,
          );
        } else {
          Get.to(() => const AddQuickProductScreen());
        }
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConst.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: const CommonText(
            content: 'Add Product', boldNess: FontWeight.w500, textSize: 16),
      ),
    );
  }

  Widget orderCardView(QuickSuppliersModel supplierModel) {
    return Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorsConst.appBorderGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              content: "Supplier : ${supplierModel.storeName ?? ''}",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  content: "Address : ",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appDarkGreyTextColor,
                ),
                Flexible(
                  child: CommonText(
                    content: "${supplierModel.storeAddress ?? ''}",
                    boldNess: FontWeight.w500,
                    textSize: 14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textColor: ColorsConst.appDarkGreyTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            CommonText(
              content: "GST No : ${supplierModel.gstNumber ?? ''}",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
            SizedBox(height: 5),
            CommonText(
              content: "Dl No : ${supplierModel.dlNumber ?? ''}",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
            SizedBox(height: 5),
            CommonText(
              content:
                  "Distance : ${(supplierModel.distance == null) ? '0.00' : supplierModel.distance!.toStringAsFixed(2)}Km",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
          ],
        ));
  }

  supplierDialog(QuickDeliveryController controller) {
    String selectedSupplierName = controller.selectStoreName.value;
    String selectedSupplierId = controller.selectStoreId.value;
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
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ColorsConst.appGradientColor,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            content: "Added Suppliers",
                            boldNess: FontWeight.w600,
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            controller.suppliersDialogList.length, (index) {
                          return RadioButton(
                            onTap: () {
                              selectedSupplierName = controller
                                      .suppliersDialogList[index].storeName ??
                                  '';
                              selectedSupplierId = controller
                                      .suppliersDialogList[index].storeId ??
                                  '';
                              setState(() {});
                            },
                            title: controller
                                    .suppliersDialogList[index].storeName ??
                                '',
                            selectTitle: selectedSupplierName,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      controller.setSelectedStoreValue(
                          storeName: selectedSupplierName,
                          storeId: selectedSupplierId);
                      Get.back();
                    },
                    child: Container(
                      height: 45,
                      width: 150,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xff2F384B),
                          Color(0xff0A101B),
                        ]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: CommonText(
                        content: 'Apply',
                        boldNess: FontWeight.w600,
                      ),
                    ),
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
