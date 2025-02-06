import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/sample_collection_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/model/cart/labtest_models/lab_test_status_model_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class RescheduleFormScreen extends StatefulWidget {
  final ThemeController themeController = Get.find();
  String? relation;
  String? firstName;
  String? id;
  num? age;
  String? gender;
  String? mobileNum;
  String? city;
  String? branch;
  String? lastName;
  String? homeCollection;
  String? appointDate;
  String? address;
  String? addressInfo;
  String? commt;
  num? totalAmount;
  List<LucidTest>? lucidList;

  RescheduleFormScreen(
      {super.key,
      required this.id,
      required this.relation,
      required this.firstName,
      required this.gender,
      required this.age,
      required this.mobileNum,
      required this.city,
      required this.branch,
      required this.lastName,
      required this.appointDate,
      this.address,
      this.addressInfo,
      this.homeCollection,
      required this.commt,
      required this.totalAmount,
      required this.lucidList});
  State<RescheduleFormScreen> createState() => _RescheduleFormScreenState();
}

class _RescheduleFormScreenState extends State<RescheduleFormScreen> {
  final SampleCollectionController sampleCollectionController =
      Get.put(SampleCollectionController());
  CartLabtestController cartController = Get.put(CartLabtestController());

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
                        cartController.rescheduleTime.text = isoFormatDate;
                        logs("Formatted date is $isoFormatDate");
                        String formattedDate = DateFormat('dd-MM-yyyy hh:mm a')
                            .format(selectedDate);
                        cartController.displayedRescheduleTime = formattedDate;
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

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm a");
    String appointDate =
        formatter.format(DateTime.parse(widget.appointDate ?? ""));
    return GetBuilder<SampleCollectionController>(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const AppAppBar(
          title: 'Fill Your Details',
          isTitleNeeded: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: _buildTextFormField(
                    readOnly: true,
                    hintText: widget.relation ?? "",
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Gap(1.h),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextFormField(
                            readOnly: true, hintText: "${widget.firstName}")),
                    Gap(4.w),
                    Expanded(
                        child: _buildTextFormField(
                            readOnly: true, hintText: "${widget.lastName}")),
                  ],
                ),
                Gap(1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        readOnly: true,
                        hintText: '${widget.age ?? ""}',
                      ),
                    ),
                    Gap(4.w),
                    Flexible(
                      child: _buildTextFormField(
                        readOnly: true,
                        hintText: widget.gender ?? "",
                        maxLength: 3,
                        keyboardType: TextInputType.number,
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
                        readOnly: true,
                        hintText: widget.mobileNum ?? "",
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Gap(4.w),
                    Flexible(
                      child: _buildTextFormField(
                        readOnly: true,
                        hintText: widget.city ?? "",
                        maxLength: 3,
                        keyboardType: TextInputType.number,
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
                        readOnly: true,
                        hintText: widget.branch ?? "",
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Gap(4.w),
                    Expanded(
                      child: _buildTextFormField(
                        controller: TextEditingController(
                            text: cartController.displayedRescheduleTime),
                        hintText: "Book Time",
                        //readOnly: true,
                        suffixIcon: Icons.calendar_month_outlined,
                        onTap: () => showDatePicker(
                            widget.homeCollection == "0" ? false : true),
                      ),
                    ),
                  ],
                ),
                Gap(1.h),
                if (widget.address!.isNotEmpty &&
                    widget.addressInfo!.isNotEmpty)
                  Column(
                    children: [
                      TextFormField(
                        maxLines: 3,
                        readOnly: true,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: widget.address ?? "",
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(185, 185, 185, 1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(185, 185, 185, 1),
                                width: 1),
                          ),
                        ),
                      ),
                      Gap(1.h),
                      TextFormField(
                        // controller:
                        //     sampleCollectionController.addressInfoController,
                        maxLength: 500,
                        maxLines: 3,
                        readOnly: true,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: widget.addressInfo ?? "",
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(185, 185, 185, 1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(185, 185, 185, 1),
                                width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                Gap(1.h),
                TextFormField(
                  controller: cartController.rescheduleComment,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: widget.commt == "" ? "Comments..." : widget.commt,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(
                        color: widget.themeController.navShadow1,
                        width: 1.3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: widget.themeController.navShadow1, width: 1),
                    ),
                  ),
                ),
                Gap(4.h),
                ListView.separated(
                  itemCount: widget.lucidList?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.themeController.textPrimaryColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            width: 1,
                            color: widget.themeController.textSecondaryColor),
                      ),
                      child: Row(
                        children: [
                          const Gap(4),
                          Expanded(
                            child: AppText(
                              widget.lucidList?[index].serviceName ?? "",
                              fontSize: 16.sp,
                              color: widget.themeController.black500Color,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          AppText(
                            "${widget.lucidList?[index].finalMrp?.toStringAsFixed(2)}/-",
                            fontSize: 16.sp,
                            color: widget.themeController.black500Color,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Gap(8);
                  },
                ),
                const Gap(8),
                const Gap(16),
                AppText(
                  'Your Personal data will be used to process your order, support your experience throughout this website, and for other purposes deescribed in our privacy policy.',
                  color: widget.themeController.textSecondaryColor,
                  fontFamily: AppFont.poppins,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                const Gap(16),
                Row(
                  children: [
                    AppText(
                      'Total Cost :',
                      color: widget.themeController.black500Color,
                      fontFamily: AppFont.poppins,
                      fontSize: 17.sp,
                    ),
                    const Gap(8),
                    Obx(
                      () => AppText(
                        "${AppString.cashSymbol}${widget.totalAmount?.toStringAsFixed(2)}",
                        color: widget.themeController.black500Color,
                        fontFamily: AppFont.poppins,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                GestureDetector(
                  onTap: () {
                    if (cartController.validation()) {
                      logs("after validate");
                      // if (cartController.rescheduleTime.text == appointDate)
                      cartController.rescheduleDate(
                          appointDate: cartController.rescheduleTime.text,
                          comment: cartController.rescheduleComment.text,
                          upCommingId: widget.id ?? "");
                      Get.back();
                    }

                    // Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: widget.themeController.navShadow1,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: AppText(
                        'Submit',
                        color: widget.themeController.textPrimaryColor,
                        fontSize: 16.sp,
                        fontFamily: AppFont.poppins,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const Gap(6),
              ],
            ),
          ),
        ),
      );
    });
  }

  TextFormField _buildTextFormField({
    required String hintText,
    IconData? suffixIcon,
    Function? onTap,
    bool? readOnly,
    int? maxLength,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly ?? false,
      onTap: onTap != null ? () => onTap() : null,
      maxLength: maxLength,
      keyboardType: keyboardType,
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
            color: readOnly ?? false
                ? const Color.fromRGBO(185, 185, 185, 1)
                : widget.themeController.navShadow1,
            width: readOnly ?? false ? 1 : 1.3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: readOnly ?? false
                ? const Color.fromRGBO(185, 185, 185, 1)
                : widget.themeController.navShadow1,
            width: readOnly ?? false ? 1 : 1.3,
          ),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 17) : null,
      ),
    );
  }
}
