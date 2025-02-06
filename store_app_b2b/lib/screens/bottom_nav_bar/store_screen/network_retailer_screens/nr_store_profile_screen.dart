import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/network_retailer/network_retailer_controller.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

// class BackgroundImageWithLoader extends StatelessWidget {
//   final String? imageUrl;
//   final double? height;
//   final double? width;
//   final BorderRadius? borderRadius;

//   const BackgroundImageWithLoader({
//     Key? key,
//     this.imageUrl,
//     this.height,
//     this.width,
//     this.borderRadius,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ImageProvider?>(
//       future: _loadImage(context, imageUrl),
//       builder: (context, snapshot) {
//         print(
//             "printing snapshot -> ${snapshot.connectionState} , ${snapshot.data} ${snapshot.hasData} , ${snapshot.hasError}");
//         return Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black12),
//             borderRadius: borderRadius ?? BorderRadius.circular(4),
//             image: snapshot.connectionState == ConnectionState.done &&
//                     snapshot.hasData
//                 ? DecorationImage(
//                     image: snapshot.data!,
//                     fit: BoxFit.cover,
//                   )
//                 : null,
//           ),
//           child: snapshot.connectionState == ConnectionState.done
//               ? (snapshot.hasError || snapshot.data == null
//                   ? const Center(
//                       child: Icon(
//                         Icons.error,
//                         color: Colors.red,
//                       ),
//                     )
//                   : null)
//               : AppShimmerEffectView(
//                   height: height ?? double.maxFinite,
//                   width: width ?? double.maxFinite,
//                 ),
//         );
//       },
//     );
//   }

//   Future<ImageProvider?> _loadImage(BuildContext context, String? url) async {
//     if (url == null || url.isEmpty || !_isValidUrl(url)) {
//       throw Exception("Invalid image URL");
//     }
//     try {
//       final networkImage = NetworkImage(url);
//       await precacheImage(networkImage, context);
//       return networkImage;
//     } catch (_) {
//       throw Exception("Failed to load image");
//     }
//   }

//   bool _isValidUrl(String url) {
//     final uri = Uri.tryParse(url);
//     return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
//   }
// }

class BackgroundImageWithLoader extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const BackgroundImageWithLoader({
    Key? key,
    this.imageUrl,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider?>(
      future: _loadImage(context, imageUrl),
      builder: (context, snapshot) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            image: snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData
                ? DecorationImage(
                    image: snapshot.data!,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: snapshot.connectionState == ConnectionState.done
              ? (snapshot.hasError || snapshot.data == null
                  ? const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 40,
                      ),
                    )
                  : null)
              : const Center(
                  child: CircularProgressIndicator(), // Loader
                ),
        );
      },
    );
  }

  Future<ImageProvider?> _loadImage(BuildContext context, String? url) async {
    if (url == null || url.isEmpty || !_isValidUrl(url)) {
      throw Exception("Invalid image URL");
    }
    try {
      final networkImage = NetworkImage(url);
      await precacheImage(networkImage, context);
      return networkImage;
    } catch (e) {
      // Log the error for debugging purposes
      debugPrint("Failed to load image: $e");
      throw Exception("Failed to load image");
    }
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
  }
}

class NrStoreProfileScreen extends StatelessWidget {
  NrStoreProfileScreen({super.key, required this.retailerId});

  final String retailerId;

  final NetworkRetailerController controller =
      Get.put(NetworkRetailerController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkRetailerController>(initState: (state) {
      Future.delayed(
        Duration(microseconds: 250),
        () {
          controller.profileStatus(retailerId);
        },
      );
    }, builder: (context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: CommonText(
            content: "Store Profile",
            boldNess: FontWeight.w600,
            textSize: 14,
          ),
          automaticallyImplyLeading: true,
          leading: null,
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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: double.infinity,
          width: double.infinity,
          child: Obx(
            () => controller.isProfileLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : controller.storeProfileDetails.value == null
                    ? SizedBox()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 250,
                                  // color: Colors.red,
                                  child: Column(
                                    children: [
                                      // BackgroundImageWithLoader(
                                      //   imageUrl:
                                      //       "${controller.storeProfileDetails.value!.imageUrl!.bannerImageId}wef",
                                      //   // imageUrl: "wef",
                                      //   height: 200,
                                      //   width: double.infinity,
                                      //   borderRadius: BorderRadius.circular(4),
                                      // ),
                                      // Container(
                                      //   clipBehavior: Clip.hardEdge,
                                      //   decoration: BoxDecoration(
                                      //     border:
                                      //         Border.all(color: Colors.black12),
                                      //     borderRadius:
                                      //         BorderRadius.circular(4),
                                      //     image: DecorationImage(
                                      //       image: NetworkImage(
                                      //         controller
                                      //                 .storeProfileDetails
                                      //                 .value!
                                      //                 .imageUrl!
                                      //                 .bannerImageId ??
                                      //             '',
                                      //       ),

                                      //       fit: BoxFit
                                      //           .cover, // Adjust the image fitting as needed
                                      //     ),
                                      //   ),
                                      //   child:
                                      //       null, // Add child widgets here if needed
                                      //   height: 200,
                                      //   width: double
                                      //       .infinity, // Adjust width if necessary
                                      // ),
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: double.infinity,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: AppImageAsset(
                                          image:
                                              "${controller.storeProfileDetails.value!.imageUrl!.bannerImageId}",
                                          width: double.infinity,
                                          height: double.infinity,

                                          // fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 20,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orange),
                                            shape: BoxShape.circle),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: AppImageAsset(
                                            image: controller
                                                .storeProfileDetails
                                                .value!
                                                .imageUrl!
                                                .profileImageId,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Gap(20),

                            if (controller
                                    .storeProfileDetails.value!.storeName !=
                                null)
                              textWithName(
                                  heading: "Store Name",
                                  content: controller.storeProfileDetails.value!
                                          .storeName ??
                                      ''),
                            // textWithName(
                            //     heading: "Store Name",
                            //     content: '"Good things are near to you"',
                            //     hideHeading: true),

                            if (controller
                                    .storeProfileDetails.value!.storeNumber !=
                                null)
                              textWithName(
                                  heading: "Store Number",
                                  content: controller.storeProfileDetails.value!
                                          .storeNumber ??
                                      ''),

                            if (controller
                                    .storeProfileDetails.value!.ownerName !=
                                null)
                              textWithName(
                                  heading: "Owner",
                                  content: controller.storeProfileDetails.value!
                                          .ownerName ??
                                      ''),

                            if (controller
                                    .storeProfileDetails.value!.phoneNumber !=
                                null)
                              textWithName(
                                  heading: "Contact",
                                  content: controller.storeProfileDetails.value!
                                          .phoneNumber ??
                                      ''),
                            if (controller.storeProfileDetails.value!
                                        .storeAddressDetailRequest !=
                                    null &&
                                controller.storeProfileDetails.value!
                                    .storeAddressDetailRequest!.isNotEmpty)
                              textWithName(
                                  heading: "Location",
                                  content: controller
                                          .storeProfileDetails
                                          .value!
                                          .storeAddressDetailRequest![0]
                                          .addressLine1 ??
                                      ''),

                            if (controller.storeProfileDetails.value!
                                        .storeRating !=
                                    null &&
                                controller.storeProfileDetails.value!
                                    .storeRating!.isNotEmpty)
                              textWithName(
                                  heading: "Store Rating",
                                  content: controller.storeProfileDetails.value!
                                          .storeRating ??
                                      ''),

                            if (controller.storeProfileDetails.value!.dealsIn !=
                                    null &&
                                controller.storeProfileDetails.value!.dealsIn!
                                    .isNotEmpty)
                              textWithName(
                                  heading: "Deals In",
                                  content: controller
                                          .storeProfileDetails.value!.dealsIn ??
                                      ''),

                            if (controller
                                        .storeProfileDetails.value!.popularIn !=
                                    null &&
                                controller.storeProfileDetails.value!.popularIn!
                                    .isNotEmpty)
                              textWithName(
                                  heading: "Popular In",
                                  content: controller.storeProfileDetails.value!
                                          .popularIn ??
                                      ''),
                            textWithName(
                                heading: "Store Timings",
                                content:
                                    "${controller.storeProfileDetails.value!.openTime ?? ''} - ${controller.storeProfileDetails.value!.closeTime ?? ''}"),

                            if (controller.storeProfileDetails.value!
                                        .retailerMessage !=
                                    null &&
                                controller.storeProfileDetails.value!
                                    .retailerMessage!.isNotEmpty)
                              textWithName(
                                  heading: "Message To Customers",
                                  content: controller.storeProfileDetails.value!
                                          .retailerMessage ??
                                      ''),
                          ],
                        ),
                      ),
          ),
        ),
      );
    });
  }

  Widget textWithName({
    required String heading,
    required String content,
    bool hideHeading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hideHeading)
          CommonText(
            content: heading,
            boldNess: FontWeight.w500,
            textSize: 16.sp,
            textColor: Colors.black,
          ),
        CommonText(
          content: content,
          textSize: 14.sp,
          textColor: Colors.black,
        ),
        Gap(20)
      ],
    );
  }
}
