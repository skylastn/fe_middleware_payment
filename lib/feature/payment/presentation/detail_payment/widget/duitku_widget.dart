import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../../shared/constants/colors.dart';
import '../../../../../shared/utility/snackbar.dart';
import '../../payment_method/payment_method_state.dart';
import '../../widget/main_widget.dart';
import '../detail_payment_logic.dart';

class DuitkuWidget extends StatelessWidget {
  DuitkuWidget({super.key});
  final logic = Get.find<DetailPaymentLogic>();
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = logic.state;
    switch (state.paymentCategory?.paymentType) {
      case PaymentType.qris:
        return qrisWidget();
      default:
        return vaWidget();
    }
  }

  Widget qrisWidget() {
    final state = logic.state;
    final qrString = state.duitkuOrder.response?.qrString ?? '';
    return Column(
      children: [
        if (qrString.isNotEmpty)
          RepaintBoundary(
            key: globalKey,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorConstants.border, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: PrettyQrView.data(
                data: qrString,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                    color: ColorConstants.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.surfaceMuted,
            foregroundColor: ColorConstants.textPrimary,
            elevation: 0,
            side: const BorderSide(color: ColorConstants.border, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: qrString.isNotEmpty
              ? () => logic.saveQRCode(qrString, globalKey)
              : null,
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text(
            'Simpan QR Code',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget vaWidget() {
    final state = logic.state;
    final vaNumber = state.duitkuOrder.response?.vaNumber ?? '';
    return itemWidget(
      title: 'Nomor Virtual Account',
      subTitle: vaNumber,
      endWidget: vaNumber.isNotEmpty
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: vaNumber));
                  Snackbar.showInfo(message: 'Nomor VA disalin ke clipboard');
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorConstants.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorConstants.border,
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: ColorConstants.primary,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
