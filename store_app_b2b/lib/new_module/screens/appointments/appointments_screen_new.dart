import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/model/appointment/doctor_list_model.dart';
import 'package:store_app_b2b/new_module/model/appointment/specialisation_list.dart';
import 'package:store_app_b2b/new_module/screens/appointments/book_slots_screen.dart';
import 'package:store_app_b2b/new_module/screens/appointments/doctor_details_screen.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_search_box.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

// class AppointmentsScreen extends StatefulWidget {
//   const AppointmentsScreen(
//       {super.key,
//       // this.isScaffoldNeed = false,
//       // this.istopDoctors = false,
//       // required this.counselling
//       });

//   // final bool isScaffoldNeed;

//   // final bool istopDoctors;

//   // final String counselling;

//   @override
//   State<AppointmentsScreen> createState() => _AppointmentsScreenState();
// }

// class _AppointmentsScreenState extends State<AppointmentsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppAppBar(
//           title: AppString.bookAppointmentText,
//           onBack: () {
//             if (widget.isScaffoldNeed) {
//               Get.back();
//             } else {
//               BottomBarController controller = Get.put(BottomBarController());
//               controller.currentSelectedIndex = 2;
//             }
//           },
//         ),
//         body: AppointmnetSubScreen(
//           istopDoctors: widget.istopDoctors,
//           councelling: widget.counselling,
//         ),
//         bottomNavigationBar: widget.isScaffoldNeed
//             ? AppBottomBar(
//                 index: 3,
//                 useIndexFromController: false,
//               )
//             : null);
//   }
// }

class AppointmnetScreen extends StatefulWidget {
  const AppointmnetScreen(
      {super.key, required this.istopDoctors, required this.councelling});

  final bool istopDoctors;

  final String councelling;

  @override
  State<AppointmnetScreen> createState() => _AppointmnetScreenState();
}

class _AppointmnetScreenState extends State<AppointmnetScreen> {
  bool isFavourite = false;
  void favourite(bool value) {
    isFavourite = value;
  }

  void selectedSpecalisation(int index) {
    BooikingAppointmentController controller =
        Get.put(BooikingAppointmentController());
    setState(() {
      controller.specialisationIndex = index;
    });
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToCenter(int index) {
    // Calculate the offset to center the tapped item
    double screenWidth = 100.w;
    double containerWidth = 35.w; // Assume each container has a fixed width
    double offset = index * containerWidth - (screenWidth - containerWidth) / 2;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // @override
  // void initState() {
  //   BooikingAppointmentController controller =
  //       Get.put(BooikingAppointmentController());

  //   super.initState();
  // }

  final ThemeController themeController = Get.find();
  TextEditingController doctorSearchController = TextEditingController();
  BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());
  @override
  Widget build(BuildContext context) {
    print('lenght ${controller.doctorSpecialisationList.length}');
    return GetBuilder<BooikingAppointmentController>(
        // init: BooikingAppointmentController(),
        initState: (state) {
      Future.delayed(
        const Duration(milliseconds: 250),
        () {
          BooikingAppointmentController controller =
              Get.put(BooikingAppointmentController());
          controller.topDoctorsCurrentPage.value = 0;
          controller.topDoctorsTotalPages.value = 0;
          controller.counselling = widget.councelling;
          controller.update();
          controller.doctorsList.value = [];
          controller.showSuffixForSearchDoctorController.value = false;
          !widget.istopDoctors
              ? controller.getAllSpecialisations()
              : controller.getAllDoctors();
          controller.specialisationIndex = 0;
          // if (widget.specializationId != "") {
          // controller.specialisation = widget.specializationId;
          // controller.update();
          // }
          controller.doctorName = '';
          controller.selectedDoctor.value = '';
          // controller.appointmentId = null;
          controller.selectedDoctorName.value = '';
        },
      );
      // booikingAppointmentController.getAllDoctors();
    }, builder: (_) {
      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppAppBar(
              title: AppString.bookAppointmentText,
            ),
            body: Column(
              children: [
                // AppHeader(
                //   title: 'Booking Appointments',
                //   titleSize: 20,
                // ),
                const Gap(4),
                !widget.istopDoctors
                    ? const Gap(0)
                    : AppText(
                        textAlign: TextAlign.center,
                        '${controller.specialisationName} ${AppString.specialistsText}',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: themeController.black500Color,
                      ),
                const Gap(14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(
                    () => AppSearchBox(
                      showSuffixIcon:
                          controller.showSuffixForSearchDoctorController.value,
                      onSuffixIconTap: () {
                        if (widget.istopDoctors) {
                          controller.doctorName = '';
                          doctorSearchController.text = "";
                          controller.topDoctorsCurrentPage.value = 0;
                          controller.topDoctorsTotalPages.value = 0;
                          controller.getAllTopDoctors();
                          controller.showSuffixForSearchDoctorController.value =
                              false;
                          return;
                        }
                        controller.doctorName = '';
                        doctorSearchController.text = "";
                        controller.doctorsCurrentPage.value = 0;
                        controller.doctorsTotalPages.value = 0;
                        controller.getAllDoctors();
                        controller.showSuffixForSearchDoctorController.value =
                            false;
                      },
                      onChange: (p0) {
                        // if (widget.istopDoctors) {
                        //   controller.topDoctorsCurrentPage.value = 0;
                        //   controller.topDoctorsTotalPages.value = 0;
                        //   controller.doctorName = p0;
                        //   controller.getAllTopDoctors();
                        //   controller.showSuffixForSearchDoctorController.value =
                        //       p0.isNotEmpty;
                        //   return;
                        // }
                        controller.doctorsList.clear();
                        controller.doctorName = p0;
                        controller.doctorsCurrentPage.value = 0;
                        // controller.doctorsPageSize.value = 0;
                        // controller.doctorsTotalPages.value = 0;
                        controller.showSuffixForSearchDoctorController.value =
                            p0.isNotEmpty;
                        controller.getAllDoctors();
                      },
                      textEditingController: doctorSearchController,
                      hintText: 'Search by doctor name',
                    ),
                  ),
                ),
                const Gap(20),
                controller.doctorSpecialisationList.length == 1
                    ? const SizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: !widget.istopDoctors ||
                                controller.doctorSpecialisationList.length == 1
                            ? SizedBox(
                                height: 4.5.h,
                                child: controller.isSpecialisationloading.value
                                    ? SizedBox(
                                        height: 60,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 10,
                                            separatorBuilder: (context, index) {
                                              return const Gap(10);
                                            },
                                            itemBuilder: (context, index) {
                                              return const Center(
                                                child: AppShimmerEffectView(
                                                  height: 50,
                                                  width: 100,
                                                ),
                                              );
                                            }),
                                      )
                                    : controller
                                            .doctorSpecialisationList.isEmpty
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : SizedBox(
                                            height: 60,
                                            child: ListView.separated(
                                              controller: _scrollController,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: controller
                                                      .doctorSpecialisationList
                                                      .length +
                                                  1,
                                              itemBuilder: (context, index) {
                                                // DoctorSpecialisations specialisations =
                                                // controller
                                                //     .doctorSpecialisationList[index];
                                                if (index == 0) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      selectedSpecalisation(
                                                          controller
                                                                  .specialisationIndex =
                                                              index);
                                                      controller
                                                          .specialisation = '';
                                                      controller
                                                          .specialisationName = '';
                                                      controller.doctorsList
                                                          .value = [];
                                                      controller.favorites = [];
                                                      controller
                                                          .doctorsCurrentPage
                                                          .value = 0;
                                                      controller
                                                          .getAllDoctors();
                                                      _scrollToCenter(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: controller
                                                                      .specialisationIndex ==
                                                                  index
                                                              ? themeController
                                                                  .nav1
                                                              : themeController
                                                                  .textPrimaryColor,
                                                          border: Border.all(
                                                              color: themeController
                                                                  .navShadow1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24)),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20,
                                                              top: 10,
                                                              bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          AppText(
                                                            'All',
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                controller.specialisationIndex ==
                                                                        index
                                                                    ? FontWeight
                                                                        .w500
                                                                    : FontWeight
                                                                        .w400,
                                                            color: controller
                                                                        .specialisationIndex ==
                                                                    index
                                                                ? themeController
                                                                    .textPrimaryColor
                                                                : themeController
                                                                    .black500Color,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      selectedSpecalisation(
                                                          controller
                                                                  .specialisationIndex =
                                                              index);
                                                      controller
                                                              .specialisation =
                                                          controller
                                                                  .doctorSpecialisationList[
                                                                      index - 1]
                                                                  .id ??
                                                              '';
                                                      controller
                                                              .specialisationName =
                                                          controller
                                                              .doctorSpecialisationList[
                                                                  index - 1]
                                                              .specialization!;
                                                      controller.doctorsList
                                                          .value = [];
                                                      controller.favorites = [];
                                                      controller
                                                          .doctorsCurrentPage
                                                          .value = 0;
                                                      controller
                                                          .getAllDoctors();
                                                      _scrollToCenter(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: controller
                                                                      .specialisationIndex ==
                                                                  index
                                                              ? themeController
                                                                  .nav1
                                                              : themeController
                                                                  .textPrimaryColor,
                                                          border: Border.all(
                                                              color: themeController
                                                                  .navShadow1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24)),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 4,
                                                        right: 8,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          controller
                                                                      .doctorSpecialisationList[
                                                                          index -
                                                                              1]
                                                                      .imageUrl ==
                                                                  null
                                                              ? const AppImageAsset(
                                                                  image:
                                                                      'assets/images/neurology_appointments.png',
                                                                  width: 30,
                                                                  height: 30,
                                                                )
                                                              : Image.network(
                                                                  controller
                                                                      .doctorSpecialisationList[
                                                                          index -
                                                                              1]
                                                                      .imageUrl!,
                                                                  width: 30,
                                                                  height: 30,
                                                                ),
                                                          const Gap(10),
                                                          AppText(
                                                            controller
                                                                    .doctorSpecialisationList[
                                                                        index -
                                                                            1]
                                                                    .specialization ??
                                                                '',
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                controller.specialisationIndex ==
                                                                        index
                                                                    ? FontWeight
                                                                        .w500
                                                                    : FontWeight
                                                                        .w400,
                                                            color: controller
                                                                        .specialisationIndex ==
                                                                    index
                                                                ? themeController
                                                                    .textPrimaryColor
                                                                : themeController
                                                                    .black500Color,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Gap(10);
                                              },
                                            ),
                                          ))
                            : const SizedBox(
                                height: 0,
                              ),
                      ),
                controller.doctorSpecialisationList.length == 1
                    ? const SizedBox(
                        height: 0,
                      )
                    : !widget.istopDoctors
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                Obx(() {
                  return controller.isDoctorListLoading.value ||
                          controller.isSpecialisationloading.value ||
                          controller.istopDoctorListLoading.value
                      ? Column(
                          children: [
                            Gap(5.h),
                            Container(
                                // color: Colors.black,
                                // height: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Lottie.asset(
                                    'assets/images/loader_doctors.json')),
                          ],
                        )
                      : controller.doctorsList.isEmpty
                          ? SizedBox(
                              width: 80.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppImageAsset(
                                    image: 'assets/images/no_doctors_image.png',
                                    width: 80.w,
                                    height: 40.h,
                                  ),
                                  Gap(5.h),
                                  AppText(
                                    textAlign: TextAlign.center,
                                    AppString
                                        .noDoctorAvailableUnderThisFiltertext,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: themeController.textSecondaryColor,
                                  )
                                ],
                              ))
                          : Obx(
                              () => NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (true) {
                                    if (notification is ScrollEndNotification &&
                                        notification.metrics.extentAfter == 0) {
                                      if (controller
                                              .isMoreDoctorsLoading.value ||
                                          controller
                                              .isDoctorListLoading.value) {
                                        return false;
                                      }
                                      controller.getAllDoctors(
                                        loadMore: true,
                                      );
                                    }
                                  }
                                  // else {
                                  //   if (notification is ScrollEndNotification &&
                                  //       notification.metrics.extentAfter == 0) {
                                  //     if (controller.isMoreTopDoctorsLoading.value ||
                                  //         controller.istopDoctorListLoading.value) {
                                  //       return false;
                                  //     }
                                  //     controller.getAllTopDoctors(
                                  //       loadMore: true,
                                  //     );
                                  //   }
                                  // }
                                  return false;
                                },
                                child: Expanded(
                                  child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.doctorsList.length,
                                      itemBuilder: (context, index) {
                                        DoctorsDetails doctorDetails =
                                            controller.doctorsList[index];
                                        //  controller.filteredList(doctorDetails.hospitalName??'');
                                        return GestureDetector(
                                          onTap: () {
                                            controller.doctorIndex = index;
                                            controller.selectedDoctor.value =
                                                controller
                                                        .doctorsList[controller
                                                            .doctorIndex!]
                                                        .id ??
                                                    '';

                                            controller.update();
                                            controller.getReviewsByDoctorId();
                                            Get.to(() =>
                                                const DoctorDetailsScreen());
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                10,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color.fromRGBO(
                                                  242,
                                                  255,
                                                  254,
                                                  1), //hexcode = #F2FFFE
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 16),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height: 130,
                                                    width: 130,
                                                    child: doctorDetails
                                                                    .userImageId ==
                                                                null ||
                                                            doctorDetails
                                                                .userImageId!
                                                                .isEmpty
                                                        ? const AppImageAsset(
                                                            image:
                                                                'assets/images/all_doctors_new.png',
                                                            fit: BoxFit.contain,
                                                          )
                                                        : AppImageAsset(
                                                            image:
                                                                '${doctorDetails.userImageId}',
                                                            fit: BoxFit.contain,
                                                          )),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0, 12, 16, 12),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: AppText(
                                                                doctorDetails
                                                                        .name ??
                                                                    '',
                                                                fontFamily:
                                                                    AppFont
                                                                        .openSans,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 18,
                                                                color: themeController
                                                                    .black500Color,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        AppText(
                                                          '${doctorDetails.specialization}',
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: themeController
                                                              .black100Color,
                                                        ),
                                                        const Gap(2),
                                                        AppText(
                                                          'Exp: ${doctorDetails.experience?.toInt()} years, ${doctorDetails.education?.join(', ')}',
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: themeController
                                                              .navShadow1,
                                                        ),
                                                        const Gap(2),
                                                        Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .local_hospital_outlined,
                                                                size: 20,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              const Gap(5),
                                                              Expanded(
                                                                child: AppText(
                                                                  doctorDetails
                                                                          .hospitalName ??
                                                                      '',
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: themeController
                                                                      .black100Color,
                                                                ),
                                                              ),
                                                            ]),
                                                        const Gap(2),
                                                        doctorDetails
                                                                    .consultationFees ==
                                                                null
                                                            ? const Gap(0)
                                                            : AppText(
                                                                '${AppString.consultationFeeText} : ${AppString.cashSymbol} ${doctorDetails.consultationFees?.toInt() ?? ''}',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: themeController
                                                                    .black500Color,
                                                              ),
                                                        const Gap(10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                bool userLogin =
                                                                    await isUserLogged();
                                                                if (userLogin) {
                                                                  controller
                                                                          .doctorIndex =
                                                                      index;
                                                                  controller
                                                                      .selectedDoctor
                                                                      .value = controller
                                                                          .doctorsList[
                                                                              controller.doctorIndex!]
                                                                          .id ??
                                                                      '';
                                                                  controller
                                                                      .update();
                                                                  Get.to(() =>
                                                                      const BookSlotsScreen());
                                                                }
                                                                //mysaa commented
                                                                // else {
                                                                //   Get.to(() =>
                                                                //       const AskLoginScreen());
                                                                // }
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                height: 28,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: themeController
                                                                        .primary200Color),
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      AppText(
                                                                    'Book',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    fontFamily:
                                                                        AppFont
                                                                            .openSans,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                doctorDetails
                                                                            .rating ==
                                                                        null
                                                                    ? const Gap(
                                                                        0)
                                                                    : const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color.fromRGBO(
                                                                            248,
                                                                            150,
                                                                            3,
                                                                            1),
                                                                        size:
                                                                            20,
                                                                      ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                AppText(
                                                                  '${doctorDetails.rating ?? ''}',
                                                                  fontFamily:
                                                                      AppFont
                                                                          .openSans,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: themeController
                                                                      .black500Color,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        //  for(int i=0;i<cardsController.offerCardFilteredList.length;i++)
                                                        //   AppText('Offer card available', color: themeController.black500Color,):Gap(0)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            );
                }),

                Obx(() => controller.isMoreDoctorsLoading.value
                    ? const Column(
                        children: [
                          Gap(10),
                          CircularProgressIndicator(),
                        ],
                      )
                    : const SizedBox()),
              ],
            )),
      );
    });
  }
}
