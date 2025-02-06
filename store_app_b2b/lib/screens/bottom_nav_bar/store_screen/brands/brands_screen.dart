import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_search_field.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller.dart';

class BrandsScreen extends StatelessWidget {
  BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController brandsController = TextEditingController();
    StoreController storeController = Get.find();
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "Suresh Enterprises",
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          CommonSearchField(
            controller: brandsController,
            // showCloseIcon:
            //     controller.searchController.value.text.isNotEmpty,
            // closeOnTap: () {
            //   controller.searchController.value.clear();
            //   controller.getBuyByProductDataApi("",
            //       categoryId: widget.categoryId);
            // },
            // controller: controller.searchController.value,
            // onChanged: (String value) {
            //   if (value.isNotEmpty) {
            //     controller.getBuyByProductDataApi(value,
            //         showLoading: false, categoryId: widget.categoryId);
            //   } else {
            //     controller.isLoading(true);
            //     controller.byProductList.clear();
            //     controller.isLoading(false);
            //     controller.getBuyByProductDataApi("",
            //         showLoading: false, categoryId: widget.categoryId);
            //     controller.update();
            //   }
            // },
          ),
          SizedBox(
            height: 20,
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 45,
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 19,
            itemBuilder: (context, index) {
              return Container(
                // height: 40,
                // width: 30.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.appWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 0.5),
                      blurRadius: 5.7,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Container(
                  height: 40,
                  width: 18.w,
                  child: Image.asset(
                    "assets/image/cipla_brand.png",
                    scale: 4,
                    package: 'store_app_b2b',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
