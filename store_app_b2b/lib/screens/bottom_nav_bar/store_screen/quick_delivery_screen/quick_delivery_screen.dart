import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/quick_delivery_controller/quick_delivery_controller.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/quick_delivery_screen/quick_delivery_refer_screen/quick_delivery_refer_screen.dart';
import 'package:store_app_b2b/widget/quick_delivery_order_history_tab.dart';
import 'package:store_app_b2b/widget/quick_delivery_place_order_tab.dart';

class QuickDeliveryScreen extends StatelessWidget {
  final int tabIndex;

  const QuickDeliveryScreen({super.key, this.tabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuickDeliveryController>(
        initState: (state) async {
          Future.delayed(
            const Duration(milliseconds: 150),
            () {
              QuickDeliveryController controller =
                  Get.find<QuickDeliveryController>();
              controller.quickDeliveryTabController.index = tabIndex;
              controller.getQuickSuppliersDialogListApi().then((value) {
                print("printing suppliers value -> $value");
                if (value != null && value.length == 1) {
                  controller.setSelectedStoreValue(
                      storeName: value[0]['storeName'] ?? '',
                      storeId: value[0]['storeId'] ?? '');
                }
              });
              controller.update();
            },
          );
        },
        init: QuickDeliveryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const CommonText(
                content: 'Quick Delivery',
                boldNess: FontWeight.w600,
                textSize: 14,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const QuickDeliveryReferScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/refer_icon.png",
                          height: 30,
                          width: 30,
                          package: 'store_app_b2b',
                          fit: BoxFit.cover,
                        ),
                        CommonText(
                          content: "Refer Supplier",
                          textSize: 10,
                        )
                      ],
                    ),
                  ),
                )
              ],
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
            body: Column(
              children: [
                DefaultTabController(
                  initialIndex: controller.quickDeliveryTabController.index,
                  length: 2,
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Material(
                      color: Colors.white,
                      child: TabBar(
                        controller: controller.quickDeliveryTabController,
                        indicatorColor: ColorsConst.primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 0,
                        indicator: const MD2Indicator(
                          indicatorSize: MD2IndicatorSize.full,
                          indicatorHeight: 3.0,
                          indicatorColor: Colors.orange,
                        ),
                        onTap: (value) async {
                          controller.quickDeliveryTabController.index = value;
                          controller.update();

                          if (value == 0) {
                            controller
                                .getQuickSuppliersDialogListApi()
                                .then((value) {
                              if (value.length == 1) {
                                controller.setSelectedStoreValue(
                                    storeName: value[0]['storeName'] ?? '',
                                    storeId: value[0]['storeId'] ?? '');
                              }
                            });
                          }
                        },
                        tabs: [
                          Tab(
                            child: CommonText(
                              content: "Place Order",
                              textColor: (controller
                                          .quickDeliveryTabController.index ==
                                      0)
                                  ? ColorsConst.primaryColor
                                  : ColorsConst.greyTextColor,
                              boldNess: FontWeight.w600,
                            ),
                          ),
                          Tab(
                            child: CommonText(
                              content: "Order History",
                              textColor: (controller
                                          .quickDeliveryTabController.index ==
                                      1)
                                  ? ColorsConst.primaryColor
                                  : ColorsConst.greyTextColor,
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
                    controller: controller.quickDeliveryTabController,
                    children: [
                      QuickDeliveryPlaceOrderTab(controller: controller),
                      QuickDeliveryOrderHistoryTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
