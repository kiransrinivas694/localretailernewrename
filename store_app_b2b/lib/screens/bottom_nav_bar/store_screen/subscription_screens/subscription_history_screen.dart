import 'package:b2c/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/bottom_controller/store_controller/subscription_controller/subscription_controller.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title: Text("Your Subscriptions"),
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
              Duration(milliseconds: 150),
              () {
                SubscriptionController controller =
                    Get.find<SubscriptionController>();
                controller.getAllSubscriptionsHistory();
              },
            );
          },
          builder: (controller) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 1, color: ColorsConst.primaryColor),
                      ),
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            content: "You’re on Basic Plan",
                            // textColor: ColorsConst.primaryColor,
                            textColor: Color.fromRGBO(255, 122, 0, 1),
                            boldNess: FontWeight.w600,
                            textSize: 18,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Basic",
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 139, 3, 1),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Benefits Include",
                                      style: TextStyle(
                                        color: ColorsConst.greyByTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "₹99/",
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 139, 3, 1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Monthly',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 139, 3, 1),
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
                            itemCount: 3,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 4,
                                    width: 4,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      content: "Live Order Status Tracking.",
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w500,
                                      textSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color.fromRGBO(199, 199, 199, 1),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 90,
                                child: CommonText(
                                  content: "Billing Cycle",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w600,
                                  textSize: 14,
                                ),
                              ),
                              CommonText(
                                content: " : ",
                                textColor: ColorsConst.appblack54,
                                boldNess: FontWeight.w600,
                                textSize: 14,
                              ),
                              Expanded(
                                child: CommonText(
                                  content: "Auto Re-new Payment",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w500,
                                  textSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 90,
                                child: CommonText(
                                  content: "Price",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w600,
                                  textSize: 14,
                                ),
                              ),
                              CommonText(
                                content: " : ",
                                textColor: ColorsConst.appblack54,
                                boldNess: FontWeight.w600,
                                textSize: 14,
                              ),
                              Expanded(
                                child: CommonText(
                                  content: "₹99/-",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w500,
                                  textSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 90,
                                child: CommonText(
                                  content: "Payment",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w600,
                                  textSize: 14,
                                ),
                              ),
                              CommonText(
                                content: " : ",
                                textColor: ColorsConst.appblack54,
                                boldNess: FontWeight.w600,
                                textSize: 14,
                              ),
                              Expanded(
                                child: CommonText(
                                  content: "UPI",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w500,
                                  textSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 90,
                                child: CommonText(
                                  content: "Paid Date",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w600,
                                  textSize: 14,
                                ),
                              ),
                              CommonText(
                                content: " : ",
                                textColor: ColorsConst.appblack54,
                                boldNess: FontWeight.w600,
                                textSize: 14,
                              ),
                              Expanded(
                                child: CommonText(
                                  content: "02-12-2023",
                                  textColor: ColorsConst.appblack54,
                                  boldNess: FontWeight.w500,
                                  textSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CommonText(
                            content: "Validity",
                            textColor: ColorsConst.primaryColor,
                            boldNess: FontWeight.w500,
                            textSize: 14,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CommonText(
                            content: "From : 02-12-2023    To : 02-12-2023",
                            textColor: ColorsConst.appblack54,
                            boldNess: FontWeight.w600,
                            textSize: 14,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CommonText(
                            content:
                                "Your plan will expire in 1 day pay now to continue your services",
                            textColor: Color.fromRGBO(255, 62, 71, 1),
                            textSize: 12,
                            boldNess: FontWeight.w500,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Expanded(
                              //   child: CommonText(
                              //     content: "Change payment mode",
                              //     textColor: ColorsConst.primaryColor,
                              //     boldNess: FontWeight.w600,
                              //     textSize: 12,
                              //     textAlign: TextAlign.center,
                              //     decoration: TextDecoration.underline,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              Container(
                                height: 40,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: ColorsConst.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: CommonText(
                                    content: 'Change Plan',
                                    textColor: ColorsConst.appWhite,
                                    boldNess: FontWeight.w600,
                                    textSize: 14,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonText(
                      content: "Subscriptions History",
                      textColor: ColorsConst.greyByTextColor,
                      boldNess: FontWeight.w400,
                      textSize: 14,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.subscriptionsHistory.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 12,
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 1, color: ColorsConst.primaryColor),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                    ),
                                    // border: Border.all(
                                    //     width: 1, color: ColorsConst.primaryColor),
                                    // color: ColorsConst.primaryColor,
                                    color: Color.fromRGBO(255, 122, 0, 1)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   "Basic",
                                          //   style: TextStyle(
                                          //     color: ColorsConst.appWhite,
                                          //     fontWeight: FontWeight.w600,
                                          //     fontSize: 20,
                                          //   ),
                                          // ),
                                          CommonText(
                                            content: "Basic",
                                            textColor: ColorsConst.appWhite,
                                            textSize: 20,
                                            boldNess: FontWeight.w600,
                                          )
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            "${controller.subscriptionsHistory[index]["paidAmount"].toString()}/",
                                        style: TextStyle(
                                          color: ColorsConst.appWhite,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          fontSize: 21,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Monthly',
                                            style: TextStyle(
                                                color: ColorsConst.appWhite,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                fontFamily: "Poppins"),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(9, 10, 8, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: CommonText(
                                        content: "Purchased on",
                                        textColor: ColorsConst.appblack54,
                                        boldNess: FontWeight.w400,
                                        textSize: 14,
                                      ),
                                    ),
                                    CommonText(
                                      content: " : ",
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w400,
                                      textSize: 14,
                                    ),
                                    Expanded(
                                      child: CommonText(
                                        content: controller
                                                    .subscriptionsHistory[index]
                                                ["startDate"] ??
                                            "",
                                        textColor: ColorsConst.appblack54,
                                        boldNess: FontWeight.w400,
                                        textSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: CommonText(
                                        content: "Expired on",
                                        textColor: ColorsConst.appblack54,
                                        boldNess: FontWeight.w400,
                                        textSize: 14,
                                      ),
                                    ),
                                    CommonText(
                                      content: " : ",
                                      textColor: ColorsConst.appblack54,
                                      boldNess: FontWeight.w400,
                                      textSize: 14,
                                    ),
                                    Expanded(
                                      child: CommonText(
                                        content: controller
                                                    .subscriptionsHistory[index]
                                                ["endDate"] ??
                                            "",
                                        textColor: ColorsConst.appblack54,
                                        boldNess: FontWeight.w400,
                                        textSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
