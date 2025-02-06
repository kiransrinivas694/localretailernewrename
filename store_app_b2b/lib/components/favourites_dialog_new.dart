import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/favorites_name_dailog_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';

import '../constants/colors_const_new.dart';

class FavouriteDialog extends StatelessWidget {
  FavouriteDialog({
    Key? key,
    required this.favouriteNameController,
    required this.controller,
  }) : super(key: key);
  TextEditingController favouriteNameController = TextEditingController();
  BuyController controller;

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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff2F394B), Color(0xff090F1A)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: CommonText(
                      content: "Favourites",
                      boldNess: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            content: "Select list to add the product",
                            boldNess: FontWeight.w400,
                            textColor: ColorsConst.textColor,
                            textSize: width * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              // Get.dialog();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsConst.primaryColor,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: List.generate(
                          controller.getFavoriteNameList.length,
                          (index) => Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.favouriteSelect.value =
                                    controller.getFavoriteNameList[index];
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: ColorsConst.hintColor,
                                    )),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      content:
                                          controller.getFavoriteNameList[index],
                                      boldNess: FontWeight.w500,
                                      textColor: ColorsConst.textColor,
                                      textSize: width * 0.04,
                                    ),
                                    controller.favouriteSelect.value !=
                                            controller
                                                .getFavoriteNameList[index]
                                        ? const SizedBox()
                                        : Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ColorsConst.primaryColor,
                                            ),
                                            padding: const EdgeInsets.all(1),
                                            child: const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: ColorsConst.redColor),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: CommonText(
                                    content: "Cancel",
                                    textSize: width * 0.035,
                                    textColor: ColorsConst.redColor,
                                    boldNess: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorsConst.greenButtonColor,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: CommonText(
                                    content: "Save",
                                    textSize: width * 0.035,
                                    textColor: Colors.white,
                                    boldNess: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
