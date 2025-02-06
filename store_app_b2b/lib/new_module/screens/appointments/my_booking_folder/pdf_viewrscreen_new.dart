import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_app_bar.dart';
import 'package:store_app_b2b/new_module/utils/widget/app_text_field.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen(
      {super.key,
      required this.pdfPath,
      this.downloadButtonNeeded = false,
      this.padding = const EdgeInsets.all(0.0),
      this.pdf = ''});

  final File pdfPath;
  final String pdf;
  final EdgeInsets? padding;
  final bool downloadButtonNeeded;

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  Future<void> downloadInvoice(BuildContext context, String image) async {
    String? message;
    // PermissionStatus status = await requestPermission();
    // if (status == PermissionStatus.granted) {
    try {
      setState(() {});
      var request = await HttpClient().getUrl(Uri.parse(image));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getTemporaryDirectory();
      String fileName = image.split('/').last;

      String fileExtension = image.split('.').last;

      String myFileName = "${fileName}";
      File? file;
      print('invoiceUrl ---> ${image}');
      file = File('${dir.path}/$myFileName');
      await file.writeAsBytes(bytes);
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Downloaded successfully';
      }
      setState(() {});
    } catch (e) {
      message = 'An error occurred while saving the invoice';
      setState(() {});
    }
    if (message != null) {
      customSuccessToast(content: message);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppAppBar(title: ""),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: widget.padding!,
                child: PDFView(
                  filePath: widget.pdfPath.path,
                  onRender: (_pages) {
                    setState(() {
                      _totalPages = _pages!;
                    });
                  },
                  onViewCreated: (PDFViewController vc) {
                    _pdfViewController = vc;
                  },
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      _currentPage = page!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Page ${_currentPage + 1} of $_totalPages',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            widget.downloadButtonNeeded
                ? Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            downloadInvoice(context, widget.pdf);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: themeController.navShadow1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.file_download_outlined,
                                  color: themeController.textPrimaryColor,
                                  size: 20,
                                ),
                                Gap(5),
                                AppText(
                                  'Download',
                                  color: themeController.textPrimaryColor,
                                  fontSize: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gap(5.h),
                    ],
                  )
                : Gap(0)
          ],
        ),
      ),
    );
  }
}
