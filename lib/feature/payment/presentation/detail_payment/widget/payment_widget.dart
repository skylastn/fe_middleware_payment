import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../../shared/constants/colors.dart';
import '../../../../../shared/utility/snackbar.dart';
import '../../../domain/model/response/payment_category.dart';
import '../../widget/main_widget.dart';
import '../detail_payment_logic.dart';

class PaymentWidget extends StatelessWidget {
  PaymentWidget({super.key});
  final logic = Get.find<DetailPaymentLogic>();
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = logic.state;
    final categoryKey = state.order?.categoryKey ?? PaymentCategoryKey.unknown;
    final isQris = categoryKey.isQris;
    final isCreditCard = categoryKey.isCreditCard;
    final value = (state.order?.value ?? '').trim();
    final qrData = state.qrString ?? (isQris ? value : '');
    final vaData = state.vaNumber ?? (!isQris && !isCreditCard && value.isNotEmpty ? value : '');
    final checkoutUrl = state.checkoutUrl ?? (state.order?.url ?? '');

    return Column(
      children: [
        if (isCreditCard) creditCardWidget(checkoutUrl),
        if (!isCreditCard && qrData.isNotEmpty) qrisWidget(qrData),
        if (!isCreditCard && vaData.isNotEmpty) vaWidget(vaData),
        if (!isCreditCard && checkoutUrl.isNotEmpty && qrData.isEmpty && vaData.isEmpty)
          checkoutLinkWidget(checkoutUrl),
      ],
    );
  }

  Widget creditCardWidget(String url) {
    final state = logic.state;
    final customerName = state.order?.customerDisplayName ?? 'CARDHOLDER NAME';
    final paymentName = state.order?.paymentMethods?.name ?? 'Credit / Debit Card';

    return Column(
      children: [
        // Visual Card Preview
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 185,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF334155), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A0F172A),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.contactless_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                  Text(
                    paymentName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '••••  ••••  ••••  ••••',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PEMEGANG KARTU',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          customerName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'BERLAKU HINGGA',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'MM / YY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Security Notice
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ColorConstants.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorConstants.border, width: 0.8),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                color: ColorConstants.primary,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pembayaran dilindungi enkripsi 256-bit dan otentikasi 3D Secure.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: ColorConstants.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Action Button
        if (url.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
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
              icon: const Icon(Icons.credit_card_rounded, size: 18),
              label: const Text(
                'Lanjut ke Pembayaran 3DS Secure',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  Widget qrisWidget(String qrString) {
    return Column(
      children: [
        Center(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              width: 230,
              height: 230,
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
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
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.surfaceMuted,
            foregroundColor: ColorConstants.textPrimary,
            elevation: 0,
            side: const BorderSide(color: ColorConstants.border, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => logic.saveQRCode(qrString, globalKey),
          icon: const Icon(Icons.download_rounded, size: 16),
          label: const Text(
            'Simpan QR Code',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
