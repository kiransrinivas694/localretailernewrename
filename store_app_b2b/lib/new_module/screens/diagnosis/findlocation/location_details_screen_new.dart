import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/snippets/snippets.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class LocationDetailsScreen extends StatelessWidget {
  final String? locationId;
  final double? storeLat;
  final double? storeLong;
  LocationDetailsScreen(
      {required this.locationId,
      required this.storeLat,
      required this.storeLong,
      super.key});

  final ThemeController themeController = Get.find();
  LucidController lucidController = Get.put(LucidController());
  dateParse(String rawDate) {
    DateTime timmings = DateFormat("HH:mm:ss").parse(rawDate);
    String time = DateFormat("h a").format(timmings);
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LucidController>(
        init: LucidController(),
        initState: (state) {
          lucidController.getFindBranchesId(branchId: locationId!);
        },
        builder: (lucidController) {
          return SafeArea(
            child: Scaffold(
              appBar: const AppAppBar(title: ""),
              body: SingleChildScrollView(
                child: Builder(builder: (context) {
                  return Obx(
                    () => lucidController.isLocationListIdLoading.value
                        ? Container(
                            margin: const EdgeInsets.all(16),
                            child: AppShimmerEffectView(
                              baseColor: Color.fromARGB(58, 188, 186, 186),
                              height: 85.h,
                              width: double.infinity,
                            ),
                          )
                        // : Stack(
                        //     children: [
                        //       SizedBox(
                        //         height: 35.h,
                        //         child: AppImageAsset(
                        //           image: lucidController
                        //               .locationListId.value.data?.image,
                        //           width: double.infinity,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        : Column(
                            children: [
                              SizedBox(
                                // height: 35.h,
                                width: double.infinity,
                                child: AppImageAsset(
                                  image: lucidController
                                      .locationListId.value.data?.image,
                                  // width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 16.0, 16.0, 100.0),
                                decoration: BoxDecoration(
                                  color: themeController.textPrimaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      "Lucid Medical Diagnostics",
                                      color: themeController.black300Color,
                                      fontSize: 20.sp,
                                      fontFamily: AppFont.poppins,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const Gap(10),
                                    AppText(
                                      lucidController.locationListId.value.data!
                                              .branchName ??
                                          "",
                                      color: themeController.black200Color,
                                      fontSize: 19.sp,
                                      fontFamily: AppFont.poppins,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 28,
                                          color:
                                              Color.fromRGBO(207, 91, 107, 1),
                                        ),
                                        Gap(2.w),
                                        Expanded(
                                          child: AppText(
                                            lucidController.locationListId.value
                                                    .data!.location ??
                                                "",
                                            color:
                                                themeController.black200Color,
                                            fontSize: 17.sp,
                                            fontFamily: AppFont.poppins,
                                            fontWeight: FontWeight.w400,
                                            // maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(2.h),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_sharp,
                                          size: 23,
                                          color:
                                              Color.fromRGBO(207, 91, 107, 1),
                                        ),
                                        const Gap(8),
                                        AppText(
                                          "${dateParse('${lucidController.locationListId.value.data?.openingTime}')} TO ${dateParse('${lucidController.locationListId.value.data?.closingTime}')}",
                                          color: themeController.black300Color,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppFont.poppins,
                                        ),
                                      ],
                                    ),
                                    Gap(5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            makePhoneCall(lucidController
                                                    .locationListId
                                                    .value
                                                    .data!
                                                    .contactNumber ??
                                                "");
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 18),
                                            decoration: BoxDecoration(
                                                color: themeController.nav1,
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  size: 24,
                                                  color: themeController
                                                      .textPrimaryColor,
                                                ),
                                                const Gap(8),
                                                AppText(
                                                  lucidController
                                                          .locationListId
                                                          .value
                                                          .data!
                                                          .contactNumber ??
                                                      "",
                                                  color: themeController
                                                      .textPrimaryColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: AppFont.poppins,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            lucidController.openGoogleMaps(
                                                storeLat!, storeLong!);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 18),
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    207, 91, 107, 1),
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 24,
                                                  color: themeController
                                                      .textPrimaryColor,
                                                ),
                                                const Gap(8),
                                                AppText(
                                                  "Directions",
                                                  color: themeController
                                                      .textPrimaryColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: AppFont.poppins,
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
                            ],
                          ),
                    //   ],
                    // ),
                  );
                }),
              ),
            ),
          );
        });
  }
}
