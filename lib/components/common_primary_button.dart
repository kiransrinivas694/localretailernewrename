import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';

class CommonPrimaryButton extends StatelessWidget {
  const CommonPrimaryButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color,
      this.isLoading})
      : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color ?? AppColors.primaryColor,
        fixedSize: Size(width, 50),
      ),
      onPressed: onTap,
      child: isLoading == true
          ? const CupertinoActivityIndicator(color: Colors.white, radius: 10)
          : CommonText(content: text),
    );
  }
}
