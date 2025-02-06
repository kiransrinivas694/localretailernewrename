import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/model/cart/labtest_models/lab_test_status_model_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/diagnosis_refund_screen_new.dart';
import 'package:store_app_b2b/new_module/snippets/snippets_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class DiagnosisCancelledScreen extends StatelessWidget {
  DiagnosisCancelledScreen({super.key});
  final ThemeController themeController = Get.find();
  final CartLabtestController controller = Get.put(CartLabtestController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.islabTestDetailsLoading.value
          ? verticalShimmerListView()
          : controller.labTestDetails.isEmpty
              ? SizedBox(
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(8.h),
                      AppImageAsset(
                        image: 'assets/images/upcoming_empty.png',
                        width: 70.w,
                        height: 30.h,
                      ),
                      Gap(5.h),
                      AppText(
                        textAlign: TextAlign.center,
                        'No Cancelled Tests',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: themeController.navShadow1,
                      )
                    ],
                  ))
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter == 0) {
                      if (controller.islabMoreTestDetailsLoading.value ||
                          controller.islabTestDetailsLoading.value) {
                        return false;
                      }

                      controller.getLucidUserUpcomingStatus(
                          status: 2, loadMore: true);
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(children: [
                        Obx(
                          () => ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.labTestDetails.length,
                            itemBuilder: (context, index) {
                              logs(
                                  " status length-->${controller.labTestDetails.length}");
                              BasicTestStatus cancelDetails =
                                  controller.labTestDetails[index];
                              String selectedCancel = controller
                                      .labTestDetails[index].cancelledAt ??
                                  "";
                              DateFormat formatter =
                                  DateFormat("MMM dd,yyyy hh:mm a");
                              String cancelDate = selectedCancel.isNotEmpty
                                  ? formatter
                                      .format(DateTime.parse(selectedCancel))
                                  : "";
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() =>
                                      DiagnosisRefundScreen(index: index));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeController.textPrimaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x0D000000), // #0000000D
                                        offset: Offset(0, 4),
                                        blurRadius: 6,
                                      ),
                                      BoxShadow(
                                        color: Color(0x1A000000), // #0000001A
                                        offset: Offset(0, 10),
                                        blurRadius: 15,
                                        spreadRadius: -3,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 24.w,
                                            height: 10.h,
                                            child: const AppImageAsset(
                                              image:
                                                  "assets/images/mri-scan.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Gap(5.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //const Gap(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      'Cancelled',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      color: themeController
                                                          .black500Color,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            DiagnosisRefundScreen(
                                                              index: index,
                                                            ));
                                                      },
                                                      child: const Icon(
                                                        Icons.chevron_right,
                                                        size: 30,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Gap(5),
                                                AppText(
                                                  cancelDate,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp,
                                                  color: themeController
                                                      .black100Color,
                                                ),
                                                const Gap(5),
                                                AppText(
                                                  cancelDetails.tests
                                                          ?.substring(
                                                              0,
                                                              (cancelDetails
                                                                      .tests!
                                                                      .length -
                                                                  1)) ??
                                                      "",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
                                                  color: themeController
                                                      .black100Color,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          ),
                        ),
                        if (controller.islabMoreTestDetailsLoading.value)
                          CircularProgressIndicator()
                      ]),
                    ),
                  ),
                ),
    );
  }
}
