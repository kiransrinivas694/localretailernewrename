import 'package:flutter/material.dart';

class DottedSeperator extends StatelessWidget {
  const DottedSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    const dashWidth = 10.0;
    final dashHeight = 1;
    // final dashCount = (boxWidth / (2 * dashWidth)).floor();
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: List.generate(30, (_) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            width: dashWidth,
            height: 1,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(176, 176, 176, 1)),
            ),
          ),
        );
      }),
    );
  }
}
