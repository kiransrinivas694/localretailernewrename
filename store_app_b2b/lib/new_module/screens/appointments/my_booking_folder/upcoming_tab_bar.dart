// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/model/appointment/appointment_history.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/appointment_details_screen.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_search_box.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class UpcomingTabBar extends StatelessWidget {
  UpcomingTabBar({super.key});

  final BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BooikingAppointmentController>(
        // init: BooikingAppointmentController(),
        // initState: (state) {
        //   BooikingAppointmentController booikingAppointmentController =
        //       Get.put(BooikingAppointmentController());
        //   // booikingAppointmentController.status = 'P';
        //   booikingAppointmentController.getAppointmentHistory();
        // },
        builder: (_) {
      return Obx(() => controller.appointmentHistoryLoading.value
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: AppShimmerEffectView(
                      height: 150,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(10);
                },
              ),
            )
          : controller.appointmentDetails.isEmpty
              ? SizedBox(
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImageAsset(
                        image: 'assets/images/upcoming_empty.png',
                        width: 70.w,
                        height: 30.h,
                      ),
                      Gap(5.h),
                      AppText(
                        textAlign: TextAlign.center,
                        'No Upcoming Appointments',
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
                      if (controller.isMoreAppointmentsLoading.value ||
                          controller.appointmentHistoryLoading.value) {
                        return false;
                      }

                      controller.getAppointmentHistory(
                        loadMore: true,
                        // searchText: controller
                        //     .searchServiceProductController
                        //     .text,
                      );
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.appointmentDetails.length,
                                itemBuilder: (context, index) {
                                  AppointmentDetails appointmentDetails =
                                      controller.appointmentDetails[index];
                                  DateTime parsedDate = DateFormat('yyyy-MM-dd')
                                      .parse(
                                          appointmentDetails.appointmentDate ??
                                              '');
                                  String formattedDate =
                                      DateFormat('MMM dd, yyyy')
                                          .format(parsedDate);
                                  DateTime bookedParsedDate =
                                      DateFormat('yyyy-MM-dd HH:mm:ss').parse(
                                          appointmentDetails.bookingDateTime ??
                                              '');
                                  String bookedFormattedDate =
                                      DateFormat('MMM dd, yyyy hh:mma')
                                          .format(bookedParsedDate);
                                  return GestureDetector(
                                    onTap: () {
                                      controller.appointmentSingleDetail.value =
                                          null;
                                      controller.getAppointmentDetails(
                                          appointmentId:
                                              appointmentDetails.id ?? '');
                                      Get.to(() => AppointmentDetailsScreen());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeController.textPrimaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                243, 244, 246, 1),
                                            width: 0.5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color(0x0D000000), // #0000000D
                                            offset: Offset(0, 4),
                                            blurRadius: 6,
                                          ),
                                          BoxShadow(
                                            color:
                                                Color(0x1A000000), // #0000001A
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: AppText(
                                                  '${appointmentDetails.userName!.capitalizeFirst}',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15.sp,
                                                  color: themeController
                                                      .black500Color,
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .appointmentSingleDetail
                                                        .value = null;
                                                    controller
                                                        .getAppointmentDetails(
                                                            appointmentId:
                                                                appointmentDetails
                                                                        .id ??
                                                                    '');
                                                    Get.to(() =>
                                                        AppointmentDetailsScreen());
                                                  },
                                                  child: const Icon(
                                                    Icons.chevron_right,
                                                    size: 25,
                                                  ))
                                            ],
                                          ),
                                          AppText(
                                            formattedDate,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.sp,
                                            color:
                                                themeController.black500Color,
                                          ),
                                          const Gap(10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: AppText(
                                              'Appointment ID: ${appointmentDetails.id}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              color:
                                                  themeController.black100Color,
                                            ),
                                          ),
                                          const Gap(5),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: themeController.black50Color,
                                          ),
                                          const Gap(10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: themeController
                                                        .navShadow1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: AppText(
                                                  'Status : ${appointmentDetails.patientCurrentStatus}',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.sp,
                                                  color: themeController
                                                      .textPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(10),
                                          Row(
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: SizedBox(
                                                    height: 130,
                                                    width: 130,
                                                    child: appointmentDetails
                                                                    .doctorImageUrl ==
                                                                null ||
                                                            appointmentDetails
                                                                .doctorImageUrl
                                                                .toString()
                                                                .isEmpty
                                                        ? const AppImageAsset(
                                                            image:
                                                                'assets/images/all_doctors_new.png',
                                                            fit: BoxFit.contain,
                                                          )
                                                        : AppImageAsset(
                                                            image:
                                                                '${appointmentDetails.doctorImageUrl}',
                                                            fit: BoxFit.contain,
                                                          )),
                                              ),
                                              const Gap(10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      appointmentDetails
                                                              .doctorName ??
                                                          "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16.sp,
                                                      color: themeController
                                                          .black500Color,
                                                    ),

                                                    AppText(
                                                      appointmentDetails
                                                                  .specialization
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              appointmentDetails
                                                                  .doctorExperience
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              appointmentDetails
                                                                  .doctorEducation
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              appointmentDetails
                                                                      .specialization !=
                                                                  null &&
                                                              appointmentDetails
                                                                      .doctorExperience !=
                                                                  null &&
                                                              appointmentDetails
                                                                      .doctorEducation !=
                                                                  null
                                                          ? '${appointmentDetails.specialization ?? ''} | ${double.parse(appointmentDetails.doctorExperience).toInt()} years Exp, ${appointmentDetails.doctorEducation}'
                                                          : appointmentDetails.specialization
                                                                      .toString()
                                                                      .isNotEmpty &&
                                                                  appointmentDetails.doctorExperience
                                                                      .toString()
                                                                      .isNotEmpty &&
                                                                  appointmentDetails
                                                                          .specialization !=
                                                                      null &&
                                                                  appointmentDetails
                                                                          .doctorExperience !=
                                                                      null
                                                              ? '${appointmentDetails.specialization ?? ''} | ${double.parse(appointmentDetails.doctorExperience).toInt()} years Exp'
                                                              : appointmentDetails
                                                                          .specialization
                                                                          .toString()
                                                                          .isNotEmpty &&
                                                                      appointmentDetails
                                                                          .doctorEducation
                                                                          .toString()
                                                                          .isNotEmpty &&
                                                                      appointmentDetails
                                                                              .specialization !=
                                                                          null &&
                                                                      appointmentDetails
                                                                              .doctorEducation !=
                                                                          null
                                                                  ? '${appointmentDetails.specialization ?? ''} | ${appointmentDetails.doctorEducation}'
                                                                  : '',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14.sp,
                                                      color: themeController
                                                          .black100Color,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const Gap(5),
                                                    appointmentDetails.consultationFees ==
                                                            null
                                                        ? const Gap(0)
                                                        : Text(
                                                            'Fees: ${AppString.cashSymbol} ${double.parse(appointmentDetails.consultationFees.toString()).toInt()}',
                                                            style: GoogleFonts.mitr(
                                                                color: themeController
                                                                    .black500Color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                    const Gap(0),
                                                    appointmentDetails
                                                                    .languages ==
                                                                null ||
                                                            appointmentDetails
                                                                .languages
                                                                .toString()
                                                                .isEmpty
                                                        ? const Gap(0)
                                                        : Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const AppImageAsset(
                                                                image:
                                                                    'assets/images/languages.png',
                                                                height: 20,
                                                                width: 16,
                                                              ),
                                                              const SizedBox(
                                                                width: 1,
                                                              ),
                                                              appointmentDetails
                                                                          .languages !=
                                                                      null
                                                                  ? Expanded(
                                                                      child:
                                                                          AppText(
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        '${appointmentDetails.languages ?? ''}',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            9,
                                                                        color: themeController
                                                                            .black100Color,
                                                                      ),
                                                                    )
                                                                  : const Gap(0)
                                                            ],
                                                          ),
                                                    const Gap(0),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .local_hospital_outlined,
                                                          size: 20,
                                                          color: Colors.red,
                                                        ),
                                                        const Gap(3),
                                                        Expanded(
                                                          child: AppText(
                                                            '${appointmentDetails.hospitalName ?? ''}',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14,
                                                            color: themeController
                                                                .black100Color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // appointmentDetails
                                                    //             .hospitalImageUrl ==
                                                    //         null
                                                    //     ? Gap(0)
                                                    //     : AppImageAsset(
                                                    //         image:
                                                    //             '${appointmentDetails.hospitalImageUrl}',
                                                    //         width: 20.w,
                                                    //         height: 5.h,
                                                    //       )
                                                    const Gap(5),
                                                    AppText(
                                                      'Booking Date: \n$bookedFormattedDate',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.sp,
                                                      color: themeController
                                                          .black100Color,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(10),

                                          if (appointmentDetails
                                                      .isSpocAssigned !=
                                                  null &&
                                              appointmentDetails
                                                      .isSpocAssigned ==
                                                  "Y")
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 11,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    119, 187, 173, 0.69),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: AppText(
                                                      'Spoc Assigned by ${appointmentDetails.spocName}',
                                                      fontSize: 12,
                                                      maxLines: 2,
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const AppImageAsset(
                                                    image:
                                                        "assets/images/info_icon.png",
                                                    width: 24,
                                                  )
                                                ],
                                              ),
                                            ),

                                          // Container(
                                          //   width: double.infinity,
                                          //   height: 1,
                                          //   color: themeController.black50Color,
                                          // ),
                                          // Gap(10),
                                          // Row(
                                          //   children: [
                                          //     Expanded(
                                          //       child: GestureDetector(
                                          //         onTap: () {},
                                          //         child: Container(
                                          //           padding: EdgeInsets.symmetric(
                                          //               vertical: 10, horizontal: 40),
                                          //           // height: 50,
                                          //           alignment: Alignment.center,
                                          //           decoration: BoxDecoration(
                                          //             borderRadius: BorderRadius.circular(50),
                                          //             color: themeController.black50Color,
                                          //           ),
                                          //           child: AppText(
                                          //             'Cancel',
                                          //             fontSize: 14.sp,
                                          //             fontWeight: FontWeight.w700,
                                          //             color: themeController.black500Color,
                                          //           ), //inter
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Gap(10),
                                          //     Expanded(
                                          //       child: GestureDetector(
                                          //         onTap: () {},
                                          //         child: Container(
                                          //           padding: EdgeInsets.symmetric(
                                          //               vertical: 10, horizontal: 20),
                                          //           // height: 50,
                                          //           alignment: Alignment.center,
                                          //           decoration: BoxDecoration(
                                          //             borderRadius: BorderRadius.circular(50),
                                          //             color: themeController.primary500Color,
                                          //           ),
                                          //           child: AppText(
                                          //             'Reschedule',
                                          //             fontSize: 14.sp,
                                          //             fontWeight: FontWeight.w700,
                                          //             color: themeController.textPrimaryColor,
                                          //           ), //inter
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // )
                                          const Gap(10),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: themeController.black50Color,
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
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Obx(() => controller.isMoreAppointmentsLoading.value
                            ? const Column(
                                children: [
                                  Gap(10),
                                  CircularProgressIndicator(),
                                ],
                              )
                            : const SizedBox()),
                      ],
                    ),
                  )));
    });
  }
}
