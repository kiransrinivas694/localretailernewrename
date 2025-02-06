import 'package:b2c/controllers/global_main_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/store_screen/order_screens/order_review_screens/invoicecontroller_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/healthpackage_controller/health_package_controller_new.dart';
import 'package:store_app_b2b/new_module/constant/app_string_new.dart';
import 'package:store_app_b2b/new_module/controllers/cart_controller/cart_labtest_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/diagnosis_controller/lucid_controller_new.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/screens/dialogs/health_package_dialog_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/new_module/widgets/records_list_view_screen_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class TestDetailsScreen extends StatelessWidget {
  TestDetailsScreen({
    super.key,
  });

  final ThemeController themeController = Get.find();
  final CartLabtestController controller = Get.put(CartLabtestController());
  final GlobalMainController globalController = Get.put(GlobalMainController());
  final LucidController lucidController = Get.put(LucidController());
  HealthPackageController healthPackageController =
      Get.put(HealthPackageController());

  dateParse(String rawDate) {
    DateFormat formatter = DateFormat("MMM dd,yyyy h:mm a");
    String date = formatter.format(DateTime.parse(rawDate));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "My Tests"),
      body: Obx(
        () => controller.isBookingDetailsLoading.value
            ? Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: AppShimmerEffectView(
                  height: 100.h,
                  width: double.infinity,
                ),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                              height: 12.h,
                              width: 38.w,
                              child: const AppImageAsset(
                                image: "assets/images/cancel_status.png",
                                fit: BoxFit.fill,
                              )),
                        ),
                        Gap(4.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Lucid Diagnostic",
                              color: themeController.black500Color,
                              fontSize: 18.sp,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: AppFont.poppins,
                              fontWeight: FontWeight.w600,
                            ),
                            Gap(1.h),
                            AppText(
                              "Location : ${controller.bookedTestData.value?.location}",
                              color: themeController.black500Color,
                              fontSize: 14.sp,
                              fontFamily: AppFont.poppins,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400,
                            ),
                            Gap(1.h),
                            GestureDetector(
                              onTap: () => makePhoneCall(lucidController
                                      .locationListId
                                      .value
                                      .data!
                                      .contactNumber ??
                                  ""),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone_callback,
                                    size: 18,
                                    color: themeController.navShadow1,
                                  ),
                                  AppText(
                                    "Contact Us : ${lucidController.locationListId.value.data?.contactNumber ?? ""}",
                                    color: themeController.navShadow1,
                                    fontSize: 15.sp,
                                    fontFamily: AppFont.poppins,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.to(() => RecordsListViewScreen(
                            recordsList: [
                              '${controller.bookedTestData.value?.lucidOrderInvoice}'
                            ],
                            medUi: true,
                            title: 'Diagnostic Invoice',
                            count: false,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          ));
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(226, 226, 226, 1)),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                        )),
                  ),
                  // Gap(2.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // color: const Color.fromRGBO(119, 187, 173, 0.22),
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
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
                          "Name :  ${controller.bookedTestData.value?.firstName?.toUpperCase()} ${controller.bookedTestData.value?.lastName?.toUpperCase()}",
                          color: themeController.navShadow1,
                          fontFamily: AppFont.poppins,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        Gap(1.h),
                        coustomTextRich(
                            title: "Relation : ",
                            content:
                                '${controller.bookedTestData.value?.relation}'),
                        Gap(1.h),
                        coustomTextRich(
                            title: "Age : ",
                            content: '${controller.bookedTestData.value?.age}'),
                        Gap(1.h),
                        coustomTextRich(
                            title: "Gender : ",
                            content:
                                '${controller.bookedTestData.value?.gender}'),
                        Gap(1.h),
                        coustomTextRich(
                            title: "Mobile Number : ",
                            content:
                                '${controller.bookedTestData.value?.mobileNumber}'),
                        Gap(1.h),
                        coustomTextRich(
                          title: "Booking Date : ",
                          content: dateParse(
                              controller.bookedTestData.value?.bookingDate ??
                                  ''),
                        ),
                        Gap(1.h),
                        coustomTextRich(
                          title: "Appointment Date : ",
                          content: dateParse(controller
                                  .bookedTestData.value?.appointmentDate ??
                              ''),
                        ),
                        (controller.bookedTestData.value?.address != null &&
                                controller
                                    .bookedTestData.value!.address!.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Gap(1.h),
                                    coustomTextRich(
                                        title: 'Address Info : ',
                                        content:
                                            '${controller.bookedTestData.value?.fullAddress}'),
                                    Gap(1.h),
                                    coustomTextRich(
                                        title: 'Address : ',
                                        content:
                                            '${controller.bookedTestData.value?.address}'),
                                  ])
                            : Gap(0),
                        if (controller
                            .bookedTestData.value!.comments!.isNotEmpty)
                          Column(
                            children: [
                              Gap(1.h),
                              coustomTextRich(
                                title: "Comments : ",
                                content:
                                    '${controller.bookedTestData.value?.comments}',
                              ),
                            ],
                          ),
                        Gap(1.h),
                        AppText(
                          "Tests :",
                          fontFamily: AppFont.poppins,
                          fontSize: 16.sp,
                          color: themeController.black300Color,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap(10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.bookedTestData.value?.lucidCart
                                  ?.lucidTest?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller
                                            .bookedTestData
                                            .value
                                            ?.lucidCart
                                            ?.lucidTest?[index]
                                            .isHealthPackage !=
                                        "Y"
                                    ? Expanded(
                                        child: AppText(
                                          '${controller.bookedTestData.value?.lucidCart?.lucidTest?[index].serviceName}',
                                          fontSize: 15.sp,
                                          color: themeController.black500Color,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await healthPackageController
                                                .getPackageViewCart(
                                                    serviceCd: controller
                                                            .bookedTestData
                                                            .value
                                                            ?.lucidCart
                                                            ?.lucidTest?[index]
                                                            .serviceCd ??
                                                        "")
                                                .then(
                                              (value) {
                                                final packageCartDetails =
                                                    healthPackageController
                                                        .healthPackageCartList
                                                        .value;
                                                if (packageCartDetails !=
                                                        null &&
                                                    packageCartDetails
                                                            .healthPackageTypes !=
                                                        null &&
                                                    packageCartDetails
                                                        .healthPackageTypes!
                                                        .isNotEmpty) {
                                                  Get.dialog(
                                                      HealthPackagesDialog(
                                                          cart: true,
                                                          healthPackageCartList:
                                                              packageCartDetails,
                                                          continueClick: () {
                                                            Get.back();
                                                          }));
                                                }
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: themeController.nav1,
                                                size: 15,
                                              ),
                                              Gap(1.w),
                                              Expanded(
                                                child: AppText(
                                                  '${controller.bookedTestData.value?.lucidCart?.lucidTest?[index].serviceName}',
                                                  fontSize: 15.sp,
                                                  color: themeController
                                                      .black500Color,
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                Gap(17),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AppText(
                                    '${AppString.cashSymbol} ${controller.bookedTestData.value?.lucidCart?.lucidTest?[index].finalMrp?.toStringAsFixed(2)}/-',
                                    fontSize: 15.sp,
                                    color: themeController.black500Color,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Gap(5);
                          },
                        ),
                        controller.bookedTestData.value!
                                        .homeCollecitonCharges !=
                                    0 &&
                                controller.bookedTestData.value!
                                        .homeCollecitonCharges !=
                                    null
                            ? Column(
                                children: [
                                  if (controller.bookedTestData.value!.lucidCart
                                          ?.lucidTest?.length !=
                                      1)
                                    Column(
                                      children: [
                                        Divider(),
                                        customeRow(
                                            text: 'Order Amount',
                                            color:
                                                themeController.black500Color,
                                            amount:
                                                '${controller.bookedTestData.value?.lucidCart?.totalAmount?.toStringAsFixed(2) ?? ''}'),
                                      ],
                                    ),
                                  Gap(5),
                                  customeRow(
                                      text: 'Home Collection Charges',
                                      color: themeController.black500Color,
                                      amount:
                                          '${controller.bookedTestData.value?.homeCollecitonCharges?.toStringAsFixed(2) ?? ''}'),
                                  Gap(5),
                                ],
                              )
                            : Gap(0),
                        Divider(),
                        Gap(5),
                        customeRow(
                            text: 'Order Total',
                            color: themeController.black500Color,
                            amount:
                                '${controller.bookedTestData.value?.totalPaidAmount?.toStringAsFixed(2) ?? ''}'),
                        Gap(5),
                        Divider(),
                        Gap(5),
                        AppText(
                          "Payment Details :",
                          color: themeController.black500Color,
                          fontSize: 18.sp,
                          fontFamily: AppFont.poppins,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                        ),
                        Gap(1.h),
                        coustomTextRich(
                          title: "TransactionId : ",
                          content:
                              "${controller.bookedTestData.value?.paymentId}",
                        ),
                        Gap(1.h),
                        coustomTextRich(
                          title: "Paid Amount : ",
                          content:
                              "${AppString.cashSymbol}${controller.bookedTestData.value?.totalPaidAmount?.toStringAsFixed(2)}/-",
                        ),
                        Gap(1.h),
                        coustomTextRich(
                          title: "Payment Date : ",
                          content: dateParse(controller
                                  .bookedTestData.value?.createdAt
                                  .toString() ??
                              ''),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  customeRow(
      {required String text, required String amount, required Color color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(4.w),
        Expanded(
          child: AppText(
            text,
            fontSize: 15.sp,
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ),
        // Gap(37.w),
        AppText(
          '${AppString.cashSymbol}$amount/-',
          fontSize: 15.sp,
          color: color,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  coustomTextRich({
    required String title,
    required String content,
  }) {
    return Text.rich(TextSpan(
        text: title,
        style: TextStyle(
          fontFamily: AppFont.poppins,
          fontSize: 16.sp,
          color: themeController.black300Color,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              fontFamily: AppFont.poppins,
              fontSize: 15.sp,
              color: themeController.black300Color,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          )
        ]));
  }
}
