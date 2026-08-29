// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:math';
import 'package:flutter/material.dart';

class ColorConstants {
  // Theme Colors
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color accent = Color(0xFF0EA5E9);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Backward compatibility
  static Color lightScaffoldBackgroundColor = background;
  static Color darkScaffoldBackgroundColor = const Color(0xFF030B1A);
  static Color secondaryAppColor = surface;
  static Color secondaryDarkAppColor = Colors.white;
  static Color tipColor = textTertiary;
  static Color lightGray = surfaceMuted;
  static Color darkGray = textSecondary;
  static Color black = textPrimary;
  static Color white = surface;
  static Color grey300 = const Color(0xFFF7FAFA);
  static Color grey100 = borderLight;
  static Color positiveButton = const Color(0xFFffe4cf);
  static Color negativeButton = const Color(0xFF2D0E15);
  static Color headerFooter = const Color(0xFFD8A48F);
  static Color lightTextColor = textPrimary;
  static Color darkTextColor = const Color(0xffffffff);
  static Color badgesColor = const Color(0xFFD8A48F);
  static Color badgesText = const Color(0xFFFFFFFF);
  static Color cardBackground = surface;
  static Color darkCardBackground = const Color(0xFF151a24);
  static Color solidIconColor = textPrimary;
  static Color unactiveIconColor = const Color(0xFFDADEDE);
  static Color textMenuColor = textPrimary;
  static Color shadowBlue = const Color(0xFFF7FAFA);
  static Color primaryColor = primary;
  static Color secondaryColor = accent;
  static Color backgroundColors = background;
  static Color backgroundShadowColor = const Color(0x0A000000);
  static Color darkShadowColor = Colors.transparent;
  static Color kWhiteGrey = surfaceMuted;
  static Color kBlack = textPrimary;
  static Color kBlackAccent = const Color(0xff2A2B37);
  static Color kGrey = textTertiary;
  static Color kLineDark = border;
  static Color kWhite = Colors.white;
  static Color lightBlue = primaryLight;
  static Color pink = errorLight;
  static Color red = error;
  static Color disableColor = const Color(0xffB3AFAF);
}

Color textToColor(String inputString) {
  List<int> codeUnits = inputString.codeUnits;
  String hexString = codeUnits.map((int codeUnit) {
    return codeUnit.toRadixString(16).padLeft(2, '0');
  }).join('');
  return hexToColor(hexString);
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

String colorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).substring(2)}';
}

Color randomColor() {
  var rndColor = Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
  return rndColor != const Color(0xffffffff) ||
          rndColor != const Color(0x00000000)
      ? rndColor
      : const Color(0xff63C4EB);
}
