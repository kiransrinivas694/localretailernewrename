import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    Key? key,
    required this.controller,
    required this.content,
    required this.hintText,
    this.gapHeight,
    this.contentColor,
    this.titleShow,
    this.maxLength,
    this.focusNode,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText,
    this.maxLines,
    this.suffixIcon,
    this.hintTextWeight,
    this.hintTextSize,
    this.counterText,
    this.readOnly = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String content;
  final String hintText;
  final double? gapHeight;
  final String? counterText;
  final Color? contentColor;
  final bool? titleShow;
  final FocusNode? focusNode;
  final FontWeight? hintTextWeight;
  final double? hintTextSize;
  final int? maxLength;
  final int? maxLines;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final Widget? suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleShow ?? true == true
            ? CommonText(
                content: content,
                textColor: contentColor ?? Colors.white,
                boldNess: FontWeight.w500,
              )
            : SizedBox(),
        SizedBox(height: gapHeight ?? height * 0.01),
        TextFormField(
          onTap: onTap,
          maxLines: maxLines,
          style: GoogleFonts.poppins(color: contentColor ?? Colors.white),
          cursorColor: contentColor ?? Colors.white,
          controller: controller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obscureText ?? false,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: counterText,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorsConst.semiGreyColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorsConst.semiGreyColor,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorsConst.semiGreyColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorsConst.semiGreyColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorsConst.semiGreyColor,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorsConst.semiGreyColor,
                width: 1,
              ),
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
                color: ColorsConst.hintColor,
                fontWeight: hintTextWeight,
                fontSize: hintTextSize),
          ),
        ),
      ],
    );
  }
}
