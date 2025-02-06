import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/constant/app_theme_colors_new.dart';
import 'package:store_app_b2b/new_module/model/color/custom_colors_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';

class ThemeController extends GetxController {
  final lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    fontFamily: AppFont.poppins,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.green,
      surface: Colors.grey[200]!,
    ),
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      AppThemeColors.lightThemeCustomColors,
    ],
  );

  final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.red,
      surface: Colors.grey[800]!,
    ),
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        //primary colors for dark theme
        primary50: Colors.black,
      ),
    ],
  );

  final Rx<ThemeData> _theme = ThemeData(
    primaryColor: AppThemeColors.lightThemeCustomColors.primary50,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.green,
      surface: Colors.grey[200]!,
    ),
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      AppThemeColors.lightThemeCustomColors,
    ],
  ).obs;

  ThemeData get theme => _theme.value;

  void switchTheme() {
    if (_theme.value.brightness == Brightness.dark) {
      _theme.value = lightTheme;
    } else {
      _theme.value = darkTheme;
    }
    update();
  }

  CustomColors get customColors => _theme.value.extension<CustomColors>()!;

  Color get primaryColor => _theme.value.primaryColor;
  Color get secondaryColor => _theme.value.colorScheme.secondary;

  // get primary colors
  Color get primary50Color =>
      _theme.value.extension<CustomColors>()!.primary50 ?? Colors.white;
  Color get primary75Color =>
      _theme.value.extension<CustomColors>()!.primary75 ?? Colors.white;
  Color get primary100Color =>
      _theme.value.extension<CustomColors>()!.primary100 ?? Colors.white;
  Color get primary200Color =>
      _theme.value.extension<CustomColors>()!.primary200 ?? Colors.white;
  Color get primary300Color =>
      _theme.value.extension<CustomColors>()!.primary300 ?? Colors.white;
  Color get primary400Color =>
      _theme.value.extension<CustomColors>()!.primary400 ?? Colors.white;
  Color get primary500Color =>
      _theme.value.extension<CustomColors>()!.primary500 ?? Colors.white;

  // get secondary colors
  Color get secondary50Color =>
      _theme.value.extension<CustomColors>()!.secondary50 ?? Colors.white;
  Color get secondary75Color =>
      _theme.value.extension<CustomColors>()!.secondary75 ?? Colors.white;
  Color get secondary100Color =>
      _theme.value.extension<CustomColors>()!.secondary100 ?? Colors.white;
  Color get secondary200Color =>
      _theme.value.extension<CustomColors>()!.secondary200 ?? Colors.white;
  Color get secondary300Color =>
      _theme.value.extension<CustomColors>()!.secondary300 ?? Colors.white;
  Color get secondary400Color =>
      _theme.value.extension<CustomColors>()!.secondary400 ?? Colors.white;
  Color get secondary500Color =>
      _theme.value.extension<CustomColors>()!.secondary500 ?? Colors.white;

  // get black colors
  Color get black50Color =>
      _theme.value.extension<CustomColors>()!.black50 ?? Colors.black;
  Color get black75Color =>
      _theme.value.extension<CustomColors>()!.black75 ?? Colors.black;
  Color get black100Color =>
      _theme.value.extension<CustomColors>()!.black100 ?? Colors.black;
  Color get black200Color =>
      _theme.value.extension<CustomColors>()!.black200 ?? Colors.black;
  Color get black300Color =>
      _theme.value.extension<CustomColors>()!.black300 ?? Colors.black;
  Color get black400Color =>
      _theme.value.extension<CustomColors>()!.black400 ?? Colors.black;
  Color get black500Color =>
      _theme.value.extension<CustomColors>()!.black500 ?? Colors.black;

  // other colors

  Color get textPrimaryColor =>
      _theme.value.extension<CustomColors>()!.textPrimaryColor ?? Colors.white;
  Color get textSecondaryColor =>
      _theme.value.extension<CustomColors>()!.textSecondaryColor ??
      Colors.white;
  Color get borderPrimaryColor =>
      _theme.value.extension<CustomColors>()!.borderPrimaryColor ??
      Colors.white;
  Color get addColor =>
      _theme.value.extension<CustomColors>()!.addColor ?? Colors.white;
  Color get buyColor =>
      _theme.value.extension<CustomColors>()!.buyColor ?? Colors.white;
  Color get bookColor =>
      _theme.value.extension<CustomColors>()!.bookColor ?? Colors.white;
  Color get nav1 =>
      _theme.value.extension<CustomColors>()!.nav1 ?? Colors.white;
  Color get navShadow1 =>
      _theme.value.extension<CustomColors>()!.navShadow1 ?? Colors.white;
  Color get nav2 =>
      _theme.value.extension<CustomColors>()!.nav2 ?? Colors.white;
  Color get nav3 =>
      _theme.value.extension<CustomColors>()!.nav3 ?? Colors.white;
  Color get nav4 =>
      _theme.value.extension<CustomColors>()!.nav4 ?? Colors.white;
  Color get nav5 =>
      _theme.value.extension<CustomColors>()!.nav5 ?? Colors.white;

  Color get nav6 =>
      _theme.value.extension<CustomColors>()!.nav6 ?? Colors.white;

  static Color hex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
