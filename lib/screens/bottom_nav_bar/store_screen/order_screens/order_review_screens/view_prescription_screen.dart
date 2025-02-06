import 'package:b2c/components/common_text.dart';
import 'package:b2c/components/full_image_view.dart';
import 'package:b2c/components/pdf_view.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import "package:flutter_cached_pdfview/src/pdf.dart";
import 'package:flutter_cached_pdfview/src/pdf_view_types.dart';

class ViewPrescriptionScreen extends StatelessWidget {
  const ViewPrescriptionScreen({super.key, required this.images});

  final dynamic images;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey.shade100,
          padding: EdgeInsets.all(20),
          // color: Colors.red,
          child: ListView.separated(
              // scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    images[index].endsWith('.pdf')
                        ? Get.to(() => PdfViewerPage(pdfUrl: images[index]))
                        : Get.to(() => FullImageView(url: images[index]));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.appWhite),
                    // height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          content: "Prescription ${index + 1}",
                          textColor: Colors.black,
                          boldNess: FontWeight.w600,
                        ),
                        Icon(Icons.visibility)
                      ],
                    ),
                  ),
                );
                // return Container(
                //     width: MediaQuery.of(context).size.width * 0.8,
                //     height: 400,
                //     // color: Colors.blue,
                //     child: images[index].endsWith('.pdf')
                //         ? GestureDetector(
                //             onTap: () {
                //               print("pdf clicked");
                //               Get.to(
                //                   () => PdfViewerPage(pdfUrl: images[index]));
                //             },
                //             child: buildPdfWidget(images[index]))
                //         : GestureDetector(
                //             onTap: () {
                //               Get.to(() => FullImageView(url: images[index]));
                //             },
                //             child: PhotoViewGallery.builder(
                //               itemCount: 1,
                //               builder: (context, index) {
                //                 return PhotoViewGalleryPageOptions(
                //                   imageProvider: NetworkImage(images[index]),
                //                   minScale: PhotoViewComputedScale.contained,
                //                   maxScale: PhotoViewComputedScale.covered * 2,
                //                 );
                //               },
                //               scrollPhysics: BouncingScrollPhysics(),
                //               backgroundDecoration: BoxDecoration(
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ));
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemCount: images.length),
          // child: CarouselSlider.builder(
          //   itemCount: (images as List<dynamic>?)?.length ?? 0,
          //   options: CarouselOptions(
          //     enlargeCenterPage: true,
          //     // height: double.infinity,

          //     aspectRatio: 4,
          //     enableInfiniteScroll: false,
          //   ),
          //   itemBuilder: (context, index, realIndex) {
          //     final imageUrl = (images as List<dynamic>)[index];
          //     if (imageUrl.endsWith('.pdf')) {
          //       return buildPdfWidget(imageUrl);
          //     }
          //     return PhotoViewGallery.builder(
          //       itemCount: 1,
          //       builder: (context, index) {
          //         return PhotoViewGalleryPageOptions(
          //           imageProvider: NetworkImage(imageUrl),
          //           minScale: PhotoViewComputedScale.covered,
          //           maxScale: PhotoViewComputedScale.covered * 2,
          //         );
          //       },
          //       scrollPhysics: BouncingScrollPhysics(),
          //       backgroundDecoration: BoxDecoration(
          //         color: Colors.white,
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }

  Widget buildPdfWidget(String pdfUrl) {
    // return PDFView(
    //   filePath: pdfUrl,
    //   autoSpacing: true,
    //   pageSnap: true,
    //   swipeHorizontal: true,
    // );
    return InkResponse(
      onTap: () {
        print("pdf clicked inside");
      },
      child: PDF(enableSwipe: false).cachedFromUrl(
        pdfUrl,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
