import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/model/cart/labtest_models/lab_test_status_model_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/details_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/reschedule_form_screen_new.dart';
import 'package:store_app_b2b/new_module/snippets/snippets_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class DiagnosisUpcomingScreen extends StatelessWidget {
  DiagnosisUpcomingScreen({super.key});
  final ThemeController themeController = Get.find();
  final LucidController lucidController = Get.put(LucidController());
  final CartLabtestController controller = Get.put(CartLabtestController());
  void showCancelDialog(BuildContext context, String cartId) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.black.withOpacity(0.01), // Slightly transparent background
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
            decoration: BoxDecoration(
              color: themeController.textPrimaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  'Are you sure, you want to cancel your test?',
                  color: themeController.black500Color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFont.poppins,
                  textAlign: TextAlign.center,
                ),
                Gap(4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.cancelCart(status: "2", cartId: cartId);
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: themeController.navShadow1,
                        ),
                        child: AppText(
                          "Yes",
                          fontFamily: AppFont.poppins,
                          color: themeController.textPrimaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: themeController.navShadow1,
                        ),
                        child: AppText(
                          "No",
                          fontFamily: AppFont.poppins,
                          color: themeController.textPrimaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.islabTestDetailsLoading.value
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: verticalShimmerListView(shimmerContainerHeight: 150),
            )
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
                        'No Upcoming Tests',
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
                          status: 0, loadMore: true);
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.labTestDetails.length,
                              itemBuilder: (context, index) {
                                String selectedBooking = controller
                                        .labTestDetails[index].bookingDate ??
                                    "";
                                String selectedAppoint = controller
                                        .labTestDetails[index]
                                        .appointmentDate ??
                                    "";
                                DateFormat formatter =
                                    DateFormat("MMM dd,yyyy h:mm a");
                                String formattedDate = selectedBooking
                                        .isNotEmpty
                                    ? formatter
                                        .format(DateTime.parse(selectedBooking))
                                    : "";
                                DateFormat formatter1 =
                                    DateFormat("MMM dd,yyyy h:mm a");
                                String formattedAppoint = selectedAppoint
                                        .isNotEmpty
                                    ? formatter1
                                        .format(DateTime.parse(selectedAppoint))
                                    : "";

                                logs(
                                    " status length-->${controller.labTestDetails.length}");
                                logs(
                                    "current page-->${controller.labTestDetailsCurrentPage}");
                                BasicTestStatus upcomingDetails =
                                    controller.labTestDetails[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            243, 244, 246, 1),
                                        width: 0.5),
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
                                                '${upcomingDetails.firstName?.capitalizeFirst ?? ""} ${upcomingDetails.lastName ?? ""}',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17.sp,
                                                color: themeController
                                                    .black500Color,
                                              ),
                                              AppText(
                                                "Appointment Date:",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: themeController
                                                    .black500Color,
                                              ),
                                              AppText(
                                                formattedAppoint,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: themeController
                                                    .black500Color,
                                              ),
                                              const Gap(10),
                                            ],
                                          ),
                                          Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceAround,
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.,
                                            children: [
                                              (upcomingDetails.umrNumber ==
                                                          null &&
                                                      upcomingDetails.vid ==
                                                          null)
                                                  ? AppText(
                                                      "Pending...",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: themeController
                                                          .textSecondaryColor,
                                                    )
                                                  : AppText(
                                                      "Billed",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: themeController
                                                          .navShadow1,
                                                    ),
                                              Gap(2.h),
                                              upcomingDetails.hv == "0"
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
                                        ],
                                      ),
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
                                                  upcomingDetails.branchId ??
                                                      "");
                                          controller.bookedId.value =
                                              upcomingDetails.id ?? '';
                                          controller.getBookedTestDetailsById();
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
                                            const Gap(10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: AppText(
                                                          upcomingDetails.id ??
                                                              "",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15.sp,
                                                          color: themeController
                                                              .black500Color,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        size: 30,
                                                        color: themeController
                                                            .black300Color,
                                                      )
                                                    ],
                                                  ),
                                                  // const Gap(5),
                                                  AppText(
                                                    upcomingDetails.tests
                                                            ?.substring(
                                                                0,
                                                                (upcomingDetails
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
                                                    "Booking Date:\n$formattedDate",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.sp,
                                                    color: themeController
                                                        .black300Color,
                                                  ),
                                                  const Gap(1),
                                                  AppText(
                                                    // "${AppString.cashSymbol}${upcomingDetails.totalAmount == null ? '' : (upcomingDetails.totalAmount! + (upcomingDetails.homeCollecitonCharges == null ? 0 : upcomingDetails.homeCollecitonCharges!))}",
                                                    "${AppString.cashSymbol}${upcomingDetails.totalPaidAmount?.toStringAsFixed(2)}",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.sp,
                                                    color: themeController
                                                        .black100Color,
                                                  ),
                                                  const Gap(1),
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
                                                          upcomingDetails
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
                                      (upcomingDetails.vid == null &&
                                              upcomingDetails.umrNumber == null)
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showCancelDialog(
                                                          context,
                                                          upcomingDetails.id ??
                                                              "");
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 40),
                                                      // height: 50,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: themeController
                                                            .black50Color,
                                                      ),
                                                      child: AppText(
                                                        'Cancel',
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                                      controller
                                                          .clearRescheduleDetails();
                                                      Get.to(
                                                        () =>
                                                            RescheduleFormScreen(
                                                          id: upcomingDetails
                                                              .id,
                                                          homeCollection:
                                                              upcomingDetails
                                                                  .hv,
                                                          relation:
                                                              upcomingDetails
                                                                  .relation,
                                                          firstName:
                                                              ' ${upcomingDetails.firstName ?? ""}',
                                                          lastName:
                                                              upcomingDetails
                                                                      .lastName ??
                                                                  "",
                                                          gender:
                                                              upcomingDetails
                                                                  .gender,
                                                          age: upcomingDetails
                                                              .age,
                                                          mobileNum:
                                                              upcomingDetails
                                                                  .mobileNumber,
                                                          city: upcomingDetails
                                                              .city,
                                                          branch:
                                                              upcomingDetails
                                                                  .location,
                                                          appointDate:
                                                              upcomingDetails
                                                                  .appointmentDate,
                                                          address:
                                                              upcomingDetails
                                                                  .address,
                                                          addressInfo:
                                                              upcomingDetails
                                                                  .fullAddress,
                                                          commt: upcomingDetails
                                                              .comments,
                                                          totalAmount:
                                                              upcomingDetails
                                                                  .totalAmount,
                                                          lucidList:
                                                              upcomingDetails
                                                                  .lucidTestData,
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 20),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: themeController
                                                            .primary500Color,
                                                      ),
                                                      child: AppText(
                                                        'Reschedule',
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themeController
                                                            .textPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Gap(5),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 15,
                                );
                              },
                            ),
                          ),
                          Gap(10),
                          if (controller.islabMoreTestDetailsLoading.value)
                            CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
