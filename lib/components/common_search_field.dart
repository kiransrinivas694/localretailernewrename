import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2c/constants/colors_const.dart';

class CommonSearchField extends StatelessWidget {
  CommonSearchField({
    Key? key,
    required this.controller,
    this.color,
    this.suffixIcon,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final Color? color;
  final Widget? suffixIcon;
  ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.poppins(color: Colors.black),
      cursorColor: color ?? Colors.black,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: suffixIcon,
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.hintColor,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        border: OutlineInputBorder(
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
        hintText: "Search",
        hintStyle: GoogleFonts.poppins(
          color: AppColors.hintColor,
        ),
      ),
    );
  }
}
