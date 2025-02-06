import 'dart:developer';

import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/screens/bottom_nav_bar/home_screens/controller/inventory_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/home_screens/inventory_detail_Screen_new.dart';
import 'package:b2c/service/api_service_new.dart';
import 'package:b2c/utils/snack_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_radio_button_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bottom_controller/invetory_controller/inventory_controller_new.dart';

class SubCategoryDialog extends StatelessWidget {
  SubCategoryDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final InventoryController controller;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: height / 1.58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.appGradientColor,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            content: GetHelperController.categoryName.value,
                            boldNess: FontWeight.w600,
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          InventoryListController.to.getCategoriesRes.length,
                          (index) => Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Obx(() {
                                        return Radio<String>(
                                          value: InventoryListController
                                                  .to.getCategoriesRes[index]
                                              ['subCategoryId'],
                                          groupValue: InventoryListController
                                              .to.categoryID.value,
                                          onChanged: (value) {
                                            InventoryListController
                                                .to
                                                .categoryID
                                                .value = value.toString();
                                            log(InventoryListController
                                                .to.categoryID.value);
                                            log((InventoryListController
                                                        .to.categoryID.value ==
                                                    value)
                                                .toString());
                                          },
                                          activeColor: AppColors.primaryColor,
                                        );
                                      }),
                                      CommonText(
                                        content: InventoryListController
                                                .to.getCategoriesRes[index]
                                            ['subCategoryName'],
                                        textSize: width * 0.035,
                                        boldNess: FontWeight.w500,
                                        textColor: AppColors.appblack,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      height: 8, color: AppColors.hintColor),
                                ],
                              )),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      InventoryListController.to.inventoryList.clear();

                      InventoryListController.to.categoryItemListApi(
                          queryParameters: {"page": 0, "size": 10},
                          subCategoryID:
                              InventoryListController.to.categoryID.value,
                          success: () {
                            Get.back();
                          },
                          error: (e) {
                            showSnackBar(
                                title: ApiConfig.error, message: e.toString());
                          });
                    },
                    child: Container(
                      height: 45,
                      width: width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          colors: AppColors.appGradientColor,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: CommonText(
                          content: "Apply",
                          textSize: width * 0.035,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
