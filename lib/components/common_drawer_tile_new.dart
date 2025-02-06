import 'package:flutter/material.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';

class CommonDrawerTile extends StatelessWidget {
  String title;

  VoidCallback onTap;
  CommonDrawerTile({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Row(
            children: [
              CommonText(
                content: title,
                textColor: Colors.black,
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(color: AppColors.semiGreyColor),
        ),
      ],
    );
  }
}
