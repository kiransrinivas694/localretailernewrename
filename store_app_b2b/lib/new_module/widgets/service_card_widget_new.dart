import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/custom_bottom_sheet_dialog_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class ServiceCardWidget extends StatelessWidget {
  ServiceCardWidget(
      {super.key,
      this.productDiscountPrice,
      required this.productSellingPrice,
      required this.productTitle,
      required this.imageUrl,
      this.containerHeight,
      this.containerWidth,
      this.index = 0,
      this.discount = 0,
      this.offerTagNeed = false,
      this.offerTitle = "",
      required this.onAddToCartTap,
      required this.themeController,
      required this.onTap,
      required this.serviceId,
      required this.isAppointmentRequired,
      this.hc});

  final String productTitle;
  final String serviceId;
  final num? productDiscountPrice;
  final num? productSellingPrice;

  final double? containerWidth;
  final double? containerHeight;
  final int index;
  final String? hc;
  final ThemeController themeController;
  final num discount;
  final bool offerTagNeed;
  final String offerTitle;
  final String imageUrl;
  final String isAppointmentRequired;

  final VoidCallback onTap;

  final VoidCallback onAddToCartTap;

  CartLabtestController cltController = Get.find();
  final LucidController lucidController = Get.put(LucidController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        String cartHv = "";
        bool isInCart = cltController.diagnosticCartTests.any((test) {
          logs("test ids ${test.serviceCd}");
          logs("posted service id $serviceId");
          if (test.serviceCd == serviceId) {
            cartHv = test.hv ?? '';
          }
          return test.serviceCd == serviceId;
        });
        bool isInHomeCart = cltController.diagnosticHomeTests.any((test) {
          if (test.serviceCd == serviceId) {
            cartHv = test.hv ?? '';
          }
          return test.serviceCd == serviceId;
        });
        print('cartHv -> $cartHv');
        logs('cartHv -> $isInCart');

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: themeController.textPrimaryColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                  color: Color.fromRGBO(152, 152, 152, 0.25),
                ),
              ],
              border: Border.all(
                color: themeController.nav5,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: AppImageAsset(
                              image: imageUrl.isEmpty
                                  ? 'assets/images/mri-scan.png'
                                  : imageUrl,
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Gap(15),
                          AppText(
                            productTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            color: themeController.black500Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            fontFamily: AppFont.poppins,
                          ),
                          const Gap(4),
                          discount == 0
                              ? (AppText(
                                  "${AppString.cashSymbol}${productSellingPrice == null ? 0 : productSellingPrice?.toStringAsFixed(2)}/-",
                                  color: themeController.black500Color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  fontFamily: AppFont.poppins,
                                ))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AppText(
                                          "M.R.P:",
                                          color: themeController
                                              .textSecondaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          fontFamily: AppFont.poppins,
                                        ),
                                        AppText(
                                          "${AppString.cashSymbol}${productSellingPrice == null ? 0 : productSellingPrice?.toStringAsFixed(2)}/-",
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: themeController
                                              .textSecondaryColor,
                                          fontSize: 14.sp,
                                          fontFamily: AppFont.poppins,
                                        ),
                                      ],
                                    ),
                                    const Gap(4),
                                    AppText(
                                      "${AppString.cashSymbol}${productDiscountPrice == null ? 0 : productDiscountPrice?.toStringAsFixed(2)}/-",
                                      color: themeController.black500Color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      fontFamily: AppFont.poppins,
                                    ),
                                  ],
                                ),
                          const Gap(8),
                        ],
                      ),
                      (hc == "0"
                              ? !(isInCart && cartHv == hc)
                              : !(isInHomeCart && cartHv == hc))
                          ? GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      themeController.customColors.navShadow1,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: themeController.textPrimaryColor,
                                      size: 14,
                                    ),
                                    const Gap(8),
                                    AppText(
                                      'Add to Cart',
                                      color: themeController.textPrimaryColor,
                                      fontSize: 14.sp,
                                      fontFamily: AppFont.poppins,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                //mysaa commented
                                //bool isUserIn = await isUserLogged();

                                // if (isUserIn) {
                                logs("is in cart -> $isInCart");
                                if ((hc == "0")
                                    ? isInHomeCart && cartHv != hc
                                    : isInCart && cartHv != hc) {
                                  print("alreadyt added");
                                  customFailureToast(
                                      content:
                                          "Test already added in cart from ${hc == '0' ? "Home sample collections" : "Find lab tests"}");
                                  return;
                                }
                                if (isAppointmentRequired == "Y") {
                                  CustomBottomSheet.show(
                                    context,
                                    helpLine: lucidController
                                            .scanServices[index]
                                            .helpLineNumber ??
                                        "",
                                    continueClick: () {
                                      cltController.getTestUserDetails(
                                          isHomeCollection:
                                              hc == '1' ? '1' : '0');
                                      if (!isInCart) {
                                        lucidController
                                            .getAddTest(
                                                serviceCd: serviceId,
                                                serviceName: productTitle,
                                                imageUrl: imageUrl,
                                                discount: discount,
                                                finalMrp:
                                                    productDiscountPrice ?? 0,
                                                mrpPrice:
                                                    productSellingPrice ?? 0,
                                                hv: hc ?? "",
                                                isAppointmentRequired:
                                                    isAppointmentRequired,
                                                isHealthPackage: 'N')
                                            .then(
                                          (value) {
                                            cltController.getDiagnosticCartData(
                                                homeCollection: hc ?? "");
                                          },
                                        );
                                      }
                                      Get.back();
                                    },
                                  );
                                } else if (!isInCart) {
                                  logs(
                                      "cart checking-->${cltController.diagnosticCartTests}");
                                  onAddToCartTap();
                                }
                                // }
                                // else {
                                //   //mysaa commented
                                //   // Get.to(() => const AskLoginScreen());
                                // }
                              },
                            )
                          : GestureDetector(
                              onTap: () {
                                if (hc == "0" ? isInCart : isInHomeCart) {
                                  cltController.deleteCartTest(
                                      serviceCd: serviceId, hv: hc);
                                  print('sravan sainedi$hc');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: themeController.navShadow1),
                                  color: themeController
                                      .customColors.textPrimaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Gap(8),
                                    AppText(
                                      'Added to Cart',
                                      color: themeController.black300Color,
                                      fontSize: 14.sp,
                                      fontFamily: AppFont.poppins,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                if (discount != 0)
                  Positioned(
                    top: 10,
                    left: -31,
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(-30 / 360),
                      child: Container(
                        width: 100,
                        // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 32.0),
                        color: const Color.fromRGBO(204, 3, 30, 1),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "$discount% OFF",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
