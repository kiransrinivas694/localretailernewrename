import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: selectTitle == title
                        ? AppColors.primaryColor
                        : AppColors.semiGreyColor,
                  ),
                  shape: BoxShape.circle),
              child: Container(
                height: 25,
                width: 25,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: selectTitle == title
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    shape: BoxShape.circle),
              ),
            ),
            SizedBox(width: Get.width * 0.03),
            CommonText(
              content: title,
              boldNess: FontWeight.w500,
              textColor: AppColors.textColor,
            ),
          ],
        ),
      ),
    );
  }
}
