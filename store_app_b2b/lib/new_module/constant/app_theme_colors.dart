import 'package:flutter/material.dart';

import 'package:store_app_b2b/new_module/model/color/custom_colors.dart';

class AppThemeColors {
  static CustomColors lightThemeCustomColors = CustomColors(
    brandColor: Colors.blueAccent,
    dangerColor: Colors.redAccent,

    //primary colors for light theme
    primary50: const Color(0xFFF0F9F9),
    primary75: const Color(0xFFBFE6E5),
    primary100: const Color(0xFFa5dcda),
    primary200: const Color(0xFF7ecdca),
    primary300: const Color(0xFF64c3bf),
    primary400: const Color(0xFF468986),
    primary500: const Color(0xFF3d7775),

    //secondary colors for light theme
    secondary50: const Color(0xFFfff5eb),
    secondary75: const Color(0xFFfed4ae),
    secondary100: const Color(0xFFfec28c),
    secondary200: const Color(0xFFfda85b),
    secondary300: const Color(0xFFfd9639),
    secondary400: const Color(0xFFb16928),
    secondary500: const Color(0xFF9a5c23),

    //black colors for light theme
    black50: const Color(0xFFe6e6e6),
    black75: const Color(0xFF969696),
    black100: const Color(0xFF6b6b6b),
    black200: const Color(0xFF2b2b2b),
    black300: const Color(0xFF000000),
    black400: const Color(0xFF000000),
    black500: const Color(0xFF000000),

    //other colors
    addColor: const Color(0xFFFF7800),
    bookColor: const Color(0xFF41675F),
    borderPrimaryColor: const Color(0xFFC9C9C9),
    buyColor: const Color(0xFF4BB543),
    textPrimaryColor: const Color(0xFFFFFFFF),
    textSecondaryColor: const Color(0xFF646464),
    nav1: const Color(0xFF77BBAD),
    navShadow1: const Color(0xFF41675F),
    nav2: const Color(0xFF434141),
    nav3: const Color(0xFF0EBE7F),
    nav4: const Color(0xFFB9B9B9),
    nav5: const Color(0xFFE1E1E1),
    nav6: const Color(0xFF091C3F),
  );

  static Color hex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
