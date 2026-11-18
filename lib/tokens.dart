import 'package:flutter/material.dart';

/// Design tokens from the Oracare Figma design system.
class T {
  static const primary = Color(0xFF00897B);
  static const btn = Color(0xFF00796B);
  static const onContainer = Color(0xFF006B60);
  static const container = Color(0xFFE0F2F1);
  static const containerStrong = Color(0xFFCAE6DF);
  static const accent = Color(0xFF80CBC4);
  static const text = Color(0xFF1C2F3F);
  static const text2 = Color(0xFF4B645F);
  static const onSurface = Color(0xFF171D1B);
  static const onSurfaceVar = Color(0xFF3F4946);
  static const bg = Color(0xFFF4F7F6);
  static const surface = Color(0xFFE9EFEC);
  static const border = Color(0xFFDCE4E2);
  static const borderDefault = Color(0xFFBEC9C5);
  static const warn = Color(0xFFF59E0B);
  static const warnContainer = Color(0xFFFEF3C7);
  static const good = Color(0xFF8BC63F);
  static const fair = Color(0xFFFFCA29);
  static const poor = Color(0xFFEE3923);
}

/// Roboto text style with an explicit line height in px (as in Figma).
TextStyle ts(double size, {FontWeight w = FontWeight.w400, Color c = T.text, double? lh, FontStyle? style}) =>
    TextStyle(
      fontFamily: 'Roboto',
      fontSize: size,
      fontWeight: w,
      color: c,
      fontStyle: style,
      height: lh == null ? null : lh / size,
      leadingDistribution: TextLeadingDistribution.even,
    );

const kBold = FontWeight.w700, kSemi = FontWeight.w600, kMed = FontWeight.w500, kReg = FontWeight.w400;

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: T.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: T.primary).copyWith(primary: T.primary, surface: T.bg),
      splashFactory: InkRipple.splashFactory,
    );
