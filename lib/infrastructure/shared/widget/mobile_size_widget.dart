import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/device_size.dart';

class MobileSizeWidget extends StatelessWidget {
  String? backgroundImage;
  Widget body;
  Widget? floatingActionButton;

  MobileSizeWidget({
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
            image: AssetImage("assets/images/im_background_dashboard.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: context.isPhone
                ? null
                : const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Card(
              color: Colors.white,
              elevation: 2,
              child: Container(
                color: Colors.white,
                width: DeviceSize.getMobileSize(),
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
