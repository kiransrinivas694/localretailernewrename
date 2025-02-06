// import 'package:b2c/components/login_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:store_app_b2b/components/common_text.dart';
// import 'package:store_app_b2b/constants/colors_const.dart';
// import 'package:store_app_b2b/controllers/bottom_controller/store_controller/buy_controller/categories_controller.dart';
// import 'package:store_app_b2b/controllers/bottom_controller/store_controller/store_controller.dart';
// import 'package:store_app_b2b/controllers/home_controller.dart';
// import 'package:store_app_b2b/delegate/height_delegate.dart';
// import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/buy_screen/buy_screen.dart';
// import 'package:store_app_b2b/utils/shar_preferences.dart';
// import 'package:store_app_b2b/widget/app_image_assets.dart';

// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     print("printing this categories is called");

//     return GetBuilder<CategoriesController>(
//       init: CategoriesController(),
//       initState: (state) {
//         Future.delayed(
//           Duration(milliseconds: 300),
//           () async {
//             String userId =
//                 await SharPreferences.getString(SharPreferences.loginId) ?? '';

//             if (userId == "") {
//               // isCategoriesLoading = false;
//               // update();
//               Get.dialog(LoginDialog());
//               // return;
//             }
//             // CategoriesController controller = Get.find<CategoriesController>();
//             // controller.getStoreCategories();
//             print("init is calling in categories screen");
//           },
//         );
//       },
//       builder: (categoriesController) {
//         return categoriesController.isCategoriesLoading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Container(
//                 // color: Colors.red,
//                 height: double.infinity,
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: ListView(
//                   physics: BouncingScrollPhysics(),
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       child: GridView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount:
//                             categoriesController.storeCategoryList.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
//                                 crossAxisCount: 2,
//                                 height: 170,
//                                 crossAxisSpacing: 20,
//                                 mainAxisSpacing: 20),
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () {
//                               HomeController controller =
//                                   Get.put(HomeController());
//                               controller.isFromBuyTab = true;
//                               controller.currentIndex = 2;
//                               controller.appBarTitle = categoriesController
//                                       .storeCategoryList[index].categoryName ??
//                                   '';
//                               controller.currentWidget = BuyScreen(
//                                 categoryId: categoriesController
//                                         .storeCategoryList[index].categoryId ??
//                                     '',
//                               );
//                               controller.update();
//                               // Get.to(() => BuyScreen(
//                               //       categoryId: categoriesController
//                               //               .storeCategoryList[index]
//                               //               .categoryId ??
//                               //           '',
//                               //     ));
//                               // switch (index) {
//                               //   case 0:
//                               //     controller.currentIndex = 2;
//                               //     controller.appBarTitle = "Medicines";
//                               //     controller.currentWidget = BuyScreen(
//                               //       categoryId: API.generalMedicineCategoryId,
//                               //     );
//                               //     controller.update();
//                               //     break;
//                               //   case 1:
//                               //     controller.currentIndex = 2;
//                               //     controller.appBarTitle = "Generic medicine";
//                               //     controller.currentWidget = BuyScreen(
//                               //       categoryId: API.genericMedicineCategoryId,
//                               //     );
//                               //     controller.update();
//                               //     break;
//                               //   case 2:
//                               //     controller.currentIndex = 2;
//                               //     controller.appBarTitle = "Speciality Medicines";
//                               //     controller.currentWidget = BuyScreen(
//                               //       categoryId: API.sppCategoryId,
//                               //     );
//                               //     controller.update();
//                               //     break;
//                               //   case 4:
//                               //     Get.to(() => const AToZSoonScreen());
//                               //     break;
//                               //   case 3:
//                               //     Get.to(() => const UnlistedSoonScreen());
//                               //     break;
//                               //   case 5:
//                               //   case 6:
//                               //     Get.to(() => const QuickDeliveryScreen());
//                               //     controller.update();
//                               //     break;
//                               // }
//                             },
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: ColorsConst.semiGreyColor
//                                         .withOpacity(0.3),
//                                     spreadRadius: 3,
//                                     blurRadius: 3,
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   // index == 5
//                                   //     ? Lottie.asset(
//                                   //         'assets/icons/quick_delivery_ani.json',
//                                   //         width: 72,
//                                   //         package: 'store_app_b2b') :
//                                   // Image.network(
//                                   //   "${categoriesController.storeCategoryList[index].imgUrl}",
//                                   //   // scale: 1,
//                                   //   height: 70,
//                                   //   // package: 'store_app_b2b',
//                                   //   fit: BoxFit.cover,
//                                   // ),
//                                   AppImageAsset(
//                                     image: categoriesController
//                                         .storeCategoryList[index].imgUrl,
//                                     height: 70,
//                                     width: 70,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   CommonText(
//                                     content:
//                                         "${categoriesController.storeCategoryList[index].categoryName}",
//                                     textColor: ColorsConst.textColor,
//                                     boldNess: FontWeight.w600,
//                                     textAlign: TextAlign.center,
//                                     textSize: 13,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ));
//       },
//     );
//   }
// }
