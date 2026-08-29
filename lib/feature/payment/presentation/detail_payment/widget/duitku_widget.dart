import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../../shared/constants/colors.dart';
import '../../../../../shared/utility/snackbar.dart';
import '../../widget/main_widget.dart';
import '../detail_payment_logic.dart';

class DuitkuWidget extends StatelessWidget {
  DuitkuWidget({super.key});
  final logic = Get.find<DetailPaymentLogic>();
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = logic.state;
    final qrData = state.qrString ?? '';
    final vaData = state.vaNumber ?? '';
    final checkoutUrl = state.checkoutUrl ?? '';

    return Column(
      children: [
        if (qrData.isNotEmpty) qrisWidget(qrData),
        if (vaData.isNotEmpty) vaWidget(vaData),
        if (checkoutUrl.isNotEmpty && qrData.isEmpty && vaData.isEmpty)
          checkoutLinkWidget(checkoutUrl),
      ],
    );
  }

  Widget qrisWidget(String qrString) {
    return Column(
      children: [
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
          onPressed: () => logic.saveQRCode(qrString, globalKey),
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text(
            'Simpan QR Code',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget vaWidget(String vaNumber) {
    return itemWidget(
      title: 'Nomor Virtual Account / Kode Bayar',
      subTitle: vaNumber,
      endWidget: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: vaNumber));
            Snackbar.showInfo(message: 'Nomor pembayaran disalin ke clipboard');
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
      ),
    );
  }

  Widget checkoutLinkWidget(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorConstants.border, width: 0.8),
      ),
      child: Column(
        children: [
          const Text(
            'Klik tombol di bawah untuk melanjutkan ke portal pembayaran gateway',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: ColorConstants.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => logic.launchPaymentUrl(url),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text(
              'Buka Halaman Pembayaran',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
