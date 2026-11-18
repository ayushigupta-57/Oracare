import 'package:flutter/material.dart';

/// Design tokens, taken from the Oracare Figma design system.
class T {
  static const primary = Color(0xFF00897B);
  static const btn = Color(0xFF00796B);
  static const onContainer = Color(0xFF006B60);
  static const container = Color(0xFFE0F2F1);
  static const containerStrong = Color(0xFFCAE6DF);
  static const accent = Color(0xFF80CBC4);
  static const text = Color(0xFF1C2F3F);
  static const text2 = Color(0xFF4B645F);
  static const bg = Color(0xFFF4F7F6);
  static const surface = Color(0xFFE9EFEC);
  static const border = Color(0xFFDCE4E2);
  static const error = Color(0xFFB3261E);
  static const warn = Color(0xFFF59E0B);
  static const ok = Color(0xFF2E7D32);
  static const good = Color(0xFF8BC63F);
  static const fair = Color(0xFFFFCA29);
  static const poor = Color(0xFFEE3923);

  // spacing scale
  static const s4 = 4.0, s8 = 8.0, s12 = 12.0, s16 = 16.0, s20 = 20.0, s24 = 24.0, s32 = 32.0;
  // radius
  static const r12 = 12.0, r16 = 16.0, r28 = 28.0;
}

/// Type scale: 11/12/14/16/18/22/24/28/36/96, Roboto.
TextStyle ts(double size, {FontWeight w = FontWeight.w400, Color c = T.text, double? h}) =>
    TextStyle(fontSize: size, fontWeight: w, color: c, height: h ?? (size <= 14 ? 1.43 : 1.33));

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: T.primary).copyWith(
    primary: T.btn,
    onPrimary: Colors.white,
    primaryContainer: T.container,
    onPrimaryContainer: T.onContainer,
    surface: T.bg,
    onSurface: T.text,
    error: T.error,
    outline: T.border,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: T.bg,
    fontFamily: 'Roboto',
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: T.container,
      labelTextStyle: WidgetStateProperty.resolveWith((s) =>
          ts(12, w: FontWeight.w500, c: s.contains(WidgetState.selected) ? T.onContainer : T.text2)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: T.text,
      contentTextStyle: ts(14, c: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.r12)),
    ),
  );
}
