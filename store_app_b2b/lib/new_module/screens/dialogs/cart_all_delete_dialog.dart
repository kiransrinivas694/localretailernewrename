// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mysaaa/app/widget/app_text.dart';
// import 'package:mysaaa/controllers/theme/theme_controller.dart';

// class CartAllDeleteDialog extends StatelessWidget {
//   CartAllDeleteDialog({
//     super.key,
//     required this.continueClick,
//   });

//   final VoidCallback continueClick;

//   final ThemeController themeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Dialog(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       backgroundColor: themeController.nav1,
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: width / 2,
//               child: AppText(
//                 "Are you sure you want to remove all items from your cart?",
//                 fontSize: width * 0.04,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: height * 0.03),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         elevation: 0,
//                         backgroundColor: Colors.transparent,
//                         side: BorderSide(
//                             color: themeController.textPrimaryColor)),
//                     onPressed: () {
//                       Get.back();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 0),
//                       child: AppText(
//                         "Back",
//                         fontSize: width * 0.035,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                       backgroundColor: Colors.white,
//                     ),
//                     onPressed: continueClick,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 0),
//                       child: AppText(
//                         "Delete",
//                         fontSize: width * 0.035,
//                         color: themeController.nav1,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
