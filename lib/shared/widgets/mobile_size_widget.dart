import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/constant.dart';
import '../constants/colors.dart';
import '../utility/device_size.dart';

class MobileSizeWidget extends StatelessWidget {
  final String? backgroundImage;
  final Widget body;
  final Widget? floatingActionButton;

  const MobileSizeWidget({
    required this.body,
    this.backgroundImage,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      floatingActionButton: floatingActionButton,
      body: Container(
        decoration: BoxDecoration(
          color: Constant.backgroundModel.type == BackgroundType.color
              ? hexToColor(Constant.backgroundModel.value ?? '#F8FAFC')
              : null,
          image: Constant.backgroundModel.type == BackgroundType.image
              ? const DecorationImage(
                  image: AssetImage('assets/images/im_background_dashboard.jpg'),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(
          child: Container(
            margin: context.isPhone
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: context.isPhone
                ? mobileWidget(context)
                : desktopWidget(context),
          ),
        ),
      ),
    );
  }

  Widget desktopWidget(BuildContext context) {
    return Container(
      width: DeviceSize.getMobileSize(),
      decoration: BoxDecoration(
        color: ColorConstants.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x050F172A),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16),
      child: body,
    );
  }

  Widget mobileWidget(BuildContext context) {
    return Container(
      color: ColorConstants.surface,
      width: DeviceSize.getMobileSize(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(child: body),
    );
  }
}
