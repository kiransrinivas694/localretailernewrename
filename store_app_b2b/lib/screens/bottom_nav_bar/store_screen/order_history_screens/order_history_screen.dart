import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/components/suppliers_dialog.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_order_history_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/order_history_controller/order_history_controller.dart';
import 'package:store_app_b2b/model/unlisted_order_model.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_by_date_order_history_tab.dart';
import 'package:store_app_b2b/widget/by_date_order_history_tab.dart';
import 'package:store_app_b2b/widget/by_supplier_order_history_tab.dart';
import 'package:store_app_b2b/widget/unlisted_order_tab.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);
  final OrderHistoryController orderController =
      Get.put(OrderHistoryController());

  final NrOrderHistoryController nrOrderController =
      Get.put(NrOrderHistoryController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<OrderHistoryController>(
      init: OrderHistoryController(),
      initState: (state) {
        orderController.selectFrom = DateTime.now();
        orderController.selectTo = DateTime.now();
        orderController.getBuyByDate();
      },
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "Invoice History",
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
                  length: 3,
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Material(
                      color: Colors.white,
                      child: TabBar(
                        onTap: (value) {
                          if (value == 0) {
                            orderController.selectFrom = DateTime.now();
                            orderController.selectTo = DateTime.now();
                            orderController.getBuyByDate();
                          } else if (value == 1) {
                            nrOrderController.selectFrom = DateTime.now();
                            nrOrderController.selectTo = DateTime.now();
                            nrOrderController.getBuyByDate();
                          } else {
                            orderController.byProductList.value = [];
                            orderController.selectTo = null;
                            orderController.selectFrom = null;
                            orderController.unlistedProductResponseModel =
                                GetUnlistedProductResponseModel();
                          }
                          FocusScope.of(context).unfocus();
                        },
                        controller: orderController.controller,
                        indicatorColor: ColorsConst.primaryColor,
                        labelPadding: EdgeInsets.all(2),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 0,
                        indicator: MD2Indicator(
                          indicatorSize: MD2IndicatorSize.normal,
                          indicatorHeight: 3.0,
                          indicatorColor: Colors.orange,
                        ),
                        tabs: [
                          Tab(
                            child: CommonText(
                              content: "Listed",
                              textColor: Colors.black,
                              boldNess: FontWeight.w600,
                              textSize: width * 0.035,
                            ),
                          ),
                          Tab(
                            child: CommonText(
                              content: "Network Retailer",
                              textColor: Colors.black,
                              boldNess: FontWeight.w600,
                              textSize: width * 0.035,
                            ),
                          ),
                          Tab(
                            child: CommonText(
                              content: "Unlisted",
                              textColor: Colors.black,
                              boldNess: FontWeight.w600,
                              textSize: width * 0.035,
                            ),
                          ),
                          // Tab(
                          //   child: CommonText(
                          //     content: "By Supplier",
                          //     textColor: Colors.black,
                          //     boldNess: FontWeight.w600,
                          //     textSize: width * 0.035,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: orderController.controller,
                          children: [
                            ByDateOrderHistoryTab(),
                            NrByDateOrderHistoryTab(),
                            UnlistedOrderTab(),
                            // BySupplierOrderHistoryTab(
                            //   onTapSupplier: () async {
                            //     await Get.put(BuyController())
                            //         .getSuppliersDialogListApi();
                            //     Get.dialog(SuppliersDialog(
                            //         applyOnTap: () => Get.back()));
                            //   },
                            // ),
                            //ShortSupplyOrderHistoryTab(),
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
      },
    );
  }
}
