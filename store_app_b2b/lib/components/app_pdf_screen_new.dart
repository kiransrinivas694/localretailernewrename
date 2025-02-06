import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class PdfUploadScreen extends StatelessWidget {
  final File pdfPath;

  const PdfUploadScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppText(
          "Invoice",
          fontWeight: FontWeight.w600,
          fontSize: width * 0.047,
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
      body: PDFView(filePath: pdfPath.path),
    );
  }
}
