import 'package:b2c/components/common_text_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/ledger_controller_new.dart';

class LedgerScreen extends StatelessWidget {
  LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<LedgerController>(
        init: LedgerController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  SizedBox(
                    width: width * 0.23,
                  ),
                  CommonText(
                    content: 'Ledgers',
                    boldNess: FontWeight.w600,
                    textSize: width * 0.047,
                  ),
                ],
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
            body: Container(
              width: width,
              // height: height,
              padding: EdgeInsets.only(top: 50, left: 16, right: 16),
              child: Container(
                // height: 400,
                decoration: BoxDecoration(
                  color: ColorsConst.appWhite,
                  border: Border.all(color: ColorsConst.appBorderLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              // controller.selectFrom =
                              //     await Get.dialog(CalendarDialog(
                              //   minSelectedDate: DateTime.now(),
                              // ));
                              // logs(
                              //     'by page selectFrom ----------> ${controller.selectFrom}');
                              // controller.update();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                lastDate: DateTime.now(),
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
                                initialDate: DateTime.now(),
                                helpText: 'Ledger From Date',
                                confirmText: 'Okay',
                                cancelText: 'Cancel',
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
                                final formatter = DateFormat('yyyy-MM-dd');
                                final finalDate = formatter.format(picked);
                                DateTime originalDateTime =
                                    DateTime.parse(finalDate);
                                DateTime newDateTime = DateTime(
                                    originalDateTime.year,
                                    originalDateTime.month,
                                    originalDateTime.day);
                                controller.selectFrom.value =
                                    formatter.format(newDateTime);
                                controller.fromDate = newDateTime;
                              } else {
                                controller.selectFrom.value = '';
                              }

                              controller.update();
                            },
                            child: Container(
                              width: width * 0.32,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: ColorsConst.appBorderGrey,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CommonText(
                                      content: controller.selectFrom.value == ''
                                          ? "FROM"
                                          : DateFormat('dd/MM/yyyy').format(
                                              controller.fromDate ??
                                                  DateTime.now()),
                                      boldNess: FontWeight.w400,
                                      textColor: ColorsConst.textColor,
                                      textSize: width * 0.030,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                    color: ColorsConst.borderColor,
                                  ),
                                  // Image.asset(
                                  //   "assets/icons/calender_icon.png",
                                  //   scale: 4.5,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // controller.selectTo =
                              //     await Get.dialog(CalendarDialog(
                              //   minSelectedDate: controller.selectFrom,
                              // ));
                              // logs(
                              //     'by page selectTo ----------> ${controller.selectTo}');
                              // controller.update();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                lastDate: DateTime.now(),
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
                                initialDate: DateTime.now(),
                                helpText: 'Ledger To Date',
                                confirmText: 'Okay',
                                cancelText: 'Cancel',
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
                                final formatter = DateFormat('yyyy-MM-dd');
                                final finalDate = formatter.format(picked);
                                DateTime originalDateTime =
                                    DateTime.parse(finalDate);
                                DateTime newDateTime = DateTime(
                                    originalDateTime.year,
                                    originalDateTime.month,
                                    originalDateTime.day);

                                controller.selectTo.value =
                                    formatter.format(newDateTime);
                                controller.toDate = newDateTime;
                              } else {
                                controller.selectTo.value = '';
                              }

                              controller.update();
                            },
                            child: Container(
                              width: width * 0.32,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: ColorsConst.appBorderGrey,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CommonText(
                                      content: controller.selectTo.value == ''
                                          ? "TO"
                                          : DateFormat('dd/MM/yyyy').format(
                                              controller.toDate ??
                                                  DateTime.now()),
                                      boldNess: FontWeight.w400,
                                      textColor: ColorsConst.textColor,
                                      textSize: width * 0.030,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                    color: ColorsConst.borderColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(30),
                    CommonText(
                      content: 'Ledger will be sent to your registered email',
                      textColor: ColorsConst.appBlack34,
                      textSize: width * 0.035,
                    ),
                    Gap(60),
                    GestureDetector(
                      onTap: () {
                        controller.checkVadilation();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: ColorsConst.primaryColor),
                        child: CommonText(
                          content: 'Send',
                          textColor: ColorsConst.appWhite,
                          boldNess: FontWeight.w600,
                          textSize: width * 0.035,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
