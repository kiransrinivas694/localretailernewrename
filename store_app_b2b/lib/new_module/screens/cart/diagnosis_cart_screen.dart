import 'package:b2c/controllers/global_main_controller.dart';
import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/screens/cart/empty_cart.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_screen.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/sample_collection_screen.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/confirmation_dialog.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/health_package_dialog.dart';
import 'package:store_app_b2b/new_module/snippets/snippets.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/service/api_service.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class DiagnosticCartScreen extends StatelessWidget {
  DiagnosticCartScreen({super.key, required this.homeCollection});
  final String homeCollection;
  final GlobalMainController globalController = Get.put(GlobalMainController());
  final HealthPackageController healthPackageController =
      Get.put(HealthPackageController());
  SampleCollectionController sampleCollectionController =
      Get.put(SampleCollectionController());
  CartLabtestController controller = Get.put(CartLabtestController());
  final ThemeController themeController = Get.find();
  formattedDates(String date) {
    DateFormat formatter = DateFormat("MMM dd,yyyy hh:mm a");
    String formattedDate = formatter.format(DateTime.parse(date));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Expanded(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: themeController.textPrimaryColor,
                ),
                child:
                    controller.isDiagnosticTestCartLoading.value ||
                            controller.isDiagnosticUSerDetailsLoading.value ||
                            controller.isTestDeletingLoading.value ||
                            controller.isTestDeletingAllLoading.value
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 16),
                            child: verticalShimmerListView(
                              shimmerContainerHeight: 90,
                              shimmerContainerWidth: 350,
                            ),
                          )
                        : (homeCollection == "0"
                                ? controller.diagnosticCartTests.isEmpty
                                : controller.diagnosticHomeTests.isEmpty)
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: EmptyCartScreen(),
                              )
                            : Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (controller.testUserDetails.value !=
                                            null)
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() =>
                                                    SampleCollectionScreen(
                                                        homeCollection:
                                                            homeCollection ==
                                                                    "0"
                                                                ? false
                                                                : true));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: const Color.fromRGBO(
                                                        240, 240, 240, 1)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AppText(
                                                          "Details:",
                                                          fontFamily:
                                                              AppFont.poppins,
                                                          fontSize: 17.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: themeController
                                                              .black300Color,
                                                        ),
                                                        Icon(
                                                          Icons.info_outline,
                                                          color: themeController
                                                              .black300Color,
                                                        ),
                                                      ],
                                                    ),
                                                    const Gap(8),
                                                    AppText(
                                                      "${controller.testUserDetails.value?.firstName!.capitalizeFirst} ${controller.testUserDetails.value?.lastName!.capitalizeFirst},${controller.testUserDetails.value?.age},${controller.testUserDetails.value?.gender},${controller.testUserDetails.value?.mobileNumber},\n${controller.testUserDetails.value?.city},${controller.testUserDetails.value?.location},${formattedDates('${controller.testUserDetails.value?.appointmentDate}')}${(controller.testUserDetails.value?.address != "") ? ",${controller.testUserDetails.value?.fullAddress},${controller.testUserDetails.value?.address}." : "."}",
                                                      fontFamily:
                                                          AppFont.poppins,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeController
                                                          .black300Color,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText(
                                                "${homeCollection == "0" ? controller.diagnosticCartTests.length : controller.diagnosticHomeTests.length} ITEMS SELECTED",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 16.sp,
                                                color: themeController
                                                    .black300Color,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await Get.dialog(
                                                      ConfirmationDialog(
                                                    message:
                                                        "Are you sure you want to remove all the items from the cart?",
                                                    continueClick: () {
                                                      // logs(
                                                      //     "cart id is ${controller.testUserDetails.value?.cartId}");
                                                      controller
                                                          .deleteAllCartTest(
                                                        cartId: controller
                                                                .diagnosticCartData
                                                                .value
                                                                ?.data
                                                                ?.id ??
                                                            "",
                                                        isHomeCollection:
                                                            homeCollection,
                                                      );
                                                      sampleCollectionController
                                                          .clearForm();
                                                      Get.back();
                                                    },
                                                  ));
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  size:
                                                      20, //#color need to added #D05061
                                                  color: Color.fromRGBO(
                                                      208, 80, 97, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Obx(
                                                      () =>
                                                          homeCollection == "0"
                                                              ? ListView
                                                                  .separated(
                                                                  itemCount:
                                                                      controller
                                                                          .diagnosticCartTests
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final lucidLabTest =
                                                                        controller
                                                                            .diagnosticCartTests[index];

                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                                boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4,
                                                                                color: Color.fromRGBO(0, 0, 0, 0.20),
                                                                                offset: Offset(0, 1),
                                                                                spreadRadius: 0,
                                                                              )
                                                                            ]),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            if (lucidLabTest.isAppointmentRequired ==
                                                                                "Y")
                                                                              Container(
                                                                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)), color: themeController.textPrimaryColor),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Gap(1.h),
                                                                                    AppText(
                                                                                      "\t*Appointment Required",
                                                                                      fontFamily: AppFont.poppins,
                                                                                      fontSize: 16.sp,
                                                                                      color: themeController.navShadow1,
                                                                                      fontWeight: FontWeight.w300,
                                                                                    ),
                                                                                    const Divider(
                                                                                      color: Color.fromRGBO(196, 196, 196, 1),
                                                                                      thickness: 1,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            Stack(
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: lucidLabTest.isAppointmentRequired == "Y" ? const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)) : BorderRadius.circular(8),
                                                                                    color: themeController.textPrimaryColor,
                                                                                  ),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(12),
                                                                                            child: AppImageAsset(
                                                                                              image: lucidLabTest.image ?? "",
                                                                                              width: 20.w,
                                                                                              height: 8.h,
                                                                                            ),
                                                                                          ),
                                                                                          Gap(2.w),
                                                                                          Expanded(
                                                                                            child: AppText(
                                                                                              // runesNeeded: true,
                                                                                              lucidLabTest.serviceName ?? "",
                                                                                              fontFamily: AppFont.poppins,
                                                                                              fontSize: 14.sp,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: themeController.black300Color,
                                                                                              maxLines: 3,
                                                                                              // overflow:
                                                                                              //     TextOverflow
                                                                                              //         .ellipsis,
                                                                                            ),
                                                                                          ),
                                                                                          Gap(1.w),
                                                                                          Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  AppText(
                                                                                                    "${AppString.cashSymbol}${lucidLabTest.finalMrp?.toStringAsFixed(2) ?? ""}",
                                                                                                    fontFamily: AppFont.poppins,
                                                                                                    fontSize: 15.sp,
                                                                                                    color: themeController.black300Color,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                  Gap(1.w),
                                                                                                  GestureDetector(
                                                                                                    onTap: () async {
                                                                                                      await Get.dialog(ConfirmationDialog(
                                                                                                        message: "Are you sure you want to remove this item from your cart?",
                                                                                                        continueClick: () {
                                                                                                          controller.deleteCartTest(serviceCd: lucidLabTest.serviceCd, hv: homeCollection);
                                                                                                          Get.back();
                                                                                                        },
                                                                                                      ));
                                                                                                    },
                                                                                                    child: Icon(Icons.close, size: 20, color: themeController.black200Color),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              const Gap(10),
                                                                                              (lucidLabTest.isHealthPackage == "Y")
                                                                                                  ? Align(
                                                                                                      child: GestureDetector(
                                                                                                        onTap: () async {
                                                                                                          await healthPackageController.getPackageViewCart(serviceCd: lucidLabTest.serviceCd!).then(
                                                                                                            (value) {
                                                                                                              final packageCartDetails = healthPackageController.healthPackageCartList.value;
                                                                                                              if (packageCartDetails != null && packageCartDetails.healthPackageTypes != null && packageCartDetails.healthPackageTypes!.isNotEmpty) {
                                                                                                                Get.dialog(HealthPackagesDialog(
                                                                                                                    cart: true,
                                                                                                                    healthPackageCartList: packageCartDetails,
                                                                                                                    continueClick: () {
                                                                                                                      Get.back();
                                                                                                                    }));
                                                                                                              }
                                                                                                            },
                                                                                                          );
                                                                                                        },
                                                                                                        child: AppText(
                                                                                                          "View All",
                                                                                                          color: themeController.black300Color,
                                                                                                          fontSize: 16.sp,
                                                                                                          fontFamily: AppFont.poppins,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          decoration: TextDecoration.underline,
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  : const Gap(0)
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                if (lucidLabTest.discount != null && lucidLabTest.discount! > 0)
                                                                                  Positioned(
                                                                                    top: 3,
                                                                                    left: -6,
                                                                                    child: RotationTransition(
                                                                                      turns: const AlwaysStoppedAnimation(-30 / 360),
                                                                                      child: Container(
                                                                                        width: 45,
                                                                                        padding: const EdgeInsets.symmetric(
                                                                                          vertical: 1,
                                                                                        ),
                                                                                        color: const Color.fromRGBO(204, 3, 30, 1),
                                                                                        child: Center(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 0.0),
                                                                                            child: Text(
                                                                                              "${lucidLabTest.discount}% Off",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  separatorBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return const Gap(
                                                                        5);
                                                                  },
                                                                )
                                                              : ListView
                                                                  .separated(
                                                                  itemCount:
                                                                      controller
                                                                          .diagnosticHomeTests
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final lucidLabTest =
                                                                        controller
                                                                            .diagnosticHomeTests[index];

                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                                boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4,
                                                                                color: Color.fromRGBO(0, 0, 0, 0.20),
                                                                                offset: Offset(0, 1),
                                                                                spreadRadius: 0,
                                                                              )
                                                                            ]),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            if (lucidLabTest.isAppointmentRequired ==
                                                                                "Y")
                                                                              Container(
                                                                                decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)), color: themeController.textPrimaryColor),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Gap(1.h),
                                                                                    AppText(
                                                                                      "\t*Appointment Required",
                                                                                      fontFamily: AppFont.poppins,
                                                                                      fontSize: 16.sp,
                                                                                      color: themeController.navShadow1,
                                                                                      fontWeight: FontWeight.w300,
                                                                                    ),
                                                                                    const Divider(
                                                                                      color: Color.fromRGBO(196, 196, 196, 1),
                                                                                      thickness: 1,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            Stack(
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: lucidLabTest.isAppointmentRequired == "Y" ? const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)) : BorderRadius.circular(8),
                                                                                    color: themeController.textPrimaryColor,
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(12),
                                                                                        child: AppImageAsset(
                                                                                          image: lucidLabTest.image ?? "",
                                                                                          width: 20.w,
                                                                                          height: 8.h,
                                                                                        ),
                                                                                      ),
                                                                                      Gap(2.w),
                                                                                      Expanded(
                                                                                        child: AppText(
                                                                                          //runesNeeded: true,
                                                                                          lucidLabTest.serviceName ?? "",
                                                                                          fontFamily: AppFont.poppins,
                                                                                          fontSize: 14.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: themeController.black300Color,
                                                                                          maxLines: 3,
                                                                                        ),
                                                                                      ),
                                                                                      Gap(1.w),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              AppText(
                                                                                                "${AppString.cashSymbol}${lucidLabTest.finalMrp?.toStringAsFixed(2) ?? ""}",
                                                                                                fontFamily: AppFont.poppins,
                                                                                                fontSize: 15.sp,
                                                                                                color: themeController.black300Color,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                              Gap(1.w),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  await Get.dialog(ConfirmationDialog(
                                                                                                    message: "Are you sure you want to remove this item from your cart?",
                                                                                                    continueClick: () {
                                                                                                      controller.deleteCartTest(serviceCd: lucidLabTest.serviceCd, hv: homeCollection);
                                                                                                      Get.back();
                                                                                                    },
                                                                                                  ));
                                                                                                },
                                                                                                child: Icon(Icons.close, size: 20, color: themeController.black200Color),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          const Gap(10),
                                                                                          (lucidLabTest.isHealthPackage == "Y")
                                                                                              ? Align(
                                                                                                  child: GestureDetector(
                                                                                                    onTap: () async {
                                                                                                      await healthPackageController.getPackageViewCart(serviceCd: lucidLabTest.serviceCd!).then(
                                                                                                        (value) {
                                                                                                          final packageCartDetails = healthPackageController.healthPackageCartList.value;
                                                                                                          if (packageCartDetails != null && packageCartDetails.healthPackageTypes != null && packageCartDetails.healthPackageTypes!.isNotEmpty) {
                                                                                                            Get.dialog(HealthPackagesDialog(
                                                                                                                cart: true,
                                                                                                                healthPackageCartList: packageCartDetails,
                                                                                                                continueClick: () {
                                                                                                                  Get.back();
                                                                                                                }));
                                                                                                          }
                                                                                                        },
                                                                                                      );
                                                                                                    },
                                                                                                    child: AppText(
                                                                                                      "View All",
                                                                                                      color: themeController.black300Color,
                                                                                                      fontSize: 16.sp,
                                                                                                      fontFamily: AppFont.poppins,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      decoration: TextDecoration.underline,
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                              : const Gap(0)
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                if (lucidLabTest.discount != null && lucidLabTest.discount! > 0)
                                                                                  Positioned(
                                                                                    top: 3,
                                                                                    left: -6,
                                                                                    child: RotationTransition(
                                                                                      turns: const AlwaysStoppedAnimation(-30 / 360),
                                                                                      child: Container(
                                                                                        width: 45,
                                                                                        padding: const EdgeInsets.symmetric(
                                                                                          vertical: 1,
                                                                                        ),
                                                                                        color: const Color.fromRGBO(204, 3, 30, 1),
                                                                                        child: Center(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 0.0),
                                                                                            child: Text(
                                                                                              "${lucidLabTest.discount}% Off",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  separatorBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return const Gap(
                                                                        5);
                                                                  },
                                                                )),
                                                  if (controller
                                                      .isTestDeletingLoading
                                                      .value)
                                                    Positioned(
                                                        right: 0,
                                                        left: 0,
                                                        top: 0,
                                                        bottom: 0,
                                                        child: SizedBox(
                                                            child: Center(
                                                                child: SizedBox(
                                                                    height: 40,
                                                                    width: 40,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: themeController
                                                                          .navShadow1,
                                                                    )))))
                                                ],
                                              ),
                                              Gap(1.h),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        DiagnosisScreen());
                                                  },
                                                  child: AppText(
                                                    "+Add Tests",
                                                    color: themeController.nav1,
                                                    fontFamily: AppFont.poppins,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    // decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                              Gap(2.h),
                                              if (controller
                                                      .testUserDetails.value ==
                                                  null)
                                                Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.rebook.value =
                                                          false;
                                                      sampleCollectionController
                                                          .clearForm();
                                                      Get.to(() =>
                                                          SampleCollectionScreen(
                                                            homeCollection:
                                                                homeCollection ==
                                                                        "1"
                                                                    ? true
                                                                    : false,
                                                          ));
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 6,
                                                          horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        color: themeController
                                                            .navShadow1,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: AppText(
                                                        "Fill Your Details",
                                                        fontFamily:
                                                            AppFont.poppins,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: themeController
                                                            .textPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              Gap(2.h),
                                              AppText(
                                                "Cart Total",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeController.navShadow1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color:
                                              Color.fromRGBO(196, 196, 196, 1),
                                          thickness: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Column(
                                            children: [
                                              buildPriceCalculationRow(
                                                  title: "Order Total(MRP)",
                                                  price:
                                                      "${(controller.diagnosticCartData.value?.data?.totalMrpPriceAmount?.toStringAsFixed(2) ?? 0)}"),
                                              Gap(1.h),
                                              buildPriceCalculationRow(
                                                  title: "Discount Price",
                                                  titleColor:
                                                      themeController.nav1,
                                                  price:
                                                      "${(controller.diagnosticCartData.value?.data?.totalDiscount?.toStringAsFixed(2) ?? 0)}"),
                                              Gap(1.h),
                                              buildPriceCalculationRow(
                                                  title: "Net Amount",
                                                  price:
                                                      "${(controller.diagnosticCartData.value?.data?.totalAmount?.toStringAsFixed(2) ?? 0)}"),
                                              Gap(1.h),
                                              if (homeCollection == "1")
                                                buildPriceCalculationRow(
                                                    title:
                                                        "Home Collection Charges",
                                                    price:
                                                        "${globalController.nonProfessionalCharges.value.toStringAsFixed(2)}"),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color:
                                              Color.fromRGBO(196, 196, 196, 1),
                                          thickness: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: buildPriceCalculationRow(
                                            title: "Total Amount",
                                            price:
                                                "${((controller.diagnosticCartData.value?.data!.totalAmount ?? 0) + ((homeCollection == "1" ? globalController.nonProfessionalCharges.value : 0))).toStringAsFixed(2)}",
                                          ),
                                        ),
                                        const Divider(
                                          color:
                                              Color.fromRGBO(196, 196, 196, 1),
                                          thickness: 1,
                                        ),
                                        Gap(5.h),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              SampleCollectionController
                                                  sampleCollectionController =
                                                  Get.put(
                                                      SampleCollectionController());
                                              if (controller
                                                      .testUserDetails.value !=
                                                  null) {
                                                if (DateTime.parse(controller
                                                        .testUserDetails
                                                        .value!
                                                        .appointmentDate!)
                                                    .isAfter(DateTime.now())) {
                                                  controller.patientId.value =
                                                      controller.testUserDetails
                                                              .value?.id ??
                                                          "";
                                                  controller.homeCollection
                                                      .value = homeCollection;
                                                  logs(
                                                      "user id-->${controller.testUserDetails.value?.id}");

                                                  sampleCollectionController.getRazorPayDataApi(
                                                      (controller
                                                                  .diagnosticCartData
                                                                  .value
                                                                  ?.data
                                                                  ?.totalAmount ??
                                                              0) +
                                                          (homeCollection == "1"
                                                              ? globalController
                                                                  .nonProfessionalCharges
                                                                  .value
                                                              : 0),
                                                      "",
                                                      API.razorpayKey);
                                                } else {
                                                  customFailureToast(
                                                      content:
                                                          "Please enter valid Appointment Date");
                                                }
                                              } else {
                                                customFailureToast(
                                                    content:
                                                        "Please Fill Your Details");
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 65),
                                              decoration: BoxDecoration(
                                                color:
                                                    themeController.navShadow1,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: AppText(
                                                "Click Here to proceed",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                                color: themeController
                                                    .textPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(8.h),
                                      ],
                                    ),
                                  ),
                                  // if (controller.isDiagnosticTestCartLoading.value ||
                                  //     controller
                                  //         .isDiagnosticUSerDetailsLoading.value ||
                                  //     healthPackageController
                                  //         .ishealthPackageCartListLoading.value)
                                  //   Positioned(child: AppLoader())
                                ],
                              )),
          ),
        ],
      ),
    );
  }
}

final ThemeController themeController = Get.find();

Widget buildPriceCalculationRow({
  required String title,
  required String price,
  num? items,
  bool rupeeNeeded = true,
  bool minusNeeded = false,
  Color? priceColor,
  Color? titleColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppText(
        '$title ${items == null ? "" : "($items items)"}',
        color: titleColor ?? themeController.textSecondaryColor,
        fontSize: 15.sp,
      ),
      AppText(
        '${minusNeeded ? "-" : ""} ${rupeeNeeded ? AppString.cashSymbol : ""} $price',
        color: priceColor ?? themeController.black500Color,
        fontSize: 15.sp,
      ),
    ],
  );
}
