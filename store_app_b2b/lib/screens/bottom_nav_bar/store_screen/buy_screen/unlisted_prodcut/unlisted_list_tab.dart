import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller.dart';
import 'package:store_app_b2b/controllers/home_controller.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/cart_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class UnlistedListTab extends StatelessWidget {
  const UnlistedListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetX<BuyController>(
      init: BuyController(),
      builder: (controller) {
        if (controller.isFindLoading.value) {
          return const Center(child: AppLoader());
        }
        if (controller.unlistedProductList.isEmpty) {
          return Center(
            child: CommonText(
                content: 'No Products',
                textColor: ColorsConst.textColor,
                boldNess: FontWeight.w500,
                textSize: 18),
          );
        }
        return Column(
          children: [
            Expanded(
                child: ListView.separated(
              itemCount: controller.unlistedProductList.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              separatorBuilder: (context, index) {
                return Divider(color: ColorsConst.notificationTextColor);
              },
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.parse(
                    controller.unlistedProductList[index]['createdDt']);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CommonText(
                            content: controller.unlistedProductList[index]
                                    ['productName'] ??
                                "",
                            boldNess: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textColor: ColorsConst.textColor,
                            textSize: width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    CommonText(
                      content:
                          "${controller.unlistedProductList[index]['productManufracturer'] ?? ""}",
                      boldNess: FontWeight.w400,
                      textColor: ColorsConst.notificationTextColor,
                      textSize: width * 0.03,
                    ),
                    Row(
                      children: [
                        if (controller.unlistedProductList[index]['imgURL'] !=
                            "")
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorsConst.hintColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: AppImageAsset(
                                  image: controller.unlistedProductList[index]
                                          ['imgURL'] ??
                                      "",
                                  height: 50,
                                  width: 50),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        CommonText(
                                          content: "QTY-",
                                          boldNess: FontWeight.w500,
                                          textColor: ColorsConst.textGreyColor,
                                          textSize: 14,
                                        ),
                                        CommonText(
                                          content:
                                              "${(controller.unlistedProductList[index]['quantity'] ?? 0)}",
                                          boldNess: FontWeight.w500,
                                          textColor: ColorsConst.textGreyColor,
                                          textSize: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (controller.unlistedProductList[index]
                                          ['imgURL'] ==
                                      '')
                                    Expanded(
                                      child: Row(
                                        children: [
                                          CommonText(
                                            content: "Free QTY-",
                                            boldNess: FontWeight.w500,
                                            textColor:
                                                ColorsConst.textGreyColor,
                                            textSize: 14,
                                          ),
                                          CommonText(
                                            content:
                                                "${(controller.unlistedProductList[index]['freeQuantity'] ?? 0)}",
                                            boldNess: FontWeight.w500,
                                            textColor:
                                                ColorsConst.textGreyColor,
                                            textSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (controller.unlistedProductList[index]
                                      ['imgURL'] !=
                                  "")
                                Row(
                                  children: [
                                    CommonText(
                                      content: "Free QTY-",
                                      boldNess: FontWeight.w500,
                                      textColor: ColorsConst.textGreyColor,
                                      textSize: 14,
                                    ),
                                    CommonText(
                                      content:
                                          "${(controller.unlistedProductList[index]['freeQuantity'] ?? 0)}",
                                      boldNess: FontWeight.w500,
                                      textColor: ColorsConst.textGreyColor,
                                      textSize: 14,
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (controller.unlistedProductList[index]
                                ['providerComments'] !=
                            null &&
                        controller
                            .unlistedProductList[index]['providerComments']
                            .isNotEmpty)
                      Row(
                        children: [
                          CommonText(
                            content: 'Provider Comments',
                            textColor: ColorsConst.primaryColor,
                            boldNess: FontWeight.w500,
                          ),
                          CommonText(
                            content:
                                '${controller.unlistedProductList[index]['providerComments']}',
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w500,
                          )
                        ],
                      ),
                    if (controller.unlistedProductList[index]['comments'] !=
                            null &&
                        controller
                            .unlistedProductList[index]['comments'].isNotEmpty)
                      CommonText(
                        content:
                            '${controller.unlistedProductList[index]['comments']}',
                        textColor: ColorsConst.textColor,
                        boldNess: FontWeight.w500,
                      ),
                    if (controller.unlistedProductList[index]['createdDt'] !=
                            null &&
                        controller
                            .unlistedProductList[index]['createdDt'].isNotEmpty)
                      Row(
                        children: [
                          // CommonText(
                          //   content: 'Store Name: ',
                          //   textColor: ColorsConst.primaryColor,
                          //   boldNess: FontWeight.w500,
                          // ),
                          CommonText(
                            content:
                                // '${controller.unlistedProductList[index]['createdDt']}',
                                "${dateTime.year}-${dateTime.month}-${dateTime.day} | ${dateTime.hour}:${dateTime.minute}",
                            textColor: ColorsConst.textColor,
                            boldNess: FontWeight.w500,
                          )
                        ],
                      ),
                  ],
                );
              },
            )),
          ],
        );
      },
    );
  }
}
