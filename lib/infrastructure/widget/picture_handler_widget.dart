import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PictureHandlerWidget {
  Widget pictureHandler(String source) {
    if (source.contains('.')) {
      if (source.split('.').last == svg) {
        return svgHandler(source);
      }
      return imageHandler(source);
    }
    return const Icon(Icons.error);
  }

  Widget svgHandler(String source) {
    if (source.contains('http')) {
      return SvgPicture.network(source);
    }
    return SvgPicture.asset(source);
  }

  Widget imageHandler(String source) {
    if (source.contains('http')) {
      return Image.network(source);
    }
    return Image.asset(source);
  }
}
