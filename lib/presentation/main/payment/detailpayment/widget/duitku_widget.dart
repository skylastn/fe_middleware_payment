import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../../shared/utils/snackbar.dart';
import '../../../widget/main_widget.dart';
import '../../controllers/payment.state.dart';
import '../controllers/detailpayment.controller.dart';

class DuitkuWidget extends StatelessWidget {
  DuitkuWidget({super.key});
  final logic = Get.find<DetailPaymentController>();
  final state = Get.find<DetailPaymentController>().state;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    switch (state.paymentCategory?.paymentType) {
      case PaymentType.qris:
        return qrisWidget();
      default:
        return vaWidget();
    }
  }

  Widget qrisWidget() {
    return Column(
      children: [
        if ((state.duitkuOrder.response?.qrString ?? '').isNotEmpty)
          RepaintBoundary(
            key: globalKey,
            child: Container(
              height: 220,
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: PrettyQrView.data(
                  data: state.duitkuOrder.response?.qrString ?? '',
                  decoration: const PrettyQrDecoration()
                  // version: QrVersions.auto,
                  // size: 200.0,
                  ),
            ),
          ),
        // else
        //   const Text("QR Code not available."),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 12,
                right: 12,
              ),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              Colors.white,
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              Colors.blue,
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                side: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          onPressed: (state.duitkuOrder.response?.qrString ?? '').isNotEmpty
              ? () => logic.saveQRCode(
                    state.duitkuOrder.response?.qrString ?? '',
                    globalKey,
                  )
              : null,
          child: const Text('Save QR'),
        ),
      ],
    );
  }

  Widget vaWidget() {
    return itemWidget(
      title: 'Nomor Akun Virtual',
      subTitle: state.duitkuOrder.response?.vaNumber ?? '',
      endWidget: InkWell(
        onTap: () async {
          await Clipboard.setData(
            ClipboardData(
              text: state.duitkuOrder.response?.vaNumber ?? '',
            ),
          );
          Snackbar.showInfo(message: 'Copied to your clipboard !');
        },
        child: const Icon(Icons.copy),
      ),
    );
  }
}
