import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/colors.dart';
import '../model/state_status.dart';

class StateWidget {
  Widget initial({
    required StateStatus stateStatus,
    required dynamic body,
    String? emptyMsg,
    String? errorMsg,
  }) {
    if (stateStatus == StateStatus.loading) {
      return loadingWidget();
    }
    if (stateStatus == StateStatus.empty) {
      return emptyWidget(msg: emptyMsg);
    }
    if (stateStatus == StateStatus.error) {
      return errorWidget(msg: errorMsg ?? 'Terjadi kesalahan memuat data');
    }
    if (stateStatus == StateStatus.success) {
      return body;
    }
    return Container();
  }

  Widget emptyWidget({String? msg}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: ColorConstants.border, width: 1),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 36,
                color: ColorConstants.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              msg ?? 'Data tidak ditemukan',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget errorWidget({String? msg}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.errorLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorConstants.error.withAlpha(0x40),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: ColorConstants.error,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              msg ?? 'Gagal memuat data',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingWidget(
      {double? height, BorderRadius? borderRadius, String loadingText = ''}) {
    return SizedBox(
      height: height,
      child: Center(
        child: customLoadingWidget(
          text: loadingText,
          color: ColorConstants.primary,
        ),
      ),
    );
  }

  Widget customLoadingWidget(
      {String text = '', Color color = ColorConstants.primary}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitThreeBounce(
          color: color,
          size: 28.0,
        ),
        if (text.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ],
    );
  }
}
