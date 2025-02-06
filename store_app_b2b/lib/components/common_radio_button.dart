import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class RadioButton extends StatelessWidget {
  RadioButton(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.selectTitle})
      : super(key: key);
  final VoidCallback onTap;
  String title = "";
  String selectTitle = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: selectTitle == title
                        ? ColorsConst.primaryColor
                        : ColorsConst.semiGreyColor,
                  ),
                  shape: BoxShape.circle),
              child: Container(
                height: 25,
                width: 25,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: selectTitle == title
                        ? ColorsConst.primaryColor
                        : Colors.transparent,
                    shape: BoxShape.circle),
              ),
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: CommonText(
                content: title,
                boldNess: FontWeight.w500,
                textColor: ColorsConst.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
