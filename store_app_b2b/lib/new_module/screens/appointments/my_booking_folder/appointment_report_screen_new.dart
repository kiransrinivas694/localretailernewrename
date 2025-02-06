import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_app_b2b/new_module/controllers/booking_appointmet_controller/booking_appointment_controller_new.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/pdf_viewrscreen_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_text_field_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/new_module/screens/appointments/my_booking_folder/view_image_dialog_new.dart';

class AppointmentReportsScreen extends StatefulWidget {
  AppointmentReportsScreen({super.key, required this.index});

  final int index;

  @override
  State<AppointmentReportsScreen> createState() =>
      _AppointmentReportsScreenState();
}

class _AppointmentReportsScreenState extends State<AppointmentReportsScreen> {
  final BooikingAppointmentController controller =
      Get.put(BooikingAppointmentController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppBar(
          title: 'Medical Reports',
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
                    itemCount: controller
                        .appointmentDetails[widget.index].prescList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
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
                                if (controller.appointmentDetails[widget.index]
                                    .prescList![index].imageId!
                                    .endsWith("pdf")) {
                                  var url = controller
                                      .appointmentDetails[widget.index]
                                      .prescList![index]
                                      .imageId!;

                                  final response =
                                      await http.get(Uri.parse(url));

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
                                  Get.dialog(
                                    barrierColor:
                                        const Color.fromRGBO(0, 0, 0, 0.86),
                                    ViewImageDialog(
                                      image: controller
                                          .appointmentDetails[widget.index]
                                          .prescList![index]
                                          .imageId!,
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
                      return Gap(20);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
