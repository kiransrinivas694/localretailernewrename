import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/app_loader_new.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller_new.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller.dart';
import 'package:store_app_b2b/new_module/model/lucid/health_package/health_packagedetails_model.dart';
import 'package:store_app_b2b/new_module/model/lucid/health_package/view_healthpackage_model.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/custom_bottom_sheet_dialog.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

import '../../controllers/theme/theme_controller.dart';

class HealthPackagesDialog extends StatelessWidget {
  HealthPackagesDialog({
    super.key,
    required this.cart,
    required this.continueClick,
    this.healthPackageList,
    this.healthPackageCartList,
  });

  final VoidCallback continueClick;
  final bool cart;
  final BasicPackageDetails? healthPackageList;
  final BasicPackageCartDetails? healthPackageCartList;
  final ThemeController themeController = Get.find();
  final HealthPackageController packagedetailsController =
      Get.put(HealthPackageController());
  LucidController lucidController = Get.put(LucidController());
  final CartLabtestController cartController = Get.put(CartLabtestController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // constraints: BoxConstraints(maxHeight: 80.h),
          height: 50.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10, right: 5),
                width: double.infinity,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6),
                            child: AppText(
                              cart
                                  ? '${healthPackageCartList?.packageName}'
                                  : '${healthPackageList?.packageName}',
                              color: themeController.navShadow1,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                            ),
                          ),
                          // const Gap(0),
                          Divider(
                            color: const Color.fromRGBO(196, 196, 196, 1),
                            thickness: 1.px,
                          ),
                          //  const Gap(0),
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cart
                                      ? healthPackageCartList
                                          ?.healthPackageTypes?.length
                                      : healthPackageList
                                          ?.healthPackageTypes?.length,
                                  itemBuilder: (context, index) {
                                    final cartPackageType =
                                        healthPackageCartList
                                            ?.healthPackageTypes![index];
                                    final packageType = healthPackageList
                                        ?.healthPackageTypes![index];

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            cart
                                                ? '${cartPackageType?.packageType}'
                                                : '${packageType?.packageType}',
                                            color:
                                                themeController.black300Color,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppFont.poppins,
                                            fontSize: 17.sp,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: cart
                                                ? cartPackageType
                                                    ?.testNames?.length
                                                : packageType
                                                    ?.testNames?.length,
                                            itemBuilder: (context, subIndex) {
                                              int? value = packageType
                                                  ?.testNames?.length;
                                              print(
                                                  "length of  packe tests$value");

                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 6),
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      cart
                                                          ? "${cartPackageType?.testNames![subIndex]}"
                                                          : "${packageType!.testNames![subIndex]}",
                                                      color:
                                                          const Color.fromRGBO(
                                                              54, 62, 60, 1),
                                                      fontSize: 16.sp,
                                                      fontFamily:
                                                          AppFont.poppins,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          cart
                              ? SizedBox()
                              : Obx(() {
                                  bool isInCart = cartController
                                      .diagnosticCartTests
                                      .any((test) =>
                                          test.serviceCd ==
                                          packagedetailsController
                                              .healthPackageList
                                              .value
                                              ?.serviceCd!);
                                  return GestureDetector(
                                    onTap: () async {
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
                                          {
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
                                                    mrpPrice:
                                                        packagedetailsController
                                                            .healthPackageList
                                                            .value!
                                                            .finalMrp!,
                                                    finalMrp:
                                                        packagedetailsController
                                                            .healthPackageList
                                                            .value!
                                                            .finalMrp!,
                                                    hv: '0',
                                                    isAppointmentRequired:
                                                        packagedetailsController
                                                                .healthPackageList
                                                                .value!
                                                                .isAppointmentRequired ??
                                                            "N",
                                                    isHealthPackage: "Y")
                                                .then(
                                              (value) {
                                                cartController
                                                    .getDiagnosticCartData(
                                                        homeCollection: "0");
                                              },
                                            );
                                          }
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
                                                finalMrp:
                                                    packagedetailsController
                                                        .healthPackageList
                                                        .value!
                                                        .finalMrp!,
                                                hv: '0',
                                                isAppointmentRequired:
                                                    packagedetailsController
                                                            .healthPackageList
                                                            .value!
                                                            .isAppointmentRequired ??
                                                        "N",
                                                isHealthPackage: "Y")
                                            .then(
                                          (value) {
                                            cartController
                                                .getDiagnosticCartData(
                                                    homeCollection: "0");
                                          },
                                        );
                                      }
                                    },
                                    child: !isInCart
                                        ? Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    65, 103, 95, 1),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: AppText(
                                              "Book Now @${packagedetailsController.totalTests} lab tests \t\t@${AppString.cashSymbol}${packagedetailsController.healthPackageList.value?.finalMrp?.toStringAsFixed(2)}/-",
                                              textAlign: TextAlign.center,
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
                                              width: double.infinity,
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: themeController
                                                          .navShadow1),
                                                  color: themeController
                                                      .textPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: AppText(
                                                "Added to Cart",
                                                color:
                                                    themeController.navShadow1,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                  );
                                })
                        ],
                      ),
                      if (cartController.isTestDeletingLoading.value ||
                          lucidController.isAddCartLoading.value)
                        Positioned(
                            right: 0,
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: SizedBox(
                                height: 5, width: 5, child: AppLoader()))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
