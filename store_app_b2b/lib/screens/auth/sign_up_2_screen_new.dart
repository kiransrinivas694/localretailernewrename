import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/components/common_primary_button_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_search_box.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_text_field.dart';
import 'package:store_app_b2b/screens/auth/search_screen_new.dart';
import 'package:store_app_b2b/utils/string_extensions_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

import '../../controllers/auth_controller/signup_controller_new.dart';

class NoLeadingSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      // Prevent input if the first character is a space
      return oldValue;
    }
    return newValue;
  }
}

class SignUp2Screen extends StatelessWidget {
  SignUp2Screen({Key? key}) : super(key: key);
  final SignupController signupController = Get.put(SignupController());
  final ThemeController themeController = Get.find();

  bool _isOpeningBeforeClosing(TimeOfDay? openingTime, TimeOfDay? closingTime) {
    if (openingTime == null || closingTime == null) return false;
    final int openingMinutes = openingTime.hour * 60 + openingTime.minute;
    final int closingMinutes = closingTime.hour * 60 + closingTime.minute;
    return openingMinutes < closingMinutes;
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(RegExp(r'[: ]'));
      final int hour = int.parse(parts[0]);
      final int minute = int.parse(parts[1]);
      final String period = parts[2];

      // Convert 12-hour time to 24-hour time
      final int adjustedHour = (period.toLowerCase() == 'pm' && hour != 12)
          ? hour + 12
          : (period.toLowerCase() == 'am' && hour == 12 ? 0 : hour);

      return TimeOfDay(hour: adjustedHour, minute: minute);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<SignupController>(
        init: SignupController(),
        initState: (state) async {
          await signupController.getDeliverySlots();
          if (signupController.storeLocationController.text.isEmpty) {
            signupController.showPincodeAndState.value = false;
            signupController.pincodeController.clear();
            signupController.stateController.clear();
          } else {
            signupController.showPincodeAndState.value = true;
          }
        },
        builder: (signupController) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/image/bg.png"),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.02),
                        Container(
                          height: height / 5.7,
                          width: width / 1.3,
                          alignment: Alignment.topLeft,
                          child: Image.asset("assets/image/text.png"),
                        ),
                        SizedBox(height: height * 0.03),
                        CommonTextField(
                          controller: signupController.documentController,
                          content: "Document Address*",
                          hintText: "Enter Address",
                          focusNode: signupController.documentFocus,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(255)
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.landmarkController,
                          content: "Landmark*",
                          hintText: "Enter Landmark",
                          focusNode: signupController.landmarkFocus,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100)
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.storeLocationController,
                          content: 'Store Location*',
                          hintText: 'Location Address*',
                          readOnly: true,
                          focusNode: signupController.storeAddressFocus,
                          onTap: () {
                            print(
                                'check latlng going lat -> ${signupController.latitude} lng - ${signupController.longitude}');
                            // if (signupController.latitude != null &&
                            //     signupController.latitude!.isNotEmpty &&
                            //     signupController.longitude != null &&
                            //     signupController.longitude!.isNotEmpty) {
                            //   Get.to(() => MapScreen(
                            //         latitude: signupController.latitude,
                            //         longitude: signupController.longitude,
                            //       ));
                            // } else {
                            Get.to(MapScreen());
                            // }
                          },
                        ),
                        //for testing purpose only
                        // IconButton(
                        //     onPressed: () {
                        //       signupController.storeLocationController.clear();
                        //       signupController.showPincodeAndState.value =
                        //           signupController
                        //                   .storeLocationController.text.isEmpty
                        //               ? false
                        //               : true;
                        //     },
                        //     icon: Icon(Icons.clear)),
                        Obx(() => signupController.showPincodeAndState.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height * 0.02),
                                  //   CommonText(
                                  //     content: "Additional Store Location Info",
                                  //     textColor: Colors.white,
                                  //     boldNess: FontWeight.w500,
                                  //   ),
                                  //   SizedBox(height: 4),
                                  //   TextFormField(
                                  //     controller:
                                  //         signupController.storeLocationInfoController,
                                  //     // readOnly: true,
                                  //     maxLength: 100,
                                  //     maxLines: 3,
                                  //     style: TextStyle(
                                  //       color: Colors.white,
                                  //     ),
                                  //     cursorColor: Colors.white,
                                  //     decoration: InputDecoration(
                                  //       counterText: "",
                                  //       hintText: 'Info Of Address:',
                                  //       hintStyle: TextStyle(color: Colors.white),
                                  //       border: InputBorder.none,
                                  //       enabledBorder: OutlineInputBorder(
                                  //         borderRadius:
                                  //             const BorderRadius.all(Radius.circular(6)),
                                  //         borderSide: BorderSide(
                                  //           color: Colors.white,
                                  //           width: 1,
                                  //         ),
                                  //       ),
                                  //       focusedBorder: OutlineInputBorder(
                                  //         borderRadius:
                                  //             const BorderRadius.all(Radius.circular(8)),
                                  //         borderSide:
                                  //             BorderSide(color: Colors.white, width: 1),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   SizedBox(height: height * 0.02),
                                  CommonTextField(
                                    controller:
                                        signupController.pincodeController,
                                    content: 'Pincode*',
                                    hintText: 'Pincode',
                                    focusNode: signupController.pincodeFocus,
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                  // SizedBox(height: height * 0.02),
                                  CommonTextField(
                                    controller:
                                        signupController.stateController,
                                    content: 'State*',
                                    hintText: 'State',
                                    focusNode: signupController.stateFocus,
                                    maxLines: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z\s]')),
                                      NoLeadingSpaceInputFormatter(), // Allows only alphabets and spaces
                                    ],
                                  ),
                                ],
                              )
                            : SizedBox()),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.dealsInController,
                          content: 'Deals in',
                          hintText: "",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(500)
                          ],
                          focusNode: signupController.dealsInFocus,
                        ),
                        SizedBox(height: height * 0.02),
                        CommonTextField(
                          controller: signupController.popularController,
                          content: 'Popular in',
                          hintText: "",
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(500)
                          ],
                          focusNode: signupController.popularFocus,
                        ),
                        SizedBox(height: height * 0.02),
                        const CommonText(
                            content: 'Slots*',
                            textColor: ColorsConst.appWhite,
                            boldNess: FontWeight.w600),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                signupController.deliverySlotsList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: AppText(
                                    signupController
                                        .deliverySlotsList[index].slotName
                                        .toString(),
                                    color: ColorsConst.appWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                signupController.deliverySlotsList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: AppText(
                                    ' : ${signupController.deliverySlotsList[index].startTime} - ${signupController.deliverySlotsList[index].endTime}',
                                    color: ColorsConst.appWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                signupController.deliverySlotsList.length,
                                (index) => InkWell(
                                  onTap: () {
                                    signupController.deliverySlotsList[index]
                                            .isChecked =
                                        !signupController
                                            .deliverySlotsList[index].isChecked;
                                    signupController.update();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: signupController
                                              .deliverySlotsList[index]
                                              .isChecked
                                          ? ColorsConst.primaryColor
                                          : ColorsConst.appWhite,
                                      // border: Border.all(
                                      //     color: ColorsConst.appWhite,
                                      //     width: 1),
                                    ),
                                    child: const Icon(Icons.done,
                                        color: ColorsConst.appWhite),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              confirmText: 'Confirm',
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor:
                                        ColorsConst.greenColor,
                                    colorScheme: ColorScheme.light(
                                      primary: ColorsConst.primaryColor,
                                      onSurface: ColorsConst.textColor,
                                    ),
                                    // fontFamily: AppAssets.defaultFont,
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            signupController.storeOpeningController.text =
                                time!.format(Get.context!);

                            if (signupController
                                .storeClosingController.text.isNotEmpty) {
                              final TimeOfDay? closingTime = _parseTime(
                                  signupController.storeClosingController.text);

                              if (!_isOpeningBeforeClosing(time, closingTime)) {
                                'Opening time must be earlier than the closing time.'
                                    .showError();
                                signupController.storeOpeningController.clear();
                              }
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const CommonText(
                                    content: 'Store opening time*',
                                    textColor: ColorsConst.appWhite),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.greyBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      focusNode:
                                          signupController.storeOpeningFocus,
                                      controller: signupController
                                          .storeOpeningController,
                                      readOnly: true,
                                      style: const TextStyle(
                                          color: ColorsConst.appWhite),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              confirmText: 'Confirm',
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor: ColorsConst.appWhite,
                                    colorScheme: ColorScheme.light(
                                      primary: ColorsConst.primaryColor,
                                      onSurface: ColorsConst.textColor,
                                    ),
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            signupController.storeClosingController.text =
                                time!.format(Get.context!);

                            if (signupController
                                .storeOpeningController.text.isNotEmpty) {
                              final TimeOfDay? openingTime = _parseTime(
                                  signupController.storeOpeningController.text);

                              if (!_isOpeningBeforeClosing(openingTime, time)) {
                                'Closing time must be later than the opening time.'
                                    .showError();
                                signupController.storeClosingController.clear();
                              }
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const AppHeaderText(
                                    headerText: 'Store closing time*',
                                    headerColor: ColorsConst.appWhite),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.greyBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      focusNode:
                                          signupController.storeClosingFocus,
                                      controller: signupController
                                          .storeClosingController,
                                      readOnly: true,
                                      style: const TextStyle(
                                          color: ColorsConst.appWhite),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 100, 1),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              helpText: 'Your Birth date',
                              confirmText: 'okay',
                              cancelText: 'cancel',
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor:
                                        ColorsConst.textColor,
                                    colorScheme: ColorScheme.light(
                                      primary: ColorsConst.primaryColor,
                                      onSurface: ColorsConst.appWhite,
                                    ),
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              final currentDate = DateTime.now();
                              final age = currentDate.year -
                                  picked.year -
                                  ((currentDate.month < picked.month ||
                                          (currentDate.month == picked.month &&
                                              currentDate.day < picked.day))
                                      ? 1
                                      : 0);

                              // If the age is less than 18
                              if (age < 18) {
                                print("Less than 18 years");
                                'You must be at least 18 years old.'
                                    .showError();
                                return;
                              } else {
                                signupController.birthDateController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }
                              // signupController.birthDateController.text =
                              //     DateTimeUtils.getFormattedDateTime(picked);
                              // signupController.update();
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const AppHeaderText(
                                    headerText: 'Your Birth date :',
                                    headerColor: ColorsConst.appWhite),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.greyBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller:
                                          signupController.birthDateController,
                                      readOnly: true,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: ColorsConst.appWhite),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 100, 1),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              helpText: 'Wedding aniversary date',
                              confirmText: 'okay',
                              cancelText: 'cancel',
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor: ColorsConst.appWhite,
                                    colorScheme: ColorScheme.light(
                                      primary: ColorsConst.primaryColor,
                                      onSurface: ColorsConst.textColor,
                                    ),
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              if (signupController
                                  .birthDateController.text.isNotEmpty) {
                                // Parse the birth date string back to a DateTime object
                                DateTime birthDate = DateTime.parse(
                                    signupController.birthDateController.text);

                                // Check if the selected date is after the birth date
                                if (picked.isAfter(birthDate)) {
                                  signupController
                                          .weddingAniversaryController.text =
                                      DateTimeUtils.getFormattedDateTime(
                                          picked);
                                  signupController.update();
                                } else {
                                  // Show an error if the anniversary is before the birth date
                                  'Wedding anniversary date must be after the birth date.'
                                      .showError();
                                }
                              } else {
                                // If no birth date is set, just update the wedding anniversary
                                signupController
                                        .weddingAniversaryController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }
                              // signupController
                              //         .weddingAniversaryController.text =
                              //     DateTimeUtils.getFormattedDateTime(picked);
                              // signupController.update();
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const AppHeaderText(
                                    headerText: 'Wedding aniversary date :',
                                    headerColor: ColorsConst.appWhite),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.greyBgColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextFormField(
                                      controller: signupController
                                          .weddingAniversaryController,
                                      readOnly: true,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: ColorsConst.appWhite),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 100, 1),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              helpText: 'Child 1 Birth date',
                              confirmText: 'okay',
                              cancelText: 'cancel',
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor: ColorsConst.appWhite,
                                    colorScheme: ColorScheme.light(
                                      primary: ColorsConst.primaryColor,
                                      onSurface: ColorsConst.textColor,
                                    ),
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              if (signupController
                                  .birthDateController.text.isNotEmpty) {
                                DateTime birthDate = DateTime.parse(
                                    signupController.birthDateController.text);

                                if (picked.isAfter(birthDate)) {
                                  signupController.childOneController.text =
                                      DateTimeUtils.getFormattedDateTime(
                                          picked);
                                  signupController.update();
                                } else {
                                  'Child 1 birth date must be after the birth date.'
                                      .showError();
                                }
                              } else {
                                signupController.childOneController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }

                              // signupController.childOneController.text =
                              //     DateTimeUtils.getFormattedDateTime(picked);
                              // signupController.update();
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const AppHeaderText(
                                    headerText: 'Child 1 Birth date :',
                                    headerColor: ColorsConst.appWhite),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.greyBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller:
                                          signupController.childOneController,
                                      readOnly: true,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: ColorsConst.appWhite),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 100, 1),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              helpText: 'Child 2 Birth date',
                              confirmText: 'okay',
                              cancelText: 'cancel',
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor: ColorsConst.appWhite,
                                    colorScheme: ColorScheme.light(
                                      primary: ColorsConst.primaryColor,
                                      onSurface: ColorsConst.textColor,
                                    ),
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              if (signupController
                                  .birthDateController.text.isNotEmpty) {
                                DateTime birthDate = DateTime.parse(
                                    signupController.birthDateController.text);

                                if (picked.isAfter(birthDate)) {
                                  signupController.childTwoController.text =
                                      DateTimeUtils.getFormattedDateTime(
                                          picked);
                                  signupController.update();
                                } else {
                                  'Child 2 birth date must be after the birth date.'
                                      .showError();
                                }
                              } else {
                                signupController.childTwoController.text =
                                    DateTimeUtils.getFormattedDateTime(picked);
                                signupController.update();
                              }

                              // signupController.childTwoController.text =
                              //     DateTimeUtils.getFormattedDateTime(picked);
                              // signupController.update();
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: width / 2,
                                child: const AppHeaderText(
                                    headerText: 'Child 2 Birth date :',
                                    headerColor: ColorsConst.appWhite),
                              ),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsConst.greyBgColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller:
                                          signupController.childTwoController,
                                      readOnly: true,
                                      style: const TextStyle(
                                          color: ColorsConst.appWhite,
                                          fontSize: 13),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorsConst.appWhite, width: 0.5)),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: const AppHeaderText(
                                  headerText: 'Delivery strength',
                                  headerColor: ColorsConst.appWhite),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorsConst.greyBgColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: signupController
                                      .deliveryStrengthController,
                                  style: const TextStyle(
                                      color: ColorsConst.appWhite),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const AppHeaderText(
                            headerText: 'Message from retailer to customer',
                            headerColor: ColorsConst.appWhite),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorsConst.greyBgColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: signupController.messageController,
                            maxLength: 200,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            maxLines: 5,
                            style: const TextStyle(color: ColorsConst.appWhite),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        CommonPrimaryButton(
                          text: "Register",
                          onTap: () {
                            signupController.registerTowUser();
                            // Get.to(() => MobileNoScreen());
                          },
                        ),
                        SizedBox(height: height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class MapScreen extends StatelessWidget {
  MapScreen({Key? key, this.status, this.latitude, this.longitude})
      : super(key: key);

  String? latitude;
  String? longitude;

  String? status = "";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<MapController>(
      init: MapController(),
      initState: (state) {
        Future.delayed(
          const Duration(microseconds: 300),
          () {
            final mapController = Get.find<MapController>();
            mapController.bodyMap = Get.parameters;
            mapController.update();

            if (latitude != null &&
                longitude != null &&
                latitude!.isNotEmpty &&
                longitude!.isNotEmpty) {
              mapController.getCurrentLocation(
                  latitude: latitude, longitude: longitude);
            } else {
              mapController.getCurrentLocation();
            }
          },
        );
      },
      builder: (MapController mapController) {
        return Scaffold(
          appBar: AppBar(
            title: CommonText(
              content:
                  status == "testAddress" ? 'My Location' : 'My Store Location',
              boldNess: FontWeight.w600,
              textSize: width * 0.047,
            ),
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff2F394B),
                    Color(0xff090F1A),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Stack(
                    children: [
                      AppSearchBox(
                        textEditingController:
                            mapController.addressSearchController,
                      ),
                      Positioned.fill(
                          child: GestureDetector(
                        onTap: () async {
                          var result = await Get.to(() => SearchScreen(
                                searchText:
                                    mapController.addressSearchController.text,
                              ));
                          if (result != null) {
                            mapController.addressSearchController.text = result;

                            mapController.fetchCoordinates(result);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ))
                    ],
                  ),
                ),
                Gap(20),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      !mapController.isLoading
                          ? GoogleMap(
                              myLocationEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                mapController.mapController.value = controller;
                              },
                              onTap: (argument) async {
                                print(mapController.bodyMap);
                                if (mapController.bodyMap.isEmpty) {
                                  mapController.markers.first.position.latitude;

                                  await mapController.manageMarker(LatLng(
                                      argument.latitude, argument.longitude));
                                  LatLng(argument.latitude, argument.longitude);
                                }
                              },
                              initialCameraPosition:
                                  //  mapController.initialCameraPosition.value,
                                  CameraPosition(
                                target: mapController.bodyMap.isEmpty
                                    ? (latitude != null &&
                                            longitude != null &&
                                            latitude!.isNotEmpty &&
                                            longitude!.isNotEmpty)
                                        ? LatLng(double.parse(latitude!),
                                            double.parse(longitude!))
                                        : LatLng(
                                            mapController.position!.latitude,
                                            mapController.position!.longitude)
                                    : LatLng(
                                        double.parse(
                                            mapController.bodyMap['latitude']),
                                        double.parse(mapController
                                            .bodyMap['longitude'])),
                                zoom: 12,
                              ),
                              zoomControlsEnabled: false,
                              markers: mapController.markers,
                            )
                          : const SizedBox(),
                      mapController.isLoading
                          ? const SizedBox()
                          : Container(
                              height: height / 7,
                              width: width,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const AppImageAsset(
                                      image: "assets/icons/map_marker.svg",
                                      height: 20,
                                      width: 16),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          content:
                                              mapController.address?.name ?? '',
                                          boldNess: FontWeight.bold,
                                          textSize: 18,
                                          textColor: ColorsConst.textColor,
                                        ),
                                        CommonText(
                                          content:
                                              '${mapController.address?.street ?? ''}, ${mapController.address?.locality ?? ''}, ${mapController.address?.subLocality ?? ''}, ${mapController.address?.postalCode ?? ''}, ${mapController.address?.country ?? ''}',
                                          boldNess: FontWeight.w400,
                                          textSize: 14,
                                          textColor: ColorsConst.textColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      if (mapController.isLoading)
                        Center(
                            child: CircularProgressIndicator(
                                color: ColorsConst.primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: InkWell(
              onTap: () {
                if (mapController.bodyMap.isNotEmpty) {
                  Get.back();
                  return;
                }
                if (status == "testAddress") {
                  final editProfileController =
                      Get.find<SampleCollectionController>();
                  editProfileController.addressController.text =
                      '${mapController.address!.street ?? ''}, ${mapController.address!.locality ?? ''}, ${mapController.address!.subLocality ?? ''}, ${mapController.address!.postalCode ?? ''}, ${mapController.address!.country ?? ''}';
                  editProfileController.latitude =
                      mapController.markers.first.position.latitude.toString();
                  editProfileController.longitude =
                      mapController.markers.first.position.longitude.toString();
                  print(editProfileController.latitude);
                  print(editProfileController.longitude);
                  editProfileController.update();
                  print(editProfileController.addressController.text);
                  Get.back();
                } else {
                  final onboardController = Get.find<SignupController>();
                  onboardController.storeLocationController.text =
                      '${mapController.address!.street ?? ''}, ${mapController.address!.locality ?? ''}, ${mapController.address!.subLocality ?? ''}, ${mapController.address!.postalCode ?? ''}, ${mapController.address!.country ?? ''}';
                  onboardController.latitude =
                      mapController.markers.first.position.latitude.toString();
                  onboardController.longitude =
                      mapController.markers.first.position.longitude.toString();
                  onboardController.pincodeController.text =
                      mapController.address!.postalCode ?? '';
                  onboardController.stateController.text =
                      mapController.address!.administrativeArea ?? '';
                  onboardController.showPincodeAndState.value =
                      onboardController.storeLocationController.text.isEmpty
                          ? false
                          : true;
                  print(onboardController.latitude);
                  print(onboardController.longitude);
                  Get.back();
                }
              },
              child: Container(
                height: mapController.isLoading ? 0 : 48,
                margin: const EdgeInsets.only(right: 22, left: 22, bottom: 22),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: status == "testAddress"
                      ? ThemeController().navShadow1
                      : ColorsConst.yellowColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CommonText(
                  content: mapController.bodyMap.isNotEmpty
                      ? 'Back to store'
                      : 'Confirm location',
                  textSize: 18,
                  boldNess: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? letterSpacing;

  const AppText(
    this.title, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? Colors.white,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize ?? 14,
        height: height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        decorationColor: decorationColor,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

class AppHeaderText extends StatelessWidget {
  final String headerText;
  final Color headerColor;

  const AppHeaderText(
      {Key? key, required this.headerText, required this.headerColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: AppText(
        headerText,
        color: headerColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DateTimeUtils {
  static String getFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static String getFormattedDateTimeInddmmyyyyFormat(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}
