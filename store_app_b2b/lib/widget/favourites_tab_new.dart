import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';

import '../screens/bottom_nav_bar/store_screen/buy_screen/favourites_stock_refill_screen_new.dart';

class FavouriteTab extends StatelessWidget {
  const FavouriteTab({Key? key, required this.controller}) : super(key: key);

  final BuyController controller;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: controller.getFavouriteList.isNotEmpty
            ? ListView.builder(
                itemCount: controller.getFavouriteList.length,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => FavouritesStockRefill(
                          controller: controller,
                          index: index,
                          favList: controller.getFavouriteList[index].favList,
                          title: controller.getFavouriteList[index],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorsConst.semiGreyColor),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                content: controller
                                        .getFavouriteList[index].favName ??
                                    "",
                                boldNess: FontWeight.w600,
                                textColor: ColorsConst.textColor,
                                textSize: width * 0.04,
                              ),
                              InkWell(
                                onTap: () async {
                                  await controller
                                      .getDeleteFavoriteApi(controller
                                              .getFavouriteList[index].id ??
                                          "")
                                      .then((data) async {
                                    if (data != null) {
                                      await controller.getFavouriteList
                                          .removeAt(index);
                                      CommonSnackBar.showError(data['message']);
                                    }
                                  });
                                },
                                child: Image.asset(
                                  "assets/icons/delete_icon.png",
                                  scale: 4,
                                  package: 'store_app_b2b',
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content: "Store:",
                                    boldNess: FontWeight.w400,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.03,
                                  ),
                                  CommonText(
                                    content: controller.getFavouriteList[index]
                                                .storesCount ==
                                            null
                                        ? "1"
                                        : controller
                                            .getFavouriteList[index].storesCount
                                            .toString(),
                                    boldNess: FontWeight.w600,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.035,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content: "Products:",
                                    boldNess: FontWeight.w400,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.03,
                                  ),
                                  CommonText(
                                    content: controller
                                        .getFavouriteList[index].favList.length
                                        .toString(),
                                    boldNess: FontWeight.w600,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.035,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content: "Status:",
                                    boldNess: FontWeight.w400,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.03,
                                  ),
                                  CommonText(
                                    content: "Draft",
                                    boldNess: FontWeight.w600,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.035,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    content: "Created Date:",
                                    boldNess: FontWeight.w400,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.03,
                                  ),
                                  CommonText(
                                    content:
                                        '${controller.getFavouriteList[index].createdDt ?? ''}',
                                    boldNess: FontWeight.w600,
                                    textColor: ColorsConst.textColor,
                                    textSize: width * 0.035,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                              color: ColorsConst.semiGreyColor, thickness: 1.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await controller
                                      .getAddFavListToCart(controller
                                              .getFavouriteList[index].id ??
                                          '')
                                      .then((data) {
                                    if (data != null) {
                                      CommonSnackBar.showSuccess(
                                          jsonDecode(data)['message']);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 38,
                                  width: width / 2.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: ColorsConst.appGradientColor,
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Image.asset(
                                            "assets/icons/bottom_icons/cart.png",
                                            scale: 6,
                                            color: Colors.white),
                                      ),
                                      CommonText(
                                        content: "Add to Cart",
                                        textSize: width * 0.035,
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No product found',
                  style: TextStyle(fontSize: 17),
                ),
              ),
      ),
    );
  }
}
