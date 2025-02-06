import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/model/appointment/reviews_by_id.dart';
import 'package:store_app_b2b/new_module/screens/appointments/book_slots_screen.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  final ThemeController themeController = Get.find();
  bool taped = false;
  int initialReviews = 1;
  BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());

  @override
  Widget build(BuildContext context) {
    // DoctorsDetails _doctorsDetails =
    //     controller.doctorsList[controller.doctorIndex!];
    controller.selectedDoctor.value =
        controller.doctorsList[controller.doctorIndex!].id ?? '';
    controller.selectedDoctorName.value =
        controller.doctorsList[controller.doctorIndex!].name ?? '';

    return SafeArea(
      child: Scaffold(
        appBar: const AppAppBar(
          title: 'Doctor Profile',
        ),
        // bottomNavigationBar: AppBottomBar(
        //   index: 3,
        //   useIndexFromController: false,
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(3),
                Container(
                  padding: const EdgeInsets.only(bottom: 1, left: 15),
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.bottomCenter,
                  // height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: themeController.textPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 10),
                        blurRadius: 15,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => SizedBox(
                            height: 120,
                            width: 110,
                            child: controller
                                            .doctorsList[
                                                controller.doctorIndex!]
                                            .userImageId ==
                                        null ||
                                    controller
                                        .doctorsList[controller.doctorIndex!]
                                        .userImageId!
                                        .isEmpty
                                ? const AppImageAsset(
                                    image: 'assets/images/all_doctors_new.png',
                                    fit: BoxFit.contain,
                                  )
                                : AppImageAsset(
                                    image: controller
                                            .doctorsList[
                                                controller.doctorIndex!]
                                            .userImageId ??
                                        '')),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => AppText(
                              controller.doctorsList[controller.doctorIndex!]
                                      .name ??
                                  '',
                              fontFamily: AppFont.poppins,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: themeController.black500Color,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 0.5,
                            color: themeController.black75Color,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => AppText(
                                '${controller.doctorsList[controller.doctorIndex!].specialization} | ${controller.doctorsList[controller.doctorIndex!].experience?.toInt() ?? '2'} years Exp | ${controller.doctorsList[controller.doctorIndex!].education != null && controller.doctorsList[controller.doctorIndex!].education!.isNotEmpty ? controller.doctorsList[controller.doctorIndex!].education!.join(", ") : ""}',
                                fontFamily: AppFont.poppins,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: themeController.black100Color,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: controller
                                    .doctorsList[controller.doctorIndex!]
                                    .languages!
                                    .isEmpty
                                ? const Gap(0)
                                : Row(
                                    children: [
                                      const AppImageAsset(
                                        image: 'assets/images/languages.png',
                                        height: 16,
                                        width: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Obx(
                                          () => AppText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            // '${controller.doctorsList[controller.doctorIndex!].address?.addressLine1}, ${controller.doctorsList[controller.doctorIndex!].address?.city}',
                                            '${controller.doctorsList[controller.doctorIndex!].languages?.join(', ')}',
                                            fontFamily: AppFont.poppins,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            color:
                                                themeController.black100Color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          controller.doctorsList[controller.doctorIndex!]
                                      .hospitalName !=
                                  null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Obx(
                                    () => AppText(
                                      // '${controller.doctorsList[controller.doctorIndex!].address?.addressLine1}, ${controller.doctorsList[controller.doctorIndex!].address?.city}',
                                      '${controller.doctorsList[controller.doctorIndex!].hospitalName}',
                                      fontFamily: AppFont.poppins,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.sp,
                                      color: themeController.black100Color,
                                    ),
                                  ),
                                )
                              : const Gap(0),
                          const Gap(10),
                        ],
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                controller.doctorsList[controller.doctorIndex!].about == null ||
                        controller
                            .doctorsList[controller.doctorIndex!].about!.isEmpty
                    ? const Gap(0)
                    : Column(
                        children: [
                          AppText('About me',
                              textAlign: TextAlign.start,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: themeController.black500Color),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                controller.doctorsList[controller.doctorIndex!].about == null ||
                        controller
                            .doctorsList[controller.doctorIndex!].about!.isEmpty
                    ? const Gap(0)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                            Obx(
                              () => !taped
                                  ? AppText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      '${controller.doctorsList[controller.doctorIndex!].about}',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: themeController.black100Color)
                                  : AppText(
                                      // 'Dr. David Patel, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.',
                                      controller
                                              .doctorsList[
                                                  controller.doctorIndex!]
                                              .about ??
                                          '',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: themeController.black100Color),
                            ),
                            controller.doctorsList[controller.doctorIndex!]
                                        .about!.length >
                                    150
                                ? !taped
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            taped = true;
                                          });
                                        },
                                        child: AppText('view more',
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color:
                                                themeController.black500Color),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            taped = false;
                                          });
                                        },
                                        child: AppText('view less',
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color:
                                                themeController.black500Color),
                                      )
                                : const Gap(0)
                          ]),
                const Gap(10),
                Obx(() =>
                    controller.doctorsList[controller.doctorIndex!].education !=
                                null &&
                            controller.doctorsList[controller.doctorIndex!]
                                .education!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText('Education',
                                  textAlign: TextAlign.start,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: themeController.black500Color),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => AppText(
                                    controller
                                        .doctorsList[controller.doctorIndex!]
                                        .education!
                                        .join(", "),
                                    textAlign: TextAlign.start,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: themeController.black100Color),
                              ),
                            ],
                          )
                        : const SizedBox()),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    // Get.to(() => BookSlotsScreen());
                    bool userLogin = await isUserLogged();
                    if (userLogin) {
                      Get.to(() => const BookSlotsScreen());
                    }
                    //mysaa commented
                    //  else {
                    //   Get.to(() => const AskLoginScreen());
                    // }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: themeController.primary500Color),
                    child: const AppText(
                      //inter
                      'Book Appointment',
                      textAlign: TextAlign.center,
                      fontFamily: AppFont.openSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                controller.reviewsList.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            //inter
                            'Reviews',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: themeController.black500Color,
                          ),
                          controller.reviewsList.length > 1 &&
                                  initialReviews ==
                                      controller.reviewsList.length
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      initialReviews =
                                          controller.reviewsList.length;
                                    });
                                  },
                                  child: AppText(
                                    //inter
                                    'See all',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: themeController.black100Color,
                                  ),
                                )
                              : const Gap(0)
                        ],
                      )
                    : const Gap(0),
                const SizedBox(
                  height: 20,
                ),
                controller.reviewsList.isNotEmpty
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: initialReviews,
                        separatorBuilder: (context, index) {
                          return const Gap(20);
                        },
                        itemBuilder: (context, index) {
                          ReviewDetails reviewDetails =
                              controller.reviewsList[index];
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(
                                            '${reviewDetails.reviewerImageId}')),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            //inter
                                            reviewDetails.reviewerName ?? '',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color:
                                                themeController.black500Color,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              AppText(
                                                '${reviewDetails.rating ?? ''}',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromRGBO(
                                                    85, 85, 85, 1),
                                              ),
                                              const SizedBox(width: 5),
                                              RatingBarIndicator(
                                                rating: reviewDetails.rating
                                                        ?.toDouble() ??
                                                    0,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 15.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                //inter
                                AppText(
                                  reviewDetails.review ?? '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: themeController.black100Color,
                                )
                              ],
                            ),
                          );
                        })
                    : const Gap(0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
