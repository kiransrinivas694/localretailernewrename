import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2c/components/app_error_text_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';

class CommonPhoneField extends StatelessWidget {
  CommonPhoneField(
      {Key? key,
      required this.controller,
      required this.content,
      this.contentColor,
      this.errorText = '',
      this.countryCodeColor,
      this.onChanged})
      : super(key: key);
  final TextEditingController controller;
  final String content;
  final Color? contentColor;
  final Color? countryCodeColor;
  final String errorText;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          content: content,
          textColor: contentColor ?? Colors.white,
        ),
        SizedBox(height: height * 0.01),
        Container(
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: AppColors.semiGreyColor),
          ),
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "1234567890",
              hintStyle: GoogleFonts.poppins(color: AppColors.hintColor),
              contentPadding: const EdgeInsets.only(bottom: 5, left: 10),
              border: InputBorder.none,
            ),
          ),
        ),
        if (errorText.isNotEmpty) ...[
          // SizedBox(height: height * 0.01),
          AppErrorText(errorText: errorText)
        ],
      ],
    );
  }
}
