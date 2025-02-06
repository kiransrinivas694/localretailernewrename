import 'package:flutter/material.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';

class CommonBorderButton extends StatelessWidget {
  const CommonBorderButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: AppColors.primaryColor),
        fixedSize: Size(width, 50),
      ),
      onPressed: onTap,
      child: CommonText(
        content: text,
        textColor: AppColors.primaryColor,
      ),
    );
  }
}
