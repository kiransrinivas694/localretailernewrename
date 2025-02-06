// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:acintyo_rider/ui/common/app_loader.dart';
// import 'package:acintyo_rider/utils/app_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:photo_view/photo_view.dart';

// class ProfileRefundPdfView extends StatefulWidget {
//   final String fileName;
//   final String? imageUrl;
//   final bool isPdf;

//   const ProfileRefundPdfView(
//       {super.key, required this.fileName, this.imageUrl, this.isPdf = true});

//   @override
//   State<ProfileRefundPdfView> createState() => ProfileRefundPdfViewState();
// }

// class ProfileRefundPdfViewState extends State<ProfileRefundPdfView> {
//   File? pFile;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     log('FileName --> ${widget.fileName}');
//     log('FileName --> ${widget.isPdf}');
//     isLoading = true;
//     if (mounted) setState(() {});
//     if (widget.isPdf) openAsset();
//     isLoading = false;
//     if (mounted) setState(() {});
//   }

//   Future<void> openAsset() async {
//     Completer<File> completer = Completer();
//     ByteData pdf = await DefaultAssetBundle.of(context)
//         .load('assets/docs/${widget.fileName}');
//     Directory documents = await getApplicationSupportDirectory();
//     File files = await File('${documents.path}/${widget.fileName}')
//         .writeAsBytes(pdf.buffer.asUint8List(), flush: true);
//     completer.complete(files);
//     pFile = await completer.future;
//     setState(() {});
//     log('pFile --> $pFile');
//   }

//   @override
//   Widget build(BuildContext context) {
//     logs('message --> ${widget.fileName}');
//     return Scaffold(
//       body: !isLoading
//           ? !widget.isPdf
//               ? Center(
//                   child: PhotoView(
//                     minScale: PhotoViewComputedScale.contained,
//                     maxScale: PhotoViewComputedScale.covered * 1.0,
//                     imageProvider: FileImage(File(widget.fileName)),
//                   ),
//                 )
//               : PDFView(
//                   filePath: pFile == null ? widget.fileName : pFile!.path,
//                   autoSpacing: false)
//           : const AppLoader(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  PdfViewerPage({required this.pdfUrl});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late File Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.pdfUrl;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Flutter PDF Viewer",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child: PDFView(
                  filePath: Pfile.path,
                ),
              ),
            ),
    );
  }
}
