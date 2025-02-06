import 'package:b2c/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class CustomToastWidget extends StatelessWidget {
  final String msg;
  final bool showTickMark;
  final double? width;

  const CustomToastWidget({
    super.key,
    required this.msg,
    this.showTickMark = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width ?? 180,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: ColorsConst.primaryColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 0),
                blurRadius: 6)
          ],
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showTickMark) Icon(Icons.done, color: Colors.white),
          CommonText(content: msg, textColor: Colors.white)
        ],
      ),
    );
  }
}
