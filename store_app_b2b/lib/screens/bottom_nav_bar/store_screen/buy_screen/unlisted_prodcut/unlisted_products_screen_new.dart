import 'package:b2c/components/login_dialog.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/new_order_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app_b2b/components/common_radio_button_new.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';
import 'package:store_app_b2b/controllers/home_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/cart_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/unlisted_prodcut/add_unlisted_tab_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/unlisted_prodcut/unlisted_list_tab_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class UnlistedProductScreen extends StatelessWidget {
  UnlistedProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder(
        init: BuyController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CommonText(
                content: "Unlisted",
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
                        controller: controller.unlistedTabController,
                        indicatorColor: ColorsConst.primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 0,
                        indicator: const MD2Indicator(
                          indicatorSize: MD2IndicatorSize.normal,
                          indicatorHeight: 3.0,
                          indicatorColor: Colors.orange,
                        ),
                        onTap: (value) async {
                          if (value == 0) {
                            await controller
                                .getSuppliersDialogListApi()
                                .then((value) {
                              print('value --> ${value}');
                              if (value.length == 1) {
                                controller.suppliersFindId.value =
                                    value[0]['supplierId'];
                                controller.suppliersFindNameSelect.value =
                                    value[0]['supplierName'];
                              }
                            });
                          }
                          if (value == 1) {
                            controller.getUnlistedPlacedProductList();
                          }
                        },
                        tabs: const [
                          Tab(
                            child: CommonText(
                              content: "Add Product",
                              textColor: Colors.black,
                              boldNess: FontWeight.w600,
                            ),
                          ),
                          Tab(
                            child: CommonText(
                              content: "Placed",
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
                    controller: controller.unlistedTabController,
                    children: const [
                      AddUnlistedProductTab(),
                      UnlistedListTab()
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
