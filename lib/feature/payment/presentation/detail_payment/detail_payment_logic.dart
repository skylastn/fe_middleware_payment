import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/constants/sample.dart';
import '../../../../shared/logic/network_logic.dart';
import '../../../../shared/logic/socket_logic.dart';
import '../../../../shared/model/state_status.dart';
import '../../../../shared/utility/snackbar.dart';
import '../../application/order_service.dart';
import '../../domain/model/response/duitku_order.dart';
import '../../domain/model/response/project.dart';
import '../../domain/model/response/spnpay_order.dart';
import '../payment_method/payment_method_state.dart';
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
    state.paymentCategory = getSelectedPaymentCategory(
      state.order?.paymentMethod ?? '',
    );
    state.paymentCode = state.order?.paymentMethod ?? '';
    state.paymentMethod = getSelectedPaymentMethod();
    listenOrder();
    update();
  }

  PaymentCategory? getSelectedPaymentCategory(String paymentType) {
    for (var cat in listPayment) {
      var found = cat.paymentMethod.firstWhereOrNull(
        (element) => paymentType == element.paymentCode,
      );
      if (found != null) {
        return cat;
      }
    }
    return null;
  }

  PaymentMethod getSelectedPaymentMethod() =>
      state.paymentCategory!.paymentMethod.firstWhere(
        (element) => state.paymentCode == element.paymentCode,
      );

  void listenOrder() {
    state.orderSubscribition?.cancel();
    state.orderSubscribition = socketLogic.orderStream.listen((data) {
      if (data == null) {
        return;
      }
      if (data.reference == state.orderId) {
        state.order = data;
        handleSuccess(isRedirect: true);
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
        handleSuccess(isRedirect: isRedirect);
        update();
      });
    } finally {
      _isFetching = false;
    }
  }

  Future<void> handleSuccess({bool isRedirect = false}) async {
    if (state.order == null) return;
    switch (state.order?.project?.projectType) {
      case ProjectType.spnpay:
        if ((state.order?.request ?? '').isNotEmpty) {
          state.spnPayOrder.request = SpnPayOrderRequest.fromJson(
            jsonDecode(state.order?.request ?? ''),
          );
        }
        if ((state.order?.response ?? '').isNotEmpty) {
          state.spnPayOrder.response = SpnPayOrderResponse.fromJson(
            jsonDecode(state.order?.response ?? ''),
          );
        }
        if ((state.order?.callback ?? '').isNotEmpty) {
          state.spnPayOrder.callback = state.order?.callback ?? '';
        }
      case ProjectType.duitku:
        if ((state.order?.request ?? '').isNotEmpty) {
          state.duitkuOrder.request = DuitkuOrderRequest.fromMap(
            jsonDecode(state.order?.request ?? ''),
          );
        }
        if ((state.order?.response ?? '').isNotEmpty) {
          state.isPayment = true;
          state.duitkuOrder.response = DuitkuOrderResponse.fromMap(
            jsonDecode(state.order?.response ?? ''),
          );
        }
        if ((state.order?.callback ?? '').isNotEmpty) {
          state.duitkuOrder.callback = DuitkuOrderCallback.fromMap(
            jsonDecode(state.order?.callback ?? ''),
          );
        }
      default:
    }
    if (isRedirect) {
      if (state.order?.status == 'SUCCESS') {
        if (state.order?.project?.projectType == ProjectType.duitku) {
          Snackbar.showInfo(message: 'Payment Success');
          await Future.delayed(const Duration(seconds: 1));
          _launchUrl(state.duitkuOrder.request?.returnUrl ?? '');
          return;
        }
      }
    }
  }

  Future<void> createOrderPayment() async {
    if (state.order?.response != null) {
      update();
      return;
    }
    state.status = StateStatus.loading;
    update();
    var response = await _orderService.createOrderPayment(
      paymentMethod: state.paymentMethod?.paymentCode ?? '',
      reference: state.orderId,
    );
    response.fold((l) {
      state.status = StateStatus.error;
      state.errorMsg = l.msg;
      update();
    }, (r) async {
      getDetailOrder(isLoading: false);
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
    Snackbar.showInfo(message: 'File saved to storage successfully!');
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      Snackbar.showInfo(message: 'Could not launch $url');
    }
  }
}
