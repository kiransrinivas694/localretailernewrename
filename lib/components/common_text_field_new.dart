import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {Key? key,
      required this.controller,
      required this.content,
      required this.hintText,
      this.contentColor,
      this.titleShow,
      this.maxLength,
      this.focusNode,
      this.onTap,
      this.keyboardType,
      this.inputFormatters,
      this.obscureText,
      this.enabled,
      this.maxLines,
      this.onChanged,
      this.readOnly,
      this.validator,
      this.suffixIcon})
      : super(key: key);

  final TextEditingController controller;
  final String content;
  final String hintText;
  final Color? contentColor;
  final bool? titleShow;
  final FocusNode? focusNode;
  final int? maxLength;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? readOnly;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
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
        SizedBox(height: height * 0.01),
        TextFormField(
          onTap: onTap,
          maxLines: maxLines,
          style: GoogleFonts.poppins(color: contentColor ?? Colors.white),
          cursorColor: contentColor ?? Colors.white,
          controller: controller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          validator: validator,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            enabled: enabled ?? true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.semiGreyColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.semiGreyColor,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.semiGreyColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.semiGreyColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.semiGreyColor,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppColors.semiGreyColor,
                width: 1,
              ),
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: AppColors.hintColor),
          ),
        ),
      ],
    );
  }
}
