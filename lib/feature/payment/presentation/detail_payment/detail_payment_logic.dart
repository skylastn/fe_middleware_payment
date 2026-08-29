import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/logic/network_logic.dart';
import '../../../../shared/logic/socket_logic.dart';
import '../../../../shared/model/state_status.dart';
import '../../../../shared/utility/snackbar.dart';
import '../../application/order_service.dart';
import 'detail_payment_state.dart';

class DetailPaymentLogic extends GetxController {
  final DetailPaymentState state = DetailPaymentState();
  final OrderService _orderService = OrderService();
  final socketLogic = Get.find<SocketLogic>();
  final networkLogic = Get.find<NetworkLogic>();

  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();
    state.orderId = Get.parameters['reference'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    init();
    listenSocket();
  }

  @override
  void onClose() {
    state.orderSubscribition?.cancel();
    state.socketReconnectSubscription?.cancel();
    state.isInternetConnectedSubscription?.cancel();
    state.isSocketConnectedSubscription?.cancel();
    super.onClose();
  }

  Future<void> init() async {
    await getDetailOrder();
    listenOrder();
    update();

    if (state.order?.status != 'PAID' && state.order?.status != 'SUCCESS') {
      if ((state.order?.response ?? '').isEmpty &&
          (state.order?.value ?? '').isEmpty &&
          (state.order?.url ?? '').isEmpty) {
        if ((state.order?.paymentMethod ?? '').isNotEmpty) {
          await createOrderPayment();
        }
      }
    }
  }

  void listenOrder() {
    state.orderSubscribition?.cancel();
    state.orderSubscribition = socketLogic.orderStream.listen((data) {
      if (data == null) return;
      if (data.reference == state.orderId) {
        state.order = data;
        handleSuccess(isRedirect: true);
        extractPaymentDetails();
        update();
      }
    });
  }

  void listenSocket() {
    state.socketReconnectSubscription?.cancel();
    state.socketReconnectSubscription =
        socketLogic.reconnectStream.listen((_) async {
      await getDetailOrder(isLoading: false, isRedirect: true);
    });
  }

  Future<void> getDetailOrder(
      {bool isLoading = true, bool isRedirect = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (isLoading) {
      state.status = StateStatus.loading;
      update();
    }

    try {
      var response =
          await _orderService.getDetailOrder(reference: state.orderId);
      response.fold((l) {
        state.status = StateStatus.error;
        state.errorMsg = l.msg;
        update();
      }, (r) {
        state.status = StateStatus.success;
        state.order = r;
        extractPaymentDetails();
        handleSuccess(isRedirect: isRedirect);
        update();
      });
    } finally {
      _isFetching = false;
    }
  }

  void extractPaymentDetails() {
    final order = state.order;
    if (order == null) return;

    final isQris = order.categoryKey.isQris;
    final value = (order.value ?? '').trim();

    if (value.isNotEmpty) {
      state.isPayment = true;
      if (isQris || value.startsWith('000201') || value.length > 50) {
        state.qrString = value;
      } else {
        state.vaNumber = value;
      }
    }

    if ((order.url).isNotEmpty && order.url.startsWith('http')) {
      state.checkoutUrl = order.url;
      state.isPayment = true;
    }

    if (state.qrString == null && state.vaNumber == null && (order.response ?? '').isNotEmpty) {
      try {
        final res = jsonDecode(order.response!);
        if (res is Map<String, dynamic>) {
          state.isPayment = true;

          final qr = res['qrString'] ??
              res['qrContent'] ??
              res['qr_string'] ??
              res['qr_url'];
          if (qr != null && qr.toString().isNotEmpty) {
            state.qrString = qr.toString();
          }

          final va = res['vaNumber'] ??
              res['account_number'] ??
              res['bill_key'] ??
              res['permata_va_number'] ??
              res['bca_va_number'] ??
              res['bri_va_number'] ??
              res['bni_va_number'];
          if (va != null && va.toString().isNotEmpty) {
            state.vaNumber = va.toString();
          }

          if (res['virtualAccount'] is Map && res['virtualAccount']['vaNumber'] != null) {
            state.vaNumber = res['virtualAccount']['vaNumber'].toString();
          }

          if (res['va_numbers'] is List && (res['va_numbers'] as List).isNotEmpty) {
            final firstVa = (res['va_numbers'] as List)[0];
            if (firstVa is Map && firstVa['va_number'] != null) {
              state.vaNumber = firstVa['va_number'].toString();
            }
          }

          final link = res['paymentUrl'] ??
              res['invoice_url'] ??
              res['redirect_url'] ??
              res['url'] ??
              res['link'];
          if (link != null && link.toString().startsWith('http')) {
            state.checkoutUrl = link.toString();
          }
        }
      } catch (_) {}
    }
  }

  Future<void> checkStatusAndHandleRedirect() async {
    await getDetailOrder(isLoading: false, isRedirect: true);
    final status = state.order?.status ?? '';
    if (status == 'PAID' || status == 'SUCCESS') {
      Snackbar.showInfo(
        title: 'Sukses',
        message: 'Pembayaran Anda berhasil!',
      );
      await handleSuccess(isRedirect: true);
    } else if (status == 'EXPIRED') {
      Snackbar.showInfo(
        title: 'Kadaluarsa',
        message: 'Waktu pembayaran telah habis.',
      );
    } else if (status == 'FAILED') {
      Snackbar.showInfo(
        title: 'Gagal',
        message: 'Pembayaran gagal diproses.',
      );
    } else {
      Snackbar.showInfo(
        title: 'Status',
        message: 'Status saat ini: ${status.isEmpty ? 'PENDING' : status}',
      );
    }
  }

  Future<void> handleSuccess({bool isRedirect = false}) async {
    if (state.order == null) return;

    if (isRedirect) {
      final status = state.order?.status ?? '';
      if (status == 'SUCCESS' || status == 'PAID') {
        Snackbar.showInfo(message: 'Pembayaran Berhasil Dikonfirmasi!');
        String returnUrl = '';

        if ((state.order?.request ?? '').isNotEmpty) {
          try {
            final req = jsonDecode(state.order!.request!);
            if (req is Map<String, dynamic>) {
              returnUrl = req['returnUrl'] ??
                  req['return_url'] ??
                  req['success_redirect_url'] ??
                  '';
            }
          } catch (_) {}
        }

        if (returnUrl.isNotEmpty && returnUrl.startsWith('http')) {
          await Future.delayed(const Duration(seconds: 1));
          _launchUrl(returnUrl);
        }
      }
    }
  }

  Future<void> createOrderPayment() async {
    if (state.order?.response != null && state.order!.response!.isNotEmpty) {
      state.isPayment = true;
      extractPaymentDetails();
      update();
      return;
    }
    state.status = StateStatus.loading;
    update();

    var response = await _orderService.createOrderPayment(
      paymentMethod: state.order?.paymentMethod ?? '',
      reference: state.orderId,
    );

    response.fold((l) {
      state.status = StateStatus.error;
      state.errorMsg = l.msg;
      update();
    }, (r) async {
      await getDetailOrder(isLoading: false);
    });
  }

  Future<void> saveQRCode(
    String qrContent,
    GlobalKey<State<StatefulWidget>> globalKey,
  ) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    Uint8List? bytes = byteData?.buffer.asUint8List();
    await FileSaver.instance.saveFile(name: 'qrcode.png', bytes: bytes);
    Snackbar.showInfo(message: 'QR Code berhasil disimpan ke penyimpanan');
  }

  Future<void> launchPaymentUrl(String url) async {
    _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_self',
    )) {
      Snackbar.showInfo(message: 'Tidak dapat membuka $url');
    }
  }
}
