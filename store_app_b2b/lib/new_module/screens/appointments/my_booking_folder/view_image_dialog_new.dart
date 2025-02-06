import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';
import 'package:store_app_b2b/new_module/utils/widget/mysaa_app_image_asset_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class ViewImageDialog extends StatefulWidget {
  ViewImageDialog(
      {super.key, required this.image, this.downloadButtonNeeded = false});

  final String image;
  final bool downloadButtonNeeded;

  @override
  State<ViewImageDialog> createState() => _ViewImageDialogState();
}

class _ViewImageDialogState extends State<ViewImageDialog> {
  bool isLoading = false;
  Future<void> downloadInvoice(BuildContext context, String image) async {
    String? message;
    // PermissionStatus status = await requestPermission();
    // if (status == PermissionStatus.granted) {
    try {
      isLoading = true;
      setState(() {});
      var request = await HttpClient().getUrl(Uri.parse(image));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getTemporaryDirectory();
      String fileName = image.split('/').last;

      String myFileName = "${fileName}";
      File? file;
      print('invoiceUrl ---> ${image}');
      file = File('${dir.path}/$myFileName');
      await file.writeAsBytes(bytes);
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Report saved successfully';
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      message = 'An error occurred while saving the invoice';
      isLoading = false;
      setState(() {});
    }
    if (message != null) {
      customSuccessToast(content: message);
      // }
    }
  }

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: themeController.black500Color
          .withOpacity(1), // Slightly transparent background
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: themeController.textPrimaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Icon(
                      Icons.close_outlined,
                      size: 28,
                      color: themeController.bookColor,
                    ),
                  )),
              Gap(1.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 5,
                        color:
                            const Color.fromRGBO(226, 226, 226, 1))), //#E2E2E2
                padding: const EdgeInsets.all(16),
                child: MysaaAppImageAsset(
                  image: widget.image,
                  fit: BoxFit.contain,
                ),
              ),
              Gap(4.h),
              widget.downloadButtonNeeded
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              downloadInvoice(context, widget.image);
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
                        Gap(2.h),
                      ],
                    )
                  : Gap(0)
            ],
          ),
        ),
      ),
    );
  }
}
