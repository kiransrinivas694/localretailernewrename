import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/suppliers_dialog_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/payment/payment_screen_new.dart';
import 'package:store_app_b2b/widget/by_product_tab_new.dart';
import 'package:store_app_b2b/widget/by_supplier_tab_new.dart';
import 'package:store_app_b2b/widget/favourites_tab_new.dart';

enum BuyScreenType { buyScreen, quickDeliveryScreen }

class BuyScreen extends StatelessWidget {
  final String categoryId;
  const BuyScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyController>(
        initState: (state) async {
          Future.delayed(
            const Duration(milliseconds: 150),
            () {
              BuyController controller = Get.find<BuyController>();
              controller.searchController.value.clear();
              // controller.getBuyByProductDataApi('a', categoryId: categoryId);
              controller.getBuyByProductDataApi("", categoryId: categoryId);
            },
          );
        },
        init: BuyController(),
        builder: (controller) {
          return Column(
            children: [
              DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: controller.productTabController,
                      indicatorColor: ColorsConst.primaryColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 0,
                      indicator: const MD2Indicator(
                        indicatorSize: MD2IndicatorSize.normal,
                        indicatorHeight: 3.0,
                        indicatorColor: Colors.orange,
                      ),
                      onTap: (value) {
                        logs('value-----> $value');
                        if (value == 0) {
                          if (controller.searchController.value.text.isEmpty) {
                            controller.getBuyByProductDataApi('',
                                categoryId: categoryId);
                          } else {
                            controller.getBuyByProductDataApi(
                                controller.searchController.value.text,
                                categoryId: categoryId);
                          }
                          controller.byProductList.value = [];
                          FocusScope.of(context).unfocus();
                          controller.update();
                        } else if (value == 1) {
                          controller.searchSupplierController.value.text = '';
                          controller.bySuppliersList.value = [];
                          FocusScope.of(context).unfocus();
                          controller.update();
                        } else if (value == 2) {
                          controller.getFavouriteProductDataApi();
                          FocusScope.of(context).unfocus();
                          controller.update();
                        }
                      },
                      tabs: const [
                        Tab(
                          child: CommonText(
                            content: "By Product",
                            textColor: Colors.black,
                            boldNess: FontWeight.w600,
                          ),
                        ),
                        // Tab(
                        //   child: CommonText(
                        //     content: "By Supplier",
                        //     textColor: Colors.black,
                        //     boldNess: FontWeight.w600,
                        //   ),
                        // ),
                        Tab(
                          child: CommonText(
                            content: "Favourites",
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
                  controller: controller.productTabController,
                  children: [
                    ByProductTab(categoryId: categoryId),
                    // BySupplierTab(
                    //   controller: controller,
                    //   categoryId: categoryId,
                    //   // onTapItem: () {
                    //   //   // Get.dialog(
                    //   //   //   QuantityDialog(
                    //   //   //     onTapAddToCart: () {},
                    //   //   //     onTapAddToFavourite: () {},
                    //   //   //   ),
                    //   //   // );
                    //   // },

                    //   onTapSupplier: () async {
                    //     await controller
                    //         .getSuppliersDialogListApi()
                    //         .then((value) {
                    //       logs('value-----> $value');
                    //       if (value != null) {
                    //         Get.dialog(
                    //           SuppliersDialog(
                    //             applyOnTap: () => Get.back(),
                    //           ),
                    //         );
                    //       }
                    //     });
                    //   },
                    // ),
                    FavouriteTab(
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
