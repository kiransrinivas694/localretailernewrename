import 'dart:math';

import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller_new.dart';

import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_dropdown_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_text_field_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/service/api_service_new.dart';

class SampleCollectionScreen extends StatefulWidget {
  SampleCollectionScreen({super.key, required this.homeCollection});
  final bool homeCollection;
  final ThemeController themeController = Get.find();
  @override
  State<SampleCollectionScreen> createState() => _SampleCollectionScreen();
}

class _SampleCollectionScreen extends State<SampleCollectionScreen> {
  final SampleCollectionController sampleCollectionController =
      Get.put(SampleCollectionController());
  CartLabtestController cartController = Get.put(CartLabtestController());
  final GlobalMainController globalController = Get.put(GlobalMainController());
  BooikingAppointmentController reportsController =
      Get.put(BooikingAppointmentController());
  @override
  void initState() {
    BooikingAppointmentController reportsController =
        Get.put(BooikingAppointmentController());
    reportsController.getRelationList();
    cartController.getDiagnosticCartData(
        homeCollection: widget.homeCollection ? "1" : "0");
    cartController.getTestUserDetails(
        isHomeCollection: widget.homeCollection ? "1" : "0");
    sampleCollectionController.getAllBranches();

    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  String isoFormatDate = '';
  void showDatePicker(bool homeTest) {
    DateTime now = DateTime.now();

    if (selectedDate.isBefore(now)) {
      selectedDate = now;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: 85.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      initialDateTime: selectedDate,
                      minimumDate: now,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                      mode: CupertinoDatePickerMode.dateAndTime,
                      use24hFormat: false,
                      minuteInterval: 1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (homeTest
                        ? selectedDate.hour >= 06 && selectedDate.hour < 15
                        : selectedDate.hour >= 10 && selectedDate.hour < 20) {
                      setState(() {
                        String isoFormatDate = selectedDate.toIso8601String();
                        sampleCollectionController.appointmentController.text =
                            isoFormatDate;
                        logs("Formatted date is $isoFormatDate");
                        String formattedDate = DateFormat('yyyy-MM-dd hh:mm a')
                            .format(selectedDate);
                        sampleCollectionController.displayedAppointmentDate =
                            formattedDate;
                      });
                      Navigator.of(context).pop();
                    } else {
                      customFailureToast(
                          content: homeTest
                              ? "Time range must be between 6AM - 3PM"
                              : "Time range must be between 10AM - 8PM");
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                        color: widget.themeController.nav1,
                        borderRadius: BorderRadius.circular(8)),
                    child: AppText(
                      'Done',
                      fontFamily: AppFont.poppins,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: widget.themeController.textPrimaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showCancelDialog(BuildContext context, String serviceCd) {
    showDialog(
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
                        Get.back();
                      },
                      child: Container(
                        width: 16.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: themeController.navShadow1,
                        ),
                        child: Center(
                          child: AppText(
                            "No",
                            fontFamily: AppFont.poppins,
                            color: themeController.textPrimaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cartController.deleteCartTest(
                            serviceCd: serviceCd,
                            hv: widget.homeCollection ? "1" : "0");
                        cartController.getTestUserDetails(
                            isHomeCollection:
                                widget.homeCollection ? "1" : "0");
                        Get.back();
                        Get.back();
                      },
                      child: Container(
                        width: 16.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: themeController.navShadow1,
                        ),
                        child: Center(
                          child: AppText(
                            "Yes",
                            fontFamily: AppFont.poppins,
                            color: themeController.textPrimaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                          ),
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
    formattedDates(String date) {
      DateFormat formatter = DateFormat("dd-MM-yyyy hh:mm a");
      String formattedDate = formatter.format(DateTime.parse(date));
      return formattedDate;
    }

    return GetBuilder<SampleCollectionController>(initState: (state) {
      if (cartController.testUserDetails.value != null) {
        sampleCollectionController.firstNameController.text =
            cartController.testUserDetails.value?.firstName ?? '';
        sampleCollectionController.lastNameController.text =
            cartController.testUserDetails.value?.lastName ?? '';
        sampleCollectionController.selectedRelation =
            cartController.testUserDetails.value?.relation ?? '';
        sampleCollectionController.ageController.text =
            cartController.testUserDetails.value!.age.toString();
        sampleCollectionController.selectedGender =
            cartController.testUserDetails.value?.gender;
        sampleCollectionController.selectedCity =
            cartController.testUserDetails.value?.city;
        sampleCollectionController.selectedLocation =
            cartController.testUserDetails.value?.location;
        sampleCollectionController.appointmentController.text =
            cartController.testUserDetails.value?.appointmentDate ?? '';
        sampleCollectionController.displayedAppointmentDate = formattedDates(
            "${cartController.testUserDetails.value?.appointmentDate}");
        sampleCollectionController.mobileNumberController.text =
            cartController.testUserDetails.value?.mobileNumber ?? '';
        sampleCollectionController.addressController.text =
            cartController.testUserDetails.value?.address ?? '';
        sampleCollectionController.addressInfoController.text =
            cartController.testUserDetails.value?.fullAddress ?? '';
        sampleCollectionController.descriptionController.text =
            cartController.testUserDetails.value?.comments ?? '';
      }
      if (cartController.rebook.value) {
        sampleCollectionController.selectedRelation = cartController
                .labTestDetails[cartController.completedIndex].relation ??
            '';
        sampleCollectionController.firstNameController.text = cartController
                .labTestDetails[cartController.completedIndex].firstName ??
            '';
        sampleCollectionController.lastNameController.text = cartController
                .labTestDetails[cartController.completedIndex].lastName ??
            '';
        sampleCollectionController.ageController.text = cartController
            .labTestDetails[cartController.completedIndex].age
            .toString();
        sampleCollectionController.selectedGender =
            cartController.labTestDetails[cartController.completedIndex].gender;
        sampleCollectionController.selectedCity =
            cartController.labTestDetails[cartController.completedIndex].city;
        sampleCollectionController.selectedLocation = cartController
            .labTestDetails[cartController.completedIndex].location;

        sampleCollectionController.mobileNumberController.text = cartController
                .labTestDetails[cartController.completedIndex].mobileNumber ??
            '';
        sampleCollectionController.addressController.text = cartController
                .labTestDetails[cartController.completedIndex].address ??
            '';
        sampleCollectionController.addressInfoController.text = cartController
                .labTestDetails[cartController.completedIndex].fullAddress ??
            '';
        sampleCollectionController.descriptionController.text = cartController
                .labTestDetails[cartController.completedIndex].comments ??
            '';
      }
    }, builder: (_) {
      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const AppAppBar(
              title: 'Fill  Details',
              isTitleNeeded: true,
            ),
            body: SingleChildScrollView(
              child: Obx(
                () => Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double maxWidth = constraints.maxWidth;
                                return AppDropdown(
                                  valuesList: reportsController.relationList,
                                  themeController: widget.themeController,
                                  itemsWidth: maxWidth - 20,
                                  dropdownIconShowOnSelect: true,
                                  selectedValue: sampleCollectionController
                                      .selectedRelation,
                                  hintText: "Relation",
                                  hintColor:
                                      widget.themeController.textSecondaryColor,
                                  containerBorderColor:
                                      widget.themeController.nav1,
                                  selectedTextAlignment: TextAlign.left,
                                  onValueChanged: (p0) {
                                    setState(() {
                                      sampleCollectionController
                                          .selectedRelation = p0;
                                    });
                                  },
                                  containerBorderRadius: 4,
                                );
                              },
                            ),
                          ),
                          Gap(1.h),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextFormField(
                                  controller: sampleCollectionController
                                      .firstNameController,
                                  hintText: 'First Name',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\s]')),
                                    LengthLimitingTextInputFormatter(64),
                                    //  NoInitialSpaceFormatter()
                                  ],
                                  // maxLength: 64
                                ),
                              ),
                              Gap(4.w),
                              Expanded(
                                child: _buildTextFormField(
                                  controller: sampleCollectionController
                                      .lastNameController,
                                  hintText: 'Last Name',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\s]')),
                                    LengthLimitingTextInputFormatter(64),
                                    // NoInitialSpaceFormatter()
                                  ],
                                  // maxLength: 64
                                ),
                              ),
                            ],
                          ),
                          Gap(1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: _buildTextFormField(
                                    controller: sampleCollectionController
                                        .ageController,
                                    hintText: 'Age',
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ]),
                              ),
                              Gap(4.w),
                              Flexible(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double maxWidth = constraints.maxWidth;
                                      return AppDropdown(
                                        valuesList: const [
                                          'Female',
                                          'Male',
                                          'Others'
                                        ],
                                        themeController: widget.themeController,
                                        itemsWidth: maxWidth - 20,
                                        dropdownIconShowOnSelect: true,
                                        selectedValue:
                                            sampleCollectionController
                                                .selectedGender,
                                        hintText: "Gender",
                                        hintColor: widget
                                            .themeController.textSecondaryColor,
                                        containerBorderColor:
                                            widget.themeController.nav1,
                                        selectedTextAlignment: TextAlign.left,
                                        onValueChanged: (p0) {
                                          setState(() {
                                            sampleCollectionController
                                                .selectedGender = p0;
                                          });
                                        },
                                        containerBorderRadius: 4,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: _buildTextFormField(
                                    controller: sampleCollectionController
                                        .mobileNumberController,
                                    hintText: 'Mobile Number',
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                              ),
                              Gap(4.w),
                              Flexible(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double maxWidth = constraints.maxWidth;
                                      return AppDropdown(
                                        valuesList: const [
                                          'Hyderabad',
                                        ],
                                        themeController: widget.themeController,
                                        itemsWidth: maxWidth - 20,
                                        dropdownIconShowOnSelect: true,
                                        selectedValue:
                                            sampleCollectionController
                                                .selectedCity,
                                        hintText: "Select City",
                                        hintColor: widget
                                            .themeController.textSecondaryColor,
                                        containerBorderColor:
                                            widget.themeController.nav1,
                                        selectedTextAlignment: TextAlign.left,
                                        onValueChanged: (p0) {
                                          setState(() {
                                            sampleCollectionController
                                                .selectedCity = p0;
                                          });
                                        },
                                        containerBorderRadius: 4,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double maxWidth = constraints.maxWidth;
                                      return Obx(
                                        () => AppDropdown(
                                          valuesList: sampleCollectionController
                                              .locationsTextList,
                                          themeController:
                                              widget.themeController,
                                          itemsWidth: maxWidth - 20,
                                          dropdownIconShowOnSelect: true,
                                          selectedValue:
                                              sampleCollectionController
                                                  .selectedLocation,
                                          hintText: "Select Location",
                                          hintColor: widget.themeController
                                              .textSecondaryColor,
                                          containerBorderColor:
                                              widget.themeController.nav1,
                                          selectedTextAlignment: TextAlign.left,
                                          onValueChanged: (p0) {
                                            setState(() {
                                              sampleCollectionController
                                                  .selectedLocation = p0;
                                            });
                                          },
                                          containerBorderRadius: 4,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Gap(4.w),
                              Expanded(
                                child: _buildTextFormField(
                                  controller: TextEditingController(
                                      text: sampleCollectionController
                                          .displayedAppointmentDate),
                                  hintText: 'Book Time',
                                  readOnly: true,
                                  suffixIcon: Icons.calendar_month_outlined,
                                  onTap: () => showDatePicker(
                                      widget.homeCollection ? true : false),
                                ),
                              ),
                            ],
                          ),
                          if (widget.homeCollection)
                            Column(
                              children: [
                                Gap(1.h),
                                TextFormField(
                                  controller: sampleCollectionController
                                      .addressController,
                                  readOnly: true,
                                  maxLength: 150,
                                  maxLines: 2,
                                  onTap: () {
                                    Get.to(
                                        () => MapScreen(status: "testAddress"));
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: 'Address:',
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      borderSide: BorderSide(
                                        color: widget.themeController.nav1,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color: widget.themeController.nav1,
                                          width: 1),
                                    ),
                                  ),
                                ),
                                Gap(1.h),
                                if (sampleCollectionController
                                    .addressController.text.isNotEmpty)
                                  TextFormField(
                                    controller: sampleCollectionController
                                        .addressInfoController,
                                    maxLength: 100,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      labelText: 'Address info',
                                      labelStyle: TextStyle(
                                          color: themeController.nav1),
                                      hintText: 'Info Of Address:',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                        borderSide: BorderSide(
                                          color: widget.themeController.nav1,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: widget.themeController.nav1,
                                            width: 1),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          Gap(1.h),
                          TextFormField(
                            controller: sampleCollectionController
                                .descriptionController,
                            maxLength: 500,
                            maxLines: 3,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Comments...',
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                  color: widget.themeController.nav1,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: widget.themeController.nav1,
                                    width: 1),
                              ),
                            ),
                          ),
                          Gap(4.h),
                          cartController.rebook.value
                              ? Obx(
                                  () => Stack(children: [
                                    ListView.separated(
                                      itemCount: cartController
                                          .labTestDetails[
                                              cartController.completedIndex]
                                          .lucidTestData!
                                          .length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: widget.themeController
                                                .textPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              width: 1,
                                              color:
                                                  widget.themeController.nav1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Gap(4),
                                              Expanded(
                                                child: AppText(
                                                  cartController
                                                          .labTestDetails[
                                                              cartController
                                                                  .completedIndex]
                                                          .lucidTestData![index]
                                                          .serviceName ??
                                                      "",
                                                  fontSize: 16.sp,
                                                  color: widget.themeController
                                                      .black500Color,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  //softWrap: false,
                                                ),
                                              ),
                                              AppText(
                                                "${AppString.cashSymbol}${cartController.labTestDetails[cartController.completedIndex].lucidTestData![index].finalMrp?.toStringAsFixed(2)}/-",
                                                fontSize: 15.sp,
                                                color: widget.themeController
                                                    .black500Color,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Gap(8);
                                      },
                                    ),
                                  ]),
                                )
                              : Obx(
                                  () => widget.homeCollection
                                      ? ListView.separated(
                                          itemCount: cartController
                                              .diagnosticHomeTests.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: widget.themeController
                                                    .textPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  width: 1,
                                                  color: widget
                                                      .themeController.nav1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (cartController
                                                              .diagnosticHomeTests
                                                              .length !=
                                                          1) {
                                                        cartController.deleteCartTest(
                                                            serviceCd:
                                                                cartController
                                                                    .diagnosticHomeTests[
                                                                        index]
                                                                    .serviceCd,
                                                            hv: widget
                                                                    .homeCollection
                                                                ? "1"
                                                                : "0");
                                                      } else {
                                                        showCancelDialog(
                                                            context,
                                                            cartController
                                                                    .diagnosticHomeTests[
                                                                        index]
                                                                    .serviceCd ??
                                                                "");
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 17,
                                                      color: widget
                                                          .themeController
                                                          .black500Color,
                                                    ),
                                                  ),
                                                  Gap(1.5.w),
                                                  Expanded(
                                                    child: AppText(
                                                      cartController
                                                              .diagnosticHomeTests[
                                                                  index]
                                                              .serviceName ??
                                                          "",

                                                      fontSize: 16.sp,
                                                      color: widget
                                                          .themeController
                                                          .black500Color,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      //softWrap: false,
                                                    ),
                                                  ),
                                                  AppText(
                                                    "${AppString.cashSymbol}${cartController.diagnosticHomeTests[index].finalMrp?.toStringAsFixed(2)}/-",
                                                    fontSize: 15.sp,
                                                    color: widget
                                                        .themeController
                                                        .black500Color,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const Gap(8);
                                          },
                                        )
                                      : ListView.separated(
                                          itemCount: cartController
                                              .diagnosticCartTests.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: widget.themeController
                                                    .textPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  width: 1,
                                                  color: widget
                                                      .themeController.nav1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (cartController
                                                              .diagnosticCartTests
                                                              .length !=
                                                          1) {
                                                        cartController.deleteCartTest(
                                                            serviceCd:
                                                                cartController
                                                                    .diagnosticCartTests[
                                                                        index]
                                                                    .serviceCd,
                                                            hv: widget
                                                                    .homeCollection
                                                                ? "1"
                                                                : "0");
                                                      } else {
                                                        showCancelDialog(
                                                            context,
                                                            cartController
                                                                    .diagnosticCartTests[
                                                                        index]
                                                                    .serviceCd ??
                                                                "");
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 17,
                                                      color: widget
                                                          .themeController
                                                          .black500Color,
                                                    ),
                                                  ),
                                                  Gap(1.5.w),
                                                  Expanded(
                                                    child: AppText(
                                                      cartController
                                                              .diagnosticCartTests[
                                                                  index]
                                                              .serviceName ??
                                                          "",

                                                      fontSize: 16.sp,
                                                      color: widget
                                                          .themeController
                                                          .black500Color,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      //softWrap: false,
                                                    ),
                                                  ),
                                                  AppText(
                                                    "${AppString.cashSymbol}${cartController.diagnosticCartTests[index].finalMrp?.toStringAsFixed(2)}/-",
                                                    fontSize: 15.sp,
                                                    color: widget
                                                        .themeController
                                                        .black500Color,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const Gap(8);
                                          },
                                        ),
                                ),
                          Gap(2.h),
                          AppText(
                            'Your Personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our privacy policy.',
                            color: widget.themeController.textSecondaryColor,
                            fontFamily: AppFont.poppins,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                          Gap(2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                'Total Cost :',
                                color: widget.themeController.black500Color,
                                fontFamily: AppFont.poppins,
                                fontSize: 17.sp,
                              ),
                              Gap(2.w),
                              Obx(
                                () => cartController.rebook.value
                                    ? ((cartController
                                                    .labTestDetails[
                                                        cartController
                                                            .completedIndex]
                                                    .address !=
                                                null &&
                                            cartController
                                                    .labTestDetails[
                                                        cartController
                                                            .completedIndex]
                                                    .address !=
                                                "")
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              AppText(
                                                "${AppString.cashSymbol}${(cartController.labTestDetails[cartController.completedIndex].totalPaidAmount?.toStringAsFixed(2) ?? 0)}",
                                                color: widget.themeController
                                                    .black500Color,
                                                fontFamily: AppFont.poppins,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              AppText(
                                                "(*Included Home Sample Collection Charges)",
                                                color: widget.themeController
                                                    .textSecondaryColor,
                                                fontFamily: AppFont.poppins,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          )
                                        : AppText(
                                            "${AppString.cashSymbol}${(cartController.labTestDetails[cartController.completedIndex].totalPaidAmount?.toStringAsFixed(2) ?? 0)}",
                                            color: widget
                                                .themeController.black500Color,
                                            fontFamily: AppFont.poppins,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                          ))
                                    : AppText(
                                        "${AppString.cashSymbol}${(cartController.diagnosticCartData.value?.data?.totalAmount?.toStringAsFixed(2) ?? 0)}",
                                        color: widget
                                            .themeController.black500Color,
                                        fontFamily: AppFont.poppins,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                              ),
                            ],
                          ),
                          Gap(2.h),
                          GestureDetector(
                            onTap: () {
                              if (sampleCollectionController.validateFields()) {
                                if (widget.homeCollection == true) {
                                  if (sampleCollectionController
                                      .addressController.text.isEmpty) {
                                    customFailureToast(
                                        content: "Address is required");
                                    return;
                                  }
                                  if (sampleCollectionController
                                      .addressInfoController.text.isEmpty) {
                                    customFailureToast(
                                        content:
                                            "Address information is required for better Service");
                                    return;
                                  }
                                }
                                logs("loader");
                                cartController.rebook.value
                                    ? cartController.getRazorPayDataApi(
                                        cartController
                                            .labTestDetails[
                                                cartController.completedIndex]
                                            .totalPaidAmount!,
                                        '',
                                        API.razorpayKey)
                                    : sampleCollectionController
                                        .postPatientData();
                                sampleCollectionController.isHc.value =
                                    widget.homeCollection ? "1" : "0";
                                // BottomBarController bbc =
                                //     Get.put(BottomBarController());
                                // bbc.currentSelectedIndex = 1;
                                // CartController cController =
                                //     Get.put(CartController());
                                // cController.activeMainCartTab.value = 1;

                                // Get.offAll(() => const DashboardScreen());
                              }
                            },
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                width: 45.w,
                                decoration: BoxDecoration(
                                  color: widget.themeController.navShadow1,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: themeController.textPrimaryColor,
                                      size: 14,
                                    ),
                                    const Gap(8),
                                    AppText(
                                      'Move To Cart',
                                      color: widget
                                          .themeController.textPrimaryColor,
                                      fontSize: 16.sp,
                                      fontFamily: AppFont.poppins,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Gap(2.h),
                        ]),
                  ),
                  if (sampleCollectionController.isPatientDataLoading.value ||
                      reportsController.isrelationListLoading.value ||
                      cartController.isDiagnosticTestCartLoading.value ||
                      cartController.isTestDeletingLoading.value)
                    Positioned(
                        right: 0,
                        top: 0,
                        left: 0,
                        bottom: 0,
                        child:
                            SizedBox(height: 5, width: 5, child: AppLoader()))
                ]),
              ),
            )),
      );
    });
  }

  TextFormField _buildTextFormField({
    required String hintText,
    IconData? suffixIcon,
    Function? onTap,
    bool? readOnly,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly ?? false,
      onTap: onTap != null ? () => onTap() : null,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterText: "",
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: TextStyle(
          color: widget.themeController.textSecondaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          fontFamily: AppFont.poppins,
        ),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(
            color: widget.themeController.nav1,
            //Color.fromRGBO(185, 185, 185, 1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: widget.themeController.nav1, width: 1),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
        suffixIconColor:
            suffixIcon != null ? widget.themeController.nav1 : null,
      ),
    );
  }
}
