// import 'package:flutter/material.dart';
// import 'package:graphic/graphic.dart';

// const data = [
//   {'category': 'Order Amount', 'sales': 201672},
//   {'category': 'Paid Amount', 'sales': 157426},
//   {'category': 'Balance Amount', 'sales': 44246},
// ];

// int roundToNextSignificant(int number) {
//   if (number < 10) return 10;
//   if (number < 100) return 100;
//   if (number < 1000) return 1000;
//   if (number < 10000) return 10000;
//   // For numbers 10,000 and above, round to the next 10,000
//   return ((number / 10000).ceil() * 10000).toInt();
// }

// class BarGraph extends StatelessWidget {
//   const BarGraph({Key? key, required this.dynamicData}) : super(key: key);

//   final List<Map<String, dynamic>> dynamicData;

//   @override
//   Widget build(BuildContext context) {
//     // Calculate max sales
//     final maxSales = dynamicData
//         .map((e) => e['sales'] as num)
//         .reduce((a, b) => a > b ? a : b)
//         .toInt();

//     // Calculate rounded max scale
//     final maxScale =
//         roundToNextSignificant(maxSales + 1); // Add 1 to ensure it's higher

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Chart(
//         data: dynamicData,
//         variables: {
//           'category': Variable(
//             accessor: (Map map) => map['category'] as String,
//           ),
//           'sales': Variable(
//             accessor: (Map map) => map['sales'] as num,
//             scale: LinearScale(
//               min: 0,
//             ),
//           ),
//         },
//         marks: [
//           IntervalMark(
//             label: LabelEncode(
//                 encoder: (tuple) => Label(tuple['sales'].toString())),
//             transition: Transition(duration: const Duration(seconds: 3)),
//             entrance: {MarkEntrance.y},
//             size: SizeEncode(value: 30),
//             position: Varset('category') * Varset('sales'),
//             color: ColorEncode(
//               variable: 'category',
//               values: [
//                 Colors.blue,
//                 Colors.green,
//                 Colors.red
//               ], // Colors for each bar
//             ),
//           ),
//         ],
//         // selections: {'tap': PointSelection(dim: Dim.x)},
//         axes: [
//           Defaults.horizontalAxis,
//           Defaults.verticalAxis,
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:b2c/constants/colors_const_new.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample8 extends StatefulWidget {
  BarChartSample8({super.key});

  final Color barBackgroundColor = AppColors.appTomatoColor.withOpacity(0.3);
  final Color barColor = AppColors.appTomatoColor;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.graphic_eq),
                const SizedBox(
                  width: 32,
                ),
                Text(
                  'Sales forecasting chart',
                  style: TextStyle(
                    color: widget.barColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: BarChart(
                randomData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x >= 4 ? Colors.transparent : widget.barColor,
          borderRadius: BorderRadius.zero,
          // borderDashArray: x >= 4 ? [4, 4] : null,
          width: 22,
          borderSide: BorderSide(color: widget.barColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: 300.0,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i,
          Random().nextInt(290).toDouble() + 10,
        ),
      ),
      gridData: FlGridData(show: false),
    );
  }
}
