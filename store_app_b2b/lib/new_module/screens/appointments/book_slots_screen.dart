import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_table_calender.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';

class BookSlotsScreen extends StatefulWidget {
  const BookSlotsScreen({super.key});

  // final bool reBook;

  @override
  State<BookSlotsScreen> createState() => _BookSlotsScreenState();
}

class _BookSlotsScreenState extends State<BookSlotsScreen> {
  BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());

  globalCurrentTime() async {
    DateTime currentTime = await NTP.now();
    String formattedTime = DateFormat('HHmm').format(currentTime);
    controller.currentTime = int.parse(formattedTime);
  }

  @override
  void initState() {
    controller.selectedDate = null;
    controller.selectedtimeIndex = -1;
    controller.selectedTime = '';
    controller.selectedDoctorName.value = '';
    controller.nameController.clear();
    controller.dobController.clear();
    controller.ageController.clear();
    controller.weightController.clear();
    controller.heightController.clear();
    controller.phoneNumberController.clear();
    controller.selectedRelationValue = null;
    controller.selectedGenderValue = null;
    controller.getRelationList();
    super.initState();
    globalCurrentTime();
    // controller.update();
  }

  List<int> dayOfWeekList = [];

  List<DateTime> days = [
    DateTime(2023, 1, 1), // Sunday
    DateTime(2023, 1, 2), // Monday
    DateTime(2023, 1, 3), // Tuesday
    DateTime(2023, 1, 4), // Wednesday
    DateTime(2023, 1, 5), // Thursday
    DateTime(2023, 1, 6), // Friday
    DateTime(2023, 1, 7), // Saturday
  ];

  void daysList() {
    if (!controller.rebook) {
      if (controller.doctorsList[controller.doctorIndex!].days != null) {
        for (int i = 0;
            i < controller.doctorsList[controller.doctorIndex!].days!.length;
            i++) {
          if (controller.doctorsList[controller.doctorIndex!].days![i] == '1') {
            dayOfWeekList.add(days[i].weekday);
          }
        }
      } else {
        dayOfWeekList = [1, 2, 3, 4, 5, 6];
      }
    } else {
      if (controller.doctorDetails.value?.days != null) {
        for (int i = 0; i < controller.doctorDetails.value!.days!.length; i++) {
          if (controller.doctorDetails.value?.days![i] == '1') {
            dayOfWeekList.add(days[i].weekday);
          }
        }
      } else {
        dayOfWeekList = [1, 2, 3, 4, 5, 6];
      }
    }
  }

  void slotsList() {
    DateTime currentTime = DateTime.now();
    if (!controller.rebook) {
      controller.doctorsList[controller.doctorIndex!].slots!
          .sort((a, b) => a.displayOrder!.compareTo(b.displayOrder!));
      if (controller.dateFormat.format(controller.selectedDate!) ==
          controller.dateFormat.format(currentTime)) {
        for (var i in controller.doctorsList[controller.doctorIndex!].slots!) {
          // var a = int.parse(i.slotName!);
          if (int.parse(i.slotName!) > controller.currentTime!) {
            controller.slots.add(i);
            controller.update();
          }
        }
      } else {
        for (var i in controller.doctorsList[controller.doctorIndex!].slots!) {
          controller.slots.add(i);
          controller.update();
        }
      }
    } else {
      controller.doctorDetails.value?.slots!
          .sort((a, b) => a.displayOrder!.compareTo(b.displayOrder!));
      if (controller.dateFormat.format(controller.selectedDate!) ==
          controller.dateFormat.format(currentTime)) {
        for (var i in controller.doctorDetails.value!.slots!) {
          // var a = int.parse(i.slotName!);
          if (int.parse(i.slotName!) > controller.currentTime!) {
            controller.slots.add(i);
            controller.update();
          }
        }
      } else {
        for (var i in controller.doctorDetails.value!.slots!) {
          controller.slots.add(i);
          controller.update();
        }
      }
    }
  }

  // List<String> demoTimes = [
  //   "09:00 AM",
  //   "09:30 AM",
  //   "10:00 AM",
  //   "10:30 AM",
  //   "11:00 AM",
  //   "11:30 AM",
  //   "03:00 PM",
  //   "03:30 PM",
  //   "04:00 PM",
  //   "04:30 PM",
  //   "05:00 PM",
  //   "05:30 PM",
  // ];
  PageController pageController = PageController();
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BooikingAppointmentController>(initState: (state) {
      Future.delayed(Duration(milliseconds: 250), () {
        daysList();
      });
    },
        // init: BooikingAppointmentController(),
        builder: (_) {
      if (controller.rebook) {
        controller.selectedDoctor.value =
            controller.doctorDetails.value?.id ?? '';
        controller.selectedDoctorName.value =
            controller.doctorDetails.value?.name ?? '';
        controller.doctorEducation.value =
            controller.doctorDetails.value?.education?.join(', ') ?? '';
        controller.doctorImageUrl.value =
            controller.doctorDetails.value?.userImageId ?? '';
        controller.hospitalName.value =
            controller.doctorDetails.value?.hospitalName ?? '';
        controller.doctorExperience.value =
            controller.doctorDetails.value?.experience.toString() ?? '';
        controller.specializationId.value =
            controller.doctorDetails.value?.specializationId ?? '';
        controller.specialization.value =
            controller.doctorDetails.value?.specialization ?? '';
        controller.hospitalId.value =
            controller.doctorDetails.value?.hospitalId ?? '';
        controller.languages.value =
            controller.doctorDetails.value?.languages?.join(', ') ?? '';
        controller.consultationFees.value =
            controller.doctorDetails.value?.consultationFees.toString() ?? '';
      } else {
        controller.selectedDoctor.value =
            controller.doctorsList[controller.doctorIndex!].id ?? '';
        controller.selectedDoctorName.value =
            controller.doctorsList[controller.doctorIndex!].name ?? '';
        controller.doctorEducation.value = controller
                .doctorsList[controller.doctorIndex!].education
                ?.join(', ') ??
            '';
        controller.doctorImageUrl.value =
            controller.doctorsList[controller.doctorIndex!].userImageId ?? '';
        controller.hospitalName.value =
            controller.doctorsList[controller.doctorIndex!].hospitalName ?? '';
        controller.doctorExperience.value = controller
            .doctorsList[controller.doctorIndex!].experience
            .toString();
        controller.specializationId.value =
            controller.doctorsList[controller.doctorIndex!].specializationId ??
                '';
        controller.specialization.value =
            controller.doctorsList[controller.doctorIndex!].specialization ??
                '';
        controller.hospitalId.value =
            controller.doctorsList[controller.doctorIndex!].hospitalId ?? '';
        controller.languages.value = controller
                .doctorsList[controller.doctorIndex!].languages
                ?.join(', ') ??
            '';
        controller.consultationFees.value = controller
            .doctorsList[controller.doctorIndex!].consultationFees
            .toString();
      }
      return SafeArea(
        child: Scaffold(
          appBar: const AppAppBar(
            title: '   Book Slots',
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  AppText(
                    'Select Date',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: themeController.black500Color,
                  ),
                  // Gap(10),
                  AppTableCalendar(
                    pageController: pageController,
                    slotsList: slotsList,
                  ),
                  const Gap(15),
                  AppText(
                    'Select Timings',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: themeController.black500Color,
                  ),
                  const Gap(10),
                  controller.selectedDate != null
                      ? controller.slots.isNotEmpty &&
                              dayOfWeekList
                                  .contains(controller.selectedDate!.weekday)
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 0,
                                mainAxisExtent: 40,
                              ),
                              itemCount: controller.slots.length,
                              shrinkWrap: true,
                              // padding: EdgeInsets.symmetric(horizontal: 0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      controller.selectedtimeIndex = index;
                                      controller.slot = controller
                                          .slots[controller.selectedtimeIndex];
                                      if (!controller.rebook) {
                                        controller.selectedTime =
                                            '${controller.doctorsList[controller.doctorIndex!].slots?[index].startTime} - ${controller.doctorsList[controller.doctorIndex!].slots?[index].endTime}'
                                            '';
                                      } else {
                                        controller.selectedTime =
                                            '${controller.doctorDetails.value!.slots?[index].startTime} - ${controller.doctorDetails.value!.slots?[index].endTime}'
                                            '';
                                      }
                                      logs(controller.selectedTime);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.selectedtimeIndex == index
                                              ? themeController.nav1
                                              : null,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: AppText(
                                      '${controller.slots[index].startTime} - ${controller.slots[index].endTime}',
                                      color:
                                          controller.selectedtimeIndex == index
                                              ? themeController.textPrimaryColor
                                              : themeController.black100Color,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFont.montserrat,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: AppText(
                                  textAlign: TextAlign.center,
                                  'No Slots available for the selected date...!',
                                  color: themeController.black500Color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: AppText(
                              textAlign: TextAlign.center,
                              ' Please select date...!',
                              color: themeController.black500Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                  const Gap(15),
                  GestureDetector(
                    onTap: () {
                      controller.chechValidationDateAndTime();
                      logs('time -> ${controller.selectedTime}');
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: themeController.primary500Color,
                      ),
                      child: AppText(
                        'Next',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: themeController.textPrimaryColor,
                      ), //inter
                    ),
                  ),
                  const Gap(15),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
