import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_circular_slider/multi_circular_slider.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/bottom_controller/home_controller/analytics_controller.dart';

import 'controller/analytics_controller.dart';

class AnalyticsScreen extends StatefulWidget {
  AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsController analyticsController =
      Get.put(AnalyticsController());

  @override
  void initState() {
    // TODO: implement initState
    AnalyticsApiController.to.analyticsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonText(
          content: "Analytics",
          boldNess: FontWeight.w600,
          textSize: width * 0.047,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.appGradientColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.04),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.01),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/total_product_icon.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(height: Get.height * 0.01),
                              CommonText(
                                content: "Total Products",
                                boldNess: FontWeight.w400,
                                textSize: width * 0.032,
                                textColor: AppColors.textColor,
                                textAlign: TextAlign.center,
                              ),
                              CommonText(
                                content:
                                    "${AnalyticsApiController.to.analyticsRes['totalProducts'] ?? '0'}",
                                boldNess: FontWeight.w500,
                                textSize: width * 0.04,
                                textColor: AppColors.textColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.01),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff30394B),
                                Color(0xff090E1A),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/ruppes_icon.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(height: Get.height * 0.01),
                              CommonText(
                                content: "Total Revenue",
                                boldNess: FontWeight.w400,
                                textSize: width * 0.032,
                                textColor: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                              CommonText(
                                content:
                                    "₹ ${AnalyticsApiController.to.analyticsRes['totalSales'] ?? '0'}",
                                boldNess: FontWeight.w500,
                                textSize: width * 0.04,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.01),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/user_icon.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(height: Get.height * 0.01),
                              CommonText(
                                content: "Total Users",
                                boldNess: FontWeight.w400,
                                textSize: width * 0.032,
                                textColor: AppColors.textColor,
                                textAlign: TextAlign.center,
                              ),
                              CommonText(
                                content:
                                    "${AnalyticsApiController.to.analyticsRes['totalCustomers'] ?? '0'}",
                                boldNess: FontWeight.w500,
                                textSize: width * 0.04,
                                textColor: AppColors.textColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: Get.height * 0.01),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Container(
                        width: width * 0.30,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/active_order_icon.png",
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            CommonText(
                              content: "Active Orders",
                              boldNess: FontWeight.w400,
                              textSize: width * 0.032,
                              textColor: AppColors.textColor,
                            ),
                            CommonText(
                              content:
                                  "${AnalyticsApiController.to.analyticsRes['totalActiveOrders'] ?? '0'}",
                              boldNess: FontWeight.w500,
                              textSize: width * 0.04,
                              textColor: AppColors.textColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Container(
                        width: width * 0.30,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/user_icon.png",
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            CommonText(
                              content: "Total Categories",
                              boldNess: FontWeight.w400,
                              textSize: width * 0.032,
                              textColor: AppColors.textColor,
                            ),
                            CommonText(
                              content:
                                  "${AnalyticsApiController.to.analyticsRes['totalCategoreis'] ?? '0'}",
                              boldNess: FontWeight.w500,
                              textSize: width * 0.04,
                              textColor: AppColors.textColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: height * 0.035),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CommonText(
                        content: "1540",
                        boldNess: FontWeight.w600,
                        textSize: width * 0.05,
                        textColor: Colors.red,
                      ),
                      CommonText(
                        content: "Express",
                        textSize: width * 0.04,
                        textColor: Colors.red,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CommonText(
                        content: "1915",
                        boldNess: FontWeight.w600,
                        textSize: width * 0.05,
                        textColor: Color(0xFF5388D8),
                      ),
                      CommonText(
                        content: "Instant",
                        textSize: width * 0.04,
                        textColor: Color(0xFF5388D8),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CommonText(
                        content: "1955",
                        boldNess: FontWeight.w600,
                        textSize: width * 0.05,
                        textColor: Color(0xFFF4BE37),
                      ),
                      CommonText(
                        content: "Schedule",
                        textSize: width * 0.04,
                        textColor: Color(0xFFF4BE37),
                      ),
                    ],
                  ),
                ],
              ),*/
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: "₹" +
                                    double.parse((AnalyticsApiController
                                                            .to.analyticsRes[
                                                        'dashboardStoreSalesAgg']
                                                    ?['currentDaySales'] ??
                                                '0')
                                            .toString())
                                        .toStringAsFixed(2),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: AppColors.appblack,
                              ),
                              CommonText(
                                content: "Current Day Sales",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: AppColors.appblack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: "₹" +
                                    double.parse((AnalyticsApiController
                                                            .to.analyticsRes[
                                                        'dashboardStoreSalesAgg']
                                                    ?['yesterDaySales'] ??
                                                '0')
                                            .toString())
                                        .toStringAsFixed(2),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: AppColors.appblack,
                              ),
                              CommonText(
                                content: "Yesterday Sales",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: AppColors.appblack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: height * 0.025),
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: "₹" +
                                    double.parse((AnalyticsApiController
                                                            .to.analyticsRes[
                                                        'dashboardStoreSalesAgg']
                                                    ?['currentMonthSales'] ??
                                                '0')
                                            .toString())
                                        .toStringAsFixed(2),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: AppColors.appblack,
                              ),
                              CommonText(
                                content: "Current Month Sales",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: AppColors.appblack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: "₹" +
                                    double.parse((AnalyticsApiController
                                                            .to.analyticsRes[
                                                        'dashboardStoreSalesAgg']
                                                    ?['lastMonthSales'] ??
                                                '0')
                                            .toString())
                                        .toStringAsFixed(2),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: AppColors.appblack,
                              ),
                              CommonText(
                                content: "Last Month Sales",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: AppColors.appblack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: height * 0.025),
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: "₹" +
                                    double.parse((AnalyticsApiController
                                                            .to.analyticsRes[
                                                        'dashboardStoreSalesAgg']
                                                    ?['currentMonthSales'] ??
                                                '0')
                                            .toString())
                                        .toStringAsFixed(2),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: AppColors.appblack,
                              ),
                              CommonText(
                                content: "Current Month Sales",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: AppColors.appblack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: "₹" +
                                    double.parse((AnalyticsApiController
                                                            .to.analyticsRes[
                                                        'dashboardStoreSalesAgg']
                                                    ?['lastMonthSales'] ??
                                                '0')
                                            .toString())
                                        .toStringAsFixed(2),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: AppColors.appblack,
                              ),
                              CommonText(
                                content: "Last Month Sales",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: AppColors.appblack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: height * 0.04),
              /*  StreamBuilder(
                  stream: AnalyticsApiController.to.analyticsRes.stream,
                  builder: (context, snapshot) {
                    return MultiCircularSlider(
                      size: MediaQuery.of(context).size.width / 2,
                      progressBarType: MultiCircularSliderType
                          .circular, // the type of indictor you want circular or linear
                      values: [
                        (double.parse((AnalyticsApiController
                                    .to.analyticsRes['totalRejcted'] ??
                                0)
                            .toString())),
                        (double.parse((AnalyticsApiController
                                    .to.analyticsRes['totalPartialOrders'] ??
                                0)
                            .toString())),
                        (double.parse((AnalyticsApiController
                                    .to.analyticsRes['totalDelivered'] ??
                                0)
                            .toString())),
                      ],
                      colors: const [
                        Color(0xFF5388D8),
                        Color(0xFFD13333),
                        Color(0xFFF4BE37),
                      ],
                      showTotalPercentage: false,
                      trackColor: AppColors.dividerColor,
                      animationDuration: const Duration(milliseconds: 500),
                      animationCurve: Curves.linear,
                      innerIcon: Icon(Icons.integration_instructions),

                      innerWidget: Center(
                        child: CommonText(
                          content: "Your\nOrders",
                          boldNess: FontWeight.w600,
                          textSize: width * 0.04,
                          textColor: AppColors.textColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      progressBarWidth: 10.0,
                      trackWidth: 52.0,
                    );
                  }),
              SizedBox(height: height * 0.08),*/
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.01),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFD13333).withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: double.parse((AnalyticsApiController.to
                                                .analyticsRes['totalRejcted'] ??
                                            '0')
                                        .toString())
                                    .toStringAsFixed(0),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: Color(0xFFD13333),
                              ),
                              CommonText(
                                content: "Rejected Orders",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: Color(0xFFD13333),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.01),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF5388D8).withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: double.parse(
                                        (AnalyticsApiController.to.analyticsRes[
                                                    'totalPartialOrders'] ??
                                                '0')
                                            .toString())
                                    .toStringAsFixed(0),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: Color(0xFF5388D8),
                              ),
                              CommonText(
                                content: "Partial \nOrders",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: Color(0xFF5388D8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.01),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CommonText(
                                content: double.parse(
                                        (AnalyticsApiController.to.analyticsRes[
                                                    'totalDelivered'] ??
                                                '0')
                                            .toString())
                                    .toStringAsFixed(0),
                                boldNess: FontWeight.w600,
                                textSize: width * 0.05,
                                textColor: Colors.green,
                              ),
                              CommonText(
                                content: "Delivered \nOrder",
                                textAlign: TextAlign.center,
                                textSize: width * 0.035,
                                textColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: height * 0.08),
              StreamBuilder(
                  stream: AnalyticsApiController.to.subCategorySalesPre.stream,
                  builder: (context, snapshot) {
                    return MultiCircularSlider(
                      size: MediaQuery.of(context).size.width / 2,
                      progressBarType: MultiCircularSliderType
                          .circular, // the type of indictor you want circular or linear
                      values: AnalyticsApiController.to.subCategorySalesPre,

                      colors: AnalyticsApiController.to.subCategorySalesColor ??
                          const [
                            Color(0xFF5388D8),
                            Color(0xFFD13333),
                            Color(0xFFF4BE37),
                            Color(0xFF8812D0),
                            Color(0xFF151BB5),
                            Color(0xFF29B6C9),
                            Color(0xFFBD07B6),
                            Color(0xFF1EAA24),
                          ],
                      showTotalPercentage: true,
                      animationDuration: const Duration(milliseconds: 500),
                      animationCurve: Curves.linear,
                      innerIcon: const Icon(Icons.integration_instructions),
                      innerWidget: Center(
                        child: CommonText(
                          content: "Categories",
                          boldNess: FontWeight.w600,
                          textSize: width * 0.04,
                          textColor: AppColors.textColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      progressBarWidth: 10.0,
                      trackWidth: 52.0,
                    );
                  }),
              SizedBox(height: height * 0.08),
              SizedBox(
                height: height * 0.5,
                child: Obx(() {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (AnalyticsApiController
                                .to.analyticsRes['subCategorySales'] ??
                            [])
                        .length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9),
                    itemBuilder: (context, index) => Column(
                      children: [
                        CommonText(
                          content:
                              "${AnalyticsApiController.to.analyticsRes['subCategorySales']?[index]?['totalPercent'] ?? '0'}%",
                          boldNess: FontWeight.w600,
                          textSize: width * 0.05,
                          textColor: Color(int.parse(
                                  (AnalyticsApiController.to.analyticsRes[
                                                  'subCategorySales']?[index]
                                              ?['colorCode'] ??
                                          "#000000")
                                      .substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                        ),
                        CommonText(
                          content:
                              "₹${AnalyticsApiController.to.analyticsRes['subCategorySales']?[index]?['totalSales'] ?? '0'}",
                          boldNess: FontWeight.w600,
                          textSize: width * 0.05,
                          textColor: Color(int.parse(
                                  (AnalyticsApiController.to.analyticsRes[
                                                  'subCategorySales']?[index]
                                              ?['colorCode'] ??
                                          "#000000")
                                      .substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                        ),
                        CommonText(
                          content:
                              "${AnalyticsApiController.to.analyticsRes['subCategorySales']?[index]?['subCategory'] ?? '-'}",
                          textAlign: TextAlign.center,
                          textSize: width * 0.035,
                          textColor: Color(int.parse(
                                  (AnalyticsApiController.to.analyticsRes[
                                                  'subCategorySales']?[index]
                                              ?['colorCode'] ??
                                          "#000000")
                                      .substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
