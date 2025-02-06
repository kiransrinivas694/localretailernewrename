import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_snackbar_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/cart_controller/cart_controller_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/cart_screen/order_placed_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class UnVerifiedProductTab extends StatelessWidget {
  const UnVerifiedProductTab({
    Key? key,
    required this.onOrderPlace,
    required this.controller,
  }) : super(key: key);
  final CartController controller;
  final VoidCallback onOrderPlace;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        (controller.unverifiedProductList.isEmpty)
            ? Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/image/empty_cart.png',
                    package: 'store_app_b2b',
                    fit: BoxFit.cover,
                    height: height * 0.3,
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: controller.unverifiedProductList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          right: 15,
                          left: 15,
                          top: index == 0 ? 10 : 0,
                          bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                content: controller.unverifiedProductList[index]
                                        ['productName'] ??
                                    "",
                                boldNess: FontWeight.w600,
                                textColor: Colors.black,
                              ),
                              CommonText(
                                content:
                                    "${controller.unverifiedProductList[index]['createdDt'] ?? ""} | ${controller.unverifiedProductList[index]['productManufracturer'] ?? ""}",
                                textColor: ColorsConst.textColor,
                                textSize: 13,
                              ),
                              SizedBox(height: height * 0.005),
                              Row(
                                children: [
                                  const CommonText(
                                    content: "QTY-",
                                    textColor: Colors.black,
                                    textSize: 12,
                                  ),
                                  SizedBox(width: width * 0.02),
                                  CommonText(
                                    content:
                                        "${controller.unverifiedProductList[index]['quantity'].toStringAsFixed(0) ?? ""}",
                                    boldNess: FontWeight.w600,
                                    textColor: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              controller.unverifiedProductList[index]
                                          ['imgURL'] ==
                                      ""
                                  ? const SizedBox(height: 50, width: 50)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorsConst.hintColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: AppImageAsset(
                                            image: controller
                                                        .unverifiedProductList[
                                                    index]['imgURL'] ??
                                                "",
                                            height: 50,
                                            width: 50),
                                      ),
                                    ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () async {
                                  await controller
                                      .getDeleteFindProductApi(controller
                                          .unverifiedProductList[index]['id'])
                                      .then((value) {
                                    if (value != null) {
                                      controller.isLoading.value = true;
                                      print("value>>>>>>>>>>>>>>$value");
                                      controller.unverifiedProductList.value =
                                          value;
                                      CommonSnackBar.showSuccess('Deleted');
                                      controller.isLoading.value = false;
                                      controller.update();
                                    }
                                  });
                                },
                                child: Image.asset(
                                  "assets/icons/delete_icon.png",
                                  scale: 4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        CommonText(
          content:
              "Note : This order doesn’t have total value It may vary from Expectations",
          textColor: Colors.red,
          boldNess: FontWeight.w500,
          textSize: width * 0.025,
        ),
        SizedBox(height: height * 0.01),
        Container(
          height: height / 6.2,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width,
                color: const Color(0xffE5E5E5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      content:
                          "Today, ${DateFormat('dd MMM yy').format(DateTime.now())}",
                      textColor: Colors.black,
                      textSize: width * 0.035,
                      boldNess: FontWeight.w600,
                    ),
                    SizedBox(height: height * 0.001),
                    Row(
                      children: [
                        CommonText(
                          content: "Products : ",
                          textSize: width * 0.035,
                          textColor: ColorsConst.textColor,
                        ),
                        CommonText(
                          content: "${controller.unverifiedProductList.length}",
                          textSize: width * 0.035,
                          boldNess: FontWeight.w600,
                          textColor: ColorsConst.textColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    if (controller.unverifiedProductList.isNotEmpty) {
                      await controller.getUnverifiedPlaceOrder().then((value) {
                        if (value != null) {
                          Get.to(() => const OrderPlacedScreen());
                        }
                      });
                    } else {
                      CommonSnackBar.showError("No product to place order");
                    }
                  },
                  child: Container(
                    height: 42,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ColorsConst.appGradientColor,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: CommonText(
                        content: "Place order",
                        textSize: width * 0.035,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
