import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller.dart';
import 'package:store_app_b2b/model/quick_prodcut_model.dart';
import 'package:store_app_b2b/model/quick_suppliers_model.dart';

class ServiceChargeScreen extends StatelessWidget {
  const ServiceChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: QuickDeliveryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: 'Service Charges',
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
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  'assets/icons/circle_i.png',
                  package: 'store_app_b2b',
                  fit: BoxFit.contain,
                  height: 20,
                  color: Colors.white,
                  width: 20,
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    orderCardView(controller.quickProductListModel,
                        controller.selectedSupplier),
                    SizedBox(height: 10),
                    OrderAmountView(controller.quickProductListModel),
                  ],
                ),
              ),
              PayNowButton(controller),
            ],
          ),
        );
      },
    );
  }

  Widget orderCardView(QuickProductListModel quickProductListModel,
      QuickSuppliersModel? suppliersModel) {
    return Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorsConst.appBorderGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              content: "Supplier : ${quickProductListModel.storeName ?? ''}",
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
                    content:
                        "${(suppliersModel == null) ? '' : suppliersModel.storeAddress ?? ''}",
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
              content:
                  "GST No : ${(suppliersModel == null) ? '' : suppliersModel.gstNumber ?? ''}",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
            SizedBox(height: 5),
            CommonText(
              content:
                  "Dl No : ${(suppliersModel == null) ? '' : suppliersModel.dlNumber ?? ''}",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
            SizedBox(height: 5),
            CommonText(
              content:
                  "Distance : ${(suppliersModel == null || suppliersModel.distance == null) ? '0.00' : suppliersModel.distance!.toStringAsFixed(2)}Km",
              boldNess: FontWeight.w500,
              textSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textColor: ColorsConst.appDarkGreyTextColor,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                    content: "No.of Products",
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: ColorsConst.appBlack34),
                CommonText(
                    content: quickProductListModel.totalProducts.toString(),
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: ColorsConst.appBlack34),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                    content: "No.of Quantity",
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: ColorsConst.appBlack34),
                CommonText(
                    content: quickProductListModel.totalQuantity.toString(),
                    boldNess: FontWeight.w500,
                    textSize: 16,
                    textColor: ColorsConst.appBlack34),
              ],
            ),
          ],
        ));
  }

  Widget OrderAmountView(QuickProductListModel quickProductListModel) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffF8F8F8),
        border: DashedBorder(
          dashLength: 3,
          left: BorderSide.none,
          top: BorderSide(color: ColorsConst.borderColor, width: 1),
          right: BorderSide.none,
          bottom: BorderSide(color: ColorsConst.borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonText(
                  content: "Service Charges",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.greyByLightTextColor),
              SizedBox(width: 20),
              Image.asset(
                'assets/icons/circle_i.png',
                package: 'store_app_b2b',
                fit: BoxFit.contain,
                height: 16,
                width: 16,
              )
            ],
          ),
          Divider(
            color: Color(0xffDADADA),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                  content: "Platform Charges",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appBlack34),
              CommonText(
                  content:
                      "₹ ${quickProductListModel.platformCharges?.toStringAsFixed(2) ?? 0.00}",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appBlack34),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                  content: "Delivery Charges",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appBlack34),
              CommonText(
                  content:
                      "₹ ${quickProductListModel.delivaryCharges?.toStringAsFixed(2) ?? 0.00}",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appBlack34),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                  content: "GST ${quickProductListModel.gstPercent ?? "0"}%",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appBlack34),
              CommonText(
                  content:
                      "₹ ${quickProductListModel.gstCharges?.toStringAsFixed(2) ?? 0.00}",
                  boldNess: FontWeight.w500,
                  textSize: 14,
                  textColor: ColorsConst.appBlack34),
            ],
          ),
          SizedBox(height: 10),
          CommonText(
              content: "Maximum Weight allowed per order is 5kg",
              boldNess: FontWeight.w500,
              textSize: 12,
              textColor: ColorsConst.greyByLightTextColor),
          Divider(
            color: Color(0xffDADADA),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                  content: "Order Total",
                  boldNess: FontWeight.w500,
                  textSize: 18,
                  textColor: ColorsConst.appBlack34),
              CommonText(
                  content:
                      "₹ ${quickProductListModel.totalPayble?.toStringAsFixed(2) ?? 0.00}",
                  boldNess: FontWeight.w500,
                  textSize: 18,
                  textColor: ColorsConst.appBlack34),
            ],
          ),
        ],
      ),
    );
  }

  Widget PayNowButton(QuickDeliveryController controller) {
    return GestureDetector(
      onTap: () => controller.openBuyProductCheckout(),
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
            content: 'Pay Now', boldNess: FontWeight.w500, textSize: 16),
      ),
    );
  }
}
