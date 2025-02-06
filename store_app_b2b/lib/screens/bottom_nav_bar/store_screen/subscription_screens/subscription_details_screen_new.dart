import 'package:b2c/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/subscription_controller/subscription_controller_new.dart';
import 'package:store_app_b2b/model/subscription_tenure_model_new.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen(
      {super.key, this.showFreeTrialButton = false});

  final bool showFreeTrialButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(236, 240, 243, 1),
        appBar: AppBar(
          centerTitle: true,
          // title: FutureBuilder<String>(
          //   future: SharPreferences.getString(SharPreferences.storeName),
          //   builder: (_, data) {
          //     return CommonText(
          //       content: '${controller.appBarTitle}',
          //       boldNess: FontWeight.w600,
          //       textSize: 14,
          //     );
          //   },
          // ),
          title: Text("Subscription Details"),
          automaticallyImplyLeading: true,
          // leading: controller.currentIndex == 0 || controller.currentIndex == 4
          //     ? null
          //     : IconButton(
          //         icon: const Icon(Icons.arrow_back),
          //         onPressed: () async {
          //           controller.appBarTitle = await SharPreferences.getString(
          //               SharPreferences.storeName);
          //           controller.currentIndex = 0;
          //           controller.currentWidget = StoreScreen();
          //           controller.update();
          //         },
          //       ),
          elevation: 0,
          // actions: [
          //   if (controller.currentIndex == 0)
          //     Switch(
          //       value: true,
          //       onChanged: (value) => Get.offAll(() => const DashboardScreen()),
          //       activeColor: ColorsConst.primaryColor,
          //       inactiveThumbColor: ColorsConst.textColor,
          //     ),
          // if(controller.currentIndex == 0 || controller.currentIndex == 3)
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: InkWell(
          //     onTap: () async {
          //       // if (controller.currentIndex == 4) {
          //       //   await SharPreferences.clearSharPreference();
          //       //   await PreferencesHelper().clearPreferenceData();
          //       // }
          //       /*controller.currentIndex == 4
          //                 ? Get.to(() => LoginScreen())
          //                 : */
          //       Get.to(() => const NotificationScreen());
          //     },
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         /*controller.currentIndex == 4
          //                   ? const Icon(Icons.logout)
          //                   : */
          //         Image.asset(
          //           "assets/icons/notification.png",
          //           scale: 5,
          //           package: 'store_app_b2b',
          //         ),
          //         CommonText(
          //           content: /*controller.currentIndex == 4
          //                     ? "Logout"
          //                     : */
          //           "Notification",
          //           textSize: width * 0.03,
          //         ),
          //       ],
          //     ),
          //   ),
          // )
          // ],
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
        body: GetBuilder<SubscriptionController>(
          init: SubscriptionController(),
          initState: (state) {
            Future.delayed(
              Duration(microseconds: 150),
              () {
                SubscriptionController controller =
                    Get.find<SubscriptionController>();
                controller.getPlanTenures();
              },
            );
          },
          builder: (controller) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Color.fromRGBO(236, 240, 243, 1),
              // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     ListView.builder(
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: 2,
                  //       itemBuilder: (context, index) {
                  //         return Container(
                  //           padding:
                  //               EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //         );
                  //       },
                  //     )
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   height: 50,
                  //   // padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: Center(
                  //     child: ListView.builder(
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: controller.plansPhases.length,
                  //       itemBuilder: (context, index) {
                  //         return GestureDetector(
                  //           onTap: () {
                  //             controller.changePlanPhase(index);
                  //           },
                  //           child: Container(
                  //             margin: EdgeInsets.all(10),
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 8, vertical: 4),
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(8),
                  //               border: Border.all(
                  //                   width: 1,
                  //                   color: index ==
                  //                           controller.selectedPlanPhaseIndex
                  //                       ? Colors.transparent
                  //                       : Color.fromRGBO(255, 122, 0, 1)),
                  //               color:
                  //                   index == controller.selectedPlanPhaseIndex
                  //                       ? Color.fromRGBO(255, 122, 0, 1)
                  //                       : Colors.transparent,
                  //             ),
                  //             child: Center(
                  //               child: CommonText(
                  //                 content: controller.plansPhases[index],
                  //                 textColor:
                  //                     index == controller.selectedPlanPhaseIndex
                  //                         ? Colors.white
                  //                         : Color.fromRGBO(255, 122, 0, 1),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 50,
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.plansPhases.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              controller.changePlanPhase(index);
                              controller.getPlansByTenure(
                                  controller.plansPhases[index]);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: index ==
                                            controller.selectedPlanPhaseIndex
                                        ? Colors.transparent
                                        : Color.fromRGBO(255, 122, 0, 1)),
                                color:
                                    index == controller.selectedPlanPhaseIndex
                                        ? Color.fromRGBO(255, 122, 0, 1)
                                        : Colors.transparent,
                              ),
                              child: Center(
                                child: CommonText(
                                  content: controller.plansPhases[index],
                                  textColor:
                                      index == controller.selectedPlanPhaseIndex
                                          ? Colors.white
                                          : Color.fromRGBO(255, 122, 0, 1),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Expanded(
                    // child: ListView.separated(
                    //   itemCount: 4,
                    //   physics: BouncingScrollPhysics(),
                    //   separatorBuilder: (context, index) {
                    //     return SizedBox(
                    //       height: 20,
                    //     );
                    //   },
                    //   itemBuilder: (context, index) {
                    //     return Container(
                    //         margin: EdgeInsets.only(
                    //             top: index == 0 ? 10 : 0,
                    //             bottom: index == 3 ? 20 : 0),
                    //         child: SubscriptionDetailCard(context,
                    //             colorCollection: controller
                    //                 .planCardColorsCollection[index]));
                    //   },
                    // ),
                    child: Container(
                      height: 375,
                      width: double.infinity,
                      child: ListView.separated(
                        itemCount: controller.subscriptionPlansList.length,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.only(
                                  // top: index == 0 ? 10 : 0,
                                  // bottom: index == 3 ? 20 : 0,
                                  left: 20,
                                  right: 20,
                                  bottom:
                                      controller.subscriptionPlansList.length -
                                                  1 ==
                                              index
                                          ? 20
                                          : 0),
                              child: SubscriptionDetailCard(context,
                                  planIndex: index,
                                  controller: controller,
                                  planCollection:
                                      controller.subscriptionPlansList[index],
                                  colorCollection: index >= 4
                                      ? controller.planCardColorsCollection[0]
                                      : controller
                                          .planCardColorsCollection[index]));
                        },
                      ),
                    ),
                  ),
                  showFreeTrialButton
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                          height: 74,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12))),
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: Color.fromRGBO(255, 122, 0, 1))),
                              child: Center(
                                child: CommonText(
                                  content: "Free Trial for 7-day",
                                  textColor: Color.fromRGBO(255, 122, 0, 1),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget SubscriptionDetailCard(BuildContext context,
      {required colorCollection,
      required int? planIndex,
      required SubscriptionTenureModel? planCollection,
      required SubscriptionController? controller}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17),
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: colorCollection["backgroundGradient"],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planCollection?.planType ?? "",
                      style: GoogleFonts.poppins(
                        color: colorCollection["planHeadingColor"],
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Benefits Include",
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(113, 113, 113, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '₹${planCollection?.planRate}',
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(38, 38, 38, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '/${planCollection?.planTenure}',
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(38, 38, 38, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            itemCount: planCollection?.features.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? colorCollection["firstBenefitColor"]
                          : Color.fromRGBO(75, 75, 75, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: CommonText(
                      content: planCollection?.features[index],
                      textColor: index == 0
                          ? colorCollection["firstBenefitColor"]
                          : Color.fromRGBO(75, 75, 75, 1),
                      boldNess: FontWeight.w500,
                      textSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              controller?.selectedSubscriptionIndex = planIndex!;
              controller?.update();
              print(
                  "printing -- parse int planrate --> ${int.parse('${controller?.subscriptionPlansList[controller.selectedSubscriptionIndex].planRate}')}");
              print(
                  "printing -- parse int id ---> ${controller!.subscriptionPlansList[controller.selectedSubscriptionIndex].id ?? ''}");

              if (controller
                          .subscriptionPlansList[
                              controller.selectedSubscriptionIndex]
                          .paymentFlg ==
                      "Y" ||
                  controller
                          .subscriptionPlansList[
                              controller.selectedSubscriptionIndex]
                          .paymentFlg ==
                      null) {
                controller.getRazorPayDataApi(
                  int.parse(
                      '${controller.subscriptionPlansList[controller.selectedSubscriptionIndex].planRate}00'),
                  controller
                          .subscriptionPlansList[
                              controller.selectedSubscriptionIndex]
                          .id ??
                      '',
                );
              } else {
                controller.getSubscriptionSubscribe(
                    transactionId: "nopaymentid_NIUaoI4cdZZjGE");
              }
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                // height: 40,
                width: 100,
                padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                decoration: BoxDecoration(
                  color: ColorsConst.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CommonText(
                    content: 'Subscribe',
                    textColor: ColorsConst.appWhite,
                    boldNess: FontWeight.w600,
                    textSize: 14,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//   Widget SubscriptionDetailCard(BuildContext context, {colorCollection}) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(17),
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: LinearGradient(
//           colors: colorCollection["backgroundGradient"],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Platinum",
//                       style: GoogleFonts.poppins(
//                         color: colorCollection["planHeadingColor"],
//                         fontWeight: FontWeight.w600,
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       "Benefits Include",
//                       style: GoogleFonts.poppins(
//                           color: Color.fromRGBO(113, 113, 113, 1),
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           height: 1),
//                     ),
//                   ],
//                 ),
//               ),
//               RichText(
//                 text: TextSpan(
//                   text: "₹99/",
//                   style: GoogleFonts.poppins(
//                     color: Color.fromRGBO(38, 38, 38, 1),
//                     fontWeight: FontWeight.w500,
//                     fontSize: 24,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: 'Monthly',
//                       style: GoogleFonts.poppins(
//                         color: Color.fromRGBO(38, 38, 38, 1),
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           ListView.builder(
//             itemCount: 3,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 4,
//                     width: 4,
//                     decoration: BoxDecoration(
//                       color: index == 0
//                           ? colorCollection["firstBenefitColor"]
//                           : Color.fromRGBO(75, 75, 75, 1),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   Expanded(
//                     child: CommonText(
//                       content: "Live Order Status Tracking.",
//                       textColor: index == 0
//                           ? colorCollection["firstBenefitColor"]
//                           : Color.fromRGBO(75, 75, 75, 1),
//                       boldNess: FontWeight.w500,
//                       textSize: 12,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//               // height: 40,
//               width: 100,
//               padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
//               decoration: BoxDecoration(
//                 color: ColorsConst.primaryColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Center(
//                 child: CommonText(
//                   content: 'Subscribe',
//                   textColor: ColorsConst.appWhite,
//                   boldNess: FontWeight.w600,
//                   textSize: 14,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
}
