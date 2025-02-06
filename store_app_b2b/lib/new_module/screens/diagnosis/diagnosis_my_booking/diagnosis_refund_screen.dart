import 'package:b2c/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/constant/app_string.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/new_module/widgets/records_list_view_screen.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';
import 'package:store_app_b2b/new_module/screens/diagnosis/diagnosis_my_booking/details_screen.dart';

class DiagnosisRefundScreen extends StatelessWidget {
  DiagnosisRefundScreen({super.key, required this.index});
  final int index;
  final ThemeController themeController = Get.find();
  final CartLabtestController controller = Get.put(CartLabtestController());
  dateParse(String rawDate) {
    DateFormat formatter = DateFormat("MMM dd,yyyy h:mm a");
    String date = formatter.format(DateTime.parse(rawDate));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    String selectedAppoint =
        controller.labTestDetails[index].appointmentDate ?? "";
    String appointTime = "";
    if (selectedAppoint.isNotEmpty) {
      try {
        DateFormat formatter = DateFormat("MMM dd, yyyy hh:mm a");
        appointTime = formatter.format(DateTime.parse(selectedAppoint));
      } catch (e) {
        logs("Error parsing date: $e");
      }
    }
    String selectedBooking = controller.labTestDetails[index].bookingDate ?? "";
    String bookedDate = "";
    if (selectedBooking.isNotEmpty) {
      try {
        DateFormat formatter = DateFormat("MMM dd, yyyy");
        bookedDate = formatter.format(DateTime.parse(selectedBooking));
      } catch (e) {
        logs("Error parsing date: $e");
      }
    }
    return Scaffold(
      appBar: AppAppBar(
        title: "View Test Details",
        backgroundColor: themeController.textPrimaryColor,
        isTitleNeeded: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Refund information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          'Refund of ',
                          fontSize: 16.sp,
                          fontFamily: AppFont.poppins,
                          fontWeight: FontWeight.w400,
                          color: themeController.black500Color,
                        ),
                        Obx(
                          () => AppText(
                            '${AppString.cashSymbol}${controller.labTestDetails[index].totalPaidAmount?.toStringAsFixed(2) ?? ''}',
                            fontSize: 16.sp,
                            fontFamily: AppFont.poppins,
                            fontWeight: FontWeight.w400,
                            color: themeController.black500Color,
                          ),
                        ),
                        const Spacer(),
                        Obx(() =>
                            controller.labTestDetails[index].refoundStatus ==
                                        'pending' ||
                                    controller.labTestDetails[index]
                                            .refoundStatus ==
                                        "N"
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.deblur_outlined,
                                        color: Colors.orangeAccent,
                                        size: 15,
                                      ),
                                      Gap(1.w),
                                      AppText(
                                        'In Progress',
                                        color: Colors.orangeAccent,
                                        fontFamily: AppFont.poppins,
                                        fontSize: 16.sp,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: themeController.buyColor,
                                        size: 15,
                                      ),
                                      AppText(
                                        'Completed',
                                        color: themeController.buyColor,
                                        fontFamily: AppFont.poppins,
                                        fontSize: 16.sp,
                                      ),
                                    ],
                                  )),
                      ],
                    ),
                    const Gap(5),
                    Obx(
                      () => AppText(
                        '${AppString.cashSymbol}${controller.labTestDetails[index].totalPaidAmount?.toStringAsFixed(2) ?? ''} Refund will be refunded to your Bank Account linked with Razor UPI in 8 working days. For any queries, please contact your bank with reference number ${controller.labTestDetails[index].refoundId ?? ''}.',
                        fontSize: 14.sp,
                        fontFamily: AppFont.poppins,
                        fontWeight: FontWeight.w400,
                        color: themeController.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(15),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Column(
                        children: [
                          customeRow(text: "Booking Date", value: bookedDate),
                          const Gap(5),
                          customeRow(
                              text: "Booking ID #",
                              value: controller.labTestDetails[index].id ?? ''),
                          const Gap(5),
                          customeRow(
                              text: "Booking total",
                              value:
                                  '${AppString.cashSymbol}${controller.labTestDetails[index].totalAmount?.toStringAsFixed(2)}'),
                          controller.labTestDetails[index]
                                      .homeCollecitonCharges !=
                                  0
                              ? Column(
                                  children: [
                                    const Gap(5),
                                    customeRow(
                                        text: "Charges",
                                        value:
                                            '${AppString.cashSymbol}${controller.labTestDetails[index].homeCollecitonCharges?.toStringAsFixed(2)}'),
                                    const Gap(5),
                                    customeRow(
                                        text: "Total Amount",
                                        value:
                                            '${AppString.cashSymbol}${controller.labTestDetails[index].totalPaidAmount?.toStringAsFixed(2)}'),
                                  ],
                                )
                              : const Gap(5),
                        ],
                      ),
                    ),
                    Divider(
                      color: themeController.textSecondaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () async {
                          Get.to(() => RecordsListViewScreen(
                                recordsList: [
                                  '${controller.labTestDetails[index].lucidOrderInvoice}'
                                ],
                                medUi: true,
                                title: 'Diagnostic Invoice',
                                count: false,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              'Download Invoice',
                              color: themeController.textSecondaryColor,
                              fontSize: 16.sp,
                              fontFamily: AppFont.poppins,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400,
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 28,
                              color: themeController.black100Color,
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(1.h),
                  ],
                ),
              ),
              const Gap(10),
              AppText(
                'Test Details',
                fontSize: 16.sp,
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w600,
                color: themeController.black500Color,
              ),
              Gap(1.h),
              // Test Details
              ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      controller.labTestDetails[index].lucidTestData!.length,
                  itemBuilder: (context, testList) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppText(
                                'Cancelled',
                                fontSize: 16.sp,
                                fontFamily: AppFont.poppins,
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                              ),
                              const Spacer(),
                              AppText(
                                controller.labTestDetails[index].hv == '0'
                                    ? 'Lab Visit'
                                    : 'Home Visit',
                                fontSize: 14.sp,
                                fontFamily: AppFont.poppins,
                                fontWeight: FontWeight.w500,
                                color: themeController.navShadow1,
                              ),
                            ],
                          ),
                          const Gap(5),
                          AppText(
                            controller.labTestDetails[index]
                                    .lucidTestData![testList].serviceName ??
                                '',
                            fontSize: 16.sp,
                            fontFamily: AppFont.poppins,
                            fontWeight: FontWeight.w400,
                            color: themeController.navShadow1,
                          ),
                          Gap(5),
                          Row(
                            children: [
                              Column(
                                children: [
                                  AppImageAsset(
                                    image: controller.labTestDetails[index]
                                            .lucidTestData![testList].image ??
                                        '',
                                    height: 10.h,
                                    width: 13.w,
                                  ),
                                  // Text('Mri Scan'),
                                  // Text('CT Scan'),
                                ],
                              ),
                              const Spacer(),
                              AppText(
                                '${AppString.cashSymbol}${controller.labTestDetails[index].lucidTestData![testList].finalMrp?.toStringAsFixed(2)}',
                                fontSize: 16.sp,
                                fontFamily: AppFont.poppins,
                                fontWeight: FontWeight.w600,
                                color: themeController.textSecondaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

              controller.labTestDetails[index].hv == '0'
                  ? const SizedBox(
                      height: 0,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        AppText(
                          'Delivery Address   ',
                          fontSize: 16.sp,
                          fontFamily: AppFont.poppins,
                          fontWeight: FontWeight.w600,
                          color: themeController.black500Color,
                        ),
                        const Gap(10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText(
                            "${controller.labTestDetails[index].fullAddress ?? ""},${controller.labTestDetails[index].address ?? ""}",
                            fontSize: 14.sp,
                            fontFamily: AppFont.poppins,
                            fontWeight: FontWeight.w400,
                            color: themeController.black300Color,
                          ),
                        ),
                      ],
                    ),

              const Gap(10),
              AppText(
                'Payment Mode ',
                fontSize: 16.sp,
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w600,
                color: themeController.black500Color,
              ),
              Gap(1.h),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          'Online',
                          fontSize: 16.sp,
                          fontFamily: AppFont.poppins,
                          fontWeight: FontWeight.w400,
                          color: themeController.black500Color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(2.h),
              AppText(
                "Patient Details :",
                color: themeController.black500Color,
                fontSize: 18.sp,
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
              ),
              Gap(2.h),
              AppText(
                "Name : ${controller.labTestDetails[index].firstName?.toUpperCase()} ${controller.labTestDetails[index].lastName?.toUpperCase()}",
                color: themeController.navShadow1,
                fontFamily: AppFont.poppins,
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
              ),
              Gap(1.h),
              Text.rich(TextSpan(
                  text: "Relation : ",
                  style: TextStyle(
                    fontFamily: AppFont.poppins,
                    fontSize: 16.sp,
                    color: themeController.black300Color,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: controller.labTestDetails[index].relation,
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 15.sp,
                        color: themeController.black300Color,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ])),
              Gap(1.h),
              Text.rich(
                TextSpan(
                    text: "Age : ",
                    style: TextStyle(
                      fontFamily: AppFont.poppins,
                      fontSize: 16.sp,
                      color: themeController.black300Color,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "${controller.labTestDetails[index].age}",
                        style: TextStyle(
                          fontFamily: AppFont.poppins,
                          fontSize: 15.sp,
                          color: themeController.black300Color,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]),
              ),
              Gap(1.h),
              Text.rich(TextSpan(
                  text: "Gender : ",
                  style: TextStyle(
                    fontFamily: AppFont.poppins,
                    fontSize: 16.sp,
                    color: themeController.black300Color,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: controller.labTestDetails[index].gender,
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 15.sp,
                        color: themeController.black300Color,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ])),
              Gap(1.h),
              Text.rich(TextSpan(
                  text: "PhoneNumber : ",
                  style: TextStyle(
                    fontFamily: AppFont.poppins,
                    fontSize: 16.sp,
                    color: themeController.black300Color,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: controller.labTestDetails[index].mobileNumber,
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 15.sp,
                        color: themeController.black300Color,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ])),
              Gap(1.h),
              Text.rich(TextSpan(
                  text: "Appointment Time : ",
                  style: TextStyle(
                    fontFamily: AppFont.poppins,
                    fontSize: 16.sp,
                    color: themeController.black300Color,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: appointTime,
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 15.sp,
                        color: themeController.black300Color,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ])),
              Gap(1.h),

              Text.rich(TextSpan(
                  text: "Branch Location : ",
                  style: TextStyle(
                    fontFamily: AppFont.poppins,
                    fontSize: 16.sp,
                    color: themeController.black300Color,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: controller.labTestDetails[index].location,
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 15.sp,
                        color: themeController.black300Color,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ])),
              Gap(1.h),

              controller.labTestDetails[index].comments!.isEmpty ||
                      controller.labTestDetails[index].comments == null
                  ? Gap(0)
                  : Text.rich(TextSpan(
                      text: "Comments : ",
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 16.sp,
                        color: themeController.black300Color,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                          TextSpan(
                            text: controller.labTestDetails[index].comments,
                            style: TextStyle(
                              fontFamily: AppFont.poppins,
                              fontSize: 15.sp,
                              color: themeController.black300Color,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          )
                        ]))
            ],
          ),
        ),
      ),
    );
  }

  customeRow({required String text, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: AppText(
            text,
            fontSize: 16.sp,
            color: themeController.textSecondaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        // Gap(37.w),
        AppText(
          value,
          fontSize: 16.sp,
          color: themeController.textSecondaryColor,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
