import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/favorites_name_dailog_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/buy_controller_new.dart';

class QuantityDialog extends StatelessWidget {
  QuantityDialog(
      {Key? key,
      required this.onTapAddToCart,
      required this.onTapAddToFavourite,
      required this.item})
      : super(key: key);
  Map item = {};
  BuyController controller = BuyController();
  final VoidCallback onTapAddToCart;
  final VoidCallback onTapAddToFavourite;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
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
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: ColorsConst.appGradientColor,
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
                          content: "${item["productName"]}",
                          boldNess: FontWeight.w600,
                        ),
                        CommonText(
                          content: "${item["storeName"]}",
                          textSize: width * 0.03,
                          boldNess: FontWeight.w500,
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      content: "${item["address"]}",
                      boldNess: FontWeight.w500,
                      textColor: ColorsConst.notificationTextColor,
                      textSize: width * 0.036,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: width / 4.5,
                          decoration: const BoxDecoration(
                            color: Color(0xffE9EDED),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/offer_icon.png",
                                scale: 3.5,
                                package: 'store_app_b2b',
                              ),
                              CommonText(
                                content: "20 + 1",
                                boldNess: FontWeight.w500,
                                textColor: ColorsConst.textColor,
                                textSize: width * 0.03,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        CommonText(
                          content: "In Stock",
                          boldNess: FontWeight.w500,
                          textColor: ColorsConst.greenColor,
                          textSize: width * 0.036,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CommonText(
                              content: "MRP",
                              boldNess: FontWeight.w400,
                              textColor: ColorsConst.semiGreyColor,
                              textSize: width * 0.036,
                            ),
                            CommonText(
                              content: "₹ ${item["mrp"]}",
                              boldNess: FontWeight.w500,
                              textColor: ColorsConst.textColor,
                              textSize: width * 0.04,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CommonText(
                              content: "PTR",
                              boldNess: FontWeight.w400,
                              textColor: ColorsConst.semiGreyColor,
                              textSize: width * 0.036,
                            ),
                            CommonText(
                              content: "₹ ${item["ptr"]}",
                              boldNess: FontWeight.w500,
                              textColor: ColorsConst.textColor,
                              textSize: width * 0.04,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width / 6,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                color: ColorsConst.semiGreyColor,
                              ),
                              hintText: "Quantity",
                              contentPadding: EdgeInsets.zero,
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 6,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                  color: ColorsConst.semiGreyColor),
                              hintText: "Free",
                              contentPadding: EdgeInsets.zero,
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.04),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                      ),
                      onPressed: onTapAddToCart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/bottom_icons/cart.png",
                                scale: 5, color: ColorsConst.textColor),
                            SizedBox(width: width * 0.02),
                            CommonText(
                              content: "Add to cart",
                              textSize: width * 0.04,
                              textColor: Colors.black,
                              boldNess: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                      ),
                      onPressed: onTapAddToFavourite,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonText(
                              content: "Add to Favourite",
                              textSize: width * 0.04,
                              textColor: Colors.black,
                              boldNess: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  favouriteListDialog(int index, double width, double height) {
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
                    mainAxisSize: MainAxisSize.min,
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
                              controller.favouriteNameController.value.clear();
                              Get.dialog(
                                FavoritesNameDialog(controller: controller),
                              );
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
                      Obx(
                        () => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            controller.getFavoriteNameList.length,
                            (index) => GestureDetector(
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
                    ],
                  ),
                ),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
        ),
      ),
    );
  }
}
