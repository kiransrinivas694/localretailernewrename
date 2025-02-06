import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller_new.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/book_scan_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/find_test_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/findlocation/find_location_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/health_package/health_package_screen_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class DiagnosisScreen extends StatelessWidget {
  final ThemeController themeController = Get.find();

  DiagnosisScreen({super.key});
  final List<DiagnosisList> diagnosisItems = [
    DiagnosisList(
        title: 'Find Lab Tests',
        imgUrl: 'assets/images/diagnopic_1.png',
        onTap: (LucidController controller) {
          controller.getAllLucidData(hc: "N");
          Get.to(() => const FindTestScreen(
                appBarTitle: "Find Lab Tests",
                typesNeeded: false,
              ));
        }),
    DiagnosisList(
        title: 'Home Sample\nCollections',
        imgUrl: 'assets/images/diagnopic_2.png',
        onTap: (LucidController controller) {
          controller.getAllLucidData(hc: "Y");
          Get.to(() => const FindTestScreen(
                appBarTitle: "Home Sample Collection",
                typesNeeded: true,
              ));
        }),
    DiagnosisList(
        title: 'Book a scan',
        imgUrl: 'assets/images/diagnopic_3.png',
        onTap: (LucidController controller) {
          controller.getlucidByDepartment();
          Get.to(() => const BookScanScreen(
                appBarTitle: "Book a scan",
              ));
        }),
    DiagnosisList(
        title: 'Health Packages',
        imgUrl: 'assets/images/diagnopic_4.png',
        onTap: (controller) {
          HealthPackageController healthPackageController =
              Get.put(HealthPackageController());
          healthPackageController.getAllHealthPackagesData();
          CartLabtestController cartController =
              Get.put(CartLabtestController());
          cartController.getDiagnosticCartData(homeCollection: '0');
          Get.to(() => HealthCheckUp(
                appBarTitle: "",
              ));
        }),
    DiagnosisList(
        title: 'Find Locations',
        imgUrl: 'assets/images/diagnopic_5.png',
        onTap: (LucidController controller) {
          controller.getAllBranches();
          Get.to(() => FindLocationScreen());
          // Get.to(() => DiagnosisScreen());
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LucidController>(
        init: LucidController(),
        builder: (lucidController) {
          return SafeArea(
            child: Scaffold(
              appBar: AppAppBar(
                title: AppString.diagnosisText,
                backgroundColor: themeController.textPrimaryColor,
                isTitleNeeded: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: diagnosisItems.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              diagnosisItems[index].onTap(lucidController);
                            },
                            child: Container(
                              height: 18.h,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    width: 1, color: themeController.nav1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 16,
                                      top: 16,
                                      child: AppText(
                                        diagnosisItems[index].title,
                                        color: themeController.navShadow1,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.montserrat,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: DiagonalPainter(),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: -55,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          diagnosisItems[index].imgUrl,
                                          width: 28.w,
                                          height: 25.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Gap(15);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class DiagonalPainter extends CustomPainter {
  final ThemeController themeController = Get.find();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = themeController.nav1
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width, -25);
    path.lineTo(size.width, size.height);
    path.lineTo(-20, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DiagnosisList {
  final String title;
  final String imgUrl;

  final Function(LucidController controller) onTap;

  DiagnosisList(
      {required this.title, required this.imgUrl, required this.onTap});
}
