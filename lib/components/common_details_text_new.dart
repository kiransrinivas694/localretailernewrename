import 'package:flutter/material.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';

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
        SizedBox(
          width: width / 3,
          child: CommonText(
            content: title + ":",
            textSize: width * 0.037,
            textColor: AppColors.textColor,
            boldNess: FontWeight.w500,
          ),
        ),
        // SizedBox(width: width * 0.05),
        Expanded(
          child: CommonText(
            content: details,
            textSize: width * 0.037,
            textColor: AppColors.textColor,
            boldNess: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
