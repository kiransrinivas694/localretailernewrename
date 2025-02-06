import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/nr_buy_controller.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_buy_product_tab.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/network_retailer_screens/nr_store_profile_screen.dart';
import 'package:store_app_b2b/widget/by_product_tab.dart';

class MaterialWrapProductScreen extends StatelessWidget {
  const MaterialWrapProductScreen(
      {super.key,
      required this.categoryId,
      required this.storeId,
      required this.storeName});

  final String categoryId;
  final String storeId;
  final String storeName;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NrBuyController>(builder: (_) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: CommonText(
              content: storeName,
              boldNess: FontWeight.w600,
              textSize: 14,
            ),
            automaticallyImplyLeading: true,
            leading: null,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => NrStoreProfileScreen(
                        retailerId: storeId,
                      ));
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle),
                  child: Icon(Icons.person),
                ),
              ),
            ],
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
          body: NrBuyProductTab(
            categoryId: categoryId,
            storeId: storeId,
          ),
        ),
      );
    });
  }
}
