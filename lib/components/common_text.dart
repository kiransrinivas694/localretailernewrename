import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    Key? key,
    this.content,
    this.textColor,
    this.textSize,
    this.boldNess,
    this.textDecoration,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  final String? content;
  final Color? textColor;
  final double? textSize;
  final FontWeight? boldNess;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text(
      content ?? "",
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        color: textColor ?? AppColors.appWhite,
        fontSize: textSize ?? width * 0.04,
        fontWeight: boldNess,
        decoration: textDecoration,
      ),
    );
  }
}
