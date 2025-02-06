import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';

class CommonSearchField extends StatelessWidget {
  const CommonSearchField(
      {Key? key,
      required this.controller,
      this.color,
      this.hintText,
      this.onChanged,
      this.closeOnTap,
      this.showCloseIcon = false})
      : super(key: key);

  final TextEditingController controller;
  final Color? color;
  final bool showCloseIcon;
  final String? hintText;
  final Function(String)? onChanged;
  final Function()? closeOnTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.poppins(color: Colors.black),
      cursorColor: color ?? Colors.black,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: (showCloseIcon)
            ? GestureDetector(
                onTap: closeOnTap,
                child: Icon(Icons.clear,
                    color: ColorsConst.greyByTextColor, size: 20))
            : SizedBox(),
        prefixIcon: Icon(
          Icons.search,
          size: 25,
          color: ColorsConst.greyByTextColor,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        border: OutlineInputBorder(
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
        hintText: hintText ?? "Search",
        hintStyle: GoogleFonts.poppins(
          color: ColorsConst.hintColor,
        ),
      ),
    );
  }
}
