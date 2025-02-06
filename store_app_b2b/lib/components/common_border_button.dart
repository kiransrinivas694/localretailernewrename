import 'package:flutter/material.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

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
        side: BorderSide(color: ColorsConst.primaryColor),
        fixedSize: Size(width, 50),
      ),
      onPressed: onTap,
      child: CommonText(
        content: text,
        textColor: ColorsConst.primaryColor,
      ),
    );
  }
}
