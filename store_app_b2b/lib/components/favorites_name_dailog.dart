import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_snackbar.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/components/common_text_field.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller.dart';

class FavoritesNameDialog extends StatelessWidget {
  FavoritesNameDialog({Key? key, required this.controller}) : super(key: key);
  BuyController controller = BuyController();

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
                      content: "Favourites ",
                      boldNess: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextField(
                        content: "Drug License",
                        hintText: "Type name here....",
                        controller: controller.favouriteNameController.value,
                        contentColor: ColorsConst.textColor,
                        titleShow: false,
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
                                if (controller.favouriteNameController.value
                                    .text.isEmpty) {
                                  CommonSnackBar.showError("Please Enter Name");
                                } else {
                                  controller.getFavoriteNameList.add(controller
                                      .favouriteNameController.value.text
                                      .trim()
                                      .toString());
                                  print(controller.getFavoriteNameList);
                                  Get.back();
                                  setState(() {});
                                }
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
