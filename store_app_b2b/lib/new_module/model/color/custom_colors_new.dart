import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? brandColor;
  final Color? dangerColor;

  //mysaa colors
  final Color? primary50;
  final Color? primary75;
  final Color? primary100;
  final Color? primary200;
  final Color? primary300;
  final Color? primary400;
  final Color? primary500;

  final Color? secondary50;
  final Color? secondary75;
  final Color? secondary100;
  final Color? secondary200;
  final Color? secondary300;
  final Color? secondary400;
  final Color? secondary500;

  final Color? black50;
  final Color? black75;
  final Color? black100;
  final Color? black200;
  final Color? black300;
  final Color? black400;
  final Color? black500;

  final Color? textPrimaryColor;
  final Color? textSecondaryColor;
  final Color? borderPrimaryColor;
  final Color? addColor;
  final Color? buyColor;
  final Color? bookColor;

  final Color? nav1;
  final Color? navShadow1;
  final Color? nav2;
  final Color? nav3;
  final Color? nav4;
  final Color? nav5;
  final Color? nav6;
  final Color? nav7;
  final Color? nav8;
  final Color? nav9;
  final Color? nav10;

  CustomColors({
    this.brandColor,
    this.dangerColor,
    this.primary50,
    this.primary75,
    this.primary100,
    this.primary200,
    this.primary300,
    this.primary400,
    this.primary500,
    this.secondary50,
    this.secondary75,
    this.secondary100,
    this.secondary200,
    this.secondary300,
    this.secondary400,
    this.secondary500,
    this.black50,
    this.black75,
    this.black100,
    this.black200,
    this.black300,
    this.black400,
    this.black500,
    this.addColor,
    this.bookColor,
    this.borderPrimaryColor,
    this.buyColor,
    this.textPrimaryColor,
    this.textSecondaryColor,
    this.nav1,
    this.navShadow1,
    this.nav2,
    this.nav3,
    this.nav4,
    this.nav5,
    this.nav6,
    this.nav7,
    this.nav8,
    this.nav9,
    this.nav10,
  });

  @override
  CustomColors copyWith({
    Color? brandColor,
    Color? dangerColor,
    Color? primary50,
    Color? primary75,
    Color? primary100,
    Color? primary200,
    Color? primary300,
    Color? primary400,
    Color? primary500,
    Color? secondary50,
    Color? secondary75,
    Color? secondary100,
    Color? secondary200,
    Color? secondary300,
    Color? secondary400,
    Color? secondary500,
    Color? black50,
    Color? black75,
    Color? black100,
    Color? black200,
    Color? black300,
    Color? black400,
    Color? black500,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? borderPrimaryColor,
    Color? addColor,
    Color? buyColor,
    Color? bookColor,
    Color? nav1,
    Color? navShadow1,
    Color? nav2,
    Color? nav3,
    Color? nav4,
    Color? nav5,
    Color? nav6,
    Color? nav7,
    Color? nav8,
    Color? nav9,
    Color? nav10,
  }) {
    return CustomColors(
      brandColor: brandColor ?? this.brandColor,
      dangerColor: dangerColor ?? this.dangerColor,
      primary50: primary50 ?? this.primary50,
      primary75: primary75 ?? this.primary75,
      primary100: primary100 ?? this.primary100,
      primary200: primary200 ?? this.primary200,
      primary300: primary300 ?? this.primary300,
      primary400: primary400 ?? this.primary400,
      primary500: primary500 ?? this.primary500,
      secondary50: secondary50 ?? this.secondary50,
      secondary75: secondary75 ?? this.secondary75,
      secondary100: secondary100 ?? this.secondary100,
      secondary200: secondary200 ?? this.secondary200,
      secondary300: secondary300 ?? this.secondary300,
      secondary400: secondary400 ?? this.secondary400,
      secondary500: secondary500 ?? this.secondary500,
      black50: black50 ?? this.black50,
      black75: black75 ?? this.black75,
      black100: black100 ?? this.black100,
      black200: black200 ?? this.black200,
      black300: black300 ?? this.black300,
      black400: black400 ?? this.black400,
      black500: black500 ?? this.black500,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      borderPrimaryColor: borderPrimaryColor ?? this.borderPrimaryColor,
      addColor: addColor ?? this.addColor,
      buyColor: buyColor ?? this.buyColor,
      bookColor: bookColor ?? this.bookColor,
      nav1: nav1 ?? this.nav1,
      navShadow1: navShadow1 ?? this.navShadow1,
      nav2: nav2 ?? this.nav2,
      nav3: nav3 ?? this.nav3,
      nav4: nav4 ?? this.nav4,
      nav5: nav5 ?? this.nav5,
      nav6: nav6 ?? this.nav6,
      nav7: nav7 ?? this.nav7,
      nav8: nav8 ?? this.nav8,
      nav9: nav9 ?? this.nav9,
      nav10: nav10 ?? this.nav10,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      brandColor: Color.lerp(brandColor, other.brandColor, t),
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t),
      primary50: Color.lerp(primary50, other.primary50, t),
      primary75: Color.lerp(primary75, other.primary75, t),
      primary100: Color.lerp(primary100, other.primary100, t),
      primary200: Color.lerp(primary200, other.primary200, t),
      primary300: Color.lerp(primary300, other.primary300, t),
      primary400: Color.lerp(primary400, other.primary400, t),
      primary500: Color.lerp(primary500, other.primary500, t),
      secondary50: Color.lerp(secondary50, other.secondary50, t),
      secondary75: Color.lerp(secondary75, other.secondary75, t),
      secondary100: Color.lerp(secondary100, other.secondary100, t),
      secondary200: Color.lerp(secondary200, other.secondary200, t),
      secondary300: Color.lerp(secondary300, other.secondary300, t),
      secondary400: Color.lerp(secondary400, other.secondary400, t),
      secondary500: Color.lerp(secondary500, other.secondary500, t),
      black50: Color.lerp(black50, other.black50, t),
      black75: Color.lerp(black75, other.black75, t),
      black100: Color.lerp(black100, other.black100, t),
      black200: Color.lerp(black200, other.black200, t),
      black300: Color.lerp(black300, other.black300, t),
      black400: Color.lerp(black400, other.black400, t),
      black500: Color.lerp(black500, other.black500, t),
      textPrimaryColor: Color.lerp(textPrimaryColor, other.textPrimaryColor, t),
      textSecondaryColor:
          Color.lerp(textSecondaryColor, other.textSecondaryColor, t),
      borderPrimaryColor:
          Color.lerp(borderPrimaryColor, other.borderPrimaryColor, t),
      addColor: Color.lerp(addColor, other.addColor, t),
      buyColor: Color.lerp(buyColor, other.buyColor, t),
      bookColor: Color.lerp(bookColor, other.bookColor, t),
      nav1: Color.lerp(nav1, other.nav1, t),
      navShadow1: Color.lerp(navShadow1, other.navShadow1, t),
      nav2: Color.lerp(nav2, other.nav2, t),
      nav3: Color.lerp(nav3, other.nav3, t),
      nav4: Color.lerp(nav4, other.nav4, t),
      nav5: Color.lerp(nav5, other.nav5, t),
      nav6: Color.lerp(nav6, other.nav6, t),
      nav7: Color.lerp(nav7, other.nav7, t),
      nav8: Color.lerp(nav8, other.nav8, t),
      nav9: Color.lerp(nav9, other.nav9, t),
      nav10: Color.lerp(nav10, other.nav10, t),
    );
  }
}
