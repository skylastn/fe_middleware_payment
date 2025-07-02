import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/device_size.dart';

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
      floatingActionButton: floatingActionButton,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/im_background_dashboard.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: context.isPhone
                ? null
                : const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: context.isPhone
                ? mobileWidget(context)
                : desktopWidget(context),
          ),
        ),
      ),
    );
  }

  Widget desktopWidget(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Container(
        width: DeviceSize.getMobileSize(),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: body,
      ),
    );
  }

  Widget mobileWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      width: DeviceSize.getMobileSize(),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: body,
    );
  }
}
