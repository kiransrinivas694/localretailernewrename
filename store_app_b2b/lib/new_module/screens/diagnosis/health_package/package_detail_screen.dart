import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/custom_bottom_sheet_dialog.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/health_package_dialog.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class PackageDetailsScreen extends StatelessWidget {
  final String packageId;
  PackageDetailsScreen({super.key, required this.packageId});
  final ThemeController themeController = Get.put(ThemeController());
  final HealthPackageController packagedetailsController =
      Get.put(HealthPackageController());
  LucidController lucidController = Get.put(LucidController());
  final CartLabtestController cartController = Get.put(CartLabtestController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealthPackageController>(
      initState: (state) {
        packagedetailsController.getHealthPackagesDetailsID(
            packageId: packageId);
      },
      builder: (packagedetailsController) {
        // final packageDetails = packagedetailsController.healthPackageList.value;
        return Scaffold(
          appBar: const AppAppBar(title: "Health Packages"),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => SingleChildScrollView(
                child: packagedetailsController.ishealthPackageListLoading.value
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: AppShimmerEffectView(
                          height: 60.h,
                          width: double.infinity,
                        ),
                      )
                    : SizedBox(
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: themeController.textPrimaryColor,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color.fromRGBO(119, 187, 173, 0.5),
                                offset: Offset(0, 1),
                              ),
                              BoxShadow(
                                blurRadius: 4,
                                color: Color.fromRGBO(119, 187, 173, 1),
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                packagedetailsController
                                        .healthPackageList.value?.packageName ??
                                    "",
                                fontSize: 18.sp,
                                fontFamily: AppFont.poppins,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                color: themeController.navShadow1,
                              ),
                              Gap(2.h),
                              Text.rich(
                                TextSpan(
                                  text:
                                      "${packagedetailsController.totalTests} Tests for ",
                                  style: TextStyle(
                                    fontFamily: AppFont.poppins,
                                    fontSize: 16.sp,
                                    color: themeController.navShadow1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    if (packagedetailsController
                                            .healthPackageList
                                            .value
                                            ?.discount !=
                                        0)
                                      TextSpan(
                                        text:
                                            'MRP${AppString.cashSymbol}${packagedetailsController.healthPackageList.value?.finalMrp?.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: AppFont.poppins,
                                          fontSize: 16.sp,
                                          color: themeController
                                              .textSecondaryColor,
                                          fontWeight: FontWeight.w400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    TextSpan(
                                      text:
                                          'MRP${AppString.cashSymbol}${packagedetailsController.healthPackageList.value?.finalMrp?.toStringAsFixed(2)}/-',
                                      style: TextStyle(
                                        fontFamily: AppFont.poppins,
                                        fontSize: 16.sp,
                                        color: themeController.black300Color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(5.h),
                              AlignedGridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 30,
                                itemCount: packagedetailsController
                                        .healthPackageList
                                        .value
                                        ?.healthPackageTypes
                                        ?.length ??
                                    0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final type = packagedetailsController
                                      .healthPackageList.value;

                                  if (type == null ||
                                      packagedetailsController
                                              .healthPackageList
                                              .value
                                              ?.healthPackageTypes
                                              ?.length ==
                                          0)
                                    return Container(
                                      child: AppText(
                                        "No Data Available",
                                        color: themeController.black300Color,
                                      ),
                                    );
                                  return Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 4.h,
                                        child: AppImageAsset(
                                            image: type
                                                    .healthPackageTypes![index]
                                                    .image ??
                                                "assets/images/no_doctors_image.png"),
                                      ),
                                      Gap(1.h),
                                      AppText(
                                        type.healthPackageTypes?[index]
                                                .packageType ??
                                            "Test Name",
                                        fontSize: 14.sp,
                                        fontFamily: AppFont.poppins,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                        color: themeController.navShadow1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Gap(5.h),
                              GestureDetector(
                                onTap: () async {
                                  final packageDetails =
                                      packagedetailsController
                                          .healthPackageList.value;
                                  print(packageDetails);
                                  if (packageDetails != null &&
                                      packageDetails.healthPackageTypes !=
                                          null &&
                                      packageDetails
                                          .healthPackageTypes!.isNotEmpty) {
                                    await Get.dialog(HealthPackagesDialog(
                                      healthPackageList: packageDetails,
                                      continueClick: () {
                                        Get.back();
                                      },
                                      cart: false,
                                    ));
                                  } else {
                                    Get.snackbar("Error",
                                        "No health package details available.");
                                  }
                                },
                                child: AppText(
                                  "View All Tests",
                                  fontSize: 16.sp,
                                  fontFamily: AppFont.poppins,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                  decoration: TextDecoration.underline,
                                  color: themeController.navShadow1,
                                ),
                              ),
                              Gap(2.h),
                              Obx(() {
                                bool isInCart = cartController
                                    .diagnosticCartTests
                                    .any((test) =>
                                        test.serviceCd ==
                                        packagedetailsController
                                            .healthPackageList
                                            .value
                                            ?.serviceCd!);
                                return GestureDetector(
                                  onTap: () {
                                    if (packagedetailsController
                                            .healthPackageList
                                            .value!
                                            .isAppointmentRequired ==
                                        "Y") {
                                      CustomBottomSheet.show(context,
                                          helpLine: packagedetailsController
                                              .healthPackageList
                                              .value!
                                              .helpLineNumber!,
                                          continueClick: () {
                                        cartController.getTestUserDetails(
                                            isHomeCollection: '0');
                                        lucidController
                                            .getAddTest(
                                                serviceCd:
                                                    packagedetailsController
                                                        .healthPackageList
                                                        .value!
                                                        .serviceCd!,
                                                serviceName:
                                                    packagedetailsController
                                                        .healthPackageList
                                                        .value!
                                                        .packageName!,
                                                imageUrl: packagedetailsController
                                                    .healthPackageList
                                                    .value!
                                                    .image!,
                                                discount: packagedetailsController
                                                    .healthPackageList
                                                    .value!
                                                    .discount!,
                                                mrpPrice: packagedetailsController
                                                    .healthPackageList
                                                    .value!
                                                    .finalMrp!,
                                                finalMrp:
                                                    packagedetailsController
                                                        .healthPackageList
                                                        .value!
                                                        .finalMrp!,
                                                isHealthPackage: 'Y',
                                                hv: '0',
                                                isAppointmentRequired:
                                                    packagedetailsController
                                                            .healthPackageList
                                                            .value!
                                                            .isAppointmentRequired ??
                                                        "N")
                                            .then(
                                          (value) {
                                            cartController
                                                .getDiagnosticCartData(
                                                    homeCollection: "0");
                                          },
                                        );
                                      });
                                    } else if (!isInCart) {
                                      cartController.getTestUserDetails(
                                          isHomeCollection: '0');
                                      lucidController
                                          .getAddTest(
                                              serviceCd:
                                                  packagedetailsController
                                                      .healthPackageList
                                                      .value!
                                                      .serviceCd!,
                                              serviceName:
                                                  packagedetailsController
                                                      .healthPackageList
                                                      .value!
                                                      .packageName!,
                                              imageUrl: packagedetailsController
                                                  .healthPackageList
                                                  .value!
                                                  .image!,
                                              discount: packagedetailsController
                                                  .healthPackageList
                                                  .value!
                                                  .discount!,
                                              mrpPrice: packagedetailsController
                                                  .healthPackageList
                                                  .value!
                                                  .finalMrp!,
                                              finalMrp: packagedetailsController
                                                  .healthPackageList
                                                  .value!
                                                  .finalMrp!,
                                              hv: '0',
                                              isHealthPackage: 'Y',
                                              isAppointmentRequired:
                                                  packagedetailsController
                                                          .healthPackageList
                                                          .value!
                                                          .isAppointmentRequired ??
                                                      "N")
                                          .then(
                                        (value) {
                                          cartController.getDiagnosticCartData(
                                              homeCollection: "0");
                                        },
                                      );
                                    }
                                  },
                                  child: !isInCart
                                      ? Container(
                                          width: 35.w,
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: themeController
                                                .customColors.navShadow1,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: AppText(
                                              AppString.book,
                                              color: themeController
                                                  .textPrimaryColor,
                                              fontSize: 16.sp,
                                              fontFamily: AppFont.poppins,
                                              // textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (isInCart) {
                                              cartController.deleteCartTest(
                                                  serviceCd:
                                                      packagedetailsController
                                                          .healthPackageList
                                                          .value!
                                                          .serviceCd!,
                                                  hv: "0");
                                            }
                                          },
                                          child: Container(
                                            width: 35.w,
                                            height: 4.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: themeController
                                                      .navShadow1),
                                              color: themeController
                                                  .customColors
                                                  .textPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // const Gap(8),
                                                AppText(
                                                  'Added to Cart',
                                                  color: themeController
                                                      .black300Color,
                                                  fontSize: 14.sp,
                                                  fontFamily: AppFont.poppins,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                );
                              })
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
