import 'package:b2c/screens/bottom_nav_bar/bank_details_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/delivery_screen/delivery_rider_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/delivery_screen/delivery_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/subscription/subscription_screen_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:b2c/widget/video_player_widget_new.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bottom_controller/store_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/new_order_screen_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/user_screen/user_screen_new.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'analytics_screens/analytics_screen_new.dart';
import 'user_screen/videoCalls_new.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  StoreB2CController storeController = Get.put(StoreB2CController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
        child: Column(
          children: [
            Obx(
              () => Container(
                height: height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: ColorsConst.yellowColor,
                ),
                child: storeController.videoControllerList.isEmpty
                    ? AppShimmerEffectView(
                        width: width,
                        height: height * 0.25,
                        borderRadius: 12,
                        baseColor: Colors.grey.withOpacity(0.9),
                        highlightColor: Colors.grey.withOpacity(0.3),
                      )
                    : VideoListWidget(
                        videoUrls: storeController.videoControllerList,
                      ),
              ),
            ),
            SizedBox(height: height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: storeController.storeList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      switch (index) {
                        case 0:
                          dynamic argument = {"selectTab": 0};
                          Get.to(() => NewOrderScreen(), arguments: argument);
                          break;
                        case 1:
                          Get.to(() => AnalyticsScreen());
                          break;
                        case 2:
                          Get.to(() => UserScreen());
                          break;
                        case 3:
                          Get.to(() => VideoCallsScreen());
                          break;
                        case 4:
                          Get.to(() => const DeliveryRiderScreen());
                          break;
                        case 5:
                          Get.to(() => const SubscriptionScreen());
                          break;
                        case 6:
                          Get.to(() => const BankDetailsScreen());
                          break;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.semiGreyColor.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "${storeController.storeList[index]["icon"]}",
                            scale: (index == 5 || index == 6)
                                ? 8
                                : index == 4
                                    ? 2
                                    : 5,
                          ),
                          SizedBox(height: height * 0.02),
                          CommonText(
                            content:
                                "${storeController.storeList[index]["title"]}",
                            textColor: AppColors.textColor,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.03),
            StreamBuilder(
                stream: storeController.bannerBottomImageList.stream,
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      Container(
                        height: height * 0.25,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // color: ColorsConst.yellowColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: storeController.bannerBottomImageList.isEmpty
                              ? AppShimmerEffectView(
                                  width: width,
                                  height: height * 0.25,
                                  borderRadius: 12,
                                  baseColor: Colors.grey.withOpacity(0.9),
                                  highlightColor: Colors.grey.withOpacity(0.3),
                                )
                              : CarouselSlider.builder(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      storeController.bannerBottomIndex.value =
                                          index;
                                    },
                                  ),
                                  itemCount: storeController
                                      .bannerBottomImageList.length,
                                  itemBuilder: (BuildContext context,
                                      int itemIndex, int pageViewIndex) {
                                    print(itemIndex);

                                    return storeController.bannerBottomImageList[
                                                    itemIndex]['imageId'] !=
                                                null ||
                                            storeController
                                                .bannerBottomImageList[
                                                    itemIndex]['imageId']
                                                .isNotEmpty
                                        ? AppImageAsset(
                                            image: storeController
                                                    .bannerBottomImageList[
                                                itemIndex]?['imageId'],
                                            fit: BoxFit.fitWidth,
                                            height: height,
                                            width: width)
                                        : AppShimmerEffectView(
                                            width: width,
                                            borderRadius: 12,
                                            baseColor:
                                                Colors.grey.withOpacity(0.9),
                                            highlightColor:
                                                Colors.grey.withOpacity(0.3),
                                          );
                                  }),
                        ),
                      ),
                      storeController.bannerBottomImageList.isEmpty
                          ? const SizedBox()
                          : Positioned(
                              bottom: 8,
                              right: 0,
                              left: 0,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Obx(() {
                                  return AnimatedSmoothIndicator(
                                    activeIndex:
                                        storeController.bannerBottomIndex.value,
                                    count: storeController
                                        .bannerBottomImageList.length,
                                    effect: WormEffect(
                                      dotWidth: 8,
                                      dotHeight: 8,
                                      activeDotColor: AppColors.primaryColor,
                                    ),
                                    onDotClicked: (index) {},
                                  );
                                }),
                              ),
                            )
                    ],
                  );
                }),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}
