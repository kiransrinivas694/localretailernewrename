// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:mysaaa/app/widget/app_image_assets.dart';
// import 'package:mysaaa/controllers/theme/theme_controller.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class ViewImageDialog extends StatelessWidget {
//   ViewImageDialog({super.key, required this.image});

//   final String image;

//   final ThemeController themeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: themeController.black500Color
//           .withOpacity(1), // Slightly transparent background
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 6),
//         decoration: BoxDecoration(
//           color: themeController.textPrimaryColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     child: Icon(
//                       Icons.close_outlined,
//                       size: 28,
//                       color: themeController.bookColor,
//                     ),
//                   )),
//               Gap(1.h),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                         width: 5,
//                         color:
//                             const Color.fromRGBO(226, 226, 226, 1))), //#E2E2E2
//                 padding: const EdgeInsets.all(16),
//                 child: AppImageAsset(
//                   image: image,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Gap(4.h)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
