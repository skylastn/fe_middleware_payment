import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:webview_all/webview_all.dart';

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
        if (isCreditCard && checkoutUrl.isNotEmpty) inAppWebviewWidget(checkoutUrl),
        if (!isCreditCard && qrData.isNotEmpty) qrisWidget(qrData),
        if (!isCreditCard && vaData.isNotEmpty) vaWidget(vaData),
        if (!isCreditCard && checkoutUrl.isNotEmpty && qrData.isEmpty && vaData.isEmpty)
          inAppWebviewWidget(checkoutUrl),
      ],
    );
  }

  Widget inAppWebviewWidget(String url) {
    if (kIsWeb) {
      return checkoutLinkWidget(url);
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 520,
      width: double.infinity,
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
      clipBehavior: Clip.antiAlias,
      child: InAppPaymentWebview(url: url),
    );
  }

  Widget checkoutLinkWidget(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstants.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConstants.border, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: ColorConstants.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: ColorConstants.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Portal Pembayaran Aman (3D Secure)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ColorConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Klik tombol di bawah untuk melanjutkan proses verifikasi kartu kredit Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: ColorConstants.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
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
              icon: const Icon(Icons.payment_rounded, size: 18),
              label: const Text(
                'Lanjut ke Pembayaran',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
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
}

class InAppPaymentWebview extends StatefulWidget {
  final String url;
  const InAppPaymentWebview({super.key, required this.url});

  @override
  State<InAppPaymentWebview> createState() => _InAppPaymentWebviewState();
}

class _InAppPaymentWebviewState extends State<InAppPaymentWebview> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    if (!kIsWeb) {
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
