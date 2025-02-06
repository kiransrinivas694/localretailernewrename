import 'package:b2c/components/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller_new.dart';
import '../order_summary_screen/order_summary_screen_new.dart';

class AddQuickProductScreen extends StatelessWidget {
  const AddQuickProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: QuickDeliveryController(),
      initState: (state) {
        state.controller!.quickDeliveryProductList.clear();
      },
      builder: (QuickDeliveryController controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: controller.selectStoreName.value,
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
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        CommonTextField(
                          focusNode: controller.focusNode,
                          content: "",
                          hintTextSize: 14,
                          hintText: "Enter product name",
                          hintTextWeight: FontWeight.w500,
                          controller: controller.productNameController.value,
                          titleShow: false,
                          contentColor: ColorsConst.textColor,
                        ),
                        SizedBox(height: Get.height * 0.01),
                        CommonTextField(
                          content: "",
                          hintTextWeight: FontWeight.w500,
                          hintText: "Manufacturing Company",
                          hintTextSize: 14,
                          controller: controller.manufacturerController.value,
                          contentColor: ColorsConst.textColor,
                          titleShow: false,
                        ),
                        SizedBox(height: Get.height * 0.01),
                        CommonTextField(
                          content: "",
                          hintTextWeight: FontWeight.w500,
                          hintText: "Dosage",
                          hintTextSize: 14,
                          controller: controller.dosageController.value,
                          contentColor: ColorsConst.textColor,
                          titleShow: false,
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SizedBox(
                                child: CommonTextField(
                                  hintTextWeight: FontWeight.w500,
                                  hintTextSize: 14,
                                  counterText: '',
                                  maxLength: 4,
                                  content: "",
                                  hintText: "QTY",
                                  controller: controller.qtyController.value,
                                  contentColor: ColorsConst.textColor,
                                  keyboardType: TextInputType.number,
                                  titleShow: false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: SizedBox(
                                child: CommonTextField(
                                  maxLength: 4,
                                  counterText: '',
                                  hintTextWeight: FontWeight.w500,
                                  hintTextSize: 14,
                                  content: "",
                                  hintText: "Free QTY +22",
                                  controller:
                                      controller.freeQtyController.value,
                                  contentColor: ColorsConst.textColor,
                                  keyboardType: TextInputType.number,
                                  titleShow: false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.02),
                        GestureDetector(
                          onTap: () =>
                              controller.addQuickDeliveryProductOnTap(context),
                          child: Container(
                            width: Get.width,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: ColorsConst.primaryColor,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 9),
                            child: Center(
                              child: CommonText(
                                content: "Add",
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        if (controller.quickDeliveryProductList.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CommonText(
                                content: 'Order Details',
                                textSize: 18,
                                textColor: Color(0xffB3B3B3),
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                onTap: () => controller.deleteCartAPI(),
                                child: Row(
                                  children: [
                                    const CommonText(
                                      content: 'Clear All',
                                      textSize: 18,
                                      textColor: Colors.black,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'assets/icons/delete_icon.png',
                                      package: 'store_app_b2b',
                                      fit: BoxFit.cover,
                                      height: 16,
                                      width: 16,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: Get.height * 0.02),
                        if (controller.quickDeliveryProductList.isNotEmpty)
                          orderDetailsView(controller),
                      ],
                    ),
                  ),
                  viewOrderSummary(controller, context)
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

  orderDetailsView(QuickDeliveryController controller) {
    return Column(
      children: [
        const Row(children: [
          Expanded(
            flex: 2,
            child: CommonText(
              content: 'Products',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(children: [
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GestureDetector(
                            onTap: () =>
                                controller.deleteCartItemAPI(e.id ?? ''),
                            child: Image.asset(
                              'assets/icons/delete_icon.png',
                              package: 'store_app_b2b',
                              fit: BoxFit.cover,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget viewOrderSummary(
      QuickDeliveryController controller, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.quickDeliveryProductList.isEmpty) {
          CommonSnackBar.showToast('Add products', context,
              showTickMark: false);
        } else {
          Get.to(() => const OrderSummeryScreen());
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
            content: 'View Order Summary',
            boldNess: FontWeight.w500,
            textSize: 16),
      ),
    );
  }
}
