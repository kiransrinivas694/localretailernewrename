import 'dart:io';

import 'package:b2c/components/common_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class QuickDeliveryInvoiceScreen extends StatefulWidget {
  final String invoiceUrl;
  final String? invoiceNumber;

  const QuickDeliveryInvoiceScreen(
      {super.key, required this.invoiceUrl, this.invoiceNumber});

  @override
  State<QuickDeliveryInvoiceScreen> createState() =>
      _QuickDeliveryInvoiceScreenState();
}

class _QuickDeliveryInvoiceScreenState
    extends State<QuickDeliveryInvoiceScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          content: 'Invoice',
          boldNess: FontWeight.w600,
          textSize: 14,
        ),
        elevation: 0,
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
        margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: (widget.invoiceUrl.contains('.pdf'))
            ? PDF(swipeHorizontal: true).cachedFromUrl(
                widget.invoiceUrl,
                placeholder: (progress) => Center(child: Text('$progress %')),
                errorWidget: (error) => Center(child: Text(error.toString())),
              )
            : AppImageAsset(
                image: widget.invoiceUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (isLoading) ? null : _downloadInvoice(context),
        backgroundColor: ColorsConst.primaryColor,
        child: (isLoading)
            ? CircularProgressIndicator(color: Colors.white)
            : Image.asset(
                'assets/icons/download_icon.png',
                package: 'store_app_b2b',
                height: 24,
                width: 24,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Future<PermissionStatus> requestPermission() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
    ].request();
    return status[Permission.storage] ?? PermissionStatus.denied;
  }

  Future<void> _downloadInvoice(BuildContext context) async {
    String? message;
    PermissionStatus status = await requestPermission();
    if (status == PermissionStatus.granted) {
      try {
        isLoading = true;
        setState(() {});
        var request = await HttpClient().getUrl(Uri.parse(widget.invoiceUrl));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        final dir = await getTemporaryDirectory();
        String fileName = widget.invoiceUrl.split('/').last;

        String fileExtension = widget.invoiceUrl.split('.').last;

        String myFileName = "${widget.invoiceNumber}.${fileExtension}";
        File? file;
        print('invoiceUrl ---> ${widget.invoiceUrl}');
        file = File('${dir.path}/$myFileName');
        await file.writeAsBytes(bytes);
        final params = SaveFileDialogParams(sourceFilePath: file.path);
        final finalPath = await FlutterFileDialog.saveFile(params: params);

        if (finalPath != null) {
          message = 'invoice saved to disk';
        }
        isLoading = false;
        setState(() {});
      } catch (e) {
        message = 'An error occurred while saving the invoice';
        isLoading = false;
        setState(() {});
      }
      if (message != null) {
        CommonSnackBar.showToast(message, context,
            showTickMark: false, width: double.infinity);
      }
    }
  }
}
