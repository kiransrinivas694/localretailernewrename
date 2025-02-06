import 'package:b2c/controllers/global_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/app_loader_new.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/custom_bottom_sheet_dialog.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class TestDescriptionScreen extends StatelessWidget {
  final String image;
  final String serviceId;
  final String title;
  final num finalMrp;
  final num orginMrp;
  final num discount;
  final String description;
  final String? hc;
  final String isAppointmentRequired;
  final String? turnaroundTime;
  final String ishomeCollection;
  final String? helpLine;

  TestDescriptionScreen({
    Key? key,
    required this.image,
    required this.serviceId,
    required this.title,
    required this.finalMrp,
    required this.orginMrp,
    required this.discount,
    required this.description,
    required this.isAppointmentRequired,
    this.helpLine,
    required this.ishomeCollection,
    this.hc,
    this.turnaroundTime,
  }) : super(key: key);

  final LucidController lucidController = Get.put(LucidController());
  final CartLabtestController cartController = Get.put(CartLabtestController());
  final GlobalMainController globalController = Get.put(GlobalMainController());
  final ThemeController themeController = Get.find();
  String stripHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppBar(
          title: "Test Details",
          backgroundColor: themeController.textPrimaryColor,
          isTitleNeeded: true,
        ),
        body: Obx(
          () => (cartController.isTestDeletingLoading.value ||
                  lucidController.isAddCartLoading.value)
              ? Container(
                  margin: const EdgeInsets.all(16),
                  child: AppShimmerEffectView(
                    baseColor: Color.fromARGB(75, 202, 201, 201),
                    height: 100.h,
                    width: double.infinity,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Stack(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 25.h,
                            color: themeController.textPrimaryColor,
                            child: AppImageAsset(
                              image: image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Gap(1.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isAppointmentRequired == "Y")
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: themeController.navShadow1,
                                        size: 20,
                                      ),
                                      AppText(
                                        "*Appointment Required",
                                        fontSize: 17.sp,
                                        fontFamily: AppFont.poppins,
                                        decoration: TextDecoration.underline,
                                        color: const Color.fromRGBO(
                                            65, 103, 95, 1),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              Gap(3.h),
                              AppText(
                                title,
                                fontSize: 17.sp,
                                fontFamily: AppFont.poppins,
                                color: themeController.black300Color,
                                fontWeight: FontWeight.w500,
                              ),
                              Gap(1.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  discount == 0
                                      ? AppText(
                                          "M.R.P: ${AppString.cashSymbol}${orginMrp.toStringAsFixed(2)}/-",
                                          color: themeController.black500Color,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17.sp,
                                          fontFamily: AppFont.poppins,
                                        )
                                      : Row(
                                          children: [
                                            AppText(
                                              "${AppString.cashSymbol}${finalMrp.toStringAsFixed(2)}/-",
                                              color:
                                                  themeController.black500Color,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17.sp,
                                              fontFamily: AppFont.poppins,
                                            ),
                                            const Gap(4),
                                            AppText(
                                              "M.R.P:",
                                              color: themeController
                                                  .textSecondaryColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.sp,
                                              fontFamily: AppFont.poppins,
                                            ),
                                            // const Gap(4),
                                            AppText(
                                              "${AppString.cashSymbol}${orginMrp.toStringAsFixed(2)}/-",
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: themeController
                                                  .textSecondaryColor,
                                              fontSize: 16.sp,
                                              fontFamily: AppFont.poppins,
                                            ),
                                          ],
                                        ),
                                  Obx(
                                    () {
                                      String cartHv = "";
                                      bool isInCart = cartController
                                          .diagnosticCartTests
                                          .any((test) {
                                        if (test.serviceCd == serviceId) {
                                          cartHv = test.hv ?? '';
                                        }
                                        return test.serviceCd == serviceId;
                                      });
                                      bool isInHomeCart = cartController
                                          .diagnosticHomeTests
                                          .any((test) {
                                        if (test.serviceCd == serviceId) {
                                          cartHv = test.hv ?? '';
                                        }
                                        return test.serviceCd == serviceId;
                                      });
                                      return Column(
                                        children: [
                                          (hc == "0"
                                                  ? !(isInCart && cartHv == hc)
                                                  : !(isInHomeCart &&
                                                      cartHv == hc))
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if ((hc == "0")
                                                        ? isInHomeCart &&
                                                            cartHv != hc
                                                        : isInCart &&
                                                            cartHv != hc) {
                                                      print("alreadyt added");
                                                      customFailureToast(
                                                          content:
                                                              "Test already added in cart from ${hc == '0' ? "Home sample collections" : "Find lab tests"}");
                                                      return;
                                                    }
                                                    if (isAppointmentRequired ==
                                                        "Y") {
                                                      CustomBottomSheet.show(
                                                          context,
                                                          helpLine:
                                                              helpLine ?? "",
                                                          continueClick: () {
                                                        cartController
                                                            .getTestUserDetails(
                                                                isHomeCollection:
                                                                    hc == '1'
                                                                        ? '1'
                                                                        : '0');
                                                        if (!isInCart) {
                                                          lucidController
                                                              .getAddTest(
                                                                  serviceCd:
                                                                      serviceId,
                                                                  serviceName:
                                                                      title,
                                                                  imageUrl:
                                                                      image,
                                                                  discount:
                                                                      discount,
                                                                  finalMrp:
                                                                      finalMrp,
                                                                  mrpPrice:
                                                                      orginMrp,
                                                                  hv: hc ?? "",
                                                                  isAppointmentRequired:
                                                                      isAppointmentRequired,
                                                                  isHealthPackage:
                                                                      'N')
                                                              .then(
                                                            (value) {
                                                              cartController
                                                                  .getDiagnosticCartData(
                                                                      homeCollection:
                                                                          hc ??
                                                                              "");
                                                            },
                                                          );
                                                        }
                                                        Get.back();
                                                      });
                                                    } else if (hc == "0"
                                                        ? !isInCart
                                                        : !isInHomeCart) {
                                                      cartController
                                                          .getTestUserDetails(
                                                              isHomeCollection:
                                                                  hc == '1'
                                                                      ? '1'
                                                                      : '0');
                                                      lucidController
                                                          .getAddTest(
                                                              serviceCd:
                                                                  serviceId,
                                                              serviceName:
                                                                  title,
                                                              imageUrl: image,
                                                              discount:
                                                                  discount,
                                                              finalMrp:
                                                                  finalMrp,
                                                              mrpPrice:
                                                                  orginMrp,
                                                              hv: hc ?? "",
                                                              isAppointmentRequired:
                                                                  isAppointmentRequired,
                                                              isHealthPackage:
                                                                  'N')
                                                          .then(
                                                        (value) {
                                                          cartController
                                                              .getDiagnosticCartData(
                                                                  homeCollection:
                                                                      hc ?? "");
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 6,
                                                        horizontal: 10),
                                                    //   width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: themeController
                                                          .customColors
                                                          .navShadow1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.shopping_cart,
                                                          color: themeController
                                                              .textPrimaryColor,
                                                          size: 14,
                                                        ),
                                                        const Gap(8),
                                                        AppText(
                                                          'Add to Cart',
                                                          color: themeController
                                                              .textPrimaryColor,
                                                          fontSize: 14.sp,
                                                          fontFamily:
                                                              AppFont.poppins,
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                              : GestureDetector(
                                                  onTap: () {
                                                    if (hc == "0"
                                                        ? isInCart
                                                        : isInHomeCart) {
                                                      cartController
                                                          .deleteCartTest(
                                                              serviceCd:
                                                                  serviceId,
                                                              hv: hc);
                                                      print(
                                                          'sravan sainedi$hc');
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 6,
                                                        horizontal: 10),
                                                    // width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: themeController
                                                              .navShadow1),
                                                      color: themeController
                                                          .customColors
                                                          .textPrimaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Gap(8),
                                                        AppText(
                                                          'Added to Cart',
                                                          color: themeController
                                                              .black300Color,
                                                          fontSize: 14.sp,
                                                          fontFamily:
                                                              AppFont.poppins,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          const Gap(5),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Gap(1.h),
                              if (discount != 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  color: themeController.nav1,
                                  child: AppText(
                                    '$discount% OFF',
                                    fontSize: 14.sp,
                                    fontFamily: AppFont.poppins,
                                    color: themeController.black400Color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              Gap(2.h),
                              (turnaroundTime == null ||
                                      turnaroundTime!.isEmpty)
                                  ? Gap(0)
                                  : Row(
                                      children: [
                                        SizedBox(
                                          height: 3.h,
                                          child: const AppImageAsset(
                                            image:
                                                "assets/images/lab_report_times.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Gap(5),
                                        AppText(
                                          "Report results within $turnaroundTime",
                                          fontSize: 15.sp,
                                          fontFamily: AppFont.poppins,
                                          color: themeController.black300Color,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                              Gap(16),
                              if (ishomeCollection == "Y" && hc == "1")
                                Row(
                                  children: [
                                    AppText(
                                      'Home Collection Charges  ',
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 14,
                                    ),
                                    Obx(
                                      () => Text(
                                        // '₹${globalController.isProfessional.value ? '${globalController.professionalCharges.value}' : '${globalController.nonProfessionalCharges.value}'}',
                                        '₹${globalController.nonProfessionalCharges.value}',
                                        style: GoogleFonts.mitr(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              Gap(2.h),
                              AppText(
                                "Description:",
                                fontSize: 18.sp,
                                fontFamily: AppFont.poppins,
                                color: themeController.black300Color,
                                fontWeight: FontWeight.w600,
                              ),
                              Divider(
                                color: themeController.black300Color,
                                thickness: 1,
                              ),
                              AppText(
                                stripHtmlTags(description),
                                fontSize: 16.sp,
                                fontFamily: AppFont.poppins,
                                color: themeController.black300Color,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (discount > 0 && discount != 0)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const AppImageAsset(
                                image: 'assets/images/offer_circle.png',
                                width: 40,
                              ),
                              AppText(
                                '$discount%\nOff',
                                fontSize: 11.sp,
                                color: Colors.white,
                                fontFamily: AppFont.poppins,
                              ),
                            ],
                          ),
                        ),
                    ]),
                  ),
                ),
        ),
      ),
    );
  }
}
