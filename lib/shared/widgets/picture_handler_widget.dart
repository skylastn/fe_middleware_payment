import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';

class PictureHandlerWidget {
  Widget pictureHandler(String? source,
      {double size = 28, Color? fallbackColor}) {
    final cleanSource = source ?? '';
    if (cleanSource.isEmpty) {
      return defaultPlaceholder(size: size, color: fallbackColor);
    }

    if (cleanSource.contains('.')) {
      final ext = cleanSource.split('.').last.toLowerCase().split('?').first;
      if (ext == 'svg') {
        return svgHandler(cleanSource,
            size: size, fallbackColor: fallbackColor);
      }
      return imageHandler(cleanSource,
          size: size, fallbackColor: fallbackColor);
    }

    return defaultPlaceholder(size: size, color: fallbackColor);
  }

  Widget svgHandler(String source, {double size = 28, Color? fallbackColor}) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return SvgPicture.network(
        source,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) =>
            defaultPlaceholder(size: size, color: fallbackColor),
      );
    }
    return SvgPicture.asset(
      source,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholderBuilder: (_) =>
          defaultPlaceholder(size: size, color: fallbackColor),
    );
  }

  Widget imageHandler(String source, {double size = 28, Color? fallbackColor}) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            defaultPlaceholder(size: size, color: fallbackColor),
      );
    }
    return Image.asset(
      source,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          defaultPlaceholder(size: size, color: fallbackColor),
    );
  }

  Widget defaultPlaceholder({double size = 28, Color? color}) {
    return Icon(
      Icons.account_balance_wallet_rounded,
      size: size,
      color: color ?? ColorConstants.primary,
    );
  }
}
