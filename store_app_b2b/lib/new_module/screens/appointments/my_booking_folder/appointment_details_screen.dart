import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/date_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_header.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  AppointmentDetailsScreen({super.key});
  final ThemeController themeController = Get.put(ThemeController());
  final BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());

  formateDate(String? date) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date ?? '');
    String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);
    return formattedDate;
  }

  formateBookingDate(String? date) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date ?? '');
    String formattedDate = DateFormat('MMM dd, yyyy hh:mma').format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppAppBar(title: "Details"),
        body: SafeArea(
          child: Stack(
            children: [
              Obx(
                () => controller.appointmentSingleDetail.value == null
                    ? const SizedBox()
                    : Column(
                        children: [
                          const AppHeader(title: "Details"),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              decoration: BoxDecoration(
                                color: themeController.textPrimaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // padding: EdgeInsets.only(
                              // left: 16, right: 16, bottom: 0, top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    thickness: 0.5,
                                    color: Color.fromRGBO(229, 231, 235, 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          controller
                                                          .appointmentSingleDetail
                                                          .value!
                                                          .appointmentDate !=
                                                      null &&
                                                  controller
                                                      .appointmentSingleDetail
                                                      .value!
                                                      .appointmentDate!
                                                      .isNotEmpty
                                              ? formatStringDateIntoMay222024(
                                                  controller
                                                          .appointmentSingleDetail
                                                          .value!
                                                          .appointmentDate ??
                                                      '')
                                              : "",
                                          color: themeController.black300Color,
                                          fontSize: 14.sp,
                                          fontFamily: AppFont.montserrat,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        AppText(
                                          'ID : ${controller.appointmentSingleDetail.value!.id}',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp,
                                          color: themeController.navShadow1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(6),
                                  const Divider(
                                    thickness: 0.5,
                                    color: Color.fromRGBO(229, 231, 235, 1),
                                  ),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     AppText(
                                  //       "Consultation is in progress",
                                  //       fontFamily: AppFont.montserrat,
                                  //       fontSize: 15.sp,
                                  //       color: Color.fromRGBO(75, 85, 99, 1),
                                  //       fontWeight: FontWeight.w600,
                                  //       // textAlign: TextAlign.end,
                                  //     ),
                                  //   ],
                                  // ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              controller.status == 'C'
                                                  ? const Gap(0)
                                                  : Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 7,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: themeController
                                                              .navShadow1,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16)),
                                                      child: AppText(
                                                        'Status : ${controller.appointmentSingleDetail.value!.patientCurrentStatus}',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13.sp,
                                                        color: themeController
                                                            .textPrimaryColor,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          // AppText(
                                          //   "${controller.appointmentSingleDetail.value!.patientCurrentStatus}",
                                          //   fontSize: 14.sp,
                                          //   color: Color.fromRGBO(75, 85, 99, 1),
                                          //   fontWeight: FontWeight.w600,
                                          // ),
                                        ),
                                        const Gap(14),
                                        Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: AppImageAsset(
                                              image: controller
                                                      .appointmentSingleDetail
                                                      .value!
                                                      .doctorImageUrl ??
                                                  '',
                                              width: 109,
                                              height: 109,
                                            ),
                                          ),
                                        ),
                                        const Gap(14),

                                        //doctor details container
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                119, 187, 173, 0.05),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                "Doctor Details :",
                                                color: themeController
                                                    .black500Color,
                                                fontSize: 16.sp,
                                                fontFamily: AppFont.montserrat,
                                                fontWeight: FontWeight.w800,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              const Gap(5),
                                              AppText(
                                                controller
                                                        .appointmentSingleDetail
                                                        .value!
                                                        .doctorName ??
                                                    '',
                                                color:
                                                    themeController.bookColor,
                                                fontFamily: AppFont.montserrat,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              AppText(
                                                "${controller.appointmentSingleDetail.value!.specialization ?? ''} | ${controller.appointmentSingleDetail.value!.doctorExperience == null ? "" : controller.appointmentSingleDetail.value!.doctorExperience!.split('.')[0]} years Exp | ${controller.appointmentSingleDetail.value!.doctorEducation}",
                                                fontFamily: AppFont.montserrat,
                                                fontSize: 15.sp,
                                                color: const Color.fromRGBO(
                                                    75, 85, 99, 1),
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.left,
                                              ),
                                              const Gap(4),
                                              Row(
                                                children: [
                                                  // AppImageAsset(
                                                  //   image: controller.appointmentSingleDetail
                                                  //           .value!.hospitalImageUrl ??
                                                  //       '',
                                                  //   height: 20,
                                                  //   width: 16,
                                                  // ),
                                                  const AppImageAsset(
                                                    image:
                                                        'assets/images/languages.png',
                                                    height: 20,
                                                    width: 16,
                                                  ),
                                                  const Gap(1),
                                                  AppText(
                                                    controller
                                                            .appointmentSingleDetail
                                                            .value!
                                                            .languages ??
                                                        '',
                                                    color: themeController
                                                        .textSecondaryColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                ],
                                              ),
                                              const Gap(3),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .local_hospital_outlined,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  const Gap(3),
                                                  AppText(
                                                    controller
                                                            .appointmentSingleDetail
                                                            .value!
                                                            .hospitalName ??
                                                        '',
                                                    fontFamily: AppFont.poppins,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeController
                                                        .textSecondaryColor,
                                                  ),
                                                ],
                                              ),
                                              const Gap(3),
                                              AppText(
                                                "Booking Date: ${formateBookingDate(controller.appointmentSingleDetail.value!.bookingDateTime) ?? ''}",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: themeController
                                                    .textSecondaryColor,
                                              ),
                                              const Gap(3),
                                              AppText(
                                                "Appointment Date: ${formateDate(controller.appointmentSingleDetail.value!.appointmentDate) ?? ''}",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: themeController
                                                    .textSecondaryColor,
                                              ),
                                              const Gap(3),
                                              AppText(
                                                "Appointment Slot: ${controller.appointmentSingleDetail.value!.bookedslot!.startTime ?? ''} - ${controller.appointmentSingleDetail.value!.bookedslot!.endTime ?? ''}",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: themeController
                                                    .textSecondaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(16),

                                        //patient details container
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                119, 187, 173, 0.05),
                                          ),
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                "Patient Details :",
                                                color: themeController
                                                    .black500Color,
                                                fontSize: 16.sp,
                                                fontFamily: AppFont.montserrat,
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              const Gap(4),
                                              AppText(
                                                controller
                                                        .appointmentSingleDetail
                                                        .value!
                                                        .userName!
                                                        .capitalizeFirst ??
                                                    '',
                                                color:
                                                    themeController.bookColor,
                                                fontFamily: AppFont.montserrat,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              const Gap(3),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: AppText(
                                                      "Relation: ${controller.appointmentSingleDetail.value!.relation}",
                                                      fontFamily:
                                                          AppFont.poppins,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeController
                                                          .textSecondaryColor,
                                                    ),
                                                  ),
                                                  AppText(
                                                    "Phone: ${controller.appointmentSingleDetail.value!.userMobileNumber}",
                                                    fontFamily: AppFont.poppins,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: themeController
                                                        .textSecondaryColor,
                                                  ),
                                                ],
                                              ),
                                              const Gap(3),
                                              AppText(
                                                "Age: ${controller.appointmentSingleDetail.value!.age}",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: themeController
                                                    .textSecondaryColor,
                                              ),
                                              const Gap(3),
                                              AppText(
                                                "Gender: ${controller.appointmentSingleDetail.value!.gender}",
                                                fontFamily: AppFont.poppins,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: themeController
                                                    .textSecondaryColor,
                                              ),
                                              const Gap(3),
                                              controller.appointmentSingleDetail
                                                          .value!.height ==
                                                      null
                                                  ? const Gap(0)
                                                  : AppText(
                                                      "Height: ${controller.appointmentSingleDetail.value!.height!.toInt()}",
                                                      fontFamily:
                                                          AppFont.poppins,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeController
                                                          .textSecondaryColor,
                                                    ),
                                              const Gap(3),
                                              controller.appointmentSingleDetail
                                                          .value!.weight ==
                                                      null
                                                  ? const Gap(0)
                                                  : AppText(
                                                      "Weight: ${controller.appointmentSingleDetail.value!.weight!.toInt()}",
                                                      fontFamily:
                                                          AppFont.poppins,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeController
                                                          .textSecondaryColor,
                                                    ),
                                              const Gap(3),
                                              // AppText(
                                              //   "Booked: ${controller.appointmentSingleDetail.value!.specialization ?? ''}",
                                              //   color: themeController
                                              //       .textSecondaryColor,
                                              //   fontFamily: AppFont.poppins,
                                              //   fontSize: 15.sp,
                                              //   fontWeight: FontWeight.w400,
                                              // ),
                                              // const Gap(3),
                                              // controller.appointmentSingleDetail
                                              //             .value!.timings ==
                                              //         null
                                              //     ? const Gap(0)
                                              //     : AppText(
                                              //         "Timings : ${controller.appointmentSingleDetail.value!.timings}",
                                              //         color: themeController
                                              //             .textSecondaryColor,
                                              //         fontFamily: AppFont.poppins,
                                              //         fontSize: 15.sp,
                                              //         fontWeight: FontWeight.w400,
                                              //       ),
                                            ],
                                          ),
                                        ),
                                        const Gap(16),

                                        //spoc details container
                                        if (controller.appointmentSingleDetail
                                                .value!.isSpocAssigned ==
                                            "Y")
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  119, 187, 173, 0.05),
                                            ),
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      "Spoc Details :",
                                                      color: themeController
                                                          .black500Color,
                                                      fontSize: 16.sp,
                                                      fontFamily:
                                                          AppFont.montserrat,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    controller
                                                                .appointmentSingleDetail
                                                                .value!
                                                                .spocContactNUmber ==
                                                            null
                                                        ? const Gap(0)
                                                        : GestureDetector(
                                                            onTap: () {
                                                              makePhoneCall(controller
                                                                      .appointmentSingleDetail
                                                                      .value!
                                                                      .spocContactNUmber ??
                                                                  '');
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    themeController
                                                                        .buyColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 2,
                                                                horizontal: 6,
                                                              ),
                                                              child: const Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AppImageAsset(
                                                                    image:
                                                                        'assets/images/phone_call_icon.png',
                                                                    width: 20,
                                                                  ),
                                                                  AppText(
                                                                    "Call",
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                                const Gap(4),
                                                AppText(
                                                  controller
                                                          .appointmentSingleDetail
                                                          .value!
                                                          .spocName ??
                                                      '',
                                                  color:
                                                      themeController.bookColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                const Gap(3),
                                                AppText(
                                                  'Contact No: ${controller.appointmentSingleDetail.value!.spocContactNUmber ?? ''}',
                                                  color:
                                                      themeController.bookColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const Gap(3),
                                                AppText(
                                                  controller
                                                          .appointmentSingleDetail
                                                          .value!
                                                          .spocHospitalName ??
                                                      '',
                                                  color:
                                                      themeController.bookColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                        const Gap(16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              Obx(() => controller.isAppointmentDetailsLoading.value
                  ? AppLoader()
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
