import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class CommonDetailsText extends StatelessWidget {
  const CommonDetailsText({
    Key? key,
    required this.title,
    required this.details,
  }) : super(key: key);

  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CommonText(
            content: title,
            textSize: width * 0.04,
            textColor: ColorsConst.textColor,
            boldNess: FontWeight.w500,
          ),
        ),
        CommonText(
          content: ":",
          textSize: width * 0.04,
          textColor: Colors.black,
          boldNess: FontWeight.w400,
        ),
        SizedBox(width: width * 0.05),
        Expanded(
          child: CommonText(
            content: details,
            textSize: width * 0.04,
            textColor: ColorsConst.textColor,
            boldNess: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
