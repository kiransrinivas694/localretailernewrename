import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    Key? key,
    required this.content,
    this.textColor,
    this.textSize,
    this.boldNess,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
  }) : super(key: key);

  final String content;
  final Color? textColor;
  final double? textSize;
  final FontWeight? boldNess;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text(
      content,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        color: textColor ?? Colors.white,
        fontSize: textSize ?? width * 0.04,
        fontWeight: boldNess,
        decoration: decoration,
      ),
    );
  }
}
