import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/constants/loader_new.dart';
import 'package:store_app_b2b/controllers/bottom_controller/payment_controller/payment_controller_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/custom_bar_graph_new.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/store_screen/store_screen_new.dart';

class CreditRatingTab extends StatelessWidget {
  CreditRatingTab({super.key});

  Widget _buildColoredCell(String text, Color color,
      {bool isHeader = false, num fontSize = 16}) {
    return Container(
      color: color,
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
              fontSize: fontSize.toDouble()),
        ),
      ),
    );
  }

  PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (paymentController.storeCreditRating != null &&
                    paymentController.storeCreditRating!.avgPaymentPercentage !=
                        null) ...[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                    // height: 250,
                    padding: EdgeInsets.fromLTRB(16, 0, 10, 10),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 0),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SpeedometerGauge(paymentController
                                      .storeCreditRating!
                                      .avgPaymentPercentage ==
                                  null
                              ? 0
                              : paymentController
                                  .storeCreditRating!.avgPaymentPercentage!
                                  .toDouble()), // Pass your value here (e.g., 70)
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(1.3),

                              // 1: FixedColumnWidth(75),
                              // 2: FixedColumnWidth(65),
                              // 3: FixedColumnWidth(65)
                            },
                            border: TableBorder.all(
                                color: Colors.black), // Table border
                            children: [
                              // Header Row
                              TableRow(
                                children: [
                                  _buildColoredCell('', Colors.transparent,
                                      isHeader: true),
                                  _buildColoredCell('', Colors.red,
                                      isHeader: true),
                                  _buildColoredCell('', Colors.orange,
                                      isHeader: true),
                                  _buildColoredCell('', Colors.yellow,
                                      isHeader: true),
                                  _buildColoredCell('', Colors.green.shade200,
                                      isHeader: true),
                                  _buildColoredCell('', Colors.green,
                                      isHeader: true),
                                ],
                              ),
                              TableRow(
                                children: [
                                  _buildColoredCell(
                                      'Discount on PTR', Colors.transparent,
                                      fontSize: 14.5.sp, isHeader: true),
                                  _buildColoredCell('Block', Colors.white,
                                      fontSize: 14.5.sp, isHeader: true),
                                  _buildColoredCell('0%', Colors.white,
                                      fontSize: 14.5.sp, isHeader: true),
                                  _buildColoredCell('2%', Colors.white,
                                      fontSize: 14.5.sp, isHeader: true),
                                  _buildColoredCell('4%', Colors.white,
                                      fontSize: 14.5.sp, isHeader: true),
                                  _buildColoredCell('6%', Colors.white,
                                      fontSize: 14.5.sp, isHeader: true),
                                ],
                              ),
                            ]),
                        SizedBox(
                          height: 5,
                        ),
                        CommonText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          content:
                              'Total Payments : ${paymentController.storeCreditRating!.numOrders}',
                          textColor: ColorsConst.appblack54,
                          boldNess: FontWeight.w600,
                          textSize: 16,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CommonText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          content:
                              'On Time Payments :  ${paymentController.storeCreditRating!.numPaidOnTime}',
                          textColor: ColorsConst.appblack54,
                          boldNess: FontWeight.w600,
                          textSize: 16,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CommonText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          content:
                              'Late/Pending Payments :  ${paymentController.storeCreditRating!.numDelayedPayments}',
                          textColor: ColorsConst.appblack54,
                          boldNess: FontWeight.w600,
                          textSize: 16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                if (paymentController.storeCreditRating != null &&
                    paymentController.storeCreditRating!.totalOrderAmount !=
                        null &&
                    paymentController.storeCreditRating!.totalOrderAmount !=
                        0) ...[
                  Container(
                    height: 250,
                    margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                    padding: EdgeInsets.fromLTRB(4, 20, 4, 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 0),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    // color: Colors.blue,
                    child: CustomBarGraph(
                      chartData: {
                        "maxY": paymentController.storeCreditRating!
                            .totalOrderAmount, // has to be int or double
                        "minY": 0, // has to be int or double
                        "width":
                            30, //has to be double or int or can be null. if null 10 width will be taken for bars.
                        "data": [
                          {
                            "xAxisName": "Order Amount", // has to be string,
                            "data": paymentController
                                    .storeCreditRating!.totalOrderAmount ??
                                0
                          },
                          {
                            "xAxisName": "Paid Amount", // has to be string
                            "data": paymentController
                                    .storeCreditRating!.totalPaidAmount ??
                                0 // has to be int or double,
                          },
                          {
                            "xAxisName": "Balance Amount", // has to be string
                            "data": paymentController
                                    .storeCreditRating!.totalBalance ??
                                0 // has to be int or double,
                          },
                        ]
                      },
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 139, 3, 1),
                          Color.fromRGBO(254, 198, 132, 1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0)),
                      showLeftTitles: true,
                      showRightTiles: false,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ],
            ),
          ),
        ),
        Obx(() => paymentController.storeCreditLoading.value
            ? AppLoader()
            : SizedBox()),
        Obx(() => !paymentController.storeCreditLoading.value &&
                paymentController.storeCreditRating == null
            ? Container(
                child: Center(
                  child: AppText(
                    "PLR Rating Not Found",
                    color: Colors.black,
                  ),
                ),
              )
            : SizedBox())
      ],
    );
  }
}
