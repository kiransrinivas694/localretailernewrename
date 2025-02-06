import 'dart:io';

import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller_new.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/pdf_viewrscreen_new.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/view_image_dialog_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_text_field_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:http/http.dart' as http;

class RecordsListViewScreen extends StatefulWidget {
  RecordsListViewScreen(
      {super.key,
      required this.recordsList,
      required this.title,
      this.padding = const EdgeInsets.all(0.0),
      this.count = true,
      this.medUi = false});

  final List<String> recordsList;
  final String title;
  final EdgeInsets? padding;
  final bool medUi;
  final bool count;

  @override
  State<RecordsListViewScreen> createState() => _RecordsListViewScreenState();
}

class _RecordsListViewScreenState extends State<RecordsListViewScreen> {
  final BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: widget.title,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Using Obx to show loading state or prescription list
                ListView.separated(
                  itemCount: widget.recordsList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (widget.medUi) {
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(119, 187, 173, 1),
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: AppText(
                                    "${widget.count ? widget.title : "Download Invoice"} ${widget.count ? index + 1 : ""}")),
                            GestureDetector(
                              onTap: () async {
                                if (widget.recordsList[index].endsWith("pdf")) {
                                  var url = widget.recordsList[index];

                                  final response =
                                      await http.get(Uri.parse(url));

                                  final bytes = response.bodyBytes;

                                  final dir =
                                      await getApplicationDocumentsDirectory();
                                  File file = File(
                                      '${dir.path}/${DateTime.now().millisecondsSinceEpoch}');

                                  await file.writeAsBytes(bytes, flush: true);
                                  //  logs("pdf");

                                  Get.to(() => PdfViewScreen(
                                      pdfPath: file,
                                      pdf: url,
                                      downloadButtonNeeded: true,
                                      padding: widget.padding));
                                } else {
                                  Get.to(
                                    () =>
                                        // barrierColor:
                                        //     const Color.fromRGBO(0, 0, 0, 0.86),
                                        ViewImageDialog(
                                      image: widget.recordsList[index],
                                      downloadButtonNeeded: true,
                                    ),
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(119, 187, 173, 1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText("Reports Added",
                              color: Color.fromRGBO(75, 181, 67, 1)),
                          ElevatedButton(
                            onPressed: () async {
                              // downloadInvoice(context,
                              //     '${controller.appointmentDetails[index].prescList![index].imageId!}');
                              // // downloadImage();
                              if (widget.recordsList[index].endsWith("pdf")) {
                                var url = widget.recordsList[index];

                                final response = await http.get(Uri.parse(url));

                                final bytes = response.bodyBytes;

                                final dir =
                                    await getApplicationDocumentsDirectory();
                                File file = File(
                                    '${dir.path}/${DateTime.now().millisecondsSinceEpoch}');

                                await file.writeAsBytes(bytes, flush: true);
                                logs("pdf");

                                Get.to(() => PdfViewScreen(
                                      pdfPath: file,
                                      pdf: url,
                                      downloadButtonNeeded: true,
                                    ));
                              } else {
                                Get.to(
                                  () =>
                                      // barrierColor:
                                      //     const Color.fromRGBO(0, 0, 0, 0.86),
                                      ViewImageDialog(
                                    image: widget.recordsList[index],
                                    downloadButtonNeeded: true,
                                  ),
                                );
                              }
                            },
                            child: AppText(
                              'View',
                              fontFamily: AppFont.poppins,
                              color: themeController.textPrimaryColor,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              backgroundColor:
                                  const Color.fromRGBO(119, 187, 173, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Gap(widget.title == "Prescription" ? 10 : 20);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
