import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller_new.dart';
import 'package:store_app_b2b/model/quick_suppliers_model_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/service_charge_screen/service_charge_screen_new.dart';

class OrderSummeryScreen extends StatelessWidget {
  const OrderSummeryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: QuickDeliveryController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: 'Order Summary',
              boldNess: FontWeight.w600,
              textSize: 14,
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
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (controller.selectedSupplier != null)
                        orderCardView(controller.selectedSupplier!),
                      SizedBox(height: Get.height * 0.02),
                      const CommonText(
                        content: 'Order Details',
                        textSize: 18,
                        textColor: Color(0xffB3B3B3),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      orderDetailsView(controller),
                    ],
                  ),
                ),
                serviceChargeButton()
              ],
            ),
          ),
        );
      },
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

  orderDetailsView(QuickDeliveryController controller) {
    return Column(
      children: [
        const Row(children: [
          Expanded(
            flex: 2,
            child: CommonText(
              content: 'Prodcuts',
              textColor: Colors.black,
              textSize: 18,
              boldNess: FontWeight.w500,
            ),
          ),
          Expanded(
              child: CommonText(
                  content: 'Qty',
                  textSize: 14,
                  textColor: Colors.black,
                  textAlign: TextAlign.center)),
          Expanded(
              child: CommonText(
                  content: 'Free Qty',
                  textSize: 14,
                  textColor: Colors.black,
                  textAlign: TextAlign.center)),
          Expanded(
              child: CommonText(
            content: 'Total Qty',
            textSize: 14,
            textColor: Colors.black,
            textAlign: TextAlign.center,
          )),
        ]),
        Column(
          children: controller.quickDeliveryProductList
              .map((e) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffCFCFCF))),
                    ),
                    child: Row(children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                content: e.productName ?? '',
                                textColor: const Color(0xff343434),
                                textSize: 14,
                              ),
                              CommonText(
                                content: e.manufacturer ?? '',
                                textColor: const Color(0xff949292),
                                textSize: 12,
                              ),
                            ],
                          )),
                      Expanded(
                          child: CommonText(
                              content: '${e.quantity ?? 0}',
                              textSize: 14,
                              textColor: Colors.black,
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: CommonText(
                              content: '${e.freeQuantity ?? 0}',
                              textSize: 14,
                              textColor: Colors.black,
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: CommonText(
                        content: '${e.totalQuantity ?? 0}',
                        textSize: 14,
                        textColor: Colors.black,
                        textAlign: TextAlign.center,
                      )),
                    ]),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget serviceChargeButton() {
    return GestureDetector(
      onTap: () => Get.to(() => const ServiceChargeScreen()),
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
            content: 'Proceed to Checkout',
            boldNess: FontWeight.w500,
            textSize: 16),
      ),
    );
  }
}
