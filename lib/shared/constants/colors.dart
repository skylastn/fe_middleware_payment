// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:math';

import 'package:flutter/material.dart';

class ColorConstants {
  static Color lightScaffoldBackgroundColor = Colors.white;
  static Color darkScaffoldBackgroundColor = const Color(0xFF030B1A);
  static Color secondaryAppColor = hexToColor('#ffffff');
  static Color secondaryDarkAppColor = Colors.white;
  static Color tipColor = hexToColor('#B6B6B6');
  static Color lightGray = const Color(0xFFF6F6F6);
  static Color darkGray = const Color(0xFF9F9F9F);
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);
  static Color grey300 = const Color(0xFFF7FAFA);
  static Color grey100 = const Color(0xFFF5F5FF);
  static Color positiveButton = const Color(0xFFffe4cf);
  static Color negativeButton = const Color(0xFF2D0E15);
  static Color headerFooter = const Color(0xFFD8A48F);
  static Color lightTextColor = const Color(0xff3f3f3f);
  static Color darkTextColor = const Color(0xffffffff);
  static Color badgesColor = const Color(0xFFD8A48F);
  static Color badgesText = const Color(0xFFFFFFFF);
  static Color cardBackground = const Color(0xFFFFFFFF);
  static Color darkCardBackground = const Color(0xFF151a24);
  static Color solidIconColor = Colors.black;
  static Color unactiveIconColor = const Color(0xFFDADEDE);
  static Color textMenuColor = const Color(0xFF212529);
  static Color shadowBlue = const Color(0xFFF7FAFA);
  static Color primaryColor = const Color(0xff1D74F5);
  static Color secondaryColor = const Color(0xff63C4EB);
  static Color backgroundColors = const Color(0xffF1F3F5);
  static Color backgroundShadowColor = const Color(0xff282828);
  static Color darkShadowColor = Colors.transparent;
  static Color kWhiteGrey = const Color(0xffF1F1F5);
  static Color kBlack = const Color(0xff222222);
  static Color kBlackAccent = const Color(0xff2A2B37);
  static Color kGrey = const Color(0xffac4c4c4);
  static Color kLineDark = const Color(0xffEAEAEA);
  static Color kWhite = const Color(0xffFFFFFF);
  static Color lightBlue = const Color(0xffE9F2FF);
  static Color pink = const Color(0xffFFE9E9);
  static Color red = const Color(0xffFF6060);
  static Color disableColor = const Color(0xffB3AFAF);
}

Color textToColor(String inputString) {
  // Konversi string ke daftar kode ASCII
  List<int> codeUnits = inputString.codeUnits;

  // Konversi kode ASCII ke heksadesimal
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
  // return '#${color.value.toRadixString(16).substring(2)}';
  return '#${color.toARGB32().toRadixString(16).substring(2)}';
}

Color randomColor() {
  var rndColor = Color(Random().nextInt(0xffffffff)).withAlpha(0xff);

  return rndColor != const Color(0xffffffff) ||
          rndColor != const Color(0x00000000)
      ? rndColor
      : const Color(0xff63C4EB);
}
