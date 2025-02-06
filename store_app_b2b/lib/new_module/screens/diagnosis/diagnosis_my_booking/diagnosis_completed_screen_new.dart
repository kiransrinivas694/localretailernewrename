import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/model/cart/labtest_models/lab_test_status_model_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/details_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/sample_collection_screen_new.dart';
import 'package:store_app_b2b/new_module/snippets/snippets_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class DiagnosisCompletedScreen extends StatelessWidget {
  DiagnosisCompletedScreen({super.key});
  final CartLabtestController cartController = Get.put(CartLabtestController());
  final LucidController lucidController = Get.put(LucidController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => cartController.islabTestDetailsLoading.value
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: verticalShimmerListView(shimmerContainerHeight: 150),
            )
          : cartController.labTestDetails.length == 0
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
                        'No Completed Tests',
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
                      if (cartController.islabMoreTestDetailsLoading.value ||
                          cartController.islabTestDetailsLoading.value) {
                        return false;
                      }
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        children: [
                          Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartController.labTestDetails.length,
                              itemBuilder: (context, index) {
                                BasicTestStatus completedDetails =
                                    cartController.labTestDetails[index];
                                String selectedCompleted = cartController
                                        .labTestDetails[index].completedAt ??
                                    "";
                                String selectedBooking = cartController
                                        .labTestDetails[index].bookingDate ??
                                    "";
                                DateFormat formatter =
                                    DateFormat("MMM dd,yyyy hh:mm a");
                                String completedDate =
                                    selectedCompleted.isNotEmpty
                                        ? formatter.format(
                                            DateTime.parse(selectedCompleted))
                                        : "";
                                DateFormat bookDate =
                                    DateFormat("MMM dd,yyyy hh:mm a");
                                String bookeddDate = selectedBooking.isNotEmpty
                                    ? bookDate
                                        .format(DateTime.parse(selectedBooking))
                                    : "";
                                return Container(
                                  decoration: BoxDecoration(
                                    color: themeController.textPrimaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            243, 244, 246, 1),
                                        width: 0.5),
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
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                '${completedDetails.firstName?.capitalizeFirst ?? ""} ${completedDetails.lastName ?? ""}',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17.sp,
                                                color: themeController
                                                    .black500Color,
                                              ),
                                              AppText(
                                                "Completed Date:",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: themeController
                                                    .black500Color,
                                              ),
                                              AppText(
                                                completedDate,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: themeController
                                                    .black500Color,
                                              ),
                                              const Gap(10),
                                            ],
                                          ),
                                          completedDetails.hv == "0"
                                              ? Row(
                                                  children: [
                                                    AppImageAsset(
                                                      image:
                                                          "assets/images/medical_icon_lab.png",
                                                      width: 6.w,
                                                    ),
                                                    Gap(1.w),
                                                    AppText(
                                                      "Lab Visit",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: themeController
                                                          .black500Color,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    AppImageAsset(
                                                      image:
                                                          "assets/images/tabler_home.png",
                                                      width: 6.w,
                                                    ),
                                                    Gap(1.w),
                                                    AppText(
                                                      "Home Visit",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: themeController
                                                          .black500Color,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: themeController.black50Color,
                                      ),
                                      const Gap(10),
                                      GestureDetector(
                                        onTap: () {
                                          lucidController.getFindBranchesId(
                                              branchId:
                                                  completedDetails.branchId ??
                                                      "");
                                          cartController.bookedId.value =
                                              completedDetails.id ?? '';
                                          cartController
                                              .getBookedTestDetailsById();
                                          Get.to(() => TestDetailsScreen());
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 28.w,
                                              height: 12.h,
                                              child: const AppImageAsset(
                                                image:
                                                    "assets/images/mri-scan.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Gap(4.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: AppText(
                                                          cartController
                                                                  .labTestDetails[
                                                                      index]
                                                                  .id ??
                                                              "",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14.sp,
                                                          color: themeController
                                                              .black500Color,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        size: 30,
                                                        color: themeController
                                                            .black300Color,
                                                      ),
                                                    ],
                                                  ),
                                                  const Gap(5),
                                                  AppText(
                                                    cartController
                                                            .labTestDetails[
                                                                index]
                                                            .tests
                                                            ?.substring(
                                                                0,
                                                                (cartController
                                                                        .labTestDetails[
                                                                            index]
                                                                        .tests!
                                                                        .length -
                                                                    1)) ??
                                                        "",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.sp,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: themeController
                                                        .black100Color,
                                                  ),
                                                  const Gap(1),
                                                  AppText(
                                                    "Booking Date:\n$bookeddDate",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.sp,
                                                    color: themeController
                                                        .black300Color,
                                                  ),
                                                  const Gap(1),
                                                  AppText(
                                                    // "${AppString.cashSymbol}${completedDetails.totalAmount == null ? '' : (completedDetails.totalAmount! + (completedDetails.homeCollecitonCharges == null ? 0 : completedDetails.homeCollecitonCharges!))}",
                                                    "${AppString.cashSymbol}${completedDetails.totalPaidAmount?.toStringAsFixed(2)}",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: themeController
                                                        .black100Color,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 14,
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        child: AppText(
                                                          cartController
                                                                  .labTestDetails[
                                                                      index]
                                                                  .location ??
                                                              "",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                          color: themeController
                                                              .black100Color,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(10),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: themeController.black50Color,
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                cartController.completedIndex =
                                                    index;
                                                cartController.testId
                                                    .value = cartController
                                                        .labTestDetails[index]
                                                        .id ??
                                                    '';
                                                cartController.rebook.value =
                                                    true;
                                                await Get.to(
                                                    SampleCollectionScreen(
                                                  homeCollection:
                                                      completedDetails.hv == "0"
                                                          ? false
                                                          : true,
                                                ));
                                                SampleCollectionController
                                                    sampleCollectionController =
                                                    Get.put(
                                                        SampleCollectionController());
                                                sampleCollectionController
                                                    .clearForm();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                // height: 50,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: themeController
                                                      .black50Color,
                                                ),
                                                child: AppText(
                                                  'Re-book',
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: themeController
                                                      .black500Color,
                                                ), //inter
                                              ),
                                            ),
                                          ),
                                          const Gap(10),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (completedDetails
                                                        .luicdReports ==
                                                    null) {
                                                  customFailureToast(
                                                      content:
                                                          'Reports not yet updated');
                                                } else {
                                                  launchHttpUrl(completedDetails
                                                          .luicdReports ??
                                                      "");
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  // horizontal: 6,
                                                ),
                                                // height: 50,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: themeController
                                                      .black50Color,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    AppText(
                                                      'Reports',
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: themeController
                                                          .black500Color,
                                                    ),
                                                    const Gap(5),
                                                    const Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      size: 15,
                                                    )
                                                  ],
                                                ), //inter
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
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
                          Gap(10),
                          if (cartController.islabMoreTestDetailsLoading.value)
                            CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
