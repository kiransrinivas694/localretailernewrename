import 'package:flutter/material.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';

class AppErrorText extends StatelessWidget {
  final String errorText;

  const AppErrorText({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: CommonText(
        content: errorText,
        textColor: AppColors.redColor,
        textSize: 14,
        boldNess: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
