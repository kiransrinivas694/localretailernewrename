import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';

// Demo Chart Data Needs To Be Send
Map<String, dynamic> demoChartData = {
  "maxY": 217000, // has to be int or double
  "minY": 0, // has to be int or double
  "width":
      10, //has to be double or int or can be null. if null 10 width will be taken for bars.
  "data": [
    {
      "xAxisName": "Order Amount", // has to be string,
      "data": 170003 // has to be int or double,
    },
    {
      "xAxisName": "Paid Amount", // has to be string
      "data": 217000 // has to be int or double,
    },
    {
      "xAxisName": "Balance Amount", // has to be string
      "data": 80000 // has to be int or double,
    },
    // {
    //   "xAxisName": "Thur", // has to be string
    //   "data": 100 // has to be int or double,
    // },
  ]
};

//above is the demo chart for reference.
class CustomBarGraph extends StatelessWidget {
  const CustomBarGraph({
    super.key,
    required this.chartData,
    this.gradient,
    this.borderRadius,
    this.showRightTiles = false,
    this.showBottomTitles = true,
    this.showTopTitles = false,
    this.showLeftTitles = true,
  });

  final Map<String, dynamic> chartData;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final bool showRightTiles;
  final bool showLeftTitles;
  final bool showTopTitles;
  final bool showBottomTitles;
  @override
  Widget build(BuildContext context) {
    print('chart data -> ${chartData}');
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.black12,
              strokeWidth: 0.5,
            );
          },
          drawVerticalLine: false,
        ),
        barTouchData: BarTouchData(
          touchCallback: (event, touchResponse) {
            if (event is FlTapUpEvent) {}
          },
        ),
        // rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: ),
        maxY: chartData["maxY"].toDouble(),
        minY: chartData["minY"].toDouble(),
        titlesData: FlTitlesData(
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 13.w,
                    showTitles: showRightTiles,
                    getTitlesWidget: getLeftTiles)),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: showTopTitles,
                    getTitlesWidget: getBottomTiles)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 13.w,
                    showTitles: showLeftTitles,
                    getTitlesWidget: getLeftTiles)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 30,
                    showTitles: showBottomTitles,
                    getTitlesWidget: getBottomTiles))),
        borderData: FlBorderData(
            border: const Border(
                bottom: BorderSide(
          width: 0.5,
          color: Colors.black26,
        ))),
        barGroups: List.generate(chartData["data"].length, (index) {
          Color barColor;

          if (chartData["data"][index]["xAxisName"] == "Order Amount") {
            barColor = Colors.orange;
          } else if (chartData["data"][index]["xAxisName"] == "Paid Amount") {
            barColor = Colors.orange;
          } else if (chartData["data"][index]["xAxisName"] ==
              "Balance Amount") {
            barColor = Colors.orange;
          } else {
            barColor = Colors.red;
          }

          print(
              'printing color -> ${barColor} ${chartData["data"][index]["xAxisName"]}');

          return BarChartGroupData(
            x: index,
            // showingTooltipIndicators: [0],
            barRods: [
              BarChartRodData(
                // gradient: gradient,
                toY: chartData["data"][index]["data"].toDouble(),
                rodStackItems: [
                  BarChartRodStackItem(
                    0,
                    chartData["data"][index]["data"].toDouble(),
                    // barColor,
                    chartData["data"][index]["xAxisName"] == "Order Amount"
                        ? Colors.orange
                        : chartData["data"][index]["xAxisName"] == "Paid Amount"
                            ? Colors.green
                            : Colors.red,
                  ),
                  // BarChartRodStackItem(
                  //     chartData["data"][index]["data"].toDouble() / 2,
                  //     chartData["data"][index]["data"].toDouble(),
                  //     Colors.blue)
                ],
                width: chartData["width"] == null
                    ? 10
                    : chartData["width"].toDouble() ?? 10,
                borderRadius: borderRadius ?? BorderRadius.zero,
              )
            ],
          );
        }),
      ),
    );
  }

  Widget getBottomTiles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: AppText(
        chartData["data"][value.toInt()]["xAxisName"],
        fontSize: 12.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget getLeftTiles(double value, TitleMeta meta) {
    // return AppText(
    //   meta.formattedValue,
    //   fontSize: 13.sp,
    // );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
      child: AppText(
        meta.formattedValue,
        color: Colors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
