import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller_new.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller_new.dart';
import 'package:store_app_b2b/new_module/model/lucid/health_package/health_package_model_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/health_package/package_detail_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/sample_collection_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/custom_bottom_sheet_dialog_new.dart';
import 'package:store_app_b2b/new_module/snippets/snippets_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_search_box_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class HealthCheckUp extends StatefulWidget {
  HealthCheckUp({
    super.key,
    required this.appBarTitle,
  });
  final String appBarTitle;
  @override
  State<HealthCheckUp> createState() => _HealthCheckUpState();
}

class _HealthCheckUpState extends State<HealthCheckUp> {
  HealthPackageController healthPackageController =
      Get.put(HealthPackageController());
  LucidController lucidController = Get.put(LucidController());
  final CartLabtestController cartController = Get.put(CartLabtestController());
  SampleCollectionController sampleCollectionController =
      Get.put(SampleCollectionController());

  final bool homeCollection = false;
  @override
  void initState() {
    HealthPackageController healthPackageController =
        Get.put(HealthPackageController());
    healthPackageController.packageSearchController.clear();
    healthPackageController.showSuffixForSearchPackageController.call(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealthPackageController>(initState: (state) {
      HealthPackageController healthPackageController =
          Get.put(HealthPackageController());
      healthPackageController.getAllHealthPackagesData();
    }, builder: (healthPackageController) {
      return Scaffold(
        appBar: AppAppBar(
          title: 'Health Packages',
          isTitleNeeded: true,
          backgroundColor: themeController.textPrimaryColor,
        ),
        body: Obx(
          () => Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    AppSearchBox(
                      showSuffixIcon: healthPackageController
                          .showSuffixForSearchPackageController.value,
                      onSuffixIconTap: () {
                        healthPackageController.packageSearchController.text =
                            "";
                        healthPackageController.healthPackageCurrentPage.value =
                            0;
                        healthPackageController.healthPackagePageSize.value = 8;
                        healthPackageController.healthPackageTotalPages.value =
                            0;
                        healthPackageController.getAllHealthPackagesData(
                          searchText: "",
                        );

                        healthPackageController
                            .showSuffixForSearchPackageController.value = false;
                      },
                      textEditingController:
                          healthPackageController.packageSearchController,
                      onChange: (value) {
                        healthPackageController.healthPackageCurrentPage.value =
                            0;
                        healthPackageController.healthPackagePageSize.value = 8;
                        healthPackageController.healthPackageTotalPages.value =
                            0;
                        healthPackageController.getAllHealthPackagesData(
                          searchText: value,
                        );
                        healthPackageController
                            .showSuffixForSearchPackageController
                            .value = value.isNotEmpty;
                      },
                    ),
                    const Gap(15),
                    Obx(
                      () => healthPackageController.isHealthPackageLoading.value
                          ? Expanded(
                              child: SizedBox(
                                  height: 100.h,
                                  child: verticalShimmerGridView()),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is ScrollEndNotification &&
                                    notification.metrics.extentAfter == 0) {
                                  logs("listener lis");
                                  if (healthPackageController
                                          .isHealthMorePackageLoading.value ||
                                      healthPackageController
                                          .isHealthPackageLoading.value) {
                                    return false;
                                  }

                                  healthPackageController
                                      .getAllHealthPackagesData(
                                    loadMore: true,
                                  );
                                }
                                return false;
                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      AlignedGridView.count(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 10,
                                        itemCount: healthPackageController
                                            .packageDetails.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          BasicHealthPackageModel
                                              healthPackageData =
                                              healthPackageController
                                                  .packageDetails[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Get.to(() => PackageDetailsScreen(
                                                    packageId:
                                                        healthPackageData.id ??
                                                            "",
                                                  ));
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: themeController
                                                    .textPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 4,
                                                    spreadRadius: 0,
                                                    offset: Offset(0, 0),
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.25),
                                                  )
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 14.h,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                    context)
                                                                .width,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          12)),
                                                          child: AppImageAsset(
                                                            image:
                                                                healthPackageData
                                                                    .image,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            AppText(
                                                              //runesNeeded: true,
                                                              "${healthPackageData.packageName}",
                                                              color: themeController
                                                                  .black500Color,
                                                              fontSize: 10,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontFamily:
                                                                  AppFont
                                                                      .poppins,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            Gap(5),
                                                            AppText(
                                                              "MRP ${AppString.cashSymbol}${healthPackageData.finalMrp!.toStringAsFixed(2)}/-",
                                                              color: themeController
                                                                  .black500Color,
                                                              fontSize: 14.sp,
                                                              fontFamily:
                                                                  AppFont
                                                                      .poppins,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Obx(() {
                                                    bool isInCart = homeCollection
                                                        ? cartController
                                                            .diagnosticHomeTests
                                                            .any((test) =>
                                                                test.serviceCd ==
                                                                healthPackageData
                                                                    .serviceCd)
                                                        : cartController
                                                            .diagnosticCartTests
                                                            .any((test) =>
                                                                test.serviceCd ==
                                                                healthPackageData
                                                                    .serviceCd);
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        if (healthPackageData
                                                                .isAppointmentRequired ==
                                                            "Y") {
                                                          CustomBottomSheet
                                                              .show(context,
                                                                  helpLine: "",
                                                                  continueClick:
                                                                      () {
                                                            if (isInCart) {
                                                            } else {
                                                              cartController
                                                                  .getTestUserDetails(
                                                                      isHomeCollection:
                                                                          '0');
                                                              lucidController
                                                                  .getAddTest(
                                                                      serviceCd:
                                                                          healthPackageData
                                                                              .serviceCd!,
                                                                      serviceName:
                                                                          healthPackageData
                                                                              .packageName!,
                                                                      imageUrl: healthPackageData
                                                                          .image!,
                                                                      discount:
                                                                          healthPackageData
                                                                              .discount!,
                                                                      mrpPrice:
                                                                          healthPackageData
                                                                              .finalMrp!,
                                                                      finalMrp:
                                                                          healthPackageData
                                                                              .finalMrp!,
                                                                      hv: "0",
                                                                      isHealthPackage:
                                                                          "Y",
                                                                      isAppointmentRequired:
                                                                          healthPackageData.isAppointmentRequired ??
                                                                              "")
                                                                  .then(
                                                                (value) {
                                                                  cartController
                                                                      .getDiagnosticCartData(
                                                                          homeCollection:
                                                                              '0');
                                                                },
                                                              );
                                                            }
                                                          });
                                                        } else if (!isInCart) {
                                                          cartController
                                                              .getTestUserDetails(
                                                                  isHomeCollection:
                                                                      '0');
                                                          lucidController
                                                              .getAddTest(
                                                                  serviceCd: healthPackageData
                                                                      .serviceCd!,
                                                                  serviceName:
                                                                      healthPackageData
                                                                          .packageName!,
                                                                  imageUrl:
                                                                      healthPackageData
                                                                          .image!,
                                                                  discount:
                                                                      healthPackageData
                                                                          .discount!,
                                                                  mrpPrice:
                                                                      healthPackageData
                                                                          .finalMrp!,
                                                                  finalMrp:
                                                                      healthPackageData
                                                                          .finalMrp!,
                                                                  hv: "0",
                                                                  isHealthPackage:
                                                                      "Y",
                                                                  isAppointmentRequired:
                                                                      healthPackageData
                                                                              .isAppointmentRequired ??
                                                                          "")
                                                              .then(
                                                            (value) {
                                                              cartController
                                                                  .getDiagnosticCartData(
                                                                      homeCollection:
                                                                          '0');
                                                            },
                                                          );
                                                        }
                                                      },
                                                      child: !isInCart
                                                          ? Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6,
                                                                  horizontal:
                                                                      10),
                                                              //   width: double.infinity,
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: themeController
                                                                    .customColors
                                                                    .navShadow1,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .shopping_cart,
                                                                    color: themeController
                                                                        .textPrimaryColor,
                                                                    size: 14,
                                                                  ),
                                                                  Gap(8),
                                                                  AppText(
                                                                    'Add to Cart',
                                                                    color: themeController
                                                                        .textPrimaryColor,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        AppFont
                                                                            .poppins,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                if (isInCart) {
                                                                  cartController.deleteCartTest(
                                                                      serviceCd:
                                                                          healthPackageData
                                                                              .serviceCd,
                                                                      hv: homeCollection
                                                                          ? "1"
                                                                          : "0");
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        12),
                                                                // width: double.infinity,
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: themeController
                                                                          .navShadow1),
                                                                  color: themeController
                                                                      .customColors
                                                                      .textPrimaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    // const Gap(8),
                                                                    AppText(
                                                                      'Added to Cart',
                                                                      color: themeController
                                                                          .black300Color,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontFamily:
                                                                          AppFont
                                                                              .poppins,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Gap(8.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    if (healthPackageController
                        .isHealthMorePackageLoading.value)
                      CircularProgressIndicator()
                  ],
                ),
              ),
              if (homeCollection
                  ? cartController.diagnosticHomeTests.isNotEmpty
                  : cartController.diagnosticCartTests.isNotEmpty)
                Positioned(
                  bottom: 25,
                  right: 18,
                  width: 90.w,
                  child: GestureDetector(
                      onTap: () {
                        cartController.rebook.value = false;
                        sampleCollectionController.clearForm();
                        Get.to(() =>
                            SampleCollectionScreen(homeCollection: false));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: themeController.nav1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cartController.diagnosticCartTests.length == 1
                                ? Expanded(
                                    child: AppText(
                                      "${homeCollection ? cartController.diagnosticHomeTests.length : cartController.diagnosticCartTests.length} Test Added",
                                      color: themeController.textPrimaryColor,
                                      fontFamily: AppFont.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Expanded(
                                    child: AppText(
                                      "${homeCollection ? cartController.diagnosticHomeTests.length : cartController.diagnosticCartTests.length} Tests Added",
                                      color: themeController.textPrimaryColor,
                                      fontFamily: AppFont.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                            Row(
                              children: [
                                cartController
                                        .isDiagnosticUSerDetailsLoading.value
                                    ? AppText(
                                        "Loading....    ",
                                        color: themeController.textPrimaryColor,
                                        fontFamily: AppFont.poppins,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w300,
                                      )
                                    : cartController.testUserDetails.value ==
                                            null
                                        ? AppText(
                                            "Fill the details",
                                            color: themeController
                                                .textPrimaryColor,
                                            fontFamily: AppFont.poppins,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300,
                                          )
                                        : AppText(
                                            " View details",
                                            color: themeController
                                                .textPrimaryColor,
                                            fontFamily: AppFont.poppins,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
                                Icon(
                                  Icons.chevron_right,
                                  color: themeController.textPrimaryColor,
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              if (cartController.isTestDeletingLoading.value ||
                  lucidController.isAddCartLoading.value)
                Positioned(
                  right: 0,
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 5,
                    width: 5,
                    child: AppLoader(),
                  ),
                ),
            ],
          ),
        ),

        // bottomNavigationBar: AppBottomBar(
        //   index: 2,
        //   useIndexFromController: false,
        // ),
      );
    });
  }
}
