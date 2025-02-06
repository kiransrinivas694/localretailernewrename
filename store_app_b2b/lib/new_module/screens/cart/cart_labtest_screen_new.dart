import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/app_loader_new.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/screens/cart/diagnosis_cart_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class CartLabTestScreen extends StatelessWidget {
  CartLabTestScreen({super.key});
  final GlobalMainController globalController = Get.put(GlobalMainController());
  final ThemeController themeController = Get.find();
  final HealthPackageController healthPackageController =
      Get.put(HealthPackageController());
  CartLabtestController controller = Get.put(CartLabtestController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLabtestController>(
      initState: (state) {
        if (controller.activeTestCartTab.value == 0) {
          controller.getDiagnosticCartData(homeCollection: "0");
          controller.getTestUserDetails(isHomeCollection: "0");
        } else {
          controller.getDiagnosticCartData(homeCollection: "1");
          controller.getTestUserDetails(isHomeCollection: "1");
        }
      },
      builder: (controller) {
        return Stack(
          children: [
            Obx(
              () => Column(
                children: [
                  controller.isDiagnosticTestCartLoading.value ||
                          controller.isDiagnosticUSerDetailsLoading.value
                      ? Row(
                          children: [
                            Gap(5.w),
                            Expanded(
                              child: AppShimmerEffectView(
                                //borderRadius: 24,
                                height: 5.h,
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: AppShimmerEffectView(
                                // borderRadius: 24,
                                height: 5.h,
                              ),
                            ),
                            const Gap(10),
                          ],
                        )
                      : Row(
                          children: [
                            Gap(5.w),
                            Expanded(
                              child: Obx(
                                () => TestsButton(
                                  onTap: () {
                                    controller.activeTestCartTab.value = 0;

                                    controller.getDiagnosticCartData(
                                        homeCollection: '0');
                                    controller.getTestUserDetails(
                                        isHomeCollection: "0");
                                  },
                                  buttonHeight: 5.h,
                                  textAlign: TextAlign.center,
                                  title:
                                      "Lab Tests${controller.diagnosticCartTests.isNotEmpty ? '(${controller.diagnosticCartTests.length})' : ""}",
                                  titleColor: controller
                                              .activeTestCartTab.value ==
                                          0
                                      ? Colors.white
                                      : const Color.fromRGBO(65, 103, 95, 1),
                                  backgroundColor: controller
                                              .activeTestCartTab.value ==
                                          0
                                      ? const Color.fromRGBO(81, 115, 108, 1)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(65, 103, 95, 1)),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                                child: Obx(
                              () => TestsButton(
                                onTap: () {
                                  controller.activeTestCartTab.value = 1;
                                  controller.getDiagnosticCartData(
                                      homeCollection: '1');
                                  controller.getTestUserDetails(
                                      isHomeCollection: "1");
                                },
                                buttonHeight: 5.h,
                                textAlign: TextAlign.center,
                                title:
                                    "Home Sample Collections${controller.diagnosticHomeTests.isNotEmpty ? '(${controller.diagnosticHomeTests.length})' : ""}",
                                titleColor:
                                    controller.activeTestCartTab.value == 1
                                        ? Colors.white
                                        : const Color.fromRGBO(65, 103, 95, 1),
                                backgroundColor:
                                    controller.activeTestCartTab.value == 1
                                        ? const Color.fromRGBO(81, 115, 108, 1)
                                        : Colors.transparent,
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(65, 103, 95, 1)),
                              ),
                            )),
                            const Gap(16),
                          ],
                        ),
                  const Gap(10),
                  Obx(
                    () => controller.activeTestCartTab.value == 0
                        ? Expanded(
                            child: DiagnosticCartScreen(
                            homeCollection: "0",
                          ))
                        : Expanded(
                            child: DiagnosticCartScreen(
                              homeCollection: "1",
                            ),
                          ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

ThemeController themeController = ThemeController();

class TestsButton extends StatelessWidget {
  const TestsButton(
      {super.key,
      this.title = "Continue",
      this.paddingBottom = 0,
      this.paddingLeft = 0,
      this.paddingRight = 0,
      this.paddingTop = 0,
      this.buttonWidth,
      this.buttonHeight,
      this.backgroundColor,
      this.borderRadius = 4,
      this.onTap,
      this.boxShadow,
      this.titleColor,
      this.decorationColor,
      this.border,
      this.fontSize,
      this.textAlign,
      this.maxLines});

  final String title;
  final double paddingTop;
  final double paddingRight;
  final double paddingLeft;
  final double paddingBottom;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? decorationColor;
  final BoxBorder? border;
  final double borderRadius;
  final VoidCallback? onTap;
  final BoxShadow? boxShadow;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
              color: backgroundColor ?? themeController.nav1,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
              boxShadow: boxShadow == null ? null : [boxShadow!]),
          padding: EdgeInsets.only(
              top: paddingTop,
              right: paddingRight,
              left: paddingLeft,
              bottom: paddingBottom),
          child: Center(
            child: AppText(
              title,
              textAlign: textAlign,
              maxLines: maxLines,
              fontWeight: FontWeight.w500,
              fontSize: fontSize ?? 15.sp,
              color: titleColor ?? themeController.textSecondaryColor,
              // decoration: TextDecoration.underline,
              decorationColor: decorationColor,
            ),
          )),
    );
  }
}
